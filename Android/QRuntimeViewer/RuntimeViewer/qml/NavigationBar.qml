import QtQuick 2.0
import ArcGIS.Extras 1.0

Rectangle {
    id: navigationBar
    width: 120
    height: parent.height
    color: "#4f5764"

    property int displayFactor: System.displayScaleFactor

    function handleHoverItem(item) {
        item.hovered = !item.hovered;
        item.color = (item.hovered) ? "#3e4551" : "#4f5764";
    }

    Rectangle {
        id: basemapItem
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 35
        height: 100
        color: parent.color

        property bool hovered: false

        Text {
            id: basemapText
            anchors {
                top: parent.top
                topMargin: 10
                horizontalCenter: parent.horizontalCenter
            }
            font {
                family: "Helvetica"
                pixelSize: 14
            }
            color: "white"
            text: qsTr("Basemaps")
        }

        Image {
            id: basemapImage
            anchors {
                fill: parent
                top: basemapText.bottom
                topMargin: 10
            }
            fillMode: Image.PreserveAspectFit
            source: "qrc:/Resources/toolbars/diamond_blue.png"

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    gallery.visible = true;
                }
                onHoveredChanged: {
                    handleHoverItem(basemapItem);
                }
            }
        }
    }
    Rectangle {
        id: layersItem
        width: parent.width
        anchors.top: basemapItem.bottom
        height: 100
        color: parent.color

        property bool hovered: false

        Text {
            id: layersText
            anchors {
                top: parent.top
                topMargin: 10
                horizontalCenter: parent.horizontalCenter
            }
            font {
                family: "Helvetica"
                pixelSize: 14
            }
            color: "white"
            text: qsTr("Layers")
        }

        Image {
            id: layersImage
            anchors {
                fill: parent
                top: layersText.bottom
                topMargin: 10
            }
            fillMode: Image.PreserveAspectFit
            source: "qrc:/Resources/toolbars/diamond_green.png"
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                layerView.visible = true;
            }
            onHoveredChanged: {
                handleHoverItem(layersItem);
            }
        }
    }
    Rectangle {
        id: searchItem
        width: parent.width
        anchors.top: layersItem.bottom
        height: 100
        color: parent.color

        property bool hovered: false

        Text {
            id: searchText
            anchors {
                top: parent.top
                topMargin: 10
                horizontalCenter: parent.horizontalCenter
            }
            font {
                family: "Helvetica"
                pixelSize: 14
            }
            color: "white"
            text: qsTr("Search")
        }

        Image {
            id: searchImage
            anchors {
                fill: parent
                top: searchText.bottom
                topMargin: 10
            }
            fillMode: Image.PreserveAspectFit
            source: "qrc:/Resources/toolbars/diamond_orange.png"

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    // TODO:
                }
                onHoveredChanged: {
                    handleHoverItem(searchItem);
                }
            }
        }
    }
    Rectangle {
        id: documentsItem
        width: parent.width
        anchors.top: searchItem.bottom
        height: 100
        color: parent.color

        property bool hovered: false

        Text {
            id: documentsText
            anchors {
                top: parent.top
                topMargin: 10
                horizontalCenter: parent.horizontalCenter
            }
            font {
                family: "Helvetica"
                pixelSize:14
            }
            color: "white"
            text: qsTr("Documents")
        }

        Image {
            id: documentsImage
            anchors {
                fill: parent
                top: documentsText.bottom
                topMargin: 10
            }
            fillMode: Image.PreserveAspectFit
            source: "qrc:/Resources/toolbars/diamond_red.png"

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    // TODO:
                }
                onHoveredChanged: {
                    handleHoverItem(documentsItem);
                }
            }
        }
    }
    Rectangle {
        id: settingsItem
        width: parent.width
        anchors.top: documentsItem.bottom
        height: 100
        color: parent.color

        property bool hovered: false

        Text {
            id: settingsText
            anchors {
                top: parent.top
                topMargin: 10
                horizontalCenter: parent.horizontalCenter
            }
            font {
                family: "Helvetica"
                pixelSize: 14
            }
            color: "white"
            text: qsTr("Settings")
        }

        Image {
            id: settingsImage
            anchors {
                fill: parent
                top: settingsText.bottom
                topMargin: 10
            }
            fillMode: Image.PreserveAspectFit
            source: "qrc:/Resources/toolbars/diamond_blue.png"

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    // TODO:
                }
                onHoveredChanged: {
                    handleHoverItem(settingsItem);
                }
            }
        }
    }
}
