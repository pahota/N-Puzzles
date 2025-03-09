import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects

Rectangle {
    id: root
    property string displayText: ""
    property int themeIndex: 0
    property bool isLastMoved: false
    property int originalValue: 0
    property int dimension: 1

    Theme {
        id: theme
        themeIndex: root.themeIndex
    }

    radius: Math.min(width, height) * 0.15
    border.color: isLastMoved ? theme.lastMovedTileColor : Qt.darker(theme.tileBorderColor, 2.5)
    border.width: Math.min(width, height) * 0.05

    color: {
        let originalRow = Math.floor((originalValue - 1) / dimension);
        let rowFactor = dimension > 1 ? (originalRow / (dimension - 1)) : 0;
        let baseColor = isLastMoved ? Qt.lighter(theme.lastMovedTileColor, 1.2) : theme.tileColor;
        return Qt.darker(baseColor, 1.0 + (rowFactor * 0.5));
    }

    Behavior on color {
        ColorAnimation { duration: 200 }
    }

    Behavior on border.color {
        ColorAnimation { duration: 200 }
    }

    Behavior on x {
        NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
    }

    Behavior on y {
        NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
    }

    Text {
        id: tileText
        anchors.centerIn: parent
        text: root.displayText
        color: Qt.lighter(theme.tileTextColor, 1.5)
        font.family: "Source Sans Pro"
        font.pointSize: Math.min(parent.width, parent.height) * 0.3
        font.bold: true

        layer.enabled: false
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 2
            radius: 8.0
            samples: 17
            color: Qt.rgba(0, 0, 0,
            0.8)
        }

        Behavior on font.pointSize {
            NumberAnimation { duration: 120 }
        }

        Behavior on color {
            ColorAnimation { duration: 120 }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: hoverAnimation.start()
        onExited: {
            restoreAnimation.start()
            restoreOriginalState.start()
        }
    }

    ParallelAnimation {
        id: hoverAnimation
        PropertyAnimation {
            target: tileText
            property: "font.pointSize"
            to: Math.min(parent.width, parent.height) * 0.35
            duration: 120
        }
        PropertyAnimation {
            target: tileText
            property: "layer.enabled"
            to: true
            duration: 50
        }
        PropertyAnimation {
            target: tileText
            property: "color"
            to: theme.highlightColor
            duration: 120
        }
        PropertyAnimation {
            target: root
            property: "border.width"
            to: Math.min(width, height) * 0.06
            duration: 120
        }
        PropertyAnimation {
            target: root
            property: "border.color"
            to: Qt.darker(theme.tileBorderColor, 3.0)
            duration: 120
        }
        PropertyAnimation {
            target: root
            property: "opacity"
            to: 0.95
            duration: 120
        }
    }

    ParallelAnimation {
        id: restoreAnimation
        PropertyAnimation {
            target: tileText
            property: "font.pointSize"
            to: Math.min(parent.width, parent.height) * 0.3
            duration: 120
        }
        PropertyAnimation {
            target: tileText
            property: "layer.enabled"
            to: false
            duration: 50
        }
        PropertyAnimation {
            target: tileText
            property: "color"
            to: Qt.lighter(theme.tileTextColor, 1.5)
            duration: 120
        }
        PropertyAnimation {
            target: root
            property: "border.width"
            to: Math.min(width, height) * 0.05
            duration: 120
        }
        PropertyAnimation {
            target: root
            property: "border.color"
            to: isLastMoved ? theme.lastMovedTileColor : Qt.darker(theme.tileBorderColor, 2.5)
            duration: 120
        }
        PropertyAnimation {
            target: root
            property: "opacity"
            to: 1.0
            duration: 120
        }
    }

    SequentialAnimation {
        id: restoreOriginalState
        PauseAnimation { duration: 120 }
        PropertyAction {
            target: root
            property: "color"
            value: {
                let originalRow = Math.floor((originalValue - 1) / dimension);
                let rowFactor = dimension > 1 ? (originalRow / (dimension - 1)) : 0;
                let baseColor = isLastMoved ? Qt.lighter(theme.lastMovedTileColor, 1.2) : theme.tileColor;
                return Qt.darker(baseColor, 1.0 + (rowFactor * 0.5));
            }
        }
    }
}
