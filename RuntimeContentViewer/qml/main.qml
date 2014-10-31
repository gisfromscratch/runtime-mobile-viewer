
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

import "Mapping.js" as Mapping

ApplicationWindow {
    id: appWindow
    width: 800
    height: 600
    title: "Runtime Content Viewer"

    // All local feature tables strong referenced
    property var localFeatureTables: []

    onVisibilityChanged: {
        if (appWindow.visible) {
            runtimeContentViewModel.clear();

            runtimeContentViewModel.append({ role: "Map", contentPath: System.userHomeFolder.filePath("data/openstreetmap.geodatabase")});
            runtimeContentViewModel.append({ role: "Map", contentPath: System.userHomeFolder.filePath("data/CafeFS.geodatabase")});
            runtimeContentViewModel.append({ role: "Map", contentPath: System.userHomeFolder.filePath("data/RuntimeSanDiego.geodatabase")});
        }
    }

    GridView {
        id: runtimeContentGridView
        anchors.fill: parent

        cellWidth: 120
        cellHeight: 120

        property int spacing: 10

        model: VisualDataModel {
            model: ListModel {
                id: runtimeContentViewModel
            }

            delegate: Component {
                Map {
                    id: focusMap
                    width: runtimeContentGridView.cellWidth - runtimeContentGridView.spacing
                    height: runtimeContentGridView.cellHeight - runtimeContentGridView.spacing

                    property Geodatabase geodatabase: Geodatabase {
                        path: contentPath
                    }

                    FeatureLayer {
                        featureTable: (geodatabase.valid) ? geodatabase.geodatabaseFeatureTables[0] : null
                    }

                    onMouseClicked: {
                        mapView.showRuntimeContent({ path: geodatabase.path });
                        mapView.visible = true;
                        runtimeContentGridView.visible = false;
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

