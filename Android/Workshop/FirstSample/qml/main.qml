
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

    property int df: System.displayScaleFactor

    Map {
        id: focusMap
        anchors.fill: parent
        width: 800
        height: 600

        property bool isLandscape: appWindow.height < appWindow.width

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
            height: 60 * df
            width: appWindow.width
            color: "#0079C1"

            states: [
                State {
                    name: "position"
                    PropertyChanges { target: toolbarGPSButton; visible: false }
                    PropertyChanges { target: toolbarAnalysisButton; visible: false }
                    PropertyChanges { target: toolbarSearchButton; visible: false }
                    PropertyChanges { target: myBackButton; visible: true }
                    PropertyChanges { target: myRouteButton; visible: true }
                    PropertyChanges { target: mapTools; visible: true }
                    PropertyChanges { target: myZoomButton; visible: true }
                    PropertyChanges { target: myClearButton; visible: true }
                },
                State {
                    name: "analysis"
                    PropertyChanges { target: toolbarGPSButton; visible: false }
                    PropertyChanges { target: toolbarAnalysisButton; visible: false }
                    PropertyChanges { target: toolbarSearchButton; visible: false }
                    PropertyChanges { target: myRouteButton; visible: false }
                    PropertyChanges { target: myBackButton; visible: true }
                    PropertyChanges { target: myClearButton; visible: true }
                    PropertyChanges { target: myZoomButton; visible: true }
                    PropertyChanges { target: mapTools; visible: true }
                    PropertyChanges { target: bufferDistanceLabel; visible: true }
                    PropertyChanges { target: bufferDistanceBox; visible: true }
                },
                State {
                    name: "search"
                    PropertyChanges { target: toolbarGPSButton; visible: false }
                    PropertyChanges { target: toolbarAnalysisButton; visible: false }
                    PropertyChanges { target: toolbarSearchButton; visible: false }
                    PropertyChanges { target: myBackButton; visible: true }
                    PropertyChanges { target: myRouteButton; visible: true }
                    PropertyChanges { target: mapTools; visible: true }
                    PropertyChanges { target: myZoomButton; visible: true }
                    PropertyChanges { target: myClearButton; visible: true }
                    PropertyChanges { target: searchBox; visible: true }
                    PropertyChanges { target: mySearchButton; visible: true }
                }
            ]

            Image {
                id: toolbarGPSButton
                width: 40 * df
                height: 40 * df
                anchors.horizontalCenter: toolbar.horizontalCenter
                anchors.horizontalCenterOffset: -toolbar.width * 0.2
                anchors.verticalCenter: toolbar.verticalCenter
                source: "qrc:/Resources/gps.png"
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

            MouseArea {
                id: toolbarGPSButtonMouseArea
                anchors.fill: parent
                onClicked: {
                    toolbar.state = "position"
                }
            }

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
                }
            }

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
                TextInput{
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
                }
            }

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
            }

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
                }
            }
        }
    }
}

