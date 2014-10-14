import QtQuick 2.0

Rectangle {
    id: gallery
    width: parent.width
    height: 100

    signal basemapChanged(string basemapUrl)

    ListView {
        id: listView
        model: viewModel
        //delegate: layerView

        anchors.fill: parent
        orientation: ListView.Horizontal
        spacing: 10
    }

    Component {
        id: layerView
        Item {
            id: item
            width: parent.height
            height: parent.height

            Image {
                id: image
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                source: imageSource

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        gallery.basemapChanged(layerUrl);
                    }
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

    function addLayer(layerUrl, thumbnailUrl) {
        serviceModel.append({ 'layerUrl': layerUrl, 'imageSource': thumbnailUrl });
    }
}
