import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQml.Models 2.15
import QtQuick.Controls 2.15
import Qt.labs.folderlistmodel 2.12
Item {
    width: 300
    height: 500
    property var songSerialNumber:0
    property var  mX:0.0
    property var  mY:0.0
    property alias songListModel:songListModel
    property alias songListView:songListView
    property alias songDelegate:songDelegate
    Rectangle{
          anchors.fill: parent
          opacity: 0.6
          ListView{
              id:songListView
              anchors.fill: parent
              delegate: songDelegate
              model: songListModel
          }
          ListModel{
              id:songListModel
          }
          Component{
              id:songDelegate
              Rectangle{
                  width: 300
                  height: 40
                  color:ListView.isCurrentItem ? "lightgrey" : "white"
                  Text {
                      id: serialNumberText
                      text: index+1
                      font.pointSize: 15
                      width: 40
                      color: "Teal"
                      anchors.rightMargin: 40
                  }
                  Text {
                      id: chapterText
                      text: chapter
                      color: "Teal"
                      anchors.left: serialNumberText.right
                      font.pointSize: 15
                  }
                  MouseArea{
                      id:mouseArea
                      acceptedButtons: Qt.RightButton|Qt.LeftButton   //点击右键，content 响应右键的上下文菜单
                      anchors.fill: parent
                      onClicked: {
                          if(mouse.button==Qt.RightButton) {
                              mX=mouseX
                              mY=mouseY
                              menu1.open()
                          }else{
                              actions.pauseAction.triggered()
                              dialogs.songSarchDialog.networkPlay=false
                              content.singerText.text=""
                              songListView.currentIndex=index
                              dialogs.lyricDialog.fileIo.readUrls(index, "../播放列表.txt")
                              console.log(dialogs.lyricDialog.fileIo.source)
                              content.musicPlayer.audio.source="file://"+dialogs.lyricDialog.fileIo.source
                              rootImage.source = "qrc:/image/背景3.png"
                              content.leftImage.source = "qrc:/image/背景3.png"
                              content.spectrogram.speTimer.running = false
                              content.spectrogram.getVertices()

                              content.lyricPage.lyricListModel.clear()
                              content.lyricPage1.lyricListModel.clear();

                              content.fileNameText.text=myMusicArray[index]
                              if(dialogs.lyricDialog.testNum===1) {
                                  dialogs.lyricDialog.testNum=0
                                  dialogs.lyricDialog.timerTest.running=false
                                  content.lyricPage.lyricListModel.clear()
                                  content.lyricPage1.lyricListModel.clear()
                                  content.lyricPage.lyricText.visible=true
                              }
                          }
                      }
                      onDoubleClicked: {
                          actions.playAction.triggered()
                      }
                  }
                  Menu{
                      id:menu1
                      x:mX
                      y:mY
                      contentData: [
                          actions.playAction,
                          actions.pauseAction,
                          actions.deleteAction
                      ]
                 }
              }
          }
    }
}
