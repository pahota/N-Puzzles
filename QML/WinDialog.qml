import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects
import QtQuick.Particles

Item {
    id: winItem
    width: Math.min(parent ? parent.width * 0.8 : 400, 400)
    height: contentRoot.height
    visible: false
    opacity: 0
    scale: 0.9

    property int elapsedTime: 0
    property int displayCounter: 0
    property string gameTitle: ""
    property int finalScore: parent ? parent.scoreManager.currentScore : 0
    signal restartGameRequested()

    function open() {
        if (parent && parent.scoreManager) {
            finalScore = parent.scoreManager.currentScore
        }
        visible = true
        x = parent ? Math.round((parent.width - width) / 2) : 0
        y = parent ? Math.round((parent.height - height) / 2) : 0
        appearAnimation.start()
        scoreCountAnimation.restart()
        confettiEmitter.startEmission(1000)
    }

    function close() {
        disappearAnimation.start()
    }

    ParallelAnimation {
        id: appearAnimation
        NumberAnimation { target: winItem; property: "opacity"; to: 1.0; duration: 400; easing.type: Easing.OutCubic }
        NumberAnimation { target: winItem; property: "scale"; to: 1.0; duration: 500; easing.type: Easing.OutBack }
    }

    ParallelAnimation {
        id: disappearAnimation
        NumberAnimation { target: winItem; property: "opacity"; to: 0.0; duration: 300; easing.type: Easing.InCubic }
        NumberAnimation { target: winItem; property: "scale"; to: 0.9; duration: 300; easing.type: Easing.InCubic }
        onFinished: winItem.visible = false
    }

    Rectangle {
        id: contentRoot
        width: parent.width
        height: contentItem.height + footer.height
        color: "transparent"

        Rectangle {
            id: bgRect
            anchors.fill: parent
            color: theme.counterBackgroundColor
            radius: 16
            border { color: theme.tileBorderColor; width: 2 }

            Rectangle {
                anchors.fill: parent
                anchors.margins: 2
                radius: 14
                color: "transparent"
                border { color: Qt.lighter(theme.tileBorderColor, 1.3); width: 1 }
            }

            layer.enabled: true
            layer.effect: DropShadow {
                horizontalOffset: 0
                verticalOffset: 6
                radius: 12.0
                samples: 24
                color: Qt.rgba(0, 0, 0, 0.3)
                transparentBorder: true
                cached: true
            }
        }

        Rectangle {
            id: contentItem
            color: "transparent"
            width: parent.width
            height: contentColumn.implicitHeight + 40
            anchors.top: parent.top

            Column {
                id: contentColumn
                anchors {
                    fill: parent
                    margins: 20
                }
                spacing: 20

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: translations.t("victoryTitle")
                    color: theme.successColor
                    font { family: "Source Sans Pro"; pixelSize: 32; bold: true }
                    horizontalAlignment: Text.AlignHCenter

                    layer.enabled: true
                    layer.effect: DropShadow {
                        horizontalOffset: 1
                        verticalOffset: 1
                        radius: 3
                        samples: 8
                        color: Qt.rgba(0, 0, 0, 0.4)
                        transparentBorder: true
                    }

                    SequentialAnimation on scale {
                        running: winItem.visible
                        loops: 1
                        PropertyAnimation { to: 1.1; duration: 200; easing.type: Easing.OutQuad }
                        PropertyAnimation { to: 1.0; duration: 200; easing.type: Easing.InOutQuad }
                    }
                }

                Rectangle {
                    id: congratsBackground
                    width: congratsText.width + 40
                    height: congratsText.height + 20
                    color: Qt.alpha(theme.accentColor, 0.1)
                    radius: 12
                    anchors.horizontalCenter: parent.horizontalCenter
                    border { color: Qt.alpha(theme.accentColor, 0.2); width: 1 }

                    SequentialAnimation on scale {
                        running: winItem.visible
                        loops: 1
                        PropertyAnimation { from: 0.9; to: 1.02; duration: 300; easing.type: Easing.OutQuad }
                        PropertyAnimation { to: 1.0; duration: 200; easing.type: Easing.InOutQuad }
                    }

                    Text {
                        id: congratsText
                        anchors.centerIn: parent
                        text: translations.t("congratulations")
                        color: theme.counterTextColor
                        font { family: "Source Sans Pro"; pixelSize: 30; bold: true }
                        horizontalAlignment: Text.AlignHCenter
                    }
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: translations.t("puzzleSolved")
                    color: theme.counterTextColor
                    width: parent.width
                    font { family: "Source Sans Pro"; pixelSize: 28; bold: true }
                    wrapMode: Text.WordWrap
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    height: 60
                }

                Rectangle {
                    width: parent.width
                    height: 2
                    color: Qt.lighter(theme.tileBorderColor, 1.2)
                    opacity: 0.7

                    SequentialAnimation on opacity {
                        running: winItem.visible
                        loops: 1
                        PropertyAnimation { to: 1.0; duration: 500; easing.type: Easing.OutQuad }
                        PropertyAnimation { to: 0.7; duration: 500; easing.type: Easing.InOutQuad }
                    }
                }

                Row {
                    width: parent.width
                    spacing: 15

                    Rectangle {
                        id: timeCard
                        width: (parent.width - 15) / 2
                        height: 85
                        radius: 12
                        color: Qt.darker(theme.counterBackgroundColor, 1.05)
                        border { color: Qt.lighter(theme.tileBorderColor, 1.1); width: 1 }

                        layer.enabled: true
                        layer.effect: DropShadow {
                            horizontalOffset: 0
                            verticalOffset: 2
                            radius: 5.0
                            samples: 10
                            color: Qt.rgba(0, 0, 0, 0.15)
                            transparentBorder: true
                            cached: true
                        }

                        Column {
                            anchors.centerIn: parent
                            spacing: 8

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: translations.t("timeLabel")
                                color: theme.timerCounterTextColor
                                font { family: "Source Sans Pro"; pixelSize: 17 }
                                opacity: 0.8
                                horizontalAlignment: Text.AlignHCenter
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: formatTime(elapsedTime)
                                color: theme.timerCounterTextColor
                                font { family: "Source Sans Pro"; pixelSize: 26; bold: true }
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }
                    }

                    Rectangle {
                        id: movesCard
                        width: (parent.width - 15) / 2
                        height: 85
                        radius: 12
                        color: Qt.darker(theme.counterBackgroundColor, 1.05)
                        border { color: Qt.lighter(theme.tileBorderColor, 1.1); width: 1 }

                        layer.enabled: true
                        layer.effect: DropShadow {
                            horizontalOffset: 0
                            verticalOffset: 2
                            radius: 5.0
                            samples: 10
                            color: Qt.rgba(0, 0, 0, 0.15)
                            transparentBorder: true
                            cached: true
                        }

                        Column {
                            anchors.centerIn: parent
                            spacing: 8

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: translations.t("movesLabel")
                                color: theme.moveCounterTextColor
                                font { family: "Source Sans Pro"; pixelSize: 17 }
                                opacity: 0.8
                                horizontalAlignment: Text.AlignHCenter
                            }

                            Text {
                                id: movesText
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: displayCounter
                                color: theme.moveCounterTextColor
                                font { family: "Source Sans Pro"; pixelSize: 26; bold: true }
                                horizontalAlignment: Text.AlignHCenter

                                SequentialAnimation on scale {
                                    running: winItem.visible
                                    loops: 1
                                    PauseAnimation { duration: 300 }
                                    PropertyAnimation { to: 1.2; duration: 150; easing.type: Easing.OutQuad }
                                    PropertyAnimation { to: 1.0; duration: 150; easing.type: Easing.InOutQuad }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    id: scoreCard
                    width: parent.width
                    height: 95
                    radius: 12
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Qt.darker(theme.counterBackgroundColor, 1.02) }
                        GradientStop { position: 1.0; color: Qt.darker(theme.counterBackgroundColor, 1.08) }
                    }
                    border { color: Qt.lighter(theme.tileBorderColor, 1.1); width: 1 }

                    layer.enabled: true
                    layer.effect: DropShadow {
                        horizontalOffset: 0
                        verticalOffset: 3
                        radius: 6.0
                        samples: 12
                        color: Qt.rgba(0, 0, 0, 0.2)
                        transparentBorder: true
                        cached: true
                    }

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 1
                        radius: 11
                        color: "transparent"
                        border { color: Qt.lighter(theme.tileBorderColor, 1.4); width: 1 }
                        opacity: 0.5
                    }

                    Column {
                        anchors.centerIn: parent
                        spacing: 8

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: translations.t("scoreLabel")
                            color: theme.accentColor
                            font { family: "Source Sans Pro"; pixelSize: 20 }
                            opacity: 0.9
                            horizontalAlignment: Text.AlignHCenter
                        }

                        Text {
                            id: scoreText
                            anchors.horizontalCenter: parent.horizontalCenter
                            property int displayScore: 0
                            text: displayScore
                            color: theme.accentColor
                            font { family: "Source Sans Pro"; pixelSize: 38; bold: true }
                            horizontalAlignment: Text.AlignHCenter

                            layer.enabled: true
                            layer.effect: DropShadow {
                                horizontalOffset: 0
                                verticalOffset: 1
                                radius: 2
                                samples: 4
                                color: Qt.rgba(0, 0, 0, 0.2)
                                transparentBorder: true
                            }
                        }
                    }
                }

                Rectangle {
                    id: leaderboardPreview
                    width: parent.width
                    height: 100
                    radius: 12
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Qt.darker(theme.counterBackgroundColor, 1.05) }
                        GradientStop { position: 1.0; color: Qt.darker(theme.counterBackgroundColor, 1.12) }
                    }
                    border { color: Qt.lighter(theme.tileBorderColor, 1.1); width: 1 }
                    visible: scoreManager && scoreManager.highScores && scoreManager.highScores.length > 0

                    layer.enabled: true
                    layer.effect: DropShadow {
                        horizontalOffset: 0
                        verticalOffset: 3
                        radius: 6.0
                        samples: 12
                        color: Qt.rgba(0, 0, 0, 0.2)
                        transparentBorder: true
                        cached: true
                    }

                    Column {
                        anchors {
                            fill: parent
                            margins: 12
                        }
                        spacing: 8

                        Text {
                            text: translations.t("topScores")
                            color: theme.counterTextColor
                            font { family: "Source Sans Pro"; pixelSize: 18; bold: true }
                            horizontalAlignment: Text.AlignHCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Row {
                            width: parent.width
                            spacing: 10
                            anchors.horizontalCenter: parent.horizontalCenter

                            Repeater {
                                model: Math.min(3, scoreManager && scoreManager.highScores ? scoreManager.highScores.length : 0)

                                Rectangle {
                                    width: (parent.width - 20) / 3
                                    height: 58
                                    radius: 10
                                    color: index === 0 ? "#FFD700" : index === 1 ? "#C0C0C0" : "#CD7F32"
                                    opacity: 0.25

                                    SequentialAnimation on opacity {
                                        running: winItem.visible
                                        loops: 1
                                        PauseAnimation { duration: 400 + index * 100 }
                                        PropertyAnimation { to: 0.4; duration: 200; easing.type: Easing.OutQuad }
                                        PropertyAnimation { to: 0.25; duration: 200; easing.type: Easing.InOutQuad }
                                    }

                                    Column {
                                        anchors.centerIn: parent
                                        spacing: 4

                                        Text {
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            text: "#" + (index + 1)
                                            color: theme.counterTextColor
                                            font { family: "Source Sans Pro"; pixelSize: 15; bold: true }
                                            horizontalAlignment: Text.AlignHCenter
                                        }

                                        Text {
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            text: scoreManager && scoreManager.highScores ? scoreManager.highScores[index] : "0"
                                            color: theme.counterTextColor
                                            font { family: "Source Sans Pro"; pixelSize: 20; bold: true }
                                            horizontalAlignment: Text.AlignHCenter
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Text {
                    id: newRecordText
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: translations.t("newRecord")
                    color: "#FFD700"
                    font { family: "Source Sans Pro"; pixelSize: 24; bold: true }
                    visible: scoreManager && scoreManager.isNewHighScore
                    horizontalAlignment: Text.AlignHCenter

                    SequentialAnimation on opacity {
                        running: winItem.visible && newRecordText.visible
                        loops: Animation.Infinite
                        PropertyAnimation { to: 0.7; duration: 600; easing.type: Easing.InOutQuad }
                        PropertyAnimation { to: 1.0; duration: 600; easing.type: Easing.InOutQuad }
                    }

                    layer.enabled: true
                    layer.effect: DropShadow {
                        horizontalOffset: 0
                        verticalOffset: 2
                        radius: 4
                        samples: 8
                        color: Qt.rgba(0, 0, 0, 0.5)
                        transparentBorder: true
                    }
                }
            }
        }

        Rectangle {
            id: footer
            height: 65
            width: parent.width
            anchors.top: contentItem.bottom
            anchors.bottomMargin: 0
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.darker(theme.counterBackgroundColor, 1.05) }
                GradientStop { position: 1.0; color: Qt.darker(theme.counterBackgroundColor, 1.15) }
            }
            radius: 14

            Rectangle {
                width: parent.width
                height: parent.height / 2
                color: Qt.darker(theme.counterBackgroundColor, 1.1)
                anchors.bottom: parent.bottom
                radius: 14
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Qt.lighter(theme.tileBorderColor, 1.1)
                anchors.top: parent.top
                opacity: 0.5
            }

            Row {
                anchors.centerIn: parent
                spacing: 20
                height: 48

                Rectangle {
                    id: playAgainButton
                    width: 140
                    height: 48
                    radius: 10
                    color: "#4CAF50"
                    border.color: "#2E7D32"
                    border.width: 1
                    property bool hovered: false

                    Behavior on color {
                        ColorAnimation { duration: 100 }
                    }

                    layer.enabled: true
                    layer.effect: DropShadow {
                        horizontalOffset: 0
                        verticalOffset: 2
                        radius: 3.0
                        samples: 6
                        color: Qt.rgba(0, 0, 0, 0.3)
                        transparentBorder: true
                        cached: true
                    }

                    Text {
                        id: playAgainText
                        anchors.centerIn: parent
                        text: translations.t("playAgain")
                        color: "white"
                        font { family: "Source Sans Pro"; pixelSize: 17; bold: true }

                        Behavior on scale {
                            NumberAnimation { duration: 100 }
                        }
                    }

                    MouseArea {
                        id: playAgainMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            winItem.restartGameRequested()
                            winItem.close()
                        }
                        onPressed: {
                            parent.color = Qt.darker("#4CAF50", 1.2)
                            playAgainText.scale = 0.95
                        }
                        onReleased: {
                            if (containsMouse) parent.color = Qt.lighter("#4CAF50", 1.1)
                            else parent.color = "#4CAF50"
                            playAgainText.scale = 1.0
                        }
                        onEntered: {
                            parent.color = Qt.lighter("#4CAF50", 1.1)
                            playAgainText.scale = 1.05
                        }
                        onExited: {
                            parent.color = "#4CAF50"
                            playAgainText.scale = 1.0
                        }
                    }

                    SequentialAnimation on scale {
                        running: winItem.visible
                        loops: 1
                        PauseAnimation { duration: 300 }
                        PropertyAnimation { to: 1.05; duration: 150; easing.type: Easing.OutBack }
                        PropertyAnimation { to: 1.0; duration: 150; easing.type: Easing.InOutQuad }
                    }
                }

                Rectangle {
                    id: closeButton
                    width: 100
                    height: 48
                    radius: 10
                    color: "#F5F5F5"
                    border.color: "#BDBDBD"
                    border.width: 1
                    property bool hovered: false

                    Behavior on color {
                        ColorAnimation { duration: 100 }
                    }

                    layer.enabled: true
                    layer.effect: DropShadow {
                        horizontalOffset: 0
                        verticalOffset: 2
                        radius: 3.0
                        samples: 6
                        color: Qt.rgba(0, 0, 0, 0.2)
                        transparentBorder: true
                        cached: true
                    }

                    Text {
                        id: closeText
                        anchors.centerIn: parent
                        text: translations.t("close")
                        color: "#424242"
                        font { family: "Source Sans Pro"; pixelSize: 17; bold: true }

                        Behavior on scale {
                            NumberAnimation { duration: 100 }
                        }
                    }

                    MouseArea {
                        id: closeMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: winItem.close()
                        onPressed: {
                            parent.color = Qt.darker("#F5F5F5", 1.1)
                            closeText.scale = 0.95
                        }
                        onReleased: {
                            if (containsMouse) parent.color = Qt.lighter("#F5F5F5", 1.05)
                            else parent.color = "#F5F5F5"
                            closeText.scale = 1.0
                        }
                        onEntered: {
                            parent.color = Qt.lighter("#F5F5F5", 1.05)
                            closeText.scale = 1.05
                        }
                        onExited: {
                            parent.color = "#F5F5F5"
                            closeText.scale = 1.0
                        }
                    }
                }
            }
        }
    }

    Item {
        id: confettiContainer
        anchors.fill: parent
        anchors.margins: -100
        clip: false
        z: -1

        ParticleSystem {
            id: confettiSystem
            anchors.fill: parent
            running: winItem.visible

            ImageParticle {
                id: confettiParticle
                source: "qrc:/assets/confetti.png"
                alpha: 1.0
                alphaVariation: 0.2
                colorTable: ["#FF0000", "#00FF00", "#0000FF", "#FFFF00", "#FF00FF", "#00FFFF"]
                entryEffect: ImageParticle.Scale
                rotationVelocityVariation: 180
                rotationVariation: 180
                autoRotation: true
            }

            Emitter {
                id: confettiEmitter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                width: parent.width * 0.8
                enabled: false
                emitRate: 500
                lifeSpan: 4000
                lifeSpanVariation: 500
                size: 16
                sizeVariation: 8
                velocity: AngleDirection {
                    angle: 90
                    angleVariation: 30
                    magnitude: 150
                    magnitudeVariation: 50
                }
                acceleration: AngleDirection {
                    angle: 90
                    magnitude: 20
                }

                function startEmission(duration) {
                    if (duration <= 0) return;
                    enabled = true;
                    emissionTimer.interval = duration;
                    emissionTimer.start();
                }

                Timer {
                    id: emissionTimer
                    repeat: false
                    onTriggered: confettiEmitter.enabled = false
                }
            }
        }
    }

    NumberAnimation {
        id: scoreCountAnimation
        target: scoreText
        property: "displayScore"
        from: 0
        to: finalScore
        duration: 1200
        easing.type: Easing.OutCubic
        running: false
    }

    function formatTime(msec) {
        var minutes = Math.floor(msec / 60000)
        var seconds = Math.floor((msec % 60000) / 1000)
        return minutes + ":" + (seconds < 10 ? "0" : "") + seconds
    }

    Connections {
        target: parent
        function onWidthChanged() {
            if (winItem.visible) {
                winItem.x = Math.round((parent.width - winItem.width) / 2)
            }
        }
        function onHeightChanged() {
            if (winItem.visible) {
                winItem.y = Math.round((parent.height - winItem.height) / 2)
            }
        }
    }
}
