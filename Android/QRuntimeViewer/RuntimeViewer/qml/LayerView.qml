import QtQuick 2.0
import ArcGIS.Runtime 10.3

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
            height: 50

            Row {
                x: 32; y: 32
                spacing: 10
                Column {
                    Image {
                        id: checkImage
                        fillMode: Image.PreserveAspectFit
                        source: focusMap.layers[layerIndex].visible ? "qrc:/Resources/dialog-ok-apply-2.png" : "qrc:/Resources/dialog-ok-apply-empty-2.png"

                        states: [
                            State {
                                name: "checked"
                                PropertyChanges { target: checkImage; source: "qrc:/Resources/dialog-ok-apply-2.png" }
                            },
                            State {
                                name: "unchecked"
                                PropertyChanges { target: checkImage; source: "qrc:/Resources/dialog-ok-apply-empty-2.png" }
                            }
                        ]

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                var featureLayer = focusMap.layers[layerIndex];
                                featureLayer.visible = !featureLayer.visible;
                                checkImage.state = (featureLayer.visible) ? "checked" : "unchecked";
                                if (featureLayer.visible) {
                                    focusMap.zoomTo(featureLayer.fullExtent);
                                }
                            }
                        }
                }}

                Column {
                    y: 5
                    Text {
                        verticalAlignment: Text.AlignVCenter
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

    function updateLayers(focusMap) {
        layerViewModel.clear();
        for (var layerIndex in focusMap.layers) {
            var layer = focusMap.layers[layerIndex];
            if ("FeatureLayer" === layer.objectType) {
                layerViewModel.append({ 'layerName': layer.name, 'layerIndex': layerIndex });
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
            anchors.horizontalCenter: parent.horizontalCenter
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
