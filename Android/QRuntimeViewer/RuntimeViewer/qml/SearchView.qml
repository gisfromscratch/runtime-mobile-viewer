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

    Item {
        id: searchViewInput
        anchors {
            top: searchViewHeader.bottom
            bottom: searchViewFooter.top
        }
        width: parent.width
        height: searchViewHeader.top - searchViewFooter.bottom

        Row {
            id: searchInputRow
            anchors {
                top: parent.top
                topMargin: 32
                left: parent.left
                leftMargin: 32
            }
            spacing: 10

            Column {
                Rectangle {
                    width: 100
                    height: 32
                    color: searchView.color
                    Text {
                         anchors.centerIn: parent
                        font {
                            family: "Helvetica"
                            pixelSize: 16
                        }
                        color: "#ffffff"
                        text: qsTr("Search:")
                    }
                }
            }

            Column {
                Rectangle {
                    width: 150
                    height: 32
                    radius: 10
                    color: "#ffffff"
                    TextInput {
                        id: searchInput
                        anchors.centerIn: parent
                        width: parent.width - 32
                        wrapMode: Text.NoWrap
                        clip: true
                        font {
                            family: "Helvetica"
                            pixelSize: 16
                        }
                        color: searchView.color
                        text: qsTr("...")
                    }
                }
            }
        }

        Row {
            layoutDirection: Qt.RightToLeft
            anchors {
                bottom: parent.bottom
                bottomMargin: 32
                left: parent.left
                leftMargin: 32
                right: parent.right
                rightMargin: 32
            }
            Rectangle {
                width: 150
                height: 32
                radius: 10
                color: searchViewHeader.color

                Text {
                    anchors.centerIn: parent
                    font {
                        family: "Helvetica"
                        pixelSize: 16
                    }
                    color: "#ffffff"
                    text: qsTr("Search")
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        console.log("Searching... '" + searchInput.text + "'");
                    }
                }
            }
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
