import QtQuick 2.0
import ArcGIS.Extras 1.0

Rectangle {
    id: navigationBar
    width: 120
    height: parent.height
    color: "#4f5764"

    property int displayFactor: System.displayScaleFactor

    Item {
        id: basemapItem
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 35
        height: 100
        Text {
            id: basemapText
            anchors.horizontalCenter: parent.horizontalCenter
            font {
                family: "Helvetica"
                pixelSize: 14
            }
            color: "white"
            text: qsTr("Basemaps")
        }

        Image {
            id: basemapImage
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: "qrc:/Resources/toolbars/diamond_blue.png"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    gallery.visible = true;
                }
            }
        }
    }
    Item {
        id: layersItem
        width: parent.width
        anchors.top: basemapItem.bottom
        height: 100
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            font {
                family: "Helvetica"
                pixelSize: 14
            }
            color: "white"
            text: qsTr("Layers")
        }

        Image {
            id: layersImage
            anchors.fill: parent
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectFit
            source: "qrc:/Resources/toolbars/diamond_green.png"
        }
    }
    Item {
        id: searchItem
        width: parent.width
        anchors.top: layersItem.bottom
        height: 100
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            font {
                family: "Helvetica"
                pixelSize: 14
            }
            color: "white"
            text: qsTr("Search")
        }

        Image {
            id: searchImage
            anchors.fill: parent
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectFit
            source: "qrc:/Resources/toolbars/diamond_orange.png"
        }
    }
    Item {
        id: documentsItem
        width: parent.width
        anchors.top: searchItem.bottom
        height: 100
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            font {
                family: "Helvetica"
                pixelSize: 14
            }
            color: "white"
            text: qsTr("Documents")
        }

        Image {
            id: documentsImage
            anchors.fill: parent
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectFit
            source: "qrc:/Resources/toolbars/diamond_red.png"
        }
    }
    Item {
        id: settingsItem
        width: parent.width
        anchors.top: documentsItem.bottom
        height: 100
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            font {
                family: "Helvetica"
                pixelSize: 14
            }
            color: "white"
            text: qsTr("Settings")
        }

        Image {
            id: settingsImage
            anchors.fill: parent
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectFit
            source: "qrc:/Resources/toolbars/diamond_blue.png"
        }
    }
}
