import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Item {
    id: buttonContainer
    width: parent.width * 0.8
    height: 60

    property string buttonText: ""
    property color accentColor: theme.accentColor
    property alias color: buttonRect.color
    property alias border: buttonRect.border
    signal buttonClicked()

    Rectangle {
        id: buttonRect
        anchors.centerIn: parent
        width: buttonContainer.width
        height: buttonContainer.height
        radius: 15
        color: mouseArea.pressed ? Qt.darker(theme.buttonBackgroundColor, 1.2) :
            mouseArea.containsMouse ? theme.buttonBackgroundColor : theme.buttonBackgroundColor
        border.width: mouseArea.containsMouse ? 2 : 1
        border.color: mouseArea.containsMouse ? accentColor : theme.buttonBorderColor || "transparent"

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 3
            verticalOffset: 3
            radius: 8
            samples: 17
            color: "#40000000"
            spread: 0.1
        }

        Behavior on border.width {
            NumberAnimation { duration: 150 }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                clickAnimation.start()
                buttonContainer.buttonClicked()
            }
            onEntered: {
                glowAnimation.start()
            }
            onExited: {
                fadeAnimation.start()
            }
        }

        Rectangle {
            id: borderGlow
            anchors.centerIn: parent
            width: buttonRect.width
            height: buttonRect.height
            color: "transparent"
            radius: buttonRect.radius
            border.width: 2
            border.color: accentColor
            opacity: 0

            layer.enabled: true
            layer.effect: Glow {
                transparentBorder: true
                radius: 8
                samples: 17
                color: accentColor
                spread: 0.3
            }
        }

        SequentialAnimation {
            id: glowAnimation
            NumberAnimation {
                target: borderGlow
                property: "opacity"
                from: 0
                to: 0.8
                duration: 300
                easing.type: Easing.OutCubic
            }
        }

        SequentialAnimation {
            id: fadeAnimation
            NumberAnimation {
                target: borderGlow
                property: "opacity"
                from: 0.8
                to: 0
                duration: 300
                easing.type: Easing.OutCubic
            }
        }

        Text {
            id: buttonTextItem
            anchors.centerIn: parent
            text: buttonContainer.buttonText
            color: mouseArea.containsMouse ? accentColor : theme.textColor
            font.pixelSize: 20
            font.weight: Font.Medium
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            Behavior on color {
                ColorAnimation { duration: 200 }
            }
        }

        Rectangle {
            id: ripple
            anchors.centerIn: parent
            width: 0
            height: 0
            radius: width/2
            color: accentColor
            opacity: 0
        }

        ParallelAnimation {
            id: clickAnimation

            NumberAnimation {
                target: buttonRect
                property: "scale"
                from: 1.0
                to: 0.97
                duration: 100
                easing.type: Easing.OutQuad
            }

            NumberAnimation {
                target: ripple
                property: "width"
                from: 0
                to: buttonRect.width * 1.5
                duration: 400
                easing.type: Easing.OutQuad
            }

            NumberAnimation {
                target: ripple
                property: "height"
                from: 0
                to: buttonRect.width * 1.5
                duration: 400
                easing.type: Easing.OutQuad
            }

            NumberAnimation {
                target: ripple
                property: "opacity"
                from: 0.3
                to: 0
                duration: 400
                easing.type: Easing.OutQuad
            }

            onStopped: {
                buttonRect.scale = 1.0
                ripple.width = 0
                ripple.height = 0
                ripple.opacity = 0
            }
        }
    }
}
