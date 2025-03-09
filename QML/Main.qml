import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import Qt5Compat.GraphicalEffects
import Qt.labs.settings 1.0
import QtMultimedia 5.15
import AudioComponents 1.0
import GameComponents 1.0
import QtQuick.Particles 2.15

ApplicationWindow {
    id: root
    width: 2560
    height: 1440
    visible: true
    color: theme.windowColor
    title: qsTr("15 Puzzle")
    visibility: Window.FullScreen

    property int themeIndex: 0
    property int displayCounter: 0
    property int elapsedTime: 0
    property bool timerRunning: false
    property bool isGameWon: false
    property bool isPaused: false
    property bool isEnglish: true
    property bool showMainMenu: true
    property int currentDimension: 4
    property var scoreManager: Score {
        onCurrentScoreChanged: {
            scoreValueText.text = currentScore
            borderCanvas.requestPaint()
        }
    }

    Settings {
        id: settingsStore
        category: "Appearance"
        property alias theme: root.themeIndex
        property alias language: root.isEnglish
    }

    Component.onCompleted: {
        themeIndex = settingsStore.value("theme", 0)
        isEnglish = settingsStore.value("language", true)
    }

    Theme {
        id: theme
        themeIndex: root.themeIndex
    }

    AudioController {
        id: audioController
    }

    Timer {
        id: gameTimer
        interval: 1000
        repeat: true
        running: timerRunning && !isGameWon && !isPaused
        onTriggered: {
            elapsedTime++
            if (scoreManager) {
                scoreManager.calculateScore(elapsedTime, displayCounter)
            }
        }
    }

    Background {
        id: background
        anchors.fill: parent
    }

    Loader {
        id: pauseLoader
        source: "Pause.qml"
        anchors.fill: parent
    }
    QtObject {
        id: translations
        property var texts: ({
            "time": { "en": "Time", "ru": "Время" },
            "steps": { "en": "Steps", "ru": "Шаги" },
            "score": { "en": "Score", "ru": "Очки" },
            "resume": { "en": "Resume", "ru": "Продолжить" },
            "pause": { "en": "Pause", "ru": "Пауза" },
            "restart": { "en": "Restart", "ru": "Рестарт" },
            "settings": { "en": "Settings", "ru": "Настройки" },
            "congratulations": { "en": "Congratulations!", "ru": "Поздравляем!" },
            "puzzleSolved": { "en": "Puzzle Solved!", "ru": "Головоломка решена!" },
            "timeLabel": { "en": "Time", "ru": "Время" },
            "movesLabel": { "en": "Moves", "ru": "Ходы" },
            "scoreLabel": { "en": "Score", "ru": "Очки" },
            "playAgain": { "en": "Play Again", "ru": "Играть снова" },
            "share": { "en": "Share", "ru": "Поделиться" },
            "about": { "en": "About Game", "ru": "Об игре" },
            "close": { "en": "Close", "ru": "Закрыть" },
            "mainMenu": { "en": "Main Menu", "ru": "Главное меню" },
            "gamePaused": { "en": "Game Paused", "ru": "Игра приостановлена" },
            "continueGame": { "en": "Continue Game", "ru": "Продолжить игру" },
            "restartLevel": { "en": "Restart Level", "ru": "Начать заново" },
            "exitConfirmationMessage": { "en": "Are you sure you want to exit to the main menu? Your progress in this level will be lost.", "ru": "Вы уверены, что хотите выйти в главное меню? Прогресс на данном уровне будет потерян." },
            "cancel": { "en": "Cancel", "ru": "Отмена" },
            "exit": { "en": "Exit", "ru": "Выйти" },
            "topScores": { "en": "Top Scores", "ru": "Лучшие результаты" },
            "newRecord": { "en": "New Record!", "ru": "Новый рекорд!" },
            "resultsCopied": { "en": "Results copied to clipboard", "ru": "Результаты скопированы в буфер обмена" },
            "shareText": { "en": "I solved the {puzzle} in {time} with {moves} moves! My score: {score}", "ru": "Я решил {puzzle} за {time} и {moves} ходов! Мой счёт: {score}" },
            "moves": { "en": "Moves", "ru": "Ходы" },
            "confirmExit": { "en": "Confirm Exit", "ru": "Подтвердите выход" },
            "saveGame": { "en": "Save Game", "ru": "Сохранить игру" },
            "enterSaveName": { "en": "Enter save name", "ru": "Введите имя сохранения" },
            "save": { "en": "Save and exit", "ru": "Сохранить и выйти" }
        })
        function t(key) {
            return texts[key][isEnglish ? "en" : "ru"] || key
        }
    }

    MainMenu {
        visible: showMainMenu
        anchors.fill: parent
        isEnglish: root.isEnglish
        themeIndex: root.themeIndex

        onStartGame: function(dimension) {
            showMainMenu = false
            currentDimension = dimension
            restartGame()
        }
    }

    Item {
        id: gameUI
        anchors.fill: parent
        visible: !showMainMenu

        Rectangle {
            id: timeCounter
            width: parent.width * 0.12
            height: parent.height * 0.10
            radius: height / 4
            color: theme.counterBackgroundColor
            border { color: theme.tileBorderColor; width: 2 }
            anchors {
                top: gameBoardBackground.top
                left: parent.left
                leftMargin: (root.width - (gameBoardBackground.width + width * 2.05 + gameBoardBackground.minMargin * 4)) / 2
            }
            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 3
                verticalOffset: 3
                radius: 8
                samples: 16
                color: "#66000000"
            }

            Row {
                anchors.centerIn: parent
                spacing: parent.width * 0.1

                Image {
                    id: timerIcon
                    source: themeIndex === 0 ? "qrc:/Img/Icons/timerIcons/timerPlayLight.svg" :
                            themeIndex === 1 ? "qrc:/Img/Icons/timerIcons/timerPlayDark.svg" :
                                              "qrc:/Img/Icons/timerIcons/timerPlayColorful.svg"
                    width: parent.height * 0.7
                    height: width
                    smooth: true
                    mipmap: true
                    anchors.verticalCenter: parent.verticalCenter
                    fillMode: Image.PreserveAspectFit

                    ColorOverlay {
                        anchors.fill: parent
                        source: parent
                        color: themeIndex === 2 ? theme.timerCounterTextColor : "transparent"
                        visible: themeIndex === 2
                    }
                }

                Rectangle {
                    width: 1
                    height: timerIcon.height
                    color: theme.tileBorderColor
                    anchors.verticalCenter: parent.verticalCenter
                }

                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 1

                    Text {
                        text: translations.t("time")
                        color: theme.timerCounterTextColor
                        font { family: "Source Sans Pro"; pixelSize: timeCounter.height * 0.35 }
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        text: formatTime(elapsedTime)
                        color: theme.timerCounterTextColor
                        font { family: "Source Sans Pro"; pixelSize: timeCounter.height * 0.35 }
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }
        }

        Rectangle {
            id: moveCounter
            width: timeCounter.width
            height: timeCounter.height
            radius: timeCounter.radius
            color: theme.counterBackgroundColor
            border { color: theme.tileBorderColor; width: 2 }
            anchors {
                top: timeCounter.top
                left: timeCounter.right
                leftMargin: timeCounter.width * 0.05
            }
            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 3
                verticalOffset: 3
                radius: 8
                samples: 16
                color: "#66000000"
            }

            Row {
                anchors.centerIn: parent
                spacing: parent.width * 0.1

                Image {
                    id: stepsIcon
                    source: themeIndex === 0 ? "qrc:/Img/Icons/stepsIcons/stepsLight.svg" :
                            themeIndex === 1 ? "qrc:/Img/Icons/stepsIcons/stepsDark.svg" :
                                              "qrc:/Img/Icons/stepsIcons/stepsColorful.svg"
                    width: parent.height * 0.7
                    height: width
                    smooth: true
                    mipmap: true
                    anchors.verticalCenter: parent.verticalCenter
                    fillMode: Image.PreserveAspectFit

                    ColorOverlay {
                        anchors.fill: parent
                        source: parent
                        color: themeIndex === 2 ? theme.moveCounterTextColor : "transparent"
                        visible: themeIndex === 2
                    }
                }

                Rectangle {
                    width: 1
                    height: stepsIcon.height
                    color: theme.tileBorderColor
                    anchors.verticalCenter: parent.verticalCenter
                }

                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 1

                    Text {
                        text: translations.t("steps")
                        color: theme.moveCounterTextColor
                        font { family: "Source Sans Pro"; pixelSize: moveCounter.height * 0.35 }
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        text: displayCounter
                        color: theme.moveCounterTextColor
                        font { family: "Source Sans Pro"; pixelSize: moveCounter.height * 0.35 }
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }
        }

        Rectangle {
            id: scorePanel
            width: gameUI.width * 0.12
            height: gameUI.height * 0.06
            radius: 0
            color: "transparent"
            border.width: 0

            anchors {
                top: gameUI.top
                right: gameUI.right
            }

            Canvas {
                id: borderCanvas
                anchors.fill: parent
                antialiasing: true
                renderTarget: Canvas.FramebufferObject
                renderStrategy: Canvas.Cooperative

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();

                    ctx.lineWidth = 1.5;
                    ctx.strokeStyle = theme.highlightColor;

                    ctx.beginPath();
                    ctx.moveTo(0, 0);
                    ctx.lineTo(0, height - 16);
                    ctx.arc(16, height - 16, 16, Math.PI, Math.PI/2, true);
                    ctx.lineTo(width, height);
                    ctx.stroke();
                }
            }

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 1
                verticalOffset: 1
                radius: 6
                samples: 17
                color: "#40000000"
            }

            Rectangle {
                id: glowBase
                anchors.fill: parent
                radius: 0
                color: "transparent"
                z: -1

                layer.enabled: true
                layer.effect: Glow {
                    radius: 8
                    samples: 16
                    color: Qt.rgba(theme.highlightColor.r, theme.highlightColor.g, theme.highlightColor.b, 0.5)
                    spread: 0.2
                }
            }

            Rectangle {
                id: contentRect
                anchors.fill: parent
                color: "transparent"
                border.width: 0

                Row {
                    anchors.centerIn: parent
                    spacing: parent.width * 0.04

                    Image {
                        id: scoreIcon
                        source: themeIndex === 0 ? "qrc:/Img/Icons/scoreIcons/scoreLight.svg" :
                                themeIndex === 1 ? "qrc:/Img/Icons/scoreIcons/scoreDark.svg" :
                                                  "qrc:/Img/Icons/scoreIcons/scoreDark.svg"
                        width: scorePanel.height * 0.7
                        height: width
                        smooth: true
                        mipmap: true
                        anchors.verticalCenter: parent.verticalCenter
                        fillMode: Image.PreserveAspectFit

                        ColorOverlay {
                            anchors.fill: parent
                            source: parent
                            color: theme.highlightColor
                        }
                    }

                    Rectangle {
                        width: 1
                        height: scoreIcon.height * 0.8
                        color: Qt.rgba(theme.tileBorderColor.r, theme.tileBorderColor.g, theme.tileBorderColor.b, 0.4)
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Row {
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: scorePanel.width * 0.03

                        Text {
                            id: scoreLabel
                            text: translations.t("score") + ":"
                            color: theme.counterTextColor
                            font { family: "Source Sans Pro"; pixelSize: scorePanel.height * 0.4; letterSpacing: 0.5 }
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            id: scoreValueText
                            text: scoreManager ? scoreManager.currentScore : "10000"
                            color: "#FFFFFF"
                            font { family: "Source Sans Pro"; pixelSize: scorePanel.height * 0.45 }
                            anchors.verticalCenter: parent.verticalCenter

                            layer.enabled: true
                            layer.effect: Glow {
                                radius: 3
                                samples: 7
                                color: Qt.rgba(theme.highlightColor.r, theme.highlightColor.g, theme.highlightColor.b, 0.7)
                                spread: 0.2
                            }

                            Behavior on text {
                                SequentialAnimation {
                                    NumberAnimation { target: scoreValueText; property: "scale"; to: 1.25; duration: 150; easing.type: Easing.OutBack }
                                    NumberAnimation { target: scoreValueText; property: "scale"; to: 1.0; duration: 200; easing.type: Easing.OutElastic; easing.amplitude: 1.2; easing.period: 0.5 }
                                }
                            }
                        }
                    }
                }
            }

            Component.onCompleted: {
                borderCanvas.requestPaint()
                if (scoreManager) {
                    scoreManager.resetScore();
                }
            }
        }

        Connections {
            target: gameBoard
            function onCounterChanged() {
                displayCounter = gameBoard.counter
                if (!timerRunning && displayCounter > 0) timerRunning = true
                if (scoreManager && displayCounter > 0) {
                    scoreManager.calculateScore(elapsedTime, displayCounter);
                }
            }
            function onGameWon() {
                isGameWon = true
                timerRunning = false
                showWinDialog()
            }
            function onMoveMade() {
                if (scoreManager) {
                    scoreManager.calculateScore(elapsedTime, displayCounter);
                }
            }
        }
        Rectangle {
            id: pauseButton
            width: timeCounter.width * 2.05
            height: timeCounter.height
            radius: timeCounter.radius
            color: theme.pauseButtonBackgroundColor
            border {
                color: pauseArea.containsMouse ? theme.accentColor : theme.pauseButtonBorderColor
                width: 2
            }
            anchors {
                top: timeCounter.bottom
                topMargin: gameBoardBackground.height - 7.2 * height
                left: timeCounter.left
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
                id: pauseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    root.isPaused = !root.isPaused
                    timerRunning = !isPaused && !isGameWon && displayCounter > 0
                }
            }

            Rectangle {
                id: pauseGlow
                anchors.fill: parent
                radius: parent.radius
                color: "transparent"
                opacity: pauseArea.containsMouse ? 1 : 0

                layer.enabled: pauseArea.containsMouse
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
                    id: pauseIcon
                    source: themeIndex === 0 ?
                            (root.isPaused ? "qrc:/Img/Icons/pauseIcons/playLight.svg" : "qrc:/Img/Icons/pauseIcons/pauseLight.svg") :
                            themeIndex === 1 ?
                            (root.isPaused ? "qrc:/Img/Icons/pauseIcons/playDark.svg" : "qrc:/Img/Icons/pauseIcons/pauseDark.svg") :
                            (root.isPaused ? "qrc:/Img/Icons/pauseIcons/playDark.svg" : "qrc:/Img/Icons/pauseIcons/pauseDark.svg")
                    width: pauseButton.height * 0.6
                    height: width
                    anchors {
                        left: parent.left
                        leftMargin: pauseButton.width * 0.15
                        verticalCenter: parent.verticalCenter
                    }
                    smooth: true
                    mipmap: true
                    fillMode: Image.PreserveAspectFit

                    ColorOverlay {
                        anchors.fill: parent
                        source: parent
                        color: pauseArea.containsMouse ? theme.pauseButtonBorderColor : themeIndex === 0 ? "#242424" : "#FFFFFF"
                        opacity: 1

                        Behavior on color {
                            ColorAnimation { duration: 200; easing.type: Easing.OutCubic }
                        }
                    }
                }

                Text {
                    id: pauseText
                    text: root.isPaused ? translations.t("resume") : translations.t("pause")
                    color: pauseArea.containsMouse ? theme.pauseButtonBorderColor : themeIndex === 0 ? "#242424" : "#FFFFFF"
                    font {
                        family: "Source Sans Pro"
                        pixelSize: pauseArea.containsMouse ? pauseButton.height * 0.38 : pauseButton.height * 0.35
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
                id: pauseScale
                origin.x: pauseButton.width/2
                origin.y: pauseButton.height/2
                xScale: pauseArea.containsMouse ? 0.98 : 1.0
                yScale: pauseArea.containsMouse ? 0.98 : 1.0

                Behavior on xScale {
                    NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
                }
                Behavior on yScale {
                    NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
                }
            }

            Component.onCompleted: {
                var pauseComponent = Qt.createComponent("Pause.qml");
                if (pauseComponent.status === Component.Ready) {
                    var pauseObject = pauseComponent.createObject(root);
                }
            }
        }

        Rectangle {
            id: restartButton
            width: timeCounter.width * 2.05
            height: timeCounter.height
            radius: timeCounter.radius
            color: theme.restartButtonBackgroundColor
            border {
                color: restartArea.containsMouse ? theme.accentColor : theme.restartButtonBorderColor
                width: 2
            }
            anchors {
                top: pauseButton.bottom
                topMargin: height * 0.3
                left: timeCounter.left
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
                id: restartArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    root.restartGame()
                }
            }

            Rectangle {
                id: restartGlow
                anchors.fill: parent
                radius: parent.radius
                color: "transparent"
                opacity: restartArea.containsMouse ? 1 : 0

                layer.enabled: restartArea.containsMouse
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
                    id: restartIcon
                    source: themeIndex === 0 ? "qrc:/Img/Icons/restartIcons/restartLight.svg" :
                            themeIndex === 1 ? "qrc:/Img/Icons/restartIcons/restartDark.svg" :
                                            "qrc:/Img/Icons/restartIcons/restartDark.svg"
                    width: restartButton.height * 0.6
                    height: width
                    anchors {
                        left: parent.left
                        leftMargin: restartButton.width * 0.15
                        verticalCenter: parent.verticalCenter
                    }
                    smooth: true
                    mipmap: true
                    fillMode: Image.PreserveAspectFit

                    ColorOverlay {
                        anchors.fill: parent
                        source: parent
                        color: restartArea.containsMouse ? theme.restartButtonBorderColor : themeIndex === 0 ? "#242424" : "#FFFFFF"
                        opacity: 1

                        Behavior on color {
                            ColorAnimation { duration: 200; easing.type: Easing.OutCubic }
                        }
                    }

                    Behavior on rotation {
                        NumberAnimation { duration: 250; easing.type: Easing.OutBack }
                    }

                    rotation: restartArea.containsMouse ? -90 : 0
                }

                Text {
                    id: restartText
                    text: translations.t("restart")
                    color: restartArea.containsMouse ? theme.restartButtonBorderColor : themeIndex === 0 ? "#242424" : "#FFFFFF"
                    font {
                        family: "Source Sans Pro"
                        pixelSize: restartArea.containsMouse ? restartButton.height * 0.38 : restartButton.height * 0.35
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
                id: restartScale
                origin.x: restartButton.width/2
                origin.y: restartButton.height/2
                xScale: restartArea.containsMouse ? 0.98 : 1.0
                yScale: restartArea.containsMouse ? 0.98 : 1.0

                Behavior on xScale {
                    NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
                }
                Behavior on yScale {
                    NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
                }
            }
        }

        Rectangle {
            id: settingsButton
            width: timeCounter.width * 2.05
            height: timeCounter.height
            radius: timeCounter.radius
            color: theme.settingsButtonBackgroundColor
            border {
                color: settingsArea.containsMouse ? theme.accentColor : theme.settingsButtonBorderColor
                width: 2
            }
            anchors {
                top: restartButton.bottom
                topMargin: height * 0.3
                left: timeCounter.left
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

            property bool backgroundMusicEnabled: settingsStore.value("backgroundMusic", true)
            property int volume: settingsStore.value("volume", 75)
            property string selectedMusic: settingsStore.value("selectedMusic", "Relaxing")
            property var audioController

            Component.onCompleted: {
                initializeAudio()
            }

            function initializeAudio() {
                if (backgroundMusicEnabled && audioController) {
                    var musicPath = ""
                    if (selectedMusic === "Classic") {
                        musicPath = "qrc:/Sounds/soundIntellect.mp3"
                    } else if (selectedMusic === "Energetic") {
                        musicPath = "qrc:/Sounds/N_Puzzle!Music.mp3"
                    } else if (selectedMusic === "Relaxing") {
                        musicPath = "qrc:/Sounds/focus.mp3"
                    }

                    audioController.stop()
                    audioController.setLooping(true)
                    audioController.playSound(musicPath)
                    audioController.setVolume(volume / 100.0)
                }
            }

            MouseArea {
                id: settingsArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    var component = Qt.createComponent("Settings.qml")
                    if (component.status === Component.Ready) {
                        var settingsWindow = component.createObject(root, {
                            "themeIndex": root.themeIndex,
                            "isEnglish": root.isEnglish,
                            "backgroundMusicEnabled": settingsButton.backgroundMusicEnabled,
                            "volume": settingsButton.volume,
                            "selectedMusic": settingsButton.selectedMusic,
                            "audioController": settingsButton.audioController
                        })

                        settingsWindow.themeChanged.connect(function(newTheme) {
                            root.themeIndex = newTheme
                            settingsStore.setValue("theme", newTheme)
                        })

                        settingsWindow.languageChanged.connect(function(newIsEnglish) {
                            root.isEnglish = newIsEnglish
                            settingsStore.setValue("language", newIsEnglish)
                        })

                        settingsWindow.settingsValueChanged.connect(function() {
                            settingsButton.backgroundMusicEnabled = settingsWindow.backgroundMusicEnabled
                            settingsButton.volume = settingsWindow.volume
                            settingsButton.selectedMusic = settingsWindow.selectedMusic

                            if (settingsButton.backgroundMusicEnabled && settingsButton.audioController) {
                                settingsButton.audioController.setVolume(settingsButton.volume / 100.0)

                                var musicPath = ""
                                if (settingsButton.selectedMusic === "Classic") {
                                    musicPath = "qrc:/Sounds/soundIntellect.mp3"
                                } else if (settingsButton.selectedMusic === "Energetic") {
                                    musicPath = "qrc:/Sounds/N_Puzzle!Music.mp3"
                                } else if (settingsButton.selectedMusic === "Relaxing") {
                                    musicPath = "qrc:/Sounds/focus.mp3"
                                }
                                settingsButton.audioController.stop()
                                settingsButton.audioController.setLooping(true)
                                settingsButton.audioController.playSound(musicPath)
                            } else if (settingsButton.audioController) {
                                settingsButton.audioController.stop()
                            }
                        })

                        settingsWindow.applySettings.connect(function() {
                            settingsButton.backgroundMusicEnabled = settingsWindow.backgroundMusicEnabled
                            settingsButton.volume = settingsWindow.volume
                            settingsButton.selectedMusic = settingsWindow.selectedMusic
                            settingsStore.setValue("backgroundMusic", settingsButton.backgroundMusicEnabled)
                            settingsStore.setValue("volume", settingsButton.volume)
                            settingsStore.setValue("selectedMusic", settingsButton.selectedMusic)

                            if (settingsButton.backgroundMusicEnabled && settingsButton.audioController) {
                                var musicPath = ""
                                if (settingsButton.selectedMusic === "Classic") {
                                    musicPath = "qrc:/Sounds/soundIntellect.mp3"
                                } else if (settingsButton.selectedMusic === "Energetic") {
                                    musicPath = "qrc:/Sounds/N_Puzzle!Music.mp3"
                                } else if (settingsButton.selectedMusic === "Relaxing") {
                                    musicPath = "qrc:/Sounds/focus.mp3"
                                }
                                settingsButton.audioController.stop()
                                settingsButton.audioController.setLooping(true)
                                settingsButton.audioController.playSound(musicPath)
                                settingsButton.audioController.setVolume(settingsButton.volume / 100.0)
                            } else if (settingsButton.audioController) {
                                settingsButton.audioController.stop()
                            }
                        })

                        settingsWindow.visible = true
                    }
                }
            }

            Rectangle {
                id: settingsGlow
                anchors.fill: parent
                radius: parent.radius
                color: "transparent"
                opacity: settingsArea.containsMouse ? 1 : 0

                layer.enabled: settingsArea.containsMouse
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
                    id: settingsIcon
                    source: themeIndex === 0 ? "qrc:/Img/Icons/settingsIcon/settingsLight.svg" :
                            themeIndex === 1 ? "qrc:/Img/Icons/settingsIcon/settingsDark.svg" :
                                            "qrc:/Img/Icons/settingsIcon/settingsDark.svg"
                    width: settingsButton.height * 0.6
                    height: width
                    anchors {
                        left: parent.left
                        leftMargin: settingsButton.width * 0.15
                        verticalCenter: parent.verticalCenter
                    }
                    smooth: true
                    mipmap: true
                    fillMode: Image.PreserveAspectFit

                    ColorOverlay {
                        anchors.fill: parent
                        source: parent
                        color: settingsArea.containsMouse ? theme.settingsButtonBorderColor : themeIndex === 0 ? "#242424" : "#FFFFFF"
                        opacity: 1

                        Behavior on color {
                            ColorAnimation { duration: 200; easing.type: Easing.OutCubic }
                        }
                    }

                    Behavior on rotation {
                        NumberAnimation { duration: 250; easing.type: Easing.OutBack }
                    }

                    rotation: settingsArea.containsMouse ? -90 : 0
                }

                Text {
                    id: settingsText
                    text: translations.t("settings")
                    color: settingsArea.containsMouse ? theme.settingsButtonBorderColor : themeIndex === 0 ? "#242424" : "#FFFFFF"
                    font {
                        family: "Source Sans Pro"
                        pixelSize: settingsArea.containsMouse ? settingsButton.height * 0.38 : settingsButton.height * 0.35
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
                id: settingsScale
                origin.x: settingsButton.width/2
                origin.y: settingsButton.height/2
                xScale: settingsArea.containsMouse ? 0.98 : 1.0
                yScale: settingsArea.containsMouse ? 0.98 : 1.0

                Behavior on xScale {
                    NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
                }
                Behavior on yScale {
                    NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
                }
            }
        }

        Rectangle {
            id: aboutButton
            width: timeCounter.width * 2.05
            height: timeCounter.height
            radius: timeCounter.radius
            color: theme.buttonBackgroundColor
            border {
                color: aboutArea.containsMouse ? theme.accentColor : theme.aboutGameButtonBorderColor
                width: 2
            }
            anchors {
                top: settingsButton.bottom
                topMargin: height * 0.3
                left: timeCounter.left
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
                id: aboutArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    var component = Qt.createComponent("AboutGame.qml")
                    if (component.status === Component.Ready) {
                        var aboutWindow = component.createObject(root, {
                            "themeIndex": root.themeIndex,
                            "isEnglish": root.isEnglish
                        })
                        aboutWindow.visible = true
                    }
                }
            }

            Rectangle {
                id: aboutGlow
                anchors.fill: parent
                radius: parent.radius
                color: "transparent"
                opacity: aboutArea.containsMouse ? 1 : 0

                layer.enabled: aboutArea.containsMouse
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
                    id: aboutIcon
                    source: themeIndex === 0 ? "qrc:/Img/Icons/aboutGameIcons/aboutgameLight.svg" :
                            themeIndex === 1 ? "qrc:/Img/Icons/aboutGameIcons/aboutGameDark.svg" :
                                            "qrc:/Img/Icons/aboutGameIcons/aboutGameDark.svg"
                    width: aboutButton.height * 0.6
                    height: width
                    anchors {
                        left: parent.left
                        leftMargin: aboutButton.width * 0.15
                        verticalCenter: parent.verticalCenter
                    }
                    smooth: true
                    mipmap: true
                    fillMode: Image.PreserveAspectFit

                    ColorOverlay {
                        anchors.fill: parent
                        source: parent
                        color: aboutArea.containsMouse ? theme.aboutGameButtonBorderColor : themeIndex === 0 ? "#242424" : "#FFFFFF"
                        opacity: 1

                        Behavior on color {
                            ColorAnimation { duration: 200; easing.type: Easing.OutCubic }
                        }
                    }
                }

                Text {
                    id: aboutText
                    text: translations.t("about")
                    color: aboutArea.containsMouse ? theme.aboutGameButtonBorderColor : themeIndex === 0 ? "#242424" : "#FFFFFF"
                    font {
                        family: "Source Sans Pro"
                        pixelSize: aboutArea.containsMouse ? aboutButton.height * 0.34 : aboutButton.height * 0.3
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
                id: aboutScale
                origin.x: aboutButton.width/2
                origin.y: aboutButton.height/2
                xScale: aboutArea.containsMouse ? 0.98 : 1.0
                yScale: aboutArea.containsMouse ? 0.98 : 1.0

                Behavior on xScale {
                    NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
                }
                Behavior on yScale {
                    NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
                }
            }
        }

        Rectangle {
            id: mainMenuButton
            width: timeCounter.width * 2.05
            height: timeCounter.height
            radius: timeCounter.radius
            color: theme.menuButtonBackgroundColor
            border {
                color: mainMenuArea.containsMouse ? theme.accentColor : theme.menuButtonBorderColor
                width: 2
            }
            anchors {
                top: aboutButton.bottom
                topMargin: height * 0.3
                left: timeCounter.left
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
                id: mainMenuArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    showMainMenu = true
                    isPaused = true
                    timerRunning = false
                }
            }

            Rectangle {
                id: mainMenuGlow
                anchors.fill: parent
                radius: parent.radius
                color: "transparent"
                opacity: mainMenuArea.containsMouse ? 1 : 0

                layer.enabled: mainMenuArea.containsMouse
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
                    id: menuIcon
                    source: themeIndex === 0 ? "qrc:/Img/Icons/menuIcons/menuLight.svg" :
                            themeIndex === 1 ? "qrc:/Img/Icons/menuIcons/menuDark.svg" :
                                            "qrc:/Img/Icons/menuIcons/menuDark.svg"
                    width: mainMenuButton.height * 0.6
                    height: width
                    anchors {
                        left: parent.left
                        leftMargin: mainMenuButton.width * 0.15
                        verticalCenter: parent.verticalCenter
                    }
                    smooth: true
                    mipmap: true
                    fillMode: Image.PreserveAspectFit

                    ColorOverlay {
                        anchors.fill: parent
                        source: parent
                        color: mainMenuArea.containsMouse ? theme.menuButtonBorderColor : themeIndex === 0 ? "#242424" : "#FFFFFF"
                        opacity: 1

                        Behavior on color {
                            ColorAnimation { duration: 200; easing.type: Easing.OutCubic }
                        }
                    }
                }

                Text {
                    id: menuText
                    text: translations.t("mainMenu")
                    color: mainMenuArea.containsMouse ? theme.menuButtonBorderColor : themeIndex === 0 ? "#242424" : "#FFFFFF"
                    font {
                        family: "Source Sans Pro"
                        pixelSize: mainMenuArea.containsMouse ? mainMenuButton.height * 0.38 : mainMenuButton.height * 0.35
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
                id: mainMenuScale
                origin.x: mainMenuButton.width/2
                origin.y: mainMenuButton.height/2
                xScale: mainMenuArea.containsMouse ? 0.98 : 1.0
                yScale: mainMenuArea.containsMouse ? 0.98 : 1.0

                Behavior on xScale {
                    NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
                }
                Behavior on yScale {
                    NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
                }
            }
        }
        Rectangle {
            id: gameBoardBackground
            property real minMargin: Math.min(root.width, root.height) * 0.05
            property real boardSize: Math.min(root.width * 0.65, root.height - (2 * minMargin))
            width: boardSize
            height: width
            radius: width * 0.22 / (root.currentDimension+1)
            anchors {
                top: parent.top
                bottom: parent.bottom
                right: parent.right
                topMargin: minMargin * 2
                bottomMargin: minMargin
                rightMargin: minMargin * 4
            }

            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.lighter(theme.gameBoardBackgroundColor, 1.1) }
                GradientStop { position: 1.0; color: Qt.darker(theme.gameBoardBackgroundColor, 1.2) }
            }

            border {
                width: 2
                color: Qt.darker(theme.tileBorderColor, 1.1)
            }

            onWidthChanged: height = width
            onHeightChanged: width = height

            Rectangle {
                id: innerBevel
                anchors.fill: parent
                anchors.margins: 3
                radius: parent.radius - 3
                color: "transparent"
                border {
                    width: 1
                    color: Qt.lighter(theme.tileBorderColor, 1.3)
                }
            }

            Rectangle {
                id: boardInset
                anchors.fill: parent
                anchors.margins: 12
                radius: parent.radius - 6
                color: Qt.darker(theme.gameBoardBackgroundColor, 1.05)

                layer.enabled: true
                layer.effect: InnerShadow {
                    horizontalOffset: 2
                    verticalOffset: 2
                    radius: 6
                    samples: 16
                    color: Qt.rgba(0, 0, 0, 0.25)
                }
            }

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 6
                verticalOffset: 6
                radius: 12
                samples: 16
                color: Qt.rgba(0, 0, 0, 0.35)
            }

            GameBoard {
                id: gameBoard
                visible: !showMainMenu
                anchors.centerIn: boardInset
                width: boardSize
                height: boardSize
                themeIndex: root.themeIndex
                currentDimension: root.currentDimension
                onGameWon: {
                    isGameWon = true
                    timerRunning = false
                    showWinDialog()
                }
                onCountChanged: function(count) {
                    displayCounter = count
                }
                onMoveMade: {
                    if (!timerRunning) {
                        timerRunning = true
                    }
                }
            }
        }

        WinDialog {
            id: winDialog
            visible: false
            elapsedTime: root.elapsedTime * 1000
            displayCounter: root.displayCounter
            gameTitle: "15 Puzzle " + currentDimension + "x" + currentDimension
            finalScore: root.scoreManager.currentScore
            onRestartGameRequested: {
                restartGame()
            }
        }

        Loader {
            id: settingsLoader
            source: "Settings.qml"
            active: false
        }

        Dialog {
            id: settingsDialog
            modal: true
            anchors.centerIn: parent

            onOpened: {
                settingsLoader.active = true
                settingsLoader.item.themeIndex = root.themeIndex
                settingsLoader.item.isEnglish = root.isEnglish
            }

            onClosed: {
                settingsLoader.active = false
            }

            background: Rectangle {
                color: theme.counterBackgroundColor
                radius: 10
                border { color: theme.tileBorderColor; width: 2 }
            }

            contentItem: Item {
                implicitWidth: 400
                implicitHeight: 300

                Loader {
                    anchors.fill: parent
                    sourceComponent: settingsLoader.item
                }
            }
        }
    }

    function restartGame() {
        displayCounter = 0
        elapsedTime = 0
        timerRunning = false
        isGameWon = false
        isPaused = false
        scoreManager.resetScore()
        if (gameBoard) {
            gameBoard.initializeBoard()
            gameBoard.resetCounter()
            gameBoard.lastMovedIndex = -1
            gameBoard.model.resetBoard()
        }
    }

    function formatTime(seconds) {
        var minutes = Math.floor(seconds / 60)
        var secs = seconds % 60
        return minutes + ":" + (secs < 10 ? "0" + secs : secs)
    }

    function showWinDialog() {
        if (scoreManager) {
            var finalScore = scoreManager.calculateScore(elapsedTime, displayCounter)
            scoreManager.setCurrentScore(finalScore)
            winDialog.finalScore = finalScore
        }
        winDialog.x = (root.width - winDialog.width) / 2
        winDialog.y = (root.height - winDialog.height) / 2
        winDialog.open()
    }
}
