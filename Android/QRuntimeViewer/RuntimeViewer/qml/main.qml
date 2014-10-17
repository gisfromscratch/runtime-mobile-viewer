
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
    title: "RuntimeViewer"

    Geodatabase {
        id: gdb
    }

    Map {
        id: focusMap
        anchors {
            top: parent.top
            left: navigationBar.right
            right: parent.right
            bottom: parent.bottom
        }

        wrapAroundEnabled: true

        ArcGISTiledMapServiceLayer {
            id: basemapLayer;
            url: "http://services.arcgisonline.com/ArcGIS/rest/services/NatGeo_World_Map/MapServer"
        }

        function addLocalFeatureData(localConnection) {
            // Create the local geodatabase instance
            var localGeodatabase = ArcGISRuntime.createObject("Geodatabase");
            console.log("Setting the local geodatabase path: " + localConnection.path);
            localGeodatabase.path = localConnection.path;

            // Validate the layer ID
            var featureTables = localGeodatabase.geodatabaseFeatureTables;
            if (featureTables.length < localConnection.layerId) {
                console.log(localConnection.layerId + " is not a valid layer id!")
                return;
            }

            // Add the feature table as feature layer
            var localFeatureTable = localGeodatabase.geodatabaseFeatureTableByLayerId(localConnection.layerId);
            var localFeatureLayer = ArcGISRuntime.createObject("FeatureLayer");
            console.log("Feature layer created");
            localFeatureLayer.featureTable = localFeatureTable;
            console.log("Feature table bound");
            focusMap.addLayer(localFeatureLayer);
            console.log("Feature layer added");
        }

        function localFeatureTableValidationChanged() {
            console.log("Local feature table validation changed.");
        }

        onMapReady: {
            gallery.addLayer("NatGeo", "http://services.arcgisonline.com/ArcGIS/rest/services/NatGeo_World_Map/MapServer", "qrc:/Resources/thumbnails/natgeo.jpg");
            gallery.addLayer("Light Grey", "http://server.arcgisonline.com/arcgis/rest/services/Canvas/World_Light_Gray_Base/MapServer", "qrc:/Resources/thumbnails/lightgrey.png");

            var localConnection = {
                path: System.userHomeFolder.filePath("data") + "/openstreetmap.geodatabase",
                layerId: 1
            };
            addLocalFeatureData(localConnection);
            localConnection = {
                path: System.userHomeFolder.filePath("data") + "/openstreetmap.geodatabase",
                layerId: 0
            };
            addLocalFeatureData(localConnection);
        }
    }

    NavigationBar {
        id: navigationBar
        anchors {
            top: parent.top
            left: parent.left
        }
    }

    BasemapGallery {
        id: gallery;
        anchors {
            top: parent.top
            left: parent.left
        }
        visible: false

        property ArcGISTiledMapServiceLayer currentLayer

        onBasemapChanged: {
            if (focusMap.containsLayer(basemapLayer)) {
                focusMap.removeLayer(basemapLayer);
            }
            if (currentLayer && focusMap.containsLayer(currentLayer)) {
                focusMap.removeLayer(currentLayer);
            }

            // Set the current basemap
            currentLayer = ArcGISRuntime.createObject("ArcGISTiledMapServiceLayer", { 'url': basemapUrl });
            focusMap.insertLayer(currentLayer, 0);
        }
    }

    LayerView {
        id: layerView
        anchors {
            top: parent.top
            left: parent.left
        }
        visible: false
    }

    SearchView {
        id: searchView
        anchors {
            top: parent.top
            left: parent.left
        }
        visible: false
    }
}

