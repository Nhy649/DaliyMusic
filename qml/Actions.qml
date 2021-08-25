import QtQuick 2.12
import QtQuick.Controls 2.5
Item {
    property alias openFileAction:openFile
    property alias openFolderAction:openFolder
    property alias exitAction:exit
    property alias copyCurrentLyricAction:copyCurrentLyric
    property alias copyAllLyricAction:copyAllLyric
    property alias editLyricAction:editLyric
    property alias downloadLyricAction:downlodLyric
 //   property alias showMenubarAction:showMenubar
    property alias recentlayPlaydAction:recentlyPlayed
    property alias trackInformationAction:trackInformation
    property alias keyMapAction:keyMap
    property alias aboutAction:about
    property alias playAction:play
    property alias pauseAction:pause
    property alias deleteAction:del
    property alias stopAction: stop
    property alias previousAction: previous
    property alias nextAction: next
    property alias fastforwardfiveScdAction: fastforwardfiveScd
    property alias backfiveScdAction: backfiveScd
    property alias seqPlayAction: seqPlay
    property alias loopPlayAction: loopPlay
    property alias ranPlayAction:ranPlay
    property alias playRecentlyAction: playRecently
    property alias delRecentlyAction: delRecently
    property alias searchSongAction:searchSong

    Action{
        id:openFile
        text: qsTr("打开文件")
        shortcut: StandardKey.Open
        icon.source: "qrc:/image/文件.png"
    }
    Action{
        id:searchSong
        icon.source: "qrc:/image/查找.png"
        text: qsTr("搜索歌曲")
        onTriggered: {
            dialogs.songSarchDialog.visible=true
        }
    }

    Action{
        id:openFolder
        text: qsTr("打开文件夹")
        icon.source: "qrc:/image/文件夹.png"
    }
    Action{
        id:play
        text: qsTr("播放")
        icon.source: "qrc:/image/播放.png"
        onTriggered: {
            if(content.musicPlayer.fileName!==" ") {
                content.musicPlayer.audio.play()
                content.spectrogram.speTimer.running = true
                content.musicPlayer.start.visible=false
                content.musicPlayer.pause.visible=true
                dialogs.recentlyPlayedDialog.recUrls.push(content.musicPlayer.audio.source)

                if(dialogs.songSarchDialog.networkPlay) {
                    content.spectrogram.speTimer.running=false
                } else {
                    content.spectrogram.speTimer.running=true
                }

                dialogs.miniDialog.musicStart.visible = false
                dialogs.miniDialog.musicPause.visible = true

                if(dialogs.lyricDialog.testNum===1) {
                    dialogs.lyricDialog.onClickAudioSlider()
                }
                if(dialogs.songSarchDialog.networkPlay) {
                    dialogs.songSarchDialog.showLyrics();
                }
            }
        }
    }

    Action{
        id:pause
        text: qsTr("暂停")
        icon.source:  "qrc:/image/暂停.png"
        onTriggered: {
            if(content.musicPlayer.fileName!==" ") {
                content.musicPlayer.audio.pause()
                content.spectrogram.speTimer.running = false
                content.musicPlayer.start.visible=true
                content.musicPlayer.pause.visible=false

                dialogs.miniDialog.musicStart.visible = true
                dialogs.miniDialog.musicPause.visible = false

                if(dialogs.lyricDialog.timerTest.running) {
                    dialogs.lyricDialog.timerTest.running=false;
                }
            }
        }
    }

    Action{
        id:del
        text: qsTr("删除")
        icon.source:  "qrc:/image/delete.png"
        onTriggered: {
            dialogs.lyricDialog.fileIo.deleteUrls(content.playlistPage.rightIndex, "../播放列表.txt")
            content.playlistPage.songListModel.remove(content.playlistPage.rightIndex, 1)
            if(content.playlistPage.rightIndex===content.playlistPage.songListView.currentIndex){
                dialogs.lyricDialog.fileIo.readUrls(content.playlistPage.songListView.currentIndex,"../播放列表.txt")
                content.musicPlayer.audio.source = dialogs.lyricDialog.fileIo.source
                content.musicPlayer.audio.play()
            }
        }
    }
    Action{
        id:exit
        text: qsTr("退出")
        shortcut: StandardKey.Quit
        icon.source:"qrc:/image/退出.png"
    }

    Action{
        id:copyCurrentLyric
        text: qsTr("复制当前歌词")
        icon.source: "qrc:/image/copy.png"
        onTriggered: {
            content.lyricPage.clipBoard.setText(content.lyricPage.lyricListModel.get(content.lyricPage.lyricListView.currentIndex).currentLyrics)
        }
    }
    Action{
        id:copyAllLyric
        text: qsTr("复制所有歌词")
        icon.source: "qrc:/image/copy.png"
        onTriggered: {
            var str;
            var num = dialogs.lyricDialog.lyric_id.painLyric.length
            for(var i = 0; i < num; i++){
                str  = str+dialogs.lyricDialog.lyric_id.painLyric[i]+"\n"
            }
            content.lyricPage.clipBoard.setText(str)
        }
    }
    Action{
        id:editLyric
        text: qsTr("编辑歌词")
        icon.source: "qrc:/image/编辑.png"
    }
    Action{
        id:downlodLyric
        text: qsTr("下载歌词")
        icon.source: "qrc:/image/下载.png"
    }
//    CheckBox{
//        id:showMenubar
//        text: qsTr("显示菜单栏")
//        checked: true
//    }
    Action{
        id:recentlyPlayed
        text: qsTr("最近播放")
        icon.source: "qrc:/image/最近播放.png"
        onTriggered: {
            if(dialogs.recentlyPlayedDialog.recUrls.length !== 0){
                dialogs.lyricDialog.fileIo.saveRecentlyUrls(dialogs.recentlyPlayedDialog.recUrls)
            }
            dialogs.lyricDialog.fileIo.getRecentlyPlaylist();
            var i = 0;
            var recentlyLength = dialogs.lyricDialog.fileIo.recentlyUrls.length
            dialogs.recentlyPlayedDialog.recentlyListModel.clear()
            for(i = 0; i<recentlyLength; i++){
                var name = dialogs.recentlyPlayedDialog.getMusicName(dialogs.lyricDialog.fileIo.recentlyUrls[i]);  //得到歌曲名字
                var path = dialogs.lyricDialog.fileIo.recentlyUrls[i]
                dialogs.songLabelDialog.song.getTags(path)
                if(dialogs.songLabelDialog.song.Tags["艺术家"]===undefined){
                    var str = " "
                }else{
                    str = dialogs.songLabelDialog.song.Tags["艺术家"]
                }
                dialogs.recentlyPlayedDialog.recentlyListModel.append({"songName":name, "singer":str})
            }
            dialogs.recentlyPlayedDialog.visible=true;
        }
    }
    Action{
        id:trackInformation
        text: qsTr("曲目信息")
        icon.source: "qrc:/image/曲目信息.png"
    }
    Action{
        id:keyMap
        text: qsTr("设置快捷键")
        onTriggered: {
            actions.openFileAction.shortcut = dialogs.lyricDialog.fileIo.readKey(0)
            actions.openFolderAction.shortcut = dialogs.lyricDialog.fileIo.readKey(1)
            actions.exitAction.shortcut = dialogs.lyricDialog.fileIo.readKey(2)
            actions.playAction.shortcut = dialogs.lyricDialog.fileIo.readKey(3)
            actions.pauseAction.shortcut = dialogs.lyricDialog.fileIo.readKey(4)
            actions.stopAction.shortcut = dialogs.lyricDialog.fileIo.readKey(5)
            actions.previousAction.shortcut = dialogs.lyricDialog.fileIo.readKey(6)
            actions.nextAction.shortcut = dialogs.lyricDialog.fileIo.readKey(7)
            actions.fastforwardfiveScdAction.shortcut = dialogs.lyricDialog.fileIo.readKey(8)
            actions.backfiveScdAction.shortcut = dialogs.lyricDialog.fileIo.readKey(9)
            actions.seqPlayAction.shortcut = dialogs.lyricDialog.fileIo.readKey(10)
            actions.loopPlayAction.shortcut = dialogs.lyricDialog.fileIo.readKey(11)
            actions.ranPlayAction.shortcut = dialogs.lyricDialog.fileIo.readKey(12)
            actions.deleteAction.shortcut = dialogs.lyricDialog.fileIo.readKey(13)
            actions.copyCurrentLyricAction.shortcut = dialogs.lyricDialog.fileIo.readKey(14)
            actions.copyAllLyricAction.shortcut = dialogs.lyricDialog.fileIo.readKey(15)
            actions.editLyricAction.shortcut = dialogs.lyricDialog.fileIo.readKey(16)
            actions.downloadLyricAction.shortcut = dialogs.lyricDialog.fileIo.readKey(17)
            actions.recentlayPlaydAction.shortcut = dialogs.lyricDialog.fileIo.readKey(18)
            actions.trackInformationAction.shortcut = dialogs.lyricDialog.fileIo.readKey(19)
            actions.keyMapAction.shortcut = dialogs.lyricDialog.fileIo.readKey(20)
            actions.aboutAction.shortcut = dialogs.lyricDialog.fileIo.readKey(21)
            dialogs.keyMapDialog.visible=true
        }
    }
    Action{
        id:about
        text: qsTr("关于")
        icon.source: "qrc:/image/帮助.png"
    }
    Action{
        id:stop
        text: qsTr("停止")
        icon.source: "qrc:/image/停止.png"
        onTriggered: {
            content.musicPlayer.audio.stop()
            actions.pauseAction.triggered()
            dialogs.miniDialog.musicStart.visible = true
            dialogs.miniDialog.musicPause.visible = false

            if(dialogs.lyricDialog.testNum===1) {
                dialogs.lyricDialog.testNum=0
                dialogs.lyricDialog.timerTest.running=false

                content.lyricPage.lyricListModel.clear()
                content.lyricPage1.lyricListModel.clear()
                content.lyricPage.lyricText.visible=true
            }
        }
    }
    Action{
        id:previous
        text: qsTr("上一曲")
        icon.source:  "qrc:/image/上一曲.png"
        onTriggered: {
            content.spectrogram.speTimer.running = false
            if(dialogs.songSarchDialog.networkPlay){
                var num = dialogs.songSarchDialog.searchlistView.currentIndex
                if(num === 0){
                    num = dialogs.songSarchDialog.songListModel.count-1
                }else{
                    num--
                }
                dialogs.songSarchDialog.searchlistView.currentIndex = num
                dialogs.songSarchDialog.play1.triggered()
            }else{
                if(content.playlistPage.songListView.currentIndex === 0){
                    content.playlistPage.songListView.currentIndex = content.playlistPage.songSerialNumber-1
                }else{
                    content.playlistPage.songListView.currentIndex--;
                }
                dialogs.lyricDialog.fileIo.readUrls(content.playlistPage.songListView.currentIndex, "../播放列表.txt")
                content.musicPlayer.audio.source = "file://"+dialogs.lyricDialog.fileIo.source
                content.musicPlayer.fileName=content.musicPlayer.getMusicName(dialogs.lyricDialog.fileIo.source)
                content.spectrogram.getVertices()
                content.spectrogram.speTimer.running = true
                content.musicPlayer.audio.play()
                content.musicPlayer.start.visible=false
                content.musicPlayer.pause.visible=true
                dialogs.miniDialog.musicStart.visible = false
                dialogs.miniDialog.musicPause.visible = true
            }
            if(dialogs.lyricDialog.timerTest.running) {
                dialogs.lyricDialog.timerTest.running=false
                content.lyricPage.lyricListView.visible=false
                content.lyricPage1.lyricListView.visible=false
            }
        }
    }
    Action{
        id:next
        text: qsTr("下一曲")
        icon.source:  "qrc:/image/下一曲.png"
        onTriggered: {
            content.spectrogram.speTimer.running = false
            if(dialogs.songSarchDialog.networkPlay){
                var num = dialogs.songSarchDialog.searchlistView.currentIndex
                if(num === dialogs.songSarchDialog.songListModel.count-1){
                    num = 0
                }else{
                    num++
                }
                dialogs.songSarchDialog.searchlistView.currentIndex = num
                dialogs.songSarchDialog.play1.triggered()
            }else{
                if(content.playlistPage.songListView.currentIndex === content.playlistPage.songSerialNumber-1){
                    content.playlistPage.songListView.currentIndex = 0
                }else{
                    content.playlistPage.songListView.currentIndex++;
                }
                dialogs.lyricDialog.fileIo.readUrls(content.playlistPage.songListView.currentIndex, "../播放列表.txt")
                content.musicPlayer.audio.source = "file://"+dialogs.lyricDialog.fileIo.source
                content.musicPlayer.fileName=content.musicPlayer.getMusicName(dialogs.lyricDialog.fileIo.source)

                content.spectrogram.getVertices()
                content.spectrogram.speTimer.running = true
                content.musicPlayer.audio.play()
                content.musicPlayer.start.visible=false
                content.musicPlayer.pause.visible=true
                dialogs.miniDialog.musicStart.visible = false
                dialogs.miniDialog.musicPause.visible = true
            }
            if(dialogs.lyricDialog.timerTest.running) {
                dialogs.lyricDialog.timerTest.running=false
                content.lyricPage.lyricListView.visible=false
                content.lyricPage1.lyricListView.visible=false
            }
        }
    }
    Action{
        id:fastforwardfiveScd
        text: qsTr("快进5秒")
        icon.source: "qrc:/image/下一曲.png"
        onTriggered: {
            content.musicPlayer.audio.seek(content.musicPlayer.audio.position + 5000)
            if(dialogs.lyricDialog.timerTest.running) {
                dialogs.lyricDialog.timerTest.running=false
                dialogs.lyricDialog.onClickAudioSlider()
            }
            if(dialogs.songSarchDialog.networkPlay) {
                dialogs.songSarchDialog.showLyrics();
            }
        }
    }
    Action{
        id:backfiveScd
        text: qsTr("快退5秒")
        icon.source: "qrc:/image/上一曲.png"
        onTriggered: {
            content.musicPlayer.audio.seek(content.musicPlayer.audio.position - 5000)
            if(dialogs.lyricDialog.timerTest.running) {
                dialogs.lyricDialog.timerTest.running=false
                dialogs.lyricDialog.onClickAudioSlider()
            }
            if(dialogs.songSarchDialog.networkPlay) {
                dialogs.songSarchDialog.showLyrics();
            }
        }
    }
    Action{
        id:seqPlay
        text: qsTr("顺序播放")
        icon.source: "qrc:/image/顺序播放.png"
        onTriggered: {
            content.musicPlayer.seqPlay.visible = true
            content.musicPlayer.loopPlay.visible = false
            content.musicPlayer.ranPlay.visible = false
        }
    }
    Action{
        id:loopPlay
        text: qsTr("列表循环")
        icon.source: "qrc:/image/列表循环.png"
        onTriggered: {
            content.musicPlayer.seqPlay.visible = false
            content.musicPlayer.loopPlay.visible = true
            content.musicPlayer.ranPlay.visible = false
        }
    }
    Action{
        id:ranPlay
        text: qsTr("随机播放")
        icon.source: "qrc:/image/随机播放.png"
        onTriggered: {
            content.musicPlayer.seqPlay.visible = false
            content.musicPlayer.loopPlay.visible = false
            content.musicPlayer.ranPlay.visible = true
        }
    }

    Action{
        id: playRecently
        text: qsTr("播放")
        shortcut: "audio-play"
        icon.source:  "qrc:/image/播放.png"
        onTriggered: {
            dialogs.lyricDialog.fileIo.readUrls(dialogs.recentlyPlayedDialog.rightIndex, "../最近播放.txt")
            content.musicPlayer.audio.source = dialogs.lyricDialog.fileIo.source
            content.musicPlayer.getMusicName(dialogs.lyricDialog.fileIo.source)

            content.spectrogram.getVertices()
            content.spectrogram.speTimer.running = true

            content.musicPlayer.audio.play()
            content.musicPlayer.start.visible=false
            content.musicPlayer.pause.visible=true

            content.lyricPage.lyricListModel.clear()
            content.lyricPage1.lyricListModel.clear()

            dialogs.recentlyPlayedDialog.recUrls.push(content.musicPlayer.audio.source)
            dialogs.recentlyPlayedDialog.close()
        }
    }
    Action{
        id: delRecently
        text: qsTr("删除")
        icon.source:  "qrc:/image/delete.png"
        onTriggered: {
            dialogs.lyricDialog.fileIo.deleteUrls(dialogs.recentlyPlayedDialog.rightIndex, "../最近播放.txt")
            dialogs.recentlyPlayedDialog.recentlyListModel.remove(dialogs.recentlyPlayedDialog.rightIndex, 1)
        }
    }
}
