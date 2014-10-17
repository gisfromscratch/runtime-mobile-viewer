
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
        anchors.fill: parent

        wrapAroundEnabled: true

        ArcGISTiledMapServiceLayer {
            id: basemapLayer;
            url: "http://services.arcgisonline.com/ArcGIS/rest/services/NatGeo_World_Map/MapServer"
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

        function addLocalFeatureData(localConnection) {
            var localGeodatabase = ArcGISRuntime.createObject("Geodatabase");
            console.log("Setting the local geodatabase path: " + localConnection.path);
            localGeodatabase.path = localConnection.path;

            var localFeatureTable = ArcGISRuntime.createObject("GeodatabaseFeatureTable");
            localFeatureTable.geodatabaseFeatureTableValidChanged.connect(localFeatureTableValidationChanged);

            localFeatureTable.geodatabase = localGeodatabase;
            localFeatureTable.featureServiceLayerId = localConnection.layerId;
            console.log("Local feature table valid: " + localFeatureTable.geodatabaseFeatureTableValid)

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
            gallery.addLayer("NatGeo", "http://services.arcgisonline.com/ArcGIS/rest/services/NatGeo_World_Map/MapServer", "qrc:/Resources/thumbnails/natgeo.jpg");
            gallery.addLayer("NatGeo", "http://services.arcgisonline.com/ArcGIS/rest/services/NatGeo_World_Map/MapServer", "qrc:/Resources/thumbnails/natgeo.jpg");
            gallery.addLayer("Light Grey", "http://server.arcgisonline.com/arcgis/rest/services/Canvas/World_Light_Gray_Base/MapServer", "qrc:/Resources/thumbnails/lightgrey.png");

            var localConnection = {
                path: System.userHomeFolder.filePath("data") + "/openstreetmap.geodatabase",
                layerId: 0
            };
            addLocalFeatureData(localConnection);
        }
    }
}

