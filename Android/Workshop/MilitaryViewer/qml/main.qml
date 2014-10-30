
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
    title: "MilitaryViewer"

    Map {
        id: focusMap
        anchors.fill: parent

        wrapAroundEnabled: true

        ArcGISTiledMapServiceLayer {
            url: "http://services.arcgisonline.com/ArcGIS/rest/services/NatGeo_World_Map/MapServer"
        }

        GraphicsLayer {
            id: graphicsLayer
        }

        onMouseClicked: {
            var graphic = ArcGISRuntime.createObject("Graphic");
            graphic.geometry = mouse.mapPoint;
            graphic.symbol = multiLayerSymbol;
            graphicsLayer.addGraphic(graphic);
        }

        MessageGroupLayer {
            id: messageGroupLayer
        }

        MultiLayerSymbol {
            id: multiLayerSymbol
            json: {"type":"CIMSymbolReference","symbol":{"type":"CIMLineSymbol","symbolLayers":[{"type":"CIMFilledStroke","enable":true,"effects":[{"type":"CIMGeometricEffectArrow","geometricEffectArrowType":"Block","primitiveName":null,"width":35}],"capStyle":"Round","pattern":{"type":"CIMSolidPattern","color":[0,0,0,255]},"width":2,"lineStyle3D":"Strip","alignment":"Center","joinStyle":"Miter","miterLimit":10,"patternFollowsStroke":true}]},"symbolName":null}
        }

        onMapReady: {
            var message = ArcGISRuntime.createObject("Message");
            //message.addProperties()
        }
    }
}

