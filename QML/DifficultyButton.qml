import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects

Item {
    id: root

    property string buttonText: "Button"
    property color buttonColor: theme.buttonBackgroundColor
    property color borderColor: theme.buttonBorderColor
    property bool isActive: false
    property int themeIndex: 0

    signal clicked()

    Rectangle {
        id: buttonBackground
        anchors.fill: parent
        radius: height / 4
        color: buttonColor
        border {
            color: buttonMouseArea.containsMouse ? theme.accentColor : borderColor
            width: 2
        }

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 2
            radius: 8
            samples: 12
            color: theme.shadowColor
        }

        Rectangle {
            id: buttonGlow
            anchors.fill: parent
            radius: parent.radius
            color: "transparent"
            opacity: buttonMouseArea.containsMouse ? 1 : 0

            layer.enabled: buttonMouseArea.containsMouse
            layer.effect: Glow {
                radius: 6
                samples: 12
                color: Qt.rgba(theme.accentColor.r, theme.accentColor.g, theme.accentColor.b, 0.4)
                spread: 0.2
            }

            Behavior on opacity {
                NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
            }
        }

        Behavior on color {
            ColorAnimation { duration: 150; easing.type: Easing.OutCubic }
        }

        Behavior on border.color {
            ColorAnimation { duration: 150; easing.type: Easing.OutCubic }
        }

        transform: Scale {
            id: buttonScale
            origin.x: buttonBackground.width/2
            origin.y: buttonBackground.height/2
            xScale: buttonMouseArea.containsMouse ? 0.98 : 1.0
            yScale: buttonMouseArea.containsMouse ? 0.98 : 1.0

            Behavior on xScale {
                NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
            }
            Behavior on yScale {
                NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
            }
        }
    }

    Text {
        id: buttonText
        text: root.buttonText
        color: buttonMouseArea.containsMouse ? borderColor : themeIndex === 0 ? "#242424" : "#FFFFFF"
        font {
            family: "Source Sans Pro"
            pixelSize: buttonMouseArea.containsMouse ? parent.height * 0.38 : parent.height * 0.35
            bold: true
            letterSpacing: 0.5
        }
        anchors.centerIn: parent

        Behavior on font.pixelSize {
            NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
        }

        Behavior on color {
            ColorAnimation { duration: 200; easing.type: Easing.OutCubic }
        }
    }

    MouseArea {
        id: buttonMouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            root.clicked()
        }
    }
}
