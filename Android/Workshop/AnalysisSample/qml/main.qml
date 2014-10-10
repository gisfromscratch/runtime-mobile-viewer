
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

import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import ArcGIS.Extras 1.0
import ArcGIS.Runtime 10.3


ApplicationWindow {
    id: appWindow
    width: 600
    height: 800
    title: "Exercise 4"

    property bool isLandscape: appWindow.width > appWindow.height
    property int df: System.displayScaleFactor

    //This is used for mobile platform deployment to find the location of where you have copied your data
    property string dataPath: System.userHomeFolder.filePath("data")
    //This is for desktop deployment to find your data location
    //property string dataPath: "./data"

    property GeodatabaseFeature selectedFeature
    property string gdbUrl: "http://services1.arcgis.com/e7dVfn25KpfE6dDd/arcgis/rest/services/CoffeeShops/FeatureServer"
    property int queryCount: 0

    /*-----------------------------------------------------------------------------------------------------------------------
          Portal sign in
      ---------------------------------------------------------------------------------------------------------------------*/

    PortalSignInDialog {
        id: portalSignInDialog
        settingsGroup: "PortalSignInDialog"
        anchors.horizontalCenter: appWindow.horizontalCenter
        anchors.verticalCenter: appWindow.verticalCenter
    }

    Component.onCompleted: {
        portalSignInDialog.visible = true;
    }

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

    Query {
        id: query
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

        GraphicsLayer {
            id: analysisLayer
        }

        FeatureLayer {
            id: featureLayer
            featureTable: gdbFeatureTable
        }

        onMouseClicked: {
            if (mouse.button === Qt.LeftButton) {
                if (toolbar.state == "") {
                    // if the app is in the base state, mouse clicks should query features within the feature table

                    if (geodatabase.valid) {
                        setStatus("Querying (" + (++queryCount) + ") ..." + JSON.stringify(mouse.mapPoint.json));
                        var geometry = mouse.mapPoint.buffer(80 * df);
                        query.geometry = geometry;
                        query.spatialRelationship = Enums.SpatialRelationshipIntersects;

                        gdbFeatureTable.queryFeatures(query);
                    }
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
        onMousePressAndHold: {
            if (mouse.button === Qt.LeftButton) {
                if (toolbar.state == "analysis") {
                    analysisLayer.removeAllGraphics();
                    bufferGraphic = ArcGISRuntime.createObject("Graphic");
                    bufferGraphic.geometry = mouse.mapPoint.buffer(analysisBufferDistance);
                    bufferGraphic.symbol = bufferSymbol;
                    analysisLayer.addGraphic(bufferGraphic);
                    analysisActive = true
                    select();
                }
            }
        }
        onMousePositionChanged: {
            if (toolbar.state == "analysis") {
                if (analysisActive) {
                    bufferGraphic.geometry = mouse.mapPoint.buffer(analysisBufferDistance);
                    select();
                }
            }
        }
        onMouseReleased: {
            if (analysisActive) {
                analysisActive = false;
                analysisLayer.removeAllGraphics();
                featureLayer.clearSelection();
            }
        }

        onMapReady: {

            if (!geodatabase.valid) {
                //featureServiceInfo.serviceInfo();
                serviceInfoTask.fetchFeatureServiceInfo();
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
                form.visible = false;

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
     Download the geodatabase the first time app is run on the device
     ---------------------------------------------------------------------------------------------------------------------*/


    ServiceInfoTask {
        id: serviceInfoTask
        url: gdbUrl

        onFeatureServiceInfoChanged: {
            IdentityManager.ignoreSslErrors = true
            generateGeodatabaseParameters.initialize(serviceInfoTask.featureServiceInfo);
            geodatabaseSyncTask.generateGeodatabase(generateGeodatabaseParameters, geodatabase.path);

        }

        onFeatureServiceInfoErrorChanged: {
            statusText.text = "Error: " + errorString;
        }
    }


    Geodatabase {
        id: geodatabase
        path: dataPath + "/CafeFS.geodatabase"
    }


    GeodatabaseFeatureTable {
        id: gdbFeatureTable
        geodatabase: geodatabase.valid ? geodatabase : null
        featureServiceLayerId: 0

        onGeodatabaseFeatureTableValidChanged: {
            console.log("Gdb feature table is initialized.")
        }

        onQueryFeaturesStatusChanged: {

            if (queryFeaturesStatus === GeodatabaseFeatureTable.QueryIdsComplete) {
                console.log("onQueryIdsComplete!!!");
            }

            if (queryFeaturesStatus === GeodatabaseFeatureTable.QueryFeaturesComplete) {
                setStatus("Features found: " + queryFeaturesResult.featureCount);
                featureLayer.clearSelection();
                textPanel.state = "";
                textPanelText.text = "";

                if (queryFeaturesResult.featureCount > 0) {
                    setStatus("");

                    //highlight the selected feature only if the count of features is 1
                    var iterator = queryFeaturesResult.iterator
                    if (toolbar.state == "") {
                        textPanel.state = "popUp"
                        form.visible = true;

                        selectedFeature = iterator.next();
                        featureLayer.selectFeature(selectedFeature.uniqueId)

                        shopName.text = selectedFeature.attributeValue("CONAME");
                        var countGoodAttr = selectedFeature.attributeValue("CountGood");
                        upVotes = countGoodAttr ? countGoodAttr : 0;
                        var countBadAttr = selectedFeature.attributeValue("CountBad");
                        downVotes = countBadAttr ? countBadAttr : 0;
                        var userNameAttr = selectedFeature.attributeValue("UserName");
                        lastReviewer = userNameAttr ? userNameAttr : "";
                        var ratingDateAttr = selectedFeature.attributeValue("RatingDate");
                        reviewDate = ratingDateAttr ? new Date(ratingDateAttr) : ""
                    }
                    else if (toolbar.state == "analysis") {
                        textPanel.state = "popUpTable"
                        form.visible = false;

                        featureLayer.selectFeatures(iterator);

                        analysisFeaturesTable.model.clear()

                        iterator.reset();

                        while (iterator.hasNext()) {
                            var feature = iterator.next();
                            var coffeeShopName = feature.attributeValue("CONAME");
                            var coffeeUpVotes = feature.attributeValue("CountGood");
                            var coffeeDownVotes = feature.attributeValue("CountBad");
                            var coffeeLastReviewer = feature.attributeValue("UserName");
                            var coffeeReviewDate = feature.attributeValue("RatingDate");
                            reviewDate = coffeeReviewDate ? new Date(coffeeReviewDate) : null
                            analysisFeaturesTable.model.append({
                                                                   "shopName": coffeeShopName,
                                                                   "upVotes": coffeeUpVotes ? coffeeUpVotes : 0,
                                                                                              "downVotes": coffeeDownVotes ? coffeeDownVotes : 0,
                                                                                                                             "lastReviewer": coffeeLastReviewer ? coffeeLastReviewer : "N/A",
                                                                                                                                                                  "reviewDate": reviewDate ? new Date(reviewDate) : "N/A"
                                                               })
                        }
                    }
                }
            }
        }
    }

    GenerateGeodatabaseParameters {
        id: generateGeodatabaseParameters
    }

    GeodatabaseSyncStatusInfo {
        id: syncStatusInfo
    }

    GeodatabaseSyncTask {
        id: geodatabaseSyncTask
        url: gdbUrl

        onGenerateStatusChanged: {
            if (generateStatus === GeodatabaseSyncTask.GenerateComplete)
            {
                geodatabase.path = geodatabaseSyncTask.geodatabasePath;
                map.removeLayer(featureLayer);
                map.addLayer(featureLayer);
                console.log(geodatabase.valid);
            }

            if (generateStatus === GeodatabaseSyncTask.GenerateError){
                console.log("Error:" + generateGeodatabaseError.message + " Code="  + generateGeodatabaseError.code.toString() + " "  + generateGeodatabaseError.details);
            }
        }

        onGeodatabaseSyncStatusInfoChanged: {
            statusText.text = geodatabaseSyncStatusInfo.statusString + " " + geodatabaseSyncStatusInfo.lastUpdatedTime.toString() + " " + geodatabaseSyncStatusInfo.jobId.toString();
            if (geodatabaseSyncStatusInfo.status != GeodatabaseSyncStatusInfo.Cancelled)
                syncStatusInfo.json = geodatabaseSyncStatusInfo.json;
        }

        onSyncStatusChanged: {
            if (syncStatus === GeodatabaseSyncTask.SyncComplete)
            {
                statusText.text = "Sync completed."
                var errorString = "";
                for(var key in syncErrors)
                {
                    for (var j = 0; j < syncErrors[key].featureEditErrors.length; j++)
                    {
                        var error = syncErrors[key].featureEditErrors[j];
                        errorString += "\nLayer Id: " + error.layerId + "\nObject Id: " + error.objectId + "\nGlobal Id: " + error.globalId + "\nEdit operation: " + error.editOperationString + "\nError: " + error.error.description;
                    }
                }

                if (errorString != "") {
                    statusText.text = errorString;
                }
            }

            if (syncStatus === GeodatabaseSyncTask.SyncError)
            {
                statusText.text = "Error:" + syncGeodatabaseError.message + " Code="  + syncGeodatabaseError.code.toString() + " "  + syncGeodatabaseError.details;
            }
        }
    }

    Text {
        id: statusText
        text: geodatabaseSyncTask.geodatabasePath
        anchors {
            left: appWindow.left
            bottom: toolbar.top
        }
        font {
            pointSize: 8
        }
    }

    function setStatus(text) {
        console.log(text);
        statusText.text = "        " + text;
    }

    property double analysisBufferDistance: Number(bufferDistanceText.text)
    property Graphic bufferGraphic
    property bool analysisActive: false
    SimpleFillSymbol {
        id: bufferSymbol
        color: "transparent"
        outline: SimpleLineSymbol {
            color: "red"
            style: Enums.SimpleLineSymbolStyleDash
        }
    }

    function select() {
        if (analysisActive) {
            query.geometry = bufferGraphic.geometry;
            gdbFeatureTable.queryFeatures(query);
        }
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
                name: "popUp"
                PropertyChanges { target: textPanel; height: 120 * df}
                PropertyChanges { target: textPanelFlickArea; visible: false}
                PropertyChanges { target: analysisTableArea; visible: false}
                AnchorChanges { target: textPanel; anchors.top: undefined; anchors.bottom: toolbar.top}
            },
            State {
                name: "popUpNav"
                PropertyChanges { target: textPanel; height: 300 * df }
                PropertyChanges { target: analysisTableArea; visible: false}
                AnchorChanges { target: textPanel; anchors.top: undefined; anchors.bottom: toolbar.top}
            },
            State {
                name: "popUpTable"
                PropertyChanges { target: textPanel; height: 170 * df}
                PropertyChanges { target: textPanelFlickArea; visible: false}
                PropertyChanges { target: analysisTableArea; visible: true}
                AnchorChanges { target: textPanel; anchors.top: undefined; anchors.bottom: toolbar.top}
            }
        ]
    }

    property int upVotes : 0
    property int downVotes : 0
    property string lastReviewer
    property var reviewDate

    GridLayout {
        id: form
        rowSpacing: 5
        columns: 5
        visible: false
        anchors {
            fill: textPanel
            horizontalCenter: textPanel.horizontalCenter
            rightMargin: 50
        }

        Text{
            id: shopName
            Layout.preferredWidth: parent.width * 0.3
            Layout.maximumWidth: parent.width * 0.3
            Layout.alignment: Qt.AlignHCenter
            elide: Text.ElideRight
            font {
                bold: true
                pointSize: 10
            }
        }

        Text {
            text: upVotes
            Layout.alignment: Qt.AlignRight
            font {
                bold: true
                pointSize: 10
            }
        }

        Image {
            id: coffeeGood
            source: "qrc:/Resources/coffeeGood.png"
            Layout.alignment: Qt.AlignHCenter
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log ("Add Good Review");
                    lastReviewer = portalSignInDialog.portal.user.fullName;
                    reviewDate = new Date();
                    upVotes = upVotes + 1
                }
            }
        }

        Image {
            id: coffeeBad
            source: "qrc:/Resources/coffeeBad.png"
            Layout.alignment: Qt.AlignHCenter
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log ("Add Bad Review");
                    lastReviewer = portalSignInDialog.portal.user.fullName;
                    reviewDate = new Date();
                    downVotes = downVotes + 1
                }
            }
        }

        Text {
            text: downVotes
            Layout.alignment: Qt.AlignLeft
            font {
                bold: true
                pointSize: 10
            }
        }

        Text {
            text: "Last Reviewed By: " + lastReviewer + "     on: " + reviewDate
            Layout.alignment: Qt.AlignCenter
            Layout.columnSpan: 5
        }
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

                if (toolbar.state == "") {
                    //first save edits to local geodatabases
                    selectedFeature.setAttributeValue("CountGood", upVotes);
                    selectedFeature.setAttributeValue("CountBad", downVotes);
                    selectedFeature.setAttributeValue("UserName", lastReviewer);
                    selectedFeature.setAttributeValue("RatingDate", reviewDate);

                    featureLayer.featureTable.updateFeature(selectedFeature.uniqueId, selectedFeature);

                    if (System.isOnline) {
                        //then sync these edits with Service
                        geodatabaseSyncTask.syncGeodatabase(geodatabase.syncGeodatabaseParameters, geodatabase);
                        statusText.text = "Starting sync task";
                    }
                    else {
                        statusText.text = "You are not online and cannot sync.";
                    }
                }
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

    Rectangle {
        id: analysisTableArea
        anchors.fill: textPanel
        anchors.topMargin: 35 * df
        visible: false

        TableView {
            id: analysisFeaturesTable
            anchors.fill: parent
            TableViewColumn{ role: "shopName" ; title: "Shop Name" ; width: analysisFeaturesTable.width * 0.4 }
            TableViewColumn{ role: "upVotes" ; title: "Up Votes" ; width: analysisFeaturesTable.width * 0.1 }
            TableViewColumn{ role: "downVotes" ; title: "Down Votes" ; width: analysisFeaturesTable.width * 0.1 }
            TableViewColumn{ role: "lastReviewer" ; title: "Last Reviewer" ; width: analysisFeaturesTable.width * 0.2 }
            TableViewColumn{ role: "reviewDate" ; title: "Review Date" ; width: analysisFeaturesTable.width * 0.2 }
            model: tableModel
            itemDelegate: Item {
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    color: styleData.textColor
                    elide: styleData.elideMode
                    text: styleData.value
                }
            }
        }

        ListModel {
            id: tableModel
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
                if ( selectedFeature ) {
                    //if there is a selected feature unselect and add it to the stops layer
                    var convertstop = stopGraphic.clone();
                    convertstop.geometry = selectedFeature.geometry;
                    stopsLayer.addGraphic(convertstop);
                    stops.addFeature(convertstop);
                    featureLayer.clearSelection();
                }
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
                if ( selectedFeature ) {
                    //if there is a selected feature unselect and add it to the stops layer
                    var convertstop = stopGraphic.clone();
                    convertstop.geometry = selectedFeature.geometry;
                    stopsLayer.addGraphic(convertstop);
                    featureLayer.clearSelection();
                }
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
                if ( selectedFeature ) {
                    //if there is a selected feature unselect and add it to the stops layer
                    var convertstop = stopGraphic.clone();
                    convertstop.geometry = selectedFeature.geometry;
                    stopsLayer.addGraphic(convertstop);
                    featureLayer.clearSelection();
                }
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
