
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
        id: focusMap
        anchors.fill: parent
        width: 800
        height: 600

        property bool isLandscape: appWindow.height < appWindow.width
        property int df: System.displayScaleFactor

        //This is used for mobile platform deployment to find the location of where you have copied your data
        property string dataPath: System.userHomeFolder.filePath("data")
        //This is for desktop deployment to find your data location
        //property string dataPath: "./data"

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

        ArcGISLocalTiledLayer {
            id: layer
            path: focusMap.dataPath + "/SanDiego.tpk"
            name: "San Diego"
        }

        Rectangle {
            id: toolbar
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
            }
            height: 60 * focusMap.df
            width: appWindow.width
            color: "#0079C1"
        }
    }
}

