import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import Qt.WebSockets 1.0

import ArcGIS.Runtime 10.3

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

    ListView {
        anchors.top: settingsViewHeader.bottom
        anchors.bottom: settingsViewFooter.top
        width: settingsView.width
        height: settingsViewHeader.top - settingsViewFooter.bottom
        orientation: ListView.Vertical

        delegate: settingsItemView

        model: ListModel {
            id: settingsViewModel

            ListElement {
                settingsItemName: "Satellites"
            }
        }
    }

    WebSocket {
        id: satelliteSocket
        url: "ws://geoeventsample3.esri.com:8080/satelliteservice"

        property GraphicsLayer layer: null
        property SimpleMarkerSymbol defaultSymbol : SimpleMarkerSymbol {
            style: "SimpleMarkerSymbolStyleCircle"
            color: "#3e4551"
            size: 5
        }

        onTextMessageReceived: {
            var features = JSON.parse(message);
            var targetSpatialReference = focusMap.spatialReference;
            for (var index in features) {
                var feature = ArcGISRuntime.createObject("Graphic");
                feature.json = features[index];
                var geometry = feature.geometry;
                if ("Point" === geometry.objectType) {
                    // Currently only WGS84 supported
                    feature.geometry = GeometryEngine.project(geometry.x, geometry.y, targetSpatialReference);
                    feature.symbol = defaultSymbol;
                    layer.addGraphic(feature);
                }
            }
        }
        onStatusChanged: {
            if (satelliteSocket.status == WebSocket.Error) {
                console.log("Error: " + satelliteSocket.errorString);
            } else if (satelliteSocket.status == WebSocket.Open) {
                console.log("Socket opened");
                layer = ArcGISRuntime.createObject("GraphicsLayer");
                focusMap.addLayer(layer);
            } else if (satelliteSocket.status == WebSocket.Closed) {
                console.log("Socket closed");
                focusMap.removeLayer(layer);
                layer = null;
            }
        }
        active: false
    }


    Component {
        id: settingsItemView
        Item {
            width: settingsView.width;
            height: 50

            Column {
                x: 32; y: 32
                CheckBox {
                    id: checkBox
                    checked: satelliteSocket.active

                    style: CheckBoxStyle {
                        spacing: 10
                        label: Text {
                            font {
                                family: "Helvetica"
                                pixelSize: 16
                            }
                            color: "white"
                            text: settingsItemName
                        }
                    }

                    onCheckedChanged: {
                        satelliteSocket.active = checkBox.checked;
                    }
                }
            }
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
