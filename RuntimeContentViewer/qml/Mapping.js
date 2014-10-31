
function addLocalFeatureData(focusMap, featureTableRegistry, localConnection) {
    // Create the local geodatabase instance
    var localGeodatabase = ArcGISRuntime.createObject("Geodatabase");
    console.log("Setting the local geodatabase path: " + localConnection.path);
    localGeodatabase.path = localConnection.path;

    // Load all feature tables
    var featureTables = localGeodatabase.geodatabaseFeatureTables;
    for (var tableIndex in featureTables) {
        var localFeatureTable = featureTables[tableIndex];
        console.log("Feature table name: " + localFeatureTable.tableName);

        // Add the feature table as feature layer
        var localFeatureLayer = ArcGISRuntime.createObject("FeatureLayer");
        console.log("Feature layer created");
        localFeatureLayer.featureTable = localFeatureTable;
        // Add a strong reference to it
        featureTableRegistry.push({ 'geodatabase': localGeodatabase, 'featureTable': localFeatureTable });
        console.log("Feature table bound");
        focusMap.insertLayer(localFeatureLayer, 0);
        console.log("Feature layer added");
    }
}
