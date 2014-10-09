import QtQuick 2.1
import QtQuick.Controls 1.2
import QtQuick.Window 2.0

Window {
    width: 300
    height: 300
    title: "Identify results"

    ListModel {
        id: resultsModel
    }

    TableView {
        id: resultsTable
        model: resultsModel
        anchors.fill: parent

        TableViewColumn {
            role: "Attribute"
            title: "Attribute"
            resizable: true
            movable: false
        }

        TableViewColumn {
            role: "Value"
            title: "Value"
            resizable: true
            movable: false
        }
    }
}
