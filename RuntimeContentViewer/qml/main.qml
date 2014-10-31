
// Copyright 2014 ESRI
//
// All rights reserved under the copyright laws of the United States
// and applicable international laws, treaties, and conventions.
//
// You may freely redistribute and use this sample code, with or
// without modification, provided you include the original copyright
// notice and use restrictions.
//
// See the Sample code usage restrictions document for further information.
//

import QtQuick 2.1
import QtQuick.Controls 1.0
import ArcGIS.Runtime 10.3
import ArcGIS.Extras 1.0

ApplicationWindow {
    id: appWindow
    width: 800
    height: 600
    title: "Runtime Content Viewer"

    GridView {
        id: runtimeContentGridView
        anchors.fill: parent

        cellWidth: 120
        cellHeight: 120

        property int spacing: 10

        model: VisualDataModel {
            model: ListModel {
                id: runtimeContentViewModel

                ListElement { role: "Map" }
                ListElement { role: "Map" }
                ListElement { role: "Map" }
                ListElement { role: "Map" }
                ListElement { role: "Map" }
                ListElement { role: "Map" }
                ListElement { role: "Map" }
                ListElement { role: "Map" }
            }

            delegate: Component {
                Map {
                    id: focusMap
                    width: runtimeContentGridView.cellWidth - runtimeContentGridView.spacing
                    height: runtimeContentGridView.cellHeight - runtimeContentGridView.spacing

                    property Geodatabase geodatabase: Geodatabase {
                        path: System.userHomeFolder.filePath("data/openstreetmap.geodatabase")
                    }

                    FeatureLayer {
                        featureTable: geodatabase.geodatabaseFeatureTables[0]
                    }

                    onMouseClicked: {
                        mapView.visible = true;
                    }
                }
            }
        }
    }

    MapView {
        id: mapView
        anchors.fill: parent

        visible: false
    }

}

