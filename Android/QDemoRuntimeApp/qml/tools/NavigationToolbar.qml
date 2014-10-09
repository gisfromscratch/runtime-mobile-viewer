import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

ToolBar {
    id: mainToolBar
    width: parent.width

    RowLayout {
        ToolButton {
            iconSource: "qrc:/Resources/Map64.png"

            onClicked: localTiledLayer.visible = !localTiledLayer.visible
        }

        ToolButton {
            iconSource: "qrc:/Resources/Map64.png"

            onClicked: localTiledLayer.visible = !localTiledLayer.visible
        }
    }
}
