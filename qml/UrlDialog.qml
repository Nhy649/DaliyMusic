import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.15
ApplicationWindow{
    width:320
    height: 130
    visible: true
    property alias submitButton:submitBtn
    property alias cancelButton:cancelBtn
    property alias urlTextField:urlTextField
    ColumnLayout{
        anchors.fill:parent
        RowLayout{
            Layout.margins: 10
            Layout.fillWidth: true
            Text {
                id:urlText
                text: qsTr("URL:")
            }
            TextField{
                id:urlTextField
                Layout.preferredWidth: 250
            }
        }
        RowLayout{
            Layout.fillWidth: parent
            Layout.margins:20
            Layout.alignment: Qt.AlignRight
            Button{
                id:submitBtn
                text: "提交"
            }
            Button{
                id:cancelBtn
                text:"取消"
            }
        }
    }
}
