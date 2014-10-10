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
    width: 600
    height: 800
    title: "Exercise 2 Part 2"

    property bool isLandscape: appWindow.width > appWindow.height
    property int df: System.displayScaleFactor

    //This is used for mobile platform deployment to find the location of where you have copied your data
    property string dataPath: System.userHomeFolder.filePath("data")
    //This is for desktop deployment to find your data location
    //property string dataPath: "./data"

    /*-----------------------------------------------------------------------------------------------------------------------
      The Map and its layers, including interaction with the layers
      ---------------------------------------------------------------------------------------------------------------------*/

    Envelope {
        id: mapExtent
        xMax: -13053000
        yMax: 3868000
        xMin: -13038000
        yMin: 3850000
    }

    Map {
        id: map
        anchors.fill: parent

        wrapAroundEnabled: true
        extent: mapExtent

        ArcGISLocalTiledLayer {
            id: layer
            path: dataPath + "/SanDiego.tpk"
            name: "San Diego"
        }

        ArcGISTiledMapServiceLayer {
            url: "http://services.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer"
        }

        GraphicsLayer {
            id: graphicLayer
        }

        GraphicsLayer {
            id: stopsLayer
        }

        GraphicsLayer {
            id: routesLayer
        }

        onMouseClicked: {
            if (mouse.button === Qt.LeftButton) {
                if (toolbar.state == "") {
                    //if the app is in the base state, mouse presses add a graphic to the screen
                    var graphic = {
                        geometry : {
                            x: mouse.mapPoint.x,
                            y: mouse.mapPoint.y
                        },
                        symbol: {
                            "type": "esriSMS",
                            "size": 16,
                            "style": "esriSMSCircle",
                            "color": "red"
                        }
                    };
                    graphicLayer.addGraphic(graphic);
                }

                else if (toolbar.state != "analysis") {
                    //if the app is in either the position or search state, mouse presses should add stops for routing
                    var stopgraphic = stopGraphic.clone();
                    stopgraphic.geometry = mouse.mapPoint;
                    stopsLayer.addGraphic(stopgraphic);
                    stops.addFeature(stopgraphic)
                }
            }
        }
    }

    /*-----------------------------------------------------------------------------------------------------------------------
      Geocoding
      ---------------------------------------------------------------------------------------------------------------------*/

    LocalLocator {
        id: locator
        path: dataPath + "/SanDiego_StreetAddress.loc"

        onFindStatusChanged: {
            if (findStatus === Locator.FindComplete)
            {
                console.log("findStatusChanged");
                for (var i = 0; i < findResults.length; i++) {
                    var result = findResults[i];
                    console.log("Result", i, result.address, result.score, result.location.x, result.location.y, result.extent.toText(), result.spatialReference.toText(), result.toText());
                    var stopGraphicClone = stopGraphic.clone();
                    stopGraphicClone.geometry = result.location;
                    var id = stopsLayer.addGraphic(stopGraphicClone);
                    stops.addFeature(stopGraphicClone);
                    var extent = map.extent;
                    extent.centerAt(result.location);
                    map.zoomTo(extent);
                }

                if (findResults.length > 0) {
                    map.extent = findResults[0].extent;
                }
            }

            else if (findStatus === Locator.FindError)
            {
                setStatus("Find Error: ", findError.message);
            }
        }
    }

    LocatorFindParameters {
        id: findTextParams
        text: searchBoxText.text
        outSR: map.spatialReference
        maxLocations: 3
    }

    PictureMarkerSymbol {
        id: stopSymbol
        image: "qrc:/Resources/RedShinyPin.png"
        xOffset: 0
        yOffset: 10
        opacity: 0.75
        height: 25
        width: 25
    }

    Graphic {
        id: stopGraphic
        symbol: stopSymbol
    }

    /*-----------------------------------------------------------------------------------------------------------------------
    Routing
    ---------------------------------------------------------------------------------------------------------------------*/

    LocalRouteTask {
        id: routeTask
        network: "Streets_ND"
        database: dataPath + "/RuntimeSanDiego.geodatabase"

        onSolveStatusChanged: {

            if (solveStatus === LocalRouteTask.SolveComplete)
            {
                console.log("Route complete # " + solveResult.routes.length.toString());

                routesLayer.removeAllGraphics();
                textPanel.state = "popUpNav";
                textPanelText.text = "";

                for (var index = 0; index < solveResult.routes.length; index++) {
                    var route = solveResult.routes[index];

                    var graphic = route.route;
                    graphic.symbol = routeSymbol;

                    routesLayer.addGraphic(graphic);

                    var t = "";
                    var dirs = route.routingDirections;
                    for (var dir = 0; dir < dirs.length; dir++) {
                        t += dirs[dir].text + "\r\n";
                    }


                    textPanelText.text += t;
                }

            }

            else if (solveStatus === LocalRouteTask.SolveError)
            {
                console.log("Route error: " + solveError.message);
                console.log("data path: " + routeTask.database);
            }
        }
    }

    LocalRouteTaskParameters {
        id: taskParameters
        task: routeTask
        returnDirections: true
        outSpatialReference: map.spatialReference
    }

    NAFeaturesAsFeature {
        id: stops
        spatialReference: map.spatialReference
    }

    NAFeaturesAsFeature {
        id: barriers
        spatialReference: map.spatialReference
    }

    SimpleLineSymbol {
        id: routeSymbol
        width: 3
        color: "#00b2ff"
        style: Enums.SimpleLineSymbolStyleSolid
    }

    /*-----------------------------------------------------------------------------------------------------------------------
      TextPanel
      ---------------------------------------------------------------------------------------------------------------------*/

    Rectangle {
        id: textPanel
        anchors {
            top: toolbar.top
            left: parent.left
            right: parent.right
        }
        height: 0
        width: isLandscape ? appWindow.width * 0.6 : appWindow.width
        color: "white"
        opacity: 0.6

        states : [
            State {
                name: "popUpNav"
                PropertyChanges { target: textPanel; height: 300 * df }
                AnchorChanges { target: textPanel; anchors.top: undefined; anchors.bottom: toolbar.top}
            }
        ]
    }
    Rectangle {
        color: "dark grey"
        radius: 25
        anchors {
            margins: -5
            fill: close
        }
        MouseArea {
            anchors.fill: parent
            anchors.margins: -50
            onClicked: {
                textPanel.state = "";
            }
        }
    }

    Image {
        id: close
        source:"qrc:/Resources/remove.png"
        width: 20 * df
        height: 20 * df
        anchors {
            top: textPanel.top
            right: textPanel.right
            margins: 10
        }
    }

    Flickable {
        id: textPanelFlickArea
        anchors.fill: textPanel
        anchors.margins: 30 * df
        contentHeight: textPanelText.height
        contentWidth: textPanel.width
        boundsBehavior: Flickable.StopAtBounds
        clip:true
        flickableDirection: Flickable.VerticalFlick

        Text {
            id: textPanelText
            anchors.fill: textPanelFlickArea
            font.pointSize: 12
            wrapMode: Text.WordWrap
        }
    }

    /*-----------------------------------------------------------------------------------------------------------------------
      Toolbar
      ---------------------------------------------------------------------------------------------------------------------*/

    Rectangle {
        id: toolbar
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }
        height: 60 * df
        width: appWindow.width
        color: "#0079C1"


        states: [
            State {
                name: "position"
                PropertyChanges { target: toolbarGPSButton; visible: false}
                PropertyChanges { target: toolbarAnalysisButton; visible: false }
                PropertyChanges { target: toolbarSearchButton;  visible: false }
                PropertyChanges { target: myBackButton;  visible: true }
                PropertyChanges { target: myRouteButton;  visible: true }
                PropertyChanges { target: mapTools;  visible: true }
                PropertyChanges { target: myZoomButton;  visible: true }
                PropertyChanges { target: myClearButton;  visible: true }
            },
            State {
                name: "analysis"
                PropertyChanges { target: toolbarGPSButton; visible: false }
                PropertyChanges { target: toolbarAnalysisButton; visible: false }
                PropertyChanges { target: toolbarSearchButton; visible: false }
                PropertyChanges { target: myRouteButton;  visible: false }
                PropertyChanges { target: myBackButton;  visible: true }
                PropertyChanges { target: myClearButton;  visible: true }
                PropertyChanges { target: myZoomButton;  visible: true }
                PropertyChanges { target: mapTools;  visible: true }
                PropertyChanges { target: bufferDistanceLabel; visible: true }
                PropertyChanges { target: bufferDistanceBox; visible: true }
            },
            State {
                name: "search"
                PropertyChanges { target: toolbarGPSButton; visible: false }
                PropertyChanges { target: toolbarAnalysisButton; visible: false }
                PropertyChanges { target: toolbarSearchButton; visible: false }
                PropertyChanges { target: myRouteButton;  visible: true }
                PropertyChanges { target: myBackButton;  visible: true }
                PropertyChanges { target: mapTools;  visible: true }
                PropertyChanges { target: myClearButton;  visible: true }
                PropertyChanges { target: myZoomButton;  visible: true }
                PropertyChanges { target: searchBox;  visible: true }
                PropertyChanges { target: mySearchButton;  visible: true }
            }
        ]
    }

    /*-----------------------------------------------------------------------------------------------------------------------
      Toolbar base state with position, analysis and search buttons
      ---------------------------------------------------------------------------------------------------------------------*/

    Image {
        id: toolbarGPSButton
        width: 40 * df
        height: 40 * df
        anchors.horizontalCenter: toolbar.horizontalCenter
        anchors.horizontalCenterOffset: -toolbar.width * 0.2
        anchors.verticalCenter: toolbar.verticalCenter
        source: "qrc:/Resources/gps.png"
        MouseArea {
            id: toolbarGPSButtonMouseArea
            anchors.fill: parent
            onClicked: {
                toolbar.state = "position"
            }
        }
    }

    Image {
        id: toolbarAnalysisButton
        width: 40 * df
        height: 40 * df
        anchors.horizontalCenter: toolbar.horizontalCenter
        anchors.verticalCenter: toolbar.verticalCenter
        source: "qrc:/Resources/clipboard.png"

        MouseArea {
            id: toolbarAnalysisButtonMouseArea
            anchors.fill: parent
            onClicked: {
                toolbar.state = "analysis"
            }
        }
    }

    Image {
        id: toolbarSearchButton
        width: 40 * df
        height: 40 * df
        anchors.horizontalCenter: toolbar.horizontalCenter
        anchors.horizontalCenterOffset: toolbar.width * 0.2
        anchors.verticalCenter: toolbar.verticalCenter
        source: "qrc:/Resources/search.png"
        MouseArea {
            id: toolbarSearchButtonMouseArea
            anchors.fill: parent
            onClicked: {
                toolbar.state = "search"
            }
        }
    }

    /*-----------------------------------------------------------------------------------------------------------------------
      Toolbar position and search states with back and route buttons
      ---------------------------------------------------------------------------------------------------------------------*/

    Image {
        id: myBackButton
        width: 40 * df
        height: 40 * df
        anchors.left: toolbar.left
        anchors.verticalCenter: toolbar.verticalCenter
        anchors.margins: 10
        source: "qrc:/Resources/back.png"
        visible: false

        MouseArea {
            id: myBackButtonMouseArea
            anchors.fill: parent
            onClicked: {
                toolbar.state = ""
                textPanel.state = ""
                stopsLayer.removeAllGraphics();
                stops.clearFeatures();
                routesLayer.removeAllGraphics();
            }
        }
    }

    Image {
        id: myRouteButton
        width: 40 * df
        height: 40 * df
        anchors.right: toolbar.right
        anchors.verticalCenter: toolbar.verticalCenter
        anchors.margins: 10
        source: "qrc:/Resources/route.png"
        visible: false

        MouseArea {
            id: myRouteButtonMouseArea
            anchors.fill: parent
            onClicked: {
                console.log("Stop graphics #=", stopsLayer.graphics.length);
                taskParameters.stops = stops;
                taskParameters.returnDirections = true;
                console.log("route params: " + taskParameters.toText());
                routeTask.solve(taskParameters);
            }
        }
    }

    /*-----------------------------------------------------------------------------------------------------------------------
      Toolbar analysis state with buffer distance box
      ---------------------------------------------------------------------------------------------------------------------*/

    Text {
        id: bufferDistanceLabel
        anchors.verticalCenter: toolbar.verticalCenter
        anchors.horizontalCenter: toolbar.horizontalCenter
        anchors.leftMargin: 40
        visible: false
        font.pixelSize: 20 * df
        color: "white"
        text: "Buffer Distance: "
    }

    Rectangle {
        id: bufferDistanceBox
        width: toolbar.width * 0.2
        height: toolbar.height * 0.7
        anchors.left: bufferDistanceLabel.right
        anchors.verticalCenter: toolbar.verticalCenter
        color: "white"
        border.color: "grey"
        radius: 3
        visible: false

        TextInput {
            id: bufferDistanceText
            anchors.fill: parent
            anchors.margins: 10
            font.pixelSize: 20 * df
            text: "300"
            selectByMouse: true
            cursorVisible: true
            onActiveFocusChanged: {
                focus: true
            }
        }

    }

    /*-----------------------------------------------------------------------------------------------------------------------
      Toolbar search state with search box and button, and route button
      ---------------------------------------------------------------------------------------------------------------------*/

    Rectangle {
        id: searchBox
        width: toolbar.width * 0.6
        height: toolbar.height * 0.7
        anchors.verticalCenter: toolbar.verticalCenter
        anchors.horizontalCenter: toolbar.horizontalCenter
        color: "white"
        border.color: "grey"
        radius: 3
        visible: false

        TextInput {
            id: searchBoxText
            anchors.margins: 10
            anchors.left: parent.left
            anchors.fill: parent
            font.pixelSize: 20 * df
            text: "1011 Market St, San Diego"
            selectByMouse: true
            cursorVisible: true
            onActiveFocusChanged: {
                focus: true
            }
        }

        Image {
            id: mySearchButton
            width: 30 * df
            height: 30 * df
            anchors.right: searchBox.right
            anchors.verticalCenter: toolbar.verticalCenter
            anchors.margins: 10
            source: "qrc:/Resources/searchDark.png"
            visible: false

            MouseArea {
                id: mySearchButtonMouseArea
                anchors.fill: parent
                onClicked: {
                    locator.find(findTextParams);
                }
            }
        }
    }

    /*-----------------------------------------------------------------------------------------------------------------------
      Map tools
      ---------------------------------------------------------------------------------------------------------------------*/

    Rectangle {
        id: mapTools
        anchors {
            top: parent.top
            right: parent.right
            margins: 20
        }
        height: 115 * df
        width: 60 * df
        color: "#0072c6"
        opacity: 0.35
        radius: 5
        visible: false
    }

    Image {
        id: myZoomButton
        width: 40 * df
        height: 40 * df
        anchors.top: mapTools.top
        anchors.horizontalCenter: mapTools.horizontalCenter
        anchors.margins: 10
        source: "qrc:/Resources/home.png"
        visible: false

        MouseArea {
            id: zoomMouseArea
            anchors.fill: parent
            onClicked: {
                map.extent = mapExtent;
                map.mapRotation = 0;
            }
        }
    }

    Image {
        id: myClearButton
        width: 40 * df
        height: 40 * df
        anchors.bottom: mapTools.bottom
        anchors.horizontalCenter: mapTools.horizontalCenter
        anchors.margins: 10
        source: "qrc:/Resources/remove.png"
        visible: false

        MouseArea {
            id: clearButtonMouseArea
            anchors.fill: myClearButton
            onClicked: {
                map.extent = mapExtent;
                map.mapRotation = 0;
                stopsLayer.removeAllGraphics();
                stops.clearFeatures();
                routesLayer.removeAllGraphics();
                textPanel.state = "";
            }
        }
    }
}

