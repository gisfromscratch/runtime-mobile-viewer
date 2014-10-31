import QtQuick 2.0
import QtGraphicalEffects 1.0

import ArcGIS.Runtime 10.3
import ArcGIS.Extras 1.0

import "Mapping.js" as Mapping

Item {

    // All local feature tables strong referenced
    property var localFeatureTables: []

    function showRuntimeContent(localConnection) {
        focusMap.removeAll();
        focusMap.reset();
        Mapping.addLocalFeatureData(focusMap, localFeatureTables, localConnection);
    }

    Column {
        Rectangle {
            id: header
            width: appWindow.width
            height: 50

            LinearGradient {
                anchors.fill: parent
                start: Qt.point(0, 0)
                end: Qt.point(0, height)
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "white" }
                    GradientStop { position: 1.0; color: appWindow.color }
                }
            }

            Text {
                id: backText
                anchors {
                    left: header.left
                    leftMargin: 10
                    verticalCenter: header.verticalCenter
                }

                font {
                    family: "Helvetica"
                    pointSize: 12
                    bold: true
                }

                text: qsTr("< Back")

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        mapView.visible = false;
                        runtimeContentGridView.visible = true;
                    }
                }
            }

            Text {
                id: headerText
                anchors.centerIn: header

                font {
                    family: "Helvetica"
                    pointSize: 12
                    bold: true
                }

                text: qsTr("Map View")
            }
        }

        Map {
            id: focusMap
            width: appWindow.width
            height: appWindow.height - header.height
        }
    }
}
