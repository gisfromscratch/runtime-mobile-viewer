import QtQuick 2.0
import QtQuick.Controls 1.2

Rectangle {
    id: identifyView
    width: 320
    height: parent.height
    color: "#4f5764"

    Rectangle {
        id: identifyViewHeader
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
            text: qsTr("Identify")
        }
    }

    ListView {
        id: featureListView
        anchors {
            top: identifyViewHeader.bottom
            left: parent.left
            right: parent.right
        }

        height: 0.5 * parent.height

        highlight: Rectangle {
            color: "#3e4551"
            radius: 10
        }
        focus: true

        delegate: Component {
            Item {
                width: 180; height: 40
                Column {
                    x: 32
                    Text {
                        font {
                            family: "Helvetica"
                            pixelSize: 16
                        }
                        color: "white"
                        text: '<b>Layer:</b> ' + layerName
                    }
                    Text {
                        font {
                            family: "Helvetica"
                            pixelSize: 16
                        }
                        color: "white"
                        text: '<b>Features:</b> ' + featuresCount
                    }
                }
            }
        }

        model: ListModel {
            id: featureListModel
        }
    }



    TableView {
        id: identifyTableView
        anchors {
            top: featureListView.bottom
            left: parent.left
            right: parent.right
            bottom: identifyViewFooter.top
        }

        TableViewColumn {
            role: "attribute"
            title: qsTr("Attribute")
        }

        TableViewColumn {
            role: "value"
            title: qsTr("Value")
        }

        headerDelegate: BorderImage{
            source: "qrc:/Resources/tableview/header.png"
            border {
                left: 2
                right: 2
                top: 2
                bottom: 2
            }
            Text {
                font {
                    family: "Helvetica"
                    pixelSize: 12
                }
                text: styleData.value
                anchors.centerIn: parent
                color: "#4f5764"
            }
        }

        itemDelegate: Component {
            Item {
                clip: true
                Text {
                    font {
                        family: "Helvetica"
                        pixelSize: 12
                    }
                    width: parent.width
                    anchors.margins: 4
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    elide: styleData.elideMode
                    text: styleData.value !== undefined  ? styleData.value.toString() : ""
                    color: "#ffffff"
                }
            }
        }

        rowDelegate: Rectangle {
            height: 44
            Behavior on height{ NumberAnimation{} }

            color: styleData.selected ? "#4f5764" : (styleData.alternate ? "#3e4551" : "#4f5764")
            BorderImage{
                id: selected
                anchors.fill: parent
                source: "qrc:/Resources/tableview/selectedrow.png"
                visible: styleData.selected
                border{
                    left: 2
                    right: 2
                    top: 2
                    bottom: 2
                }
//                SequentialAnimation {
//                    running: true; loops: Animation.Infinite
//                    NumberAnimation { target:selected; property: "opacity"; to: 1.0; duration: 900}
//                    NumberAnimation { target:selected; property: "opacity"; to: 0.5; duration: 900}
//                }
            }
        }

        model: ListModel {
            id: identifyModel
        }
    }

    function showResults(layerResult) {
        featureListModel.clear();
        identifyModel.clear();
        for (var layerIndex in layerResult) {
            var layer = layerResult[layerIndex];
            featureListModel.append(layer);
            if (1 === layer.features.length) {
                for (var featureIndex in layer.features) {
                    var featureAsJson = layer.features[featureIndex];
                    for (var attribute in featureAsJson.attributes) {
                        identifyModel.append({ 'attribute': attribute, 'value': featureAsJson.attributes[attribute]});
                    }
                }
            }
        }
    }

    Rectangle {
        id: identifyViewFooter
        color: "#272c33"
        width: parent.width
        height: 44
        anchors.bottom: identifyView.bottom

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10
            Column {
                Image {
                    height: identifyViewFooter.height
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/Resources/toolbars/window-close.png"

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            identifyView.visible = false;
                        }
                    }
                }
            }

            Column {
                Text {
                    verticalAlignment: Text.AlignVCenter
                    height: identifyViewFooter.height
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
