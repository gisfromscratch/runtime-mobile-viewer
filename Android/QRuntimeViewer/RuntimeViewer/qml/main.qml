
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

                currentLayer = ArcGISRuntime.createObject("ArcGISTiledMapServiceLayer", { 'url': basemapUrl });
                focusMap.addLayer(currentLayer);
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

        onMapReady: {
            gallery.addLayer("NatGeo", "http://services.arcgisonline.com/ArcGIS/rest/services/NatGeo_World_Map/MapServer", "qrc:/Resources/thumbnails/natgeo.jpg");
            gallery.addLayer("Light Grey", "http://server.arcgisonline.com/arcgis/rest/services/Canvas/World_Light_Gray_Base/MapServer", "qrc:/Resources/thumbnails/lightgrey.png");
            gallery.addLayer("NatGeo", "http://services.arcgisonline.com/ArcGIS/rest/services/NatGeo_World_Map/MapServer", "qrc:/Resources/thumbnails/natgeo.jpg");
            gallery.addLayer("NatGeo", "http://services.arcgisonline.com/ArcGIS/rest/services/NatGeo_World_Map/MapServer", "qrc:/Resources/thumbnails/natgeo.jpg");
            gallery.addLayer("Light Grey", "http://server.arcgisonline.com/arcgis/rest/services/Canvas/World_Light_Gray_Base/MapServer", "qrc:/Resources/thumbnails/lightgrey.png");
        }
    }
}

