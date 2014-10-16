import QtQuick 2.0

Rectangle {
    id: gallery
    width: 320
    height: parent.height
    color: "#4f5764"

    signal basemapChanged(string basemapUrl)

    Rectangle {
        id: galleryHeader
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
            text: qsTr("Basemaps")
        }
    }

    GridView {
        id: gridView
        model: viewModel
        cellWidth: 120
        cellHeight: 120

        anchors {
            fill: parent
            top: galleryHeader.bottom
            topMargin: 50
            margins: {
                left: 32
            }
        }
    }

    Component {
        id: layerView
        Rectangle {
            id: item
            width: gridView.cellWidth
            height: gridView.cellHeight
            color: gallery.color

            property bool hovered: false

            Column {
                anchors.fill: parent
                Image {
                    id: image
                    width: parent.width - 32
                    height: parent.height - 32
                    anchors.horizontalCenter: parent.horizontalCenter
                    fillMode: Image.PreserveAspectFit
                    source: imageSource

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true

                        onClicked: {
                            gallery.basemapChanged(layerUrl);
                            gallery.visible = false;
                        }
                        onHoveredChanged: {
                            item.hovered = !item.hovered;
                            item.color = (item.hovered) ? "#3e4551" : gallery.color;
                        }
                    }
                }

                Text {
                    id: basemapText
                    anchors.horizontalCenter: parent.horizontalCenter
                    font {
                        family: "Helvetica"
                        pixelSize: 12
                    }
                    color: "white"
                    text: layerName
                }
            }
        }
    }

    VisualDataModel {
        id: viewModel
        model: serviceModel

        delegate: layerView
    }

    ListModel {
        id: serviceModel
    }

    function addLayer(layerName, layerUrl, thumbnailUrl) {
        serviceModel.append({ 'layerName': layerName, 'layerUrl': layerUrl, 'imageSource': thumbnailUrl });
    }

    Rectangle {
        id: galleryFooter
        color: "#272c33"
        width: parent.width
        height: 44

        anchors.bottom: gallery.bottom

        Row {
            spacing: 5
            Column {
                Image {
                    height: galleryFooter.height
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/Resources/AppIcon.png"

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            gallery.visible = false;
                        }
                    }
                }
            }

            Column {
                Text {
                    verticalAlignment: Text.AlignVCenter
                    height: galleryFooter.height
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
