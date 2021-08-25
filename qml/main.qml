import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.2

ApplicationWindow {
    id:appWindow
    width: 920
    height: 700
    visible: true
    property alias rootImage:name
    property var myMusicArray:[]
    background: Image {
        id: name
        fillMode: Image.PreserveAspectCrop
        source: "qrc:/image/背景3.png"
        anchors.fill: parent
        opacity: 0.3
        cache: false
    }
    MenuSeparator{id:menuSeparator}
    menuBar: MenuBar{
        id:menuBar
        Menu{
            title: qsTr("&文件")
            contentData: [
                actions.openFileAction,
                actions.openFolderAction,
                actions.openUrlAction,
                menuSeparator,
                actions.exitAction
            ]
        }
        Menu{
            title: qsTr("&歌词")
            contentData: [
                actions.copyCurrentLyricAction,
                actions.copyAllLyricAction,
                actions.editLyricAction,
                actions.downloadLyricAction
            ]
        }
        Menu{
            title: qsTr("&播放控制")
            MenuItem{
                action: actions.playAction
            }
            MenuItem{
                action: actions.pauseAction
            }
            MenuItem{
                action: actions.stopAction
            }
            MenuItem{
                action: actions.previousAction
            }
            MenuItem{
                action: actions.nextAction
            }
            MenuItem{
                action: actions.fastforwardfiveScdAction
            }
            MenuItem{
                action: actions.backfiveScdAction
            }
            MenuSeparator { }

            Menu {
                title: "循环模式"
                MenuItem{
                    action: actions.seqPlayAction
                }
                MenuItem{
                    action: actions.loopPlayAction
                }
                MenuItem{
                    action: actions.ranPlayAction
                }
            }
        }

        Menu{
            title: qsTr("&播放列表")
            contentData: [
                actions.deleteAction,
                actions.searchSongAction
            ]
        }

        Menu{
            title: qsTr("&工具")
            contentData: [
              //  actions.showMenubarAction,
                actions.recentlayPlaydAction,
                actions.trackInformationAction,
                actions.keyMapAction
            ]
        }
        Menu{
            title: qsTr("&帮助")
            contentData: [
                actions.aboutAction
            ]
        }
    }
    Content{
        id:content
    }

    Actions{
        id:actions
        openFileAction.onTriggered: {
            dialogs.openMusicFileDialog();
        }
        openFolderAction.onTriggered: {
            dialogs.openMusicFolderDialog();
        }
        exitAction.onTriggered: {
            if(dialogs.recentlyPlayedDialog.recUrls.length !== 0){
                dialogs.lyricDialog.fileIo.saveRecentlyUrls(dialogs.recentlyPlayedDialog.recUrls)
            }
            appWindow.close()
        }

        trackInformationAction.onTriggered: {
            var str = new String(content.musicPlayer.audio.source).slice(7)
            dialogs.songLabelDialog.song.getTags(str)
            dialogs.songLabelDialog.get_Tags_Meta()
            dialogs.songLabelDialog.visible=true
        }
        editLyricAction.onTriggered: {
            dialogs.lyricDialog.visible=true
            dialogs.lyricDialog.textArea.text = ""
        }

//        showMenubarAction.onCheckedChanged: {
//            menuBar.visible=menuBar.visible ? false: true;  //显示或隐藏工具栏
//        }
        aboutAction.onTriggered: {
           dialogs.openAboutDialog()
        }
        keyMapAction.onTriggered: {
            dialogs.keyMapDialog.visible=true
        }
        downloadLyricAction.onTriggered: {
            dialogs.lyricSarchDialog.visible=true
        }

    }
    Dialogs{
        id:dialogs
        fileMusicDialog.onAccepted: {
            onAcceptedfileMusicDialog();
        }
        folderMusicDialog.onAccepted: {
            var folderPath=new String(folderMusicDialog.folder).slice(7);
            var filePaths=lyricDialog.fileIo.getFiles(folderPath);
            for(var i=0;i<filePaths.length;i++) {
                myMusicArray.push(filePaths[i])
                content.playlistPage.songListModel.append({"chapter":filePaths[i]})
            }

            var path=new Array();
            for(var i=0;i<filePaths.length;i++) {
                path[i]=dialogs.lyricDialog.fileIo.strToUrl(folderMusicDialog.folder.toString()+"/"+filePaths[i]);
            }
            dialogs.lyricDialog.fileIo.saveUrls(path)  //加入到播放列表
            content.lyricPage.lyricText.visible=true
            content.musicPlayer.audio.source=path[path.length-1];
            var finalPath=new String(content.musicPlayer.audio.source).slice(7)
            dialogs.songLabelDialog.song.getTags(finalPath)
            dialogs.songLabelDialog.get_Tags_Meta()
            content.spectrogram.speTimer.running = false
            content.spectrogram.getVertices()
            content.musicPlayer.getMusicName(finalPath);  //得到歌曲名字
        }

    }

    function onAcceptedfileMusicDialog(){
        content.playlistPage.songListView.delegate=content.playlistPage.songDelegate
        content.playlistPage.songListView.model=content.playlistPage.songListModel
        if(dialogs.fileMusicDialog.fileUrls.length<=1) {
            content.musicPlayer.audio.source=dialogs.fileMusicDialog.fileUrl
            var path=new String(dialogs.fileMusicDialog.fileUrl).slice(7);
            content.musicPlayer.getMusicName(path);  //得到歌曲名字
            content.playlistPage.songSerialNumber++;
            content.playlistPage.songListModel.append({"chapter":content.musicPlayer.fileName})
        } else {
            content.musicPlayer.audio.source=dialogs.fileMusicDialog.fileUrls[dialogs.fileMusicDialog.fileUrls.length-1]
            var path=new String(dialogs.fileMusicDialog.fileUrls[dialogs.fileMusicDialog.fileUrls.length-1]).slice(7);
            for(var i=0;i<dialogs.fileMusicDialog.fileUrls.length;i++) {
                content.playlistPage.songSerialNumber++;
                content.musicPlayer.getMusicName(new String(dialogs.fileMusicDialog.fileUrls[i]).slice(7));
                content.playlistPage.songListModel.append({"chapter":content.musicPlayer.fileName})
            }
        }
        dialogs.songLabelDialog.song.getTags(path)
        dialogs.songLabelDialog.get_Tags_Meta()
        content.spectrogram.speTimer.running = false
        content.spectrogram.getVertices()
        content.playlistPage.songListView.currentIndex = content.playlistPage.songSerialNumber-1
        content.lyricPage.lyricText.visible=true
        dialogs.lyricDialog.fileIo.saveUrls(dialogs.fileMusicDialog.fileUrls)  //加入到播放列表

        if(dialogs.lyricDialog.testNum===1) {
            dialogs.lyricDialog.testNum=0
            dialogs.lyricDialog.timerTest.running=false

            content.lyricPage.lyricListModel.clear()
            content.lyricPage1.lyricListModel.clear()
            content.lyricPage.lyricText.visible=true
        }
        dialogs.songSarchDialog.networkPlay=false
    }
    Component.onCompleted: {
        var i = 0;
        dialogs.lyricDialog.fileIo.getPlaylist();
        var length=dialogs.lyricDialog.fileIo.urls.length
        for(i=0;i<length;i++) {
            content.musicPlayer.getMusicName(dialogs.lyricDialog.fileIo.urls[i]);  //得到歌曲名字
            content.playlistPage.songListModel.append({"chapter":content.musicPlayer.fileName})
        }
        content.playlistPage.songSerialNumber=length
        content.playlistPage.songListView.currentIndex = length-1
        if(length!==0) {
            content.musicPlayer.audio.source="file://"+dialogs.lyricDialog.fileIo.urls[length-1]
            content.spectrogram.getVertices();
            content.lyricPage.lyricText.visible=true
        } else {
            content.lyricPage.lyricText.visible=false
        }
    }

}

