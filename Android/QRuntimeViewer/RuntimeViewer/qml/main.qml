
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
        anchors.fill: parent

        wrapAroundEnabled: true

        ArcGISTiledMapServiceLayer {
            id: natGeoLayer;
            url: "http://services.arcgisonline.com/ArcGIS/rest/services/NatGeo_World_Map/MapServer"
        }

        BasemapGallery {
            id: gallery;
        }

        onMapReady: {
            gallery.addLayer(natGeoLayer);
        }
    }
}

