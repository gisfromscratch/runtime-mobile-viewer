
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

    Map {
        id: focusMap
        anchors {
            top: parent.top
            left: navigationBar.right
            right: parent.right
            bottom: parent.bottom
        }

        property var localFeatureTables: []

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

            // Load all feature tables
            var featureTables = localGeodatabase.geodatabaseFeatureTables;
            for (var tableIndex in featureTables) {
                var localFeatureTable = featureTables[tableIndex];
                console.log("Feature table name: " + localFeatureTable.tableName);

                // Add the feature table as feature layer
                var localFeatureLayer = ArcGISRuntime.createObject("FeatureLayer");
                console.log("Feature layer created");
                localFeatureLayer.featureTable = localFeatureTable;
                // Add a strong reference to it
                localFeatureTables.push({ 'geodatabase': localGeodatabase, 'featureTable': localFeatureTable });
                console.log("Feature table bound");
                focusMap.insertLayer(localFeatureLayer, 1);
                console.log("Feature layer added");
            }
        }

        function localFeatureTableValidationChanged() {
            console.log("Local feature table validation changed.");
        }

        onMapReady: {
            gallery.addLayer("NatGeo", "http://services.arcgisonline.com/ArcGIS/rest/services/NatGeo_World_Map/MapServer", "qrc:/Resources/thumbnails/natgeo.jpg");
            gallery.addLayer("Light Grey", "http://server.arcgisonline.com/arcgis/rest/services/Canvas/World_Light_Gray_Base/MapServer", "qrc:/Resources/thumbnails/lightgrey.png");
            gallery.addLayer("Imagery", "http://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer", "qrc:/Resources/thumbnails/imagery.png");

            var localConnection = {
                path: System.userHomeFolder.filePath("data") + "/openstreetmap.geodatabase",
            };
            addLocalFeatureData(localConnection);
        }

        onMouseClicked: {
            var layerResult = [];
            console.log("Identifying...");
            for (var layerIndex in focusMap.layers) {
                var layer = focusMap.layers[layerIndex];
                if ("FeatureLayer" === layer.objectType) {
                    console.log("Clear selection...");
                    layer.clearSelection();

                    if (layer.featureTable) {
                        var pixelTolerance = 5;
                        var maxRecords = 100;
                        var ids = layer.findFeatures(mouse.x, mouse.y, pixelTolerance, maxRecords);
                        if (ids && 0 < ids.length) {
                            console.log("Selecting...");
                            layer.selectFeatures(ids, false);
                            var featureResult = [];
                            var features = layer.featureTable.features(ids);
                            for (var featureIndex in features) {
                                var attributeResult = [];
                                var feature = features[featureIndex];
                                featureResult.push(feature.json);
                            }
                            layerResult.push({ 'layerName': layer.name, 'features': featureResult, "featuresCount": featureResult.length });
                        }
                    } else {
                        console.error("Feature table of '" + layer.name + "' is not initialized!");
                    }
                }
            }

            if (0 < layerResult.length) {
                identifyView.showResults(layerResult);
                identifyView.visible = true;
            }
            console.log("Identifying done.");
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

    IdentifyView {
        id: identifyView
        anchors {
            top: parent.top
            left: parent.left
        }
        visible: false
    }
}

