
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
import QtQuick.Layouts 1.1
import ArcGIS.Runtime 10.3

import "tools" as Tools

ApplicationWindow {
    id: appWindow
    width: 800
    height: 600
    title: "Demo Runtime App"

    Tools.NavigationToolbar {
        id: mainToolbar
    }

    Map {
        id: focusMap
        anchors.top: mainToolbar.bottom
        width: parent.width
        height: parent.height - mainToolbar.height - mainStatusBar.height

        wrapAroundEnabled: true

        ArcGISLocalTiledLayer {
            id: localTiledLayer
            path: "C:/Program Files (x86)/ArcGIS SDKs/Qt10.3/sdk/samples/data/tpks/Topographic.tpk"
        }
    }

    Tools.NavigationStatusBar {
        id: mainStatusBar
    }
}

