import QtQuick 2.0

Rectangle {
    id: settingsView
    width: 320
    height: parent.height
    color: "#4f5764"

    Rectangle {
        id: settingsViewHeader
        color: "#272c33"
        width: parent.width
        height: 44

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font {
                family: "Helvetica"
                pixelSize: 16
            }
            color: "#ffffff"
            text: qsTr("Settings")
        }
    }


    Rectangle {
        id: settingsViewFooter
        color: "#272c33"
        width: parent.width
        height: 44
        anchors.bottom: settingsView.bottom

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10
            Column {
                Image {
                    height: settingsViewFooter.height
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/Resources/toolbars/window-close.png"

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            settingsView.visible = false;
                        }
                    }
                }
            }

            Column {
                Text {
                    verticalAlignment: Text.AlignVCenter
                    height: settingsViewFooter.height
                    font {
                        family: "Helvetica"
                        pixelSize: 16
                    }
                    color: "#ffffff"
                    text: qsTr("Close")
                }
            }
        }
    }
}
