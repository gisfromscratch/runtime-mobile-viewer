import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
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

            Column {
                x: 32; y: 32
                CheckBox {
                    id: checkBox
                    checked: focusMap.layers[layerIndex].visible;

                    style: CheckBoxStyle {
                        spacing: 10
                        label: Text {
                            font {
                                family: "Helvetica"
                                pixelSize: 16
                            }
                            color: "white"
                            text: layerName
                        }
                    }

                    onCheckedChanged: {
                        focusMap.layers[layerIndex].visible = checked;
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
