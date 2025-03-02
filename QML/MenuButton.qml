import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects

Rectangle {
    id: button
    width: 200
    height: 50
    radius: height / 4
    color: theme.counterBackgroundColor
    border { color: theme.tileBorderColor; width: 2 }

    property string buttonText: "Button"
    property int themeIndex: 0

    signal clicked()

    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 3
        verticalOffset: 3
        radius: 8
        samples: 16
        color: "#66000000"
    }

    MouseArea {
        id: buttonArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: button.clicked()
    }

    Text {
        id: buttonLabel
        text: buttonText
        color: theme.counterTextColor
        font {
            family: "Source Sans Pro"
            pixelSize: parent.height * 0.4
            bold: true
        }
        anchors.centerIn: parent
    }

    states: State {
        name: "hovered"
        when: buttonArea.containsMouse
        PropertyChanges { target: button; scale: 0.98 }
        PropertyChanges { target: buttonLabel; color: theme.highlightColor }
    }

    transitions: Transition {
        from: ""; to: "hovered"; reversible: true
        ParallelAnimation {
            NumberAnimation { properties: "scale"; duration: 200 }
            ColorAnimation { properties: "color"; duration: 200 }
        }
    }
}
