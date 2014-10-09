import QtQuick 2.1
import QtQuick.Controls 1.2
import QtQuick.Window 2.0
import ArcGIS.Runtime 10.3

Window {
    width: 300
    height: 300
    title: "Identify results"

    ListModel {
        id: resultsModel
    }

    function updateResults(results) {
        resultsModel.clear();

        for (var index in results) {
            var identifyResult = results[index];
        }
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
