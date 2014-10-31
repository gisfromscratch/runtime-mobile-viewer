import QtQuick 2.0
import ArcGIS.Runtime 10.3
import ArcGIS.Extras 1.0

Item{
    property Geodatabase geodatabase: Geodatabase {
        path: System.userHomeFolder.filePath("data/openstreetmap.geodatabase")
    }
    Column {
        Rectangle {
            id: header
            width: appWindow.width
            height: 50

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

            FeatureLayer {
                featureTable: geodatabase.geodatabaseFeatureTables[0]
            }
        }
    }
}
