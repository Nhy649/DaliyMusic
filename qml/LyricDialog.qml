import QtQuick 2.15
import QtQuick.Controls 2.12 as QQ
import QtQuick.Controls 1.4 as QQC
import QtQuick.Layouts 1.12
import Lyric 1.0
import FileIo 1.0

QQ.ApplicationWindow {
    id: root
    width: 450
    height: 500
    visible: true
    title: qsTr("编辑歌词")
    property real mX:0.0
    property real mY:0.0
    property bool flag: false
    property int pos: 0

    property alias fileIo:fileIo
    property alias lyric_id:lyric_id
    property var timeStampIndex:0
    property bool timeFlag:false;
    property alias timerTest:timerTest
    property alias action:action
    property alias textArea:textArea
    property var testNum:0

    function getColumn(){
        var pos = textArea.cursorPosition;
        var start= textArea.cursorPosition;
        while((textArea.getText(start-1, start) !== "\r")&&(textArea.getText(start-1, start) !== "\n")&&( start !== 0)){
            start--;
        }

        return pos-start+1
    }

    function getRow(){
        var end = textArea.cursorPosition
        var num = 0;
        var str;
        for(var i = 0; i < end; i++){
            str = textArea.getText(i, i+1)
            if((str === "\r")||(str === "\n")){
                num++;
            }
        }
        return num+1
    }

    QQ.MenuSeparator{id:menuSeparator}
    menuBar: QQ.MenuBar{
        id: menBar

        QQ.Menu{
            title: qsTr("文件")

            contentData: [
                action.newAction,
                action.openAction,
                action.saveAction,
                action.closeAction,
                action.exitAction
            ]
        }
        QQ.Menu{
            title: qsTr("编辑")

            contentData: [
                action.copyAction,
                action.pasteAction,
                action.cutAction,
                menuSeparator,
                action.undoAction,
                action.redoAction
            ]
        }
        QQ.Menu{
            title: qsTr("标签")

            contentData: [
                action.addTagAction,
                action.deleteHeaderLabelAction,
                action.deleteAllLabelAction
            ]
        }
        QQ.Menu{
            title: qsTr("测试播放")

            contentData: [
                action.testAction
            ]
        }
    }

    header:QQ.ToolBar{
        id: toolBar
        RowLayout{
           QQ.ToolButton {
                id:toolBaropen
                icon.source: "qrc:/image/open.png"
                onClicked: {action.openAction.triggered()}
            }
            QQ.ToolButton {
                id:toolBarAddTag
                icon.source: "qrc:/image/add.png"
                onClicked: {action.addTagAction.triggered()}
            }
            QQ.ToolButton {
                id:tooBarDeleteHeaderLabel
                icon.source: "qrc:/image/delete.png"
                onClicked: {action.deleteHeaderLabelAction.triggered()}
            }
            QQ.ToolButton {
                id:tooBarTest
                icon.source: "qrc:/image/test.png"
                onClicked: {action.testAction.triggered()}
                enabled: content.musicPlayer.pause.visible & textArea.length!==0
            }
        }
    }

    footer: Rectangle{
        anchors.bottom: parent.buttom
        height: 30
        border.width: 1
        border.color: "grey"
        RowLayout{
            anchors.verticalCenter: parent.verticalCenter
            spacing: 60
            QQ.Button{
                implicitWidth: 100
                implicitHeight: 25
                text: qsTr("行"+getRow()+", 列"+getColumn())
                background: Rectangle{
                    id: rec1
                    width: parent.width-2
                    border.width: 1
                    border.color: "white"
                }
                HoverHandler{
                    onHoveredChanged: {
                        if(hovered){
                            rec1.border.color = "lightblue"
                        }else{
                            rec1.border.color = "white"
                        }
                    }
                }
            }
            QQ.Button{
                implicitWidth: 100
                implicitHeight: 25
                text: qsTr("共"+textArea.length+"个字符")
                background: Rectangle{
                    id: rec2
                    width: parent.width-2
                    border.width: 1
                    border.color: "white"
                }
                HoverHandler{
                    onHoveredChanged: {
                        if(hovered){
                            rec2.border.color = "lightblue"
                        }else{
                            rec2.border.color = "white"
                        }
                    }
                }
            }
            QQ.Button{
                implicitWidth: 100
                implicitHeight: 25
                text: flag?qsTr("已修改"):qsTr("未修改")
                background: Rectangle{
                    id: rec3
                    width: parent.width-2
                    border.width: 1
                    border.color: "white"
                }
                HoverHandler{
                    onHoveredChanged: {
                        if(hovered){
                            rec3.border.color = "lightblue"
                        }else{
                            rec3.border.color = "white"
                        }
                    }
                }
            }
        }
    }

    QQC.TextArea{
        id: textArea
        anchors.fill: parent
        focus: true
//        selectByKeyboard: true   //让文本中的内容可以被鼠标选中
        textFormat: TextEdit.AutoText
        onTextChanged: {
            if(text.length !== 0){
                flag = true;
            }
        }
        MouseArea{
            id:mouseArea
            acceptedButtons: Qt.RightButton   //点击右键，content 响应右键的上下文菜单
            anchors.fill: textArea
            onClicked: {
                if(mouse.button==Qt.RightButton) {
                    mX=mouseX
                    mY=mouseY
                    menu1.open()
                }
            }
        }
        TapHandler{
            acceptedButtons: Qt.LeftButton  //点击左键，content 响应左键，右键的mousearea 关闭
            onTapped: {
                mouseArea.enabled=false;
            }
        }

        QQ.Menu{
            id:menu1
            x:mX
            y:mY
            contentData: [
                action.copyAction,
                action.pasteAction,
                action.cutAction,
                action.undoAction,
                action.redoAction
            ]
        }
    }

    LyricEditorActions{
        id:action
        newAction.onTriggered: {
            if(flag === true){
                dialogs.newDialog.open()
            }else{
                textArea.text = "";
                dialogs.fileDialog.selectExisting = false
            }
        }
        openAction.onTriggered: {
            if(flag === true){
                dialogs.closeDialog.open()
            }else{
                dialogs.fileDialog.selectExisting = true;
                dialogs.fileDialog.open();
            }
        }
        saveAction.onTriggered: {
            if(!dialogs.fileDialog.selectExisting){
                dialogs.fileDialog.open()
            }else{
                var filePath=new String(dialogs.fileDialog.fileUrl);
                fileIo.source=filePath.slice(7);  //   remove file://
                fileIo.write(textArea.text)
                lyric_id.lyric=textArea.text;
            }
            flag = false
        }
        closeAction.onTriggered:{
            if(flag === true){
                dialogs.newDialog.open()
            }else{
                textArea.text = "";
                dialogs.fileDialog.selectExisting = false
            }
        }
        exitAction.onTriggered: {
            textArea.text = ""
            root.close()
        }

        cutAction.onTriggered: {
            textArea.cut();
        }
        copyAction.onTriggered: {
            textArea.copy();
        }
        pasteAction.onTriggered: {
            textArea.paste();
        }
        undoAction.onTriggered: textArea.undo()
        redoAction.onTriggered: textArea.redo()
        addTagAction.onTriggered:{
            pos = textArea.cursorPosition;
            textArea.text=lyric_id.addTag(textArea.text,textArea.cursorPosition,action.addTagAction.text.slice(4));
            textArea.cursorPosition = pos;
        }
        deleteHeaderLabelAction.onTriggered: {
            textArea.text=lyric_id.deleteHeaderLabel(textArea.text,textArea.cursorPosition)
        }
        deleteAllLabelAction.onTriggered:{
            textArea.text=lyric_id.deleteAllLabel(textArea.text,textArea.cursorPosition)
        }
        Timer{
            id:timerTest
            repeat: true
            running: false
            onTriggered: {
                if(timeFlag) {
                    lyric_id.test(lyric_id.translateStamp(lyric_id.timeStamp[timeStampIndex]));
                    timeFlag=false;
                    content.lyricPage.lyricListView.currentIndex=timeStampIndex
                    content.lyricPage1.lyricListView.currentIndex=timeStampIndex
                    miniDialog.miniText.text = content.lyricPage.lyricListModel.get(content.lyricPage.lyricListView.currentIndex).currentLyrics

                } else {
                    lyric_id.test(lyric_id.translateStamp(lyric_id.timeStamp[timeStampIndex]));

                    content.lyricPage.lyricListView.currentIndex++;
                    content.lyricPage1.lyricListView.currentIndex++;

                    if(content.lyricPage.lyricListModel.count===10) {
                        miniDialog.miniText.text = content.lyricPage.lyricListModel.get(content.lyricPage.lyricListView.currentIndex-1).currentLyrics
                    }else{
                        miniDialog.miniText.text = content.lyricPage.lyricListModel.get(content.lyricPage.lyricListView.currentIndex).currentLyrics
                    }
                }

                if(!songSarchDialog.networkPlay) {
                    highlight()
                }

                timeStampIndex++;
                interval=lyric_id.timeStamp[timeStampIndex]-lyric_id.timeStamp[timeStampIndex-1];
                if(content.musicPlayer.currentTime===content.musicPlayer.totalTime) {
                    timerTest.running=false
                    content.musicPlayer.pause.clicked()
                }
            }
        }
        testAction.onTriggered: {
            if(!timerTest.running) {
                action.addTagAction.enabled=false;
                action.deleteHeaderLabelAction.enabled=false;
                action.deleteAllLabelAction.enabled=false;

                if(content.playlistPage.visible) {
                     content.lyricPage.lyricListView.visible=false
                     content.lyricPage1.lyricListView.visible=true
                } else {
                     content.lyricPage.lyricListView.visible=true
                     content.lyricPage1.lyricListView.visible=false
                }

                content.lyricPage.lyricListModel.clear()
                content.lyricPage1.lyricListModel.clear()

                content.lyricPage.lyricText.visible=false
                lyric_id.lyric=textArea.text
                lyric_id.extract_timeStamp();

                content.lyricPage.appendRight(lyric_id.painLyric.length)
                content.lyricPage.appendLeft(lyric_id.painLyric.length)

                onClickAudioSlider();
            } else {
                action.addTagAction.enabled=true;
                action.deleteHeaderLabelAction.enabled=true;
                action.deleteAllLabelAction.enabled=true;
                timerTest.running=false
                testNum=0

                content.lyricPage.lyricListModel.clear()
                content.lyricPage1.lyricListModel.clear()
                content.lyricPage.lyricText.visible=true

                console.log("结束测试")
            }
        }
    }

    LyricEditorDialogs{
        id: dialogs
        fileDialog.onAccepted: {
            var filePath=new String(fileDialog.fileUrl);
            fileIo.source=filePath.slice(7);  //   remove file://
            if(fileDialog.selectExisting){
                textArea.text=fileIo.read();
                flag = false;
                lyric_id.lyric=textArea.text;    //更新歌词内容
//                lyric_id.extract_timeStamp();               //解析出时间戳
            }else{
                fileIo.write(textArea.text)
                dialogs.fileDialog.selectExisting = true
            }
        }
    }

    FileIo{
        id: fileIo
    }

    Lyric{
        id: lyric_id
    }

    function onClickAudioSlider() {
        content.lyricPage.lyricListView.currentIndex=-1
        timeStampIndex=lyric_id.findTimeInterval("["+content.musicPlayer.currentTime+"]");
        timerTest.interval=lyric_id.timeDif;     //设置第一个时间间隔
        timeFlag=true;
        timerTest.running=true
        testNum=1
        console.log("开始测试")
    }

    function highlight(){
        textArea.cursorPosition=lyric_id.highlightPos;
        textArea.select(lyric_id.highlightPos,lyric_id.highlightPos+lyric_id.highlightLength);
    }

}
