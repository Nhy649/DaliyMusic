import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtMultimedia 5.8
import QtQuick.Controls 2.15
Item {
    property bool wordFlag:false
    property alias wordBackground: wordBackground
    width: columnLayout.width
    height: columnLayout.height
    property alias audio:audio
    property var totalTime:"00:00";
    property var currentTime:"00:00";
    property var fileName:" "
    property alias start:start
    property alias pause:pause
    property alias seqPlay: seqPlay
    property alias loopPlay: loopPlay
    property alias ranPlay: ranPlay
    signal playOver()

    function getMusicName(path){
        for(var i=path.length-1;i>=0;i--) {
            if(path[i]==="/") {
                fileName=path.slice(i+1)
                myMusicArray.push(path.slice(i+1))
                content.fileNameText.text=path.slice(i+1);
                content.singerText.text=""
                dialogs.miniDialog.miniText.text=path.slice(i+1);
                break;
            }
        }
    }
    //得到歌曲总时长
    function setTime(playTime) {
        var m,s;
        playTime=(playTime-playTime%1000)/1000;
        m=(playTime-playTime%60)/60
        s=playTime-m*60
        if(m>=0&m<10) {
            if(s>=0&s<10) {
                totalTime="0"+m+":0"+s;
            } else {
                totalTime="0"+m+":"+s;
            }
        } else {
            if(s>=0&s<10) {
                totalTime=m+":0"+s;
            } else {
                totalTime=m+":"+s;
            }
        }
    }

    //得到进度条当前播放时间
    function setTime1(playTime) {
        var m,s;
        playTime=(playTime-playTime%1000)/1000;
        m=(playTime-playTime%60)/60
        s=playTime-m*60
        if(m>=0&m<10) {
            if(s>=0&s<10) {
                currentTime="0"+m+":0"+s;
            } else {
                currentTime="0"+m+":"+s;
            }
        } else {
            if(s>=0&s<10) {
                currentTime=m+":0"+s;
            } else {
                currentTime=m+":"+s;
            }
        }
    }
    Rectangle{
        id:loopName
        width: 65
        height: 20
        color: "black"
        visible: false
        z:-1
        Text {
          id: loopNameText
          color: "white"
       }
    }
   ColumnLayout{
       id:columnLayout
       Layout.alignment: Qt.AlignBottom
       RowLayout{
           spacing: 15
           Layout.preferredHeight: 48
           Image {
               id:seqPlay
               visible: true
               source: "qrc:/image/顺序播放.png"

               TapHandler{
                   onTapped: {
                       seqPlay.visible=false
                       loopPlay.visible=true
                       ranPlay.visible = false
                       loopName.visible=true
                       loopNameText.text = "列表循环"
                   }
               }
               HoverHandler{
                    onHoveredChanged: {
                        if(hovered){
                            loopName.visible = true
                            loopNameText.text = "顺序播放"
                        }
                        if(!hovered){
                            loopName.visible = false
                        }
                    }
               }
           }
           Image {
               id: loopPlay
               visible: false
               source: "qrc:/image/列表循环.png"
               TapHandler{
                   onTapped: {
                       seqPlay.visible=false
                       loopPlay.visible=false
                       ranPlay.visible = true
                       loopName.visible=true
                       loopNameText.text = "随机播放"
                   }
               }
               HoverHandler{
                    onHoveredChanged: {
                        if(hovered){
                            loopName.visible = true
                            loopNameText.text = "列表循环"
                        }
                        if(!hovered){
                            loopName.visible = false
                        }
                    }
               }
           }
           Image {
               id:ranPlay
               visible: false
               source: "qrc:/image/随机播放.png"
               TapHandler{
                   onTapped: {
                       seqPlay.visible=true
                       loopPlay.visible=false
                       ranPlay.visible = false
                       loopName.visible=true
                       loopNameText.text = "顺序播放"
                   }
               }
               HoverHandler{
                    onHoveredChanged: {
                        if(hovered){
                            loopName.visible = true
                            loopNameText.text = "随机播放"
                        }
                        if(!hovered){
                            loopName.visible = false
                        }
                    }
               }
           }
           Image {
               id: searchSongs
               source: "qrc:/image/查找.png"
               TapHandler{
                   onTapped: {
                       dialogs.songSarchDialog.visible=true
                   }
               }
           }
           Rectangle{
               id:wordBackground
               color: "Teal"
               width:25
               height:25
               visible: false
               Text {
                   id: word1
                   anchors.centerIn: parent
                   text: qsTr("词")
                   font.pointSize: 15
                   color: "grey"
                   TapHandler{
                       onTapped: {
                           wordBackground.visible=false
                           word.visible=true
                           dialogs.miniDialog.visible = false
                       }
                   }
               }
           }

           Text {
               id: word
               text: qsTr("词")
               font.pointSize: 15
               Layout.preferredWidth: 25
               Layout.preferredHeight: 25
               color: "grey"
               TapHandler{
                   onTapped: {
                       word.visible=false
                       wordBackground.visible=true
                       dialogs.miniDialog.visible=true
                   }
               }
           }
//           Text {
//               id: karaoke
//               text: qsTr("K")
//               font.pointSize: 15
//               color: "grey"
//           }
           RoundButton{
               Layout.preferredWidth: 35
               Layout.preferredHeight: 35
               id:volumButton
          //     Layout.leftMargin: 30
              icon.source:"qrc:/image/voice.png"
               onClicked: {
                  if(volumSlider.visible) {
                    volumSlider.visible=false;
                  } else{
                     volumSlider.visible=true;
                  }
              }
           }
           Slider{
               id:volumSlider
               visible: false
               to:1.0
               value: audio.volume
               Layout.preferredWidth: 100
               onValueChanged: {
                   audio.volume=value  //音量大小0-1.0
               }
           }
       }
       RowLayout{
           spacing: 15
           RoundButton{
               Layout.preferredWidth: 35
               Layout.preferredHeight: 35
//               Layout.leftMargin: 20
               icon.source:"qrc:/image/stop.png"
               onClicked: {
                   actions.stopAction.triggered()
               }
           }
           RoundButton{
               Layout.preferredWidth: 35
               Layout.preferredHeight: 35
               id:previous
               icon.source:"qrc:/image/pass.png"
               onClicked: {
                    actions.previousAction.triggered()
               }
           }

           RoundButton{
               Layout.preferredWidth: 35
               Layout.preferredHeight: 35
               id:start
               icon.source:"qrc:/image/play.png"
               visible: true
               onClicked: {
                    actions.playAction.triggered()
               }
           }
           RoundButton{
               Layout.preferredWidth: 35
               Layout.preferredHeight: 35
               id:pause
               icon.source:"qrc:/image/pause.png"
               visible: false
               onClicked: {
                   actions.pauseAction.triggered()
               }
           }
           RoundButton{
               Layout.preferredWidth: 35
               Layout.preferredHeight: 35
               id:next
              icon.source:"qrc:/image/back.png"
               onClicked: {
                    actions.nextAction.triggered()
               }
           }
           Slider{
               id:audioSlider
               to:audio.duration
               value: audio.position
               Layout.preferredWidth: 500
               snapMode: Slider.SnapOnRelease
               onValueChanged: {
                   setTime1(value)
                   audio.seek(value);
               }
               onPressedChanged: {
                   if(dialogs.lyricDialog.timerTest.running &&!dialogs.songSarchDialog.networkPlay) {
                       dialogs.lyricDialog.timerTest.running=false
                       dialogs.lyricDialog.onClickAudioSlider()
                   }
                   if(dialogs.songSarchDialog.networkPlay) {
                       dialogs.songSarchDialog.showLyrics()
                   }
               }
           }
           Text {
               id: playbackTime
               text:currentTime+"/"+totalTime
           }
           Image {
               id: playlist
               source: "qrc:/image/播放列表.png"
               TapHandler{
                   onTapped: {
                       if(!content.playlistPage.visible) {
                            content.playlistPage.visible=true
                            content.lyricPage.visible=false
                           content.lyricPage.lyricListView.visible=false
                           content.lyricPage1.lyricListView.visible=true
                       } else {
                            content.playlistPage.visible=false
                            content.lyricPage.visible=true
                           content.lyricPage.lyricListView.visible=true
                           content.lyricPage1.lyricListView.visible=false
                       }
                   }
               }
           }
       }
    }
   Audio{
       id:audio
       onDurationChanged: {
           var playTime=audio.duration;
           setTime(playTime);
       }
       onPositionChanged: {
           if(audio.position != 0 & audio.position == audio.duration){
               actions.pauseAction.triggered()
               content.lyricPage.lyricListModel.clear()
               content.lyricPage1.lyricListModel.clear()
               if(dialogs.songSarchDialog.networkPlay){
                   networkplayOrder()
               }else{
                   playOrder()
               }
           }
           content.spectrogram.pcount=position/100
       }
   }
  function playOrder() {
      var flag = true
      var num = playlistPage.songListView.currentIndex
      if(seqPlay.visible){
          if((num === playlistPage.songSerialNumber-1) ){
               audio.stop();
               flag = false
          }else{
              num++
              dialogs.lyricDialog.fileIo.readUrls(num, "../播放列表.txt")
              audio.source = dialogs.lyricDialog.fileIo.source
              content.musicPlayer.fileName=content.musicPlayer.getMusicName(dialogs.lyricDialog.fileIo.source)
          }
      }else if(loopPlay.visible){
          if(num === playlistPage.songSerialNumber-1){
              num = 0;
              dialogs.lyricDialog.fileIo.readUrls(num, "../播放列表.txt")
              audio.source = dialogs.lyricDialog.fileIo.source
              content.musicPlayer.fileName=content.musicPlayer.getMusicName((dialogs.lyricDialog.fileIo.source))
          }else{
              num++
              dialogs.lyricDialog.fileIo.readUrls(num, "../播放列表.txt")
              audio.source = dialogs.lyricDialog.fileIo.source
              content.musicPlayer.fileName=content.musicPlayer.getMusicName(dialogs.lyricDialog.fileIo.source)
          }
      }else{
           var Range = playlistPage.songSerialNumber -1
           var rand = Math.random();                   //random函数得到一个0-1之间的小数， round函数取整，四舍五入
           num = 1 + Math.round(rand*Range);
           dialogs.lyricDialog.fileIo.readUrls(num, "../播放列表.txt")
           audio.source = dialogs.lyricDialog.fileIo.source
           content.musicPlayer.fileName=content.musicPlayer.getMusicName(dialogs.lyricDialog.fileIo.source)
      }
      playlistPage.songListView.currentIndex = num
      if(flag){
          var path = new String(audio.source).slice(7)
          dialogs.songLabelDialog.song.getTags(path)
          dialogs.songLabelDialog.get_Tags_Meta()
      }
  }

  function networkplayOrder(){
      var num = dialogs.songSarchDialog.searchlistView.currentIndex
      if(seqPlay.visible){
          if(num  === dialogs.songSarchDialog.songListModel.count-1){
               audio.stop()
          }else{
               num++;
          }
      }else if(loopPlay.visible){
          if(num  === dialogs.songSarchDialog.songListModel.count-1){
               num = 0
          }else{
               num++;
          }
      }else{
          var Range = dialogs.songSarchDialog.songListModel.count-1
          var rand = Math.random();                   //random函数得到一个0-1之间的小数， round函数取整，四舍五入
          num = 1 + Math.round(rand*Range);
      }
      dialogs.songSarchDialog.searchlistView.currentIndex = num
      dialogs.songSarchDialog.play1.triggered()
  }
}
