
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
import ArcGIS.Extras 1.0
import ArcGIS.Runtime 10.3

ApplicationWindow {
    id: appWindow
    width: 800
    height: 600
    title: "FirstSample"

    Map {
        anchors.fill: parent
        width: 800
        height: 600

        property bool isLandscape: appWindow.height < appWindow.width
        property int df: System.displayScaleFactor

        wrapAroundEnabled: true

        Envelope {
            id: mapExtent
            xMax: -13053000
            yMax: 3868000
            xMin: -13038000
            yMin: 3850000
        }

        ArcGISTiledMapServiceLayer {
            url: "http://services.arcgisonline.com/ArcGIS/rest/services/NatGeo_World_Map/MapServer"
        }
    }
}

