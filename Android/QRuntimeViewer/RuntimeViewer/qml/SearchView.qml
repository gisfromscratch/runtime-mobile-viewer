import QtQuick 2.0

Rectangle {
    id: searchView
    width: 320
    height: parent.height
    color: "#4f5764"

    Rectangle {
        id: searchViewHeader
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
            text: qsTr("Search")
        }
    }

    Rectangle {
        id: searchViewFooter
        color: "#272c33"
        width: parent.width
        height: 44
        anchors.bottom: parent.bottom

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10
            Column {
                Image {
                    height: searchViewFooter.height
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/Resources/toolbars/window-close.png"

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            searchView.visible = false;
                        }
                    }
                }
            }

            Column {
                Text {
                    verticalAlignment: Text.AlignVCenter
                    height: searchViewFooter.height
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
