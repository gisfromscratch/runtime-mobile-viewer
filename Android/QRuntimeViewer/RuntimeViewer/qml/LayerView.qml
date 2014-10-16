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
        width: layerView.width
        height: layerViewHeader.top - layerViewFooter.bottom
        orientation: ListView.Vertical

        delegate: layerItemView

        model: ListModel {
            id: layerViewModel
        }
    }

    Component {
        id: layerItemView
        Item {
            width: layerView.width;

            Row {
                x: 32; y: 5
                spacing: 10
                Image {
                    fillMode: Image.PreserveAspectFit
                    source: visible ? "qrc:/Resources/dialog-ok-apply-2.png" : ""
                }

                Column {
                    x: 32; y: 5
                    Text {
                        font {
                            family: "Helvetica"
                            pixelSize: 16
                        }
                        color: "white"
                        text: layerName
                    }
                }
            }
        }
    }

    function updateLayers(map) {
        for (var layerIndex = 0; layerIndex < map.layerCount; layerIndex++) {
            var layer = map.layer(layerIndex);
            console.log(layer.name);
            layerViewModel.append({ 'layerName': layer.name, 'visible': layer.visible });
        }
    }

    Rectangle {
        id: layerViewFooter
        color: "#272c33"
        width: parent.width
        height: 44
        anchors.bottom: layerView.bottom

        Row {
            x: 32
            spacing: 10
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
