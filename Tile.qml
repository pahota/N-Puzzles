import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root
    property string displayText: ""
    property int themeIndex: 0
    property bool isLastMoved: false

    Theme {
        id: theme
        themeIndex: root.themeIndex
    }

    radius: Math.min(width, height) * 0.15
    border.color: isLastMoved ? theme.lastMovedTileColor : Qt.darker(theme.tileBorderColor, 2.5)
    border.width: Math.min(width, height) * 0.05
    color: isLastMoved ? Qt.lighter(theme.lastMovedTileColor, 1.2) : Qt.darker(theme.tileColor, 1.2)

    Behavior on color {
        ColorAnimation { duration: 200 }
    }

    Behavior on border.color {
        ColorAnimation { duration: 200 }
    }

    Text {
        id: tileText
        anchors.centerIn: parent
        text: root.displayText
        color: Qt.lighter(theme.tileTextColor, 1.5)
        font.family: "Source Sans Pro"
        font.pointSize: Math.min(parent.width, parent.height) * 0.3
        font.bold: true

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
        onExited: restoreAnimation.start()
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
            property: "color"
            to: theme.highlightColor
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
            property: "color"
            to: Qt.lighter(theme.tileTextColor, 1.5)
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
}
