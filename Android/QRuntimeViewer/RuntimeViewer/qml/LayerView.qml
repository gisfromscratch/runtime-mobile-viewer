import QtQuick 2.0

Rectangle {
    id: layerView
    width: 320
    height: parent.height
    color: "#4f5764"

    Rectangle {
        id: layerViewHeader
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
            text: qsTr("Layers")
        }
    }

    ListView {
        anchors.top: layerViewHeader.bottom
        anchors.bottom: layerViewFooter.top
        width: parent.width
        height: layerViewHeader.bottom - layerViewFooter.top

        delegate: layerItemView

        model: ListModel {
            ListElement {
                name: "---"
            }
        }
    }

    Component {
        id: layerItemView
        Item {
            width: parent.width;
            Column {
                x: 5; y: 5
                Text {
                    font {
                        family: "Helvetica"
                        pixelSize: 16
                    }
                    color: "white"
                    text: '<b>Name:</b> ' + name
                }
            }
        }
    }


    Rectangle {
        id: layerViewFooter
        color: "#272c33"
        width: parent.width
        height: 44
        anchors.bottom: layerView.bottom

        Row {
            spacing: 5
            Column {
                Image {
                    height: layerViewFooter.height
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/Resources/toolbars/window-close.png"

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            layerView.visible = false;
                        }
                    }
                }
            }

            Column {
                Text {
                    verticalAlignment: Text.AlignVCenter
                    height: layerViewFooter.height
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
