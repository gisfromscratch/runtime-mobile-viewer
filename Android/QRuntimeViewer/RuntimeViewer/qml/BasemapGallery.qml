import QtQuick 2.0

Rectangle {
    width: parent.width
    height: 100

    ListView {
        id: gallery
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

        ListElement {
            name: "Layer1";
            imageSource: "qrc:/Resources/thumbnails/thumbnails/natgeo.jpg"
        }
    }

    function addLayer(imageServiceLayer) {
        console.log(imageServiceLayer.url);
        //serviceModel.append({ 'name': imageServiceLayer.name, 'source': "/Resources/thumbnails/thumbnails/natgeo.jpg" });
    }
}
