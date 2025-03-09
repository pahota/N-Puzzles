import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects

Rectangle {
    id: menuButton

    property string buttonText: "Button"
    property string icon: ""
    property int themeIndex: 0

    signal clicked()

    radius: height / 4
    color: theme.buttonBackgroundColor
    border {
        color: mouseArea.containsMouse ? theme.accentColor : theme.highlightColor
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

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: parent.clicked()
    }

    Rectangle {
        id: buttonGlow
        anchors.fill: parent
        radius: parent.radius
        color: "transparent"
        opacity: mouseArea.containsMouse ? 1 : 0

        layer.enabled: mouseArea.containsMouse
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

    Item {
        anchors.fill: parent

        Image {
            id: buttonIcon
            source: icon
            width: menuButton.height * 0.6
            height: width
            anchors {
                left: parent.left
                leftMargin: menuButton.width * 0.15
                verticalCenter: parent.verticalCenter
            }
            smooth: true
            mipmap: true
            fillMode: Image.PreserveAspectFit
            visible: icon !== ""

            ColorOverlay {
                anchors.fill: parent
                source: parent
                color: mouseArea.containsMouse ? theme.highlightColor : themeIndex === 0 ? "#242424" : "#FFFFFF"
                opacity: 1

                Behavior on color {
                    ColorAnimation { duration: 200; easing.type: Easing.OutCubic }
                }
            }
        }

        Text {
            id: buttonText
            text: menuButton.buttonText
            color: mouseArea.containsMouse ? theme.highlightColor : themeIndex === 0 ? "#242424" : "#FFFFFF"
            font {
                family: "Source Sans Pro"
                pixelSize: mouseArea.containsMouse ? menuButton.height * 0.4 : menuButton.height * 0.36
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
    }

    Behavior on color {
        ColorAnimation { duration: 150; easing.type: Easing.OutCubic }
    }

    Behavior on border.color {
        ColorAnimation { duration: 150; easing.type: Easing.OutCubic }
    }

    transform: Scale {
        id: buttonScale
        origin.x: menuButton.width/2
        origin.y: menuButton.height/2
        xScale: mouseArea.containsMouse ? 0.98 : 1.0
        yScale: mouseArea.containsMouse ? 0.98 : 1.0

        Behavior on xScale {
            NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
        }
        Behavior on yScale {
            NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
        }
    }
}
