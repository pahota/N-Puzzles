import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Item {
    id: pauseScreen
    visible: root.isPaused
    anchors.fill: parent
    z: 100

    property QtObject translationsRef: translations
    property int moveCount: root.displayCounter
    property int elapsedTime: root.elapsedTime
    property int score: root.scoreManager.currentScore

    Rectangle {
        id: backgroundOverlay
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.8)
        opacity: 0

        NumberAnimation {
            id: showAnimation
            target: backgroundOverlay
            property: "opacity"
            from: 0
            to: 1
            duration: 300
            easing.type: Easing.OutQuad
            running: pauseScreen.visible
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {}
        }

        Item {
            id: pauseDialogContainer
            width: Math.min(parent.width * 0.4, 550) + 100
            height: Math.min(parent.height * 0.7, 700) + 250
            anchors.centerIn: parent

            Rectangle {
                id: pauseDialog
                width: Math.min(pauseDialogContainer.parent.width * 0.4, 550)
                height: Math.min(pauseDialogContainer.parent.height * 0.8, 700)
                anchors.centerIn: parent
                color: Qt.darker(theme.cardColor, 2)
                radius: 20
                opacity: 0
                scale: 0.9
                border.width: 0

                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    horizontalOffset: 4
                    verticalOffset: 4
                    radius: 12
                    samples: 24
                    color: "#80000000"
                }

                Rectangle {
                    id: glowingBorder
                    anchors.fill: parent
                    color: "transparent"
                    radius: pauseDialog.radius
                    border.width: 2
                    border.color: theme.accentColor
                    opacity: 0.8

                    layer.enabled: true
                    layer.effect: Glow {
                        transparentBorder: true
                        radius: 12
                        samples: 24
                        color: theme.accentColor
                        spread: 0.3
                    }
                }

                SequentialAnimation {
                    id: borderPulseAnimation
                    running: pauseScreen.visible
                    loops: Animation.Infinite

                    NumberAnimation {
                        target: glowingBorder
                        property: "opacity"
                        from: 0.8
                        to: 0.3
                        duration: 1500
                        easing.type: Easing.InOutQuad
                    }

                    NumberAnimation {
                        target: glowingBorder
                        property: "opacity"
                        from: 0.3
                        to: 0.8
                        duration: 1500
                        easing.type: Easing.InOutQuad
                    }
                }

                NumberAnimation {
                    id: dialogShowAnimation
                    target: pauseDialog
                    properties: "opacity,scale"
                    from: 0
                    to: 1
                    duration: 400
                    easing.type: Easing.OutBack
                    running: pauseScreen.visible
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 30
                    spacing: 25

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: translationsRef.t("gamePaused")
                        color: theme.textColor
                        font.pixelSize: 40
                        font.bold: true
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 4
                        radius: 2
                        color: "transparent"

                        Rectangle {
                            id: gradientBar
                            anchors.fill: parent
                            radius: 2
                            gradient: Gradient {
                                orientation: Gradient.Horizontal
                                GradientStop { position: 0.0; color: theme.accentGradientStartColor }
                                GradientStop { position: 1.0; color: theme.accentGradientEndColor || theme.accentColor }
                            }
                        }

                        SequentialAnimation {
                            running: pauseScreen.visible
                            loops: Animation.Infinite

                            NumberAnimation {
                                target: gradientBar
                                property: "opacity"
                                from: 1.0
                                to: 0.6
                                duration: 1200
                                easing.type: Easing.InOutSine
                            }

                            NumberAnimation {
                                target: gradientBar
                                property: "opacity"
                                from: 0.6
                                to: 1.0
                                duration: 1200
                                easing.type: Easing.InOutSine
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: statsLayout.height + 30
                        color: Qt.rgba(theme.cardColor.r * 0.9, theme.cardColor.g * 0.9, theme.cardColor.b * 0.9, 0.7)
                        radius: 15
                        border.width: 1
                        border.color: theme.accentColor

                        GridLayout {
                            id: statsLayout
                            anchors.centerIn: parent
                            width: parent.width - 40
                            columns: 2
                            columnSpacing: 20
                            rowSpacing: 15

                            Text {
                                text: translationsRef.t("moves") + ":"
                                font.pixelSize: 20
                                color: theme.textColor
                                font.bold: true
                            }

                            Text {
                                text: pauseScreen.moveCount || "0"
                                font.pixelSize: 20
                                color: theme.accentColor
                                font.bold: true
                            }

                            Text {
                                text: translationsRef.t("time") + ":"
                                font.pixelSize: 20
                                color: theme.textColor
                                font.bold: true
                            }

                            Text {
                                text: formatTime(pauseScreen.elapsedTime)
                                font.pixelSize: 20
                                color: theme.accentColor
                                font.bold: true
                            }

                            Text {
                                text: translationsRef.t("score") + ":"
                                font.pixelSize: 20
                                color: theme.textColor
                                font.bold: true
                            }

                            Text {
                                text: pauseScreen.score || "0"
                                font.pixelSize: 20
                                color: theme.accentColor
                                font.bold: true
                            }
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: 25
                        Layout.topMargin: 10

                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                        }

                        PauseButton {
                            Layout.alignment: Qt.AlignHCenter
                            Layout.preferredWidth: parent.width * 0.8
                            height: 60
                            buttonText: translationsRef.t("continueGame")
                            border.color: theme.accentColor
                            accentColor: theme.accentColor

                            onButtonClicked: {
                                root.isPaused = false
                                timerRunning = !isPaused && !isGameWon && root.displayCounter > 0
                            }
                        }

                        PauseButton {
                            Layout.alignment: Qt.AlignHCenter
                            Layout.preferredWidth: parent.width * 0.8
                            height: 60
                            buttonText: translationsRef.t("saveGame")
                            border.color: theme.accentColor
                            accentColor: theme.accentColor

                            onButtonClicked: {
                                saveGameDialog.open()
                            }
                        }

                        PauseButton {
                            Layout.alignment: Qt.AlignHCenter
                            Layout.preferredWidth: parent.width * 0.8
                            height: 60
                            buttonText: translationsRef.t("restartLevel")
                            border.color: theme.accentColor
                            accentColor: theme.accentColor

                            onButtonClicked: {
                                root.isPaused = false
                                root.elapsedTime = 0
                                root.displayCounter = 0
                                root.restartGame()
                                timerRunning = !isPaused && !isGameWon && root.displayCounter > 0
                                gameBoard.resetGame()
                            }
                        }

                        PauseButton {
                            Layout.alignment: Qt.AlignHCenter
                            Layout.preferredWidth: parent.width * 0.8
                            height: 60
                            buttonText: translationsRef.t("mainMenu")
                            border.color: theme.accentColor
                            accentColor: theme.accentColor

                            onButtonClicked: {
                                confirmExitDialog.open()
                            }
                        }

                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                        }
                    }
                }
            }
        }

        Item {
            id: saveGameContainer
            width: Math.min(parent.width * 0.4, 480) + 60
            height: Math.min(parent.height * 0.3, 280) + 60
            anchors.centerIn: parent
            z: 15

            Rectangle {
                id: saveGameDialog
                visible: false
                width: Math.min(saveGameContainer.parent.width * 0.4, 480)
                height: Math.min(saveGameContainer.parent.height * 0.3, 280)
                anchors.centerIn: parent
                color: Qt.rgba(theme.cardColor.r * 0.95, theme.cardColor.g * 0.95, theme.cardColor.b * 0.95, 1)
                radius: 20
                border.width: 0
                opacity: 0
                scale: 0.9

                property bool isOpen: false

                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    horizontalOffset: 4
                    verticalOffset: 4
                    radius: 12
                    samples: 24
                    color: "#80000000"
                }

                Rectangle {
                    id: saveGlowBorder
                    anchors.fill: parent
                    color: "transparent"
                    radius: saveGameDialog.radius
                    border.width: 2
                    border.color: theme.accentColor
                    opacity: 0.8

                    layer.enabled: true
                    layer.effect: Glow {
                        transparentBorder: true
                        radius: 12
                        samples: 24
                        color: theme.accentColor
                        spread: 0.3
                    }
                }

                function open() {
                    isOpen = true
                    visible = true
                    saveDialogAnimation.start()
                }

                function close() {
                    isOpen = false
                    saveDialogCloseAnimation.start()
                }

                ParallelAnimation {
                    id: saveDialogAnimation

                    NumberAnimation {
                        target: saveGameDialog
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: 300
                        easing.type: Easing.OutQuad
                    }

                    NumberAnimation {
                        target: saveGameDialog
                        property: "scale"
                        from: 0.9
                        to: 1
                        duration: 400
                        easing.type: Easing.OutBack
                    }
                }

                SequentialAnimation {
                    id: saveDialogCloseAnimation

                    ParallelAnimation {
                        NumberAnimation {
                            target: saveGameDialog
                            property: "opacity"
                            from: 1
                            to: 0
                            duration: 200
                            easing.type: Easing.InQuad
                        }

                        NumberAnimation {
                            target: saveGameDialog
                            property: "scale"
                            from: 1
                            to: 0.9
                            duration: 200
                            easing.type: Easing.InQuad
                        }
                    }

                    ScriptAction {
                        script: saveGameDialog.visible = false
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {}
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 30
                    spacing: 20

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.fillWidth: true
                        text: translationsRef.t("saveGame")
                        color: theme.textColor
                        font.pixelSize: 30
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 3
                        radius: 1.5
                        color: theme.accentColor
                        opacity: 0.7
                    }

                    TextField {
                        id: saveNameField
                        Layout.fillWidth: true
                        Layout.preferredHeight: 45
                        placeholderText: translationsRef.t("enterSaveName")
                        color: theme.textColor
                        font.pixelSize: 18
                        background: Rectangle {
                            color: Qt.rgba(theme.cardColor.r * 0.9, theme.cardColor.g * 0.9, theme.cardColor.b * 0.9, 1)
                            radius: 8
                            border.width: 1
                            border.color: parent.activeFocus ? theme.accentColor : "transparent"
                        }
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 20
                        Layout.topMargin: 20

                        PauseButton {
                            Layout.preferredWidth: 150
                            height: 50
                            buttonText: translationsRef.t("cancel")
                            border.color: theme.accentColor
                            accentColor: theme.accentColor

                            onButtonClicked: {
                                saveGameDialog.close()
                            }
                        }

                        PauseButton {
                            Layout.preferredWidth: 150
                            height: 50
                            color: theme.accentColor
                            border.color: theme.accentColor
                            buttonText: translationsRef.t("save")
                            accentColor: theme.accentColor

                            onButtonClicked: {
                                if (saveNameField.text.trim() !== "") {
                                    root.saveGame(saveNameField.text.trim())
                                    saveGameDialog.close()
                                }
                            }
                        }
                    }
                }
            }
        }

        Item {
            id: confirmExitContainer
            width: Math.min(parent.width * 0.4, 480) + 60
            height: Math.min(parent.height * 0.3, 280) + 60
            anchors.centerIn: parent
            z: 10

            Rectangle {
                id: confirmExitDialog
                visible: false
                width: Math.min(confirmExitContainer.parent.width * 0.4, 480)
                height: Math.min(confirmExitContainer.parent.height * 0.3, 280)
                anchors.centerIn: parent
                color: Qt.rgba(theme.cardColor.r * 0.95, theme.cardColor.g * 0.95, theme.cardColor.b * 0.95, 1)
                radius: 20
                border.width: 0
                opacity: 0
                scale: 0.9

                property bool isOpen: false

                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    horizontalOffset: 4
                    verticalOffset: 4
                    radius: 12
                    samples: 24
                    color: "#80000000"
                }

                Rectangle {
                    id: errorGlowBorder
                    anchors.fill: parent
                    color: "transparent"
                    radius: confirmExitDialog.radius
                    border.width: 2
                    border.color: theme.errorColor
                    opacity: 0.8

                    layer.enabled: true
                    layer.effect: Glow {
                        transparentBorder: true
                        radius: 12
                        samples: 24
                        color: theme.errorColor
                        spread: 0.3
                    }
                }

                SequentialAnimation {
                    id: errorBorderPulseAnimation
                    running: confirmExitDialog.visible
                    loops: Animation.Infinite

                    NumberAnimation {
                        target: errorGlowBorder
                        property: "opacity"
                        from: 0.8
                        to: 0.3
                        duration: 1000
                        easing.type: Easing.InOutQuad
                    }

                    NumberAnimation {
                        target: errorGlowBorder
                        property: "opacity"
                        from: 0.3
                        to: 0.8
                        duration: 1000
                        easing.type: Easing.InOutQuad
                    }
                }

                function open() {
                    isOpen = true
                    visible = true
                    confirmDialogAnimation.start()
                }

                function close() {
                    isOpen = false
                    confirmDialogCloseAnimation.start()
                }

                ParallelAnimation {
                    id: confirmDialogAnimation

                    NumberAnimation {
                        target: confirmExitDialog
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: 300
                        easing.type: Easing.OutQuad
                    }

                    NumberAnimation {
                        target: confirmExitDialog
                        property: "scale"
                        from: 0.9
                        to: 1
                        duration: 400
                        easing.type: Easing.OutBack
                    }
                }

                SequentialAnimation {
                    id: confirmDialogCloseAnimation

                    ParallelAnimation {
                        NumberAnimation {
                            target: confirmExitDialog
                            property: "opacity"
                            from: 1
                            to: 0
                            duration: 200
                            easing.type: Easing.InQuad
                        }

                        NumberAnimation {
                            target: confirmExitDialog
                            property: "scale"
                            from: 1
                            to: 0.9
                            duration: 200
                            easing.type: Easing.InQuad
                        }
                    }

                    ScriptAction {
                        script: confirmExitDialog.visible = false
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {}
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 30
                    spacing: 20

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.fillWidth: true
                        text: translationsRef.t("confirmExit")
                        color: theme.textColor
                        font.pixelSize: 30
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 3
                        radius: 1.5
                        color: theme.errorColor
                        opacity: 0.7
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.fillWidth: true
                        Layout.topMargin: 10
                        text: translationsRef.t("exitConfirmationMessage")
                        color: theme.textSecondaryColor
                        font.pixelSize: 18
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignHCenter
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 20
                        Layout.topMargin: 20

                        PauseButton {
                            Layout.preferredWidth: 150
                            height: 50
                            buttonText: translationsRef.t("cancel")
                            border.color: theme.accentColor
                            accentColor: theme.accentColor

                            onButtonClicked: {
                                confirmExitDialog.close()
                            }
                        }

                        PauseButton {
                            Layout.preferredWidth: 150
                            height: 50
                            color: theme.errorColor
                            border.color: theme.errorColor
                            buttonText: translationsRef.t("exit")
                            accentColor: theme.errorColor

                            onButtonClicked: {
                                confirmExitDialog.close()
                                root.isPaused = false
                                root.showMainMenu = true
                                root.elapsedTime = 0
                                root.displayCounter = 0
                                timerRunning = false
                                gameBoard.resetGame()
                            }
                        }
                    }
                }
            }
        }
    }
    function formatTime(seconds) {
        var minutes = Math.floor(seconds / 60)
        var secs = seconds % 60
        return minutes + ":" + (secs < 10 ? "0" + secs : secs)
    }
}
