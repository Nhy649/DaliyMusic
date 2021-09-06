import QtQuick 2.12
import QtQuick.Dialogs 1.3 as QQ
import Qt.labs.platform 1.1
Item {
    function openMusicFileDialog(){
        fileMusicDialog.open();
    }

    function openMusicFolderDialog(){
        folderMusicDialog.open();
    }
    function openAboutDialog(){
        aboutDialog.open()
    }

    property alias fileMusicDialog:fileMusicDialog
    property alias folderMusicDialog:folderMusicDialog
    property alias songLabelDialog:songLabelDialog
    property alias lyricDialog:lyricDialog
    property alias recentlyPlayedDialog: recentlyPlayedDialog
    property alias keyMapDialog:keyMapDialog
    property alias lyricSarchDialog:lyricSarchDialog
    property alias songSarchDialog:songSarchDialog
    property alias miniDialog: miniDialog

    QQ.FileDialog{
        id:fileMusicDialog
        title: "Please choose a music file"
        folder:shortcuts.documents
        nameFilters: ["Audio Files(*.mp3 /**.ogg *.flac*/)"]
        selectMultiple: true
    }

    FolderDialog{
        id:folderMusicDialog
        title:"select a folder"
    }
    QQ.MessageDialog{
        id:aboutDialog
        title:"May I have your attention please"
        text:"The name of the program is DaliyMusic
              The authors of the program are wenwenChen、haiyanNie、chunlinLi
              This program can realize the music playing at the same time the lyrics for editing,editing the song meta information"
        standardButtons: StandardButton.Ok
    }
    SongLabelDialog{
        id:songLabelDialog
        visible: false
    }
    LyricDialog{
        id:lyricDialog
        visible: false
    }
    RecentlyPlayedDialog{
        id: recentlyPlayedDialog
        visible: false
    }
    KeyMapDialog{
        id:keyMapDialog
        visible: false
    }
    LyricSarchDialog{
        id:lyricSarchDialog
        visible: false
    }
    SongSarchDialog{
        id:songSarchDialog
        visible: false
    }
    MiniDialog{
        id:miniDialog
        visible: false
    }
}
