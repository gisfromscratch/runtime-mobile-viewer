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

    ListView {
        id: listView
        model: viewModel

        anchors.fill: parent
        anchors.margins: {
            left: 32
        }

        orientation: ListView.Horizontal
        spacing: 32
    }

    Component {
        id: layerView
        Item {
            id: item
            width: 100
            height: 100

            Image {
                id: image
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                source: imageSource

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        gallery.basemapChanged(layerUrl);
                        gallery.visible = false;
                    }
                }
            }

            Text {
                id: basemapText
                anchors.top: image.bottom
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
}
