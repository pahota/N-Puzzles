import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import Qt5Compat.GraphicalEffects
import Qt.labs.settings 1.0
import QtMultimedia 5.15
import AudioComponents 1.0

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
        onTriggered: elapsedTime++
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
            "resume": { "en": "Resume", "ru": "Продолжить" },
            "pause": { "en": "Pause", "ru": "Пауза" },
            "restart": { "en": "Restart", "ru": "Рестарт" },
            "settings": { "en": "Settings", "ru": "Настройки" },
            "congratulations": { "en": "Congratulations!", "ru": "Поздравляем!" },
            "puzzleSolved": { "en": "Puzzle Solved!", "ru": "Головоломка решена!" },
            "timeLabel": { "en": "Time: ", "ru": "Время: " },
            "movesLabel": { "en": "Moves: ", "ru": "Ходы: " },
            "playAgain": { "en": "Play Again", "ru": "Играть снова" },
            "about": { "en": "About Game", "ru": "Об игре" },
            "close": { "en": "Close", "ru": "Закрыть" },
            "mainMenu": { "en": "Main Menu", "ru": "Главное меню" },
            "gamePaused": { "en": "Game Paused", "ru": "Игра приостановлена" },
            "continueGame": { "en": "Continue Game", "ru": "Продолжить игру" },
            "restartLevel": { "en": "Restart Level", "ru": "Начать заново" },
            "mainMenu": { "en": "Main Menu", "ru": "Главное меню" },
            "confirmExit": { "en": "Confirm Exit", "ru": "Подтвердите выход" },
            "exitConfirmationMessage": { "en": "Are you sure you want to exit to the main menu? Your progress in this level will be lost.", "ru": "Вы уверены, что хотите выйти в главное меню? Прогресс на данном уровне будет потерян." },
            "cancel": { "en": "Cancel", "ru": "Отмена" },
            "exit": { "en": "Exit", "ru": "Выйти" }
        })
        function t(key) {
            return texts[key][isEnglish ? "en" : "ru"]
        }
    }

    MainMenu {
        visible: showMainMenu
        anchors.fill: parent
        isEnglish: root.isEnglish
        themeIndex: root.themeIndex

        onPlayClicked: {
            showMainMenu = false
            restartGame()
        }
    }

    Item {
        id: gameUI
        anchors.fill: parent
        visible: !showMainMenu

        Rectangle {
            id: timeCounter
            width: parent.width * 0.15
            height: parent.height * 0.10
            radius: height / 4
            color: theme.counterBackgroundColor
            border { color: theme.tileBorderColor; width: 2 }
            anchors {
                top: parent.top
                left: parent.left
                topMargin: gameBoardBackground.minMargin
                leftMargin: (root.width - (gameBoardBackground.boardSize + width * 2.1 + gameBoardBackground.minMargin * 2)) / 2
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
                leftMargin: timeCounter.width * 0.1
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
            id: pauseButton
            width: timeCounter.width * 2.1
            height: timeCounter.height
            radius: timeCounter.radius
            color: theme.counterBackgroundColor
            border { color: theme.tileBorderColor; width: 2 }
            anchors {
                top: moveCounter.bottom
                topMargin: height * 0.2
                left: timeCounter.left
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
            MouseArea {
                id: pauseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    root.isPaused = !root.isPaused
                    timerRunning = !isPaused && !isGameWon && displayCounter > 0
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
                }
                Text {
                    id: pauseText
                    text: root.isPaused ? translations.t("resume") : translations.t("pause")
                    color: theme.counterTextColor
                    font { family: "Source Sans Pro"; pixelSize: pauseButton.height * 0.35 }
                    anchors.centerIn: parent
                }
            }
            states: State {
                name: "hovered"
                when: pauseArea.containsMouse
                PropertyChanges { target: pauseButton; scale: 0.98 }
                PropertyChanges { target: pauseText; color: theme.highlightColor }
            }
            transitions: Transition {
                from: ""; to: "hovered"; reversible: true
                ParallelAnimation {
                    NumberAnimation { properties: "scale"; duration: 200 }
                    ColorAnimation { properties: "color"; duration: 200 }
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
            width: timeCounter.width * 2.1
            height: timeCounter.height
            radius: timeCounter.radius
            color: theme.counterBackgroundColor
            border { color: theme.tileBorderColor; width: 2 }
            anchors {
                top: pauseButton.bottom
                topMargin: height * 0.2
                left: timeCounter.left
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

            MouseArea {
                id: restartArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    root.restartGame()
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
                }

                Text {
                    id: restartText
                    text: translations.t("restart")
                    color: theme.counterTextColor
                    font { family: "Source Sans Pro"; pixelSize: restartButton.height * 0.35 }
                    anchors.centerIn: parent
                }
            }

            states: State {
                name: "hovered"
                when: restartArea.containsMouse
                PropertyChanges { target: restartButton; scale: 0.98 }
                PropertyChanges { target: restartText; color: theme.highlightColor }
                PropertyChanges { target: restartIcon; rotation: -90 }
            }

            transitions: Transition {
                from: ""; to: "hovered"; reversible: true
                ParallelAnimation {
                    NumberAnimation { properties: "scale"; duration: 200 }
                    ColorAnimation { properties: "color"; duration: 200 }
                    NumberAnimation { properties: "rotation"; duration: 200 }
                }
            }
        }

        Rectangle {
            id: settingsButton
            width: timeCounter.width * 2.1
            height: timeCounter.height
            radius: timeCounter.radius
            color: theme.counterBackgroundColor
            border { color: theme.tileBorderColor; width: 2 }
            anchors {
                top: restartButton.bottom
                topMargin: height * 0.2
                left: timeCounter.left
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

            property bool backgroundMusicEnabled: true
            property int volume: 75
            property string selectedMusic: "Relaxing"
            property var audioController

            Component.onCompleted: {
                initializeAudio()
            }

            function initializeAudio() {
                if (backgroundMusicEnabled && audioController) {
                    var musicPath = ""
                    if (selectedMusic === "Relaxing") {
                        musicPath = "qrc:/Sounds/soundIntellect.mp3"
                    } else if (selectedMusic === "Energetic") {
                        musicPath = "qrc:/Sounds/soundIntellect.mp3"
                    } else if (selectedMusic === "Classic") {
                        musicPath = "qrc:/Sounds/soundIntellect.mp3"
                    }

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
                            "isEnglish": root.isEnglish
                        })
                        settingsWindow.onThemeChanged.connect(function(newTheme) {
                            root.themeIndex = newTheme
                            settingsStore.setValue("theme", newTheme)
                        })
                        settingsWindow.onLanguageChanged.connect(function(newIsEnglish) {
                            root.isEnglish = newIsEnglish
                            settingsStore.setValue("language", newIsEnglish)
                        })

                        if (settingsWindow.hasOwnProperty("backgroundMusicEnabled")) {
                            settingsWindow.backgroundMusicEnabled = backgroundMusicEnabled
                            settingsWindow.volume = volume
                            settingsWindow.selectedMusic = selectedMusic
                            settingsWindow.audioController = audioController

                            if (settingsWindow.hasOwnProperty("applySettings")) {
                                settingsWindow.applySettings.connect(function() {
                                    backgroundMusicEnabled = settingsWindow.backgroundMusicEnabled
                                    volume = settingsWindow.volume
                                    selectedMusic = settingsWindow.selectedMusic
                                    settingsStore.setValue("backgroundMusic", backgroundMusicEnabled)
                                    settingsStore.setValue("volume", volume)
                                    settingsStore.setValue("selectedMusic", selectedMusic)

                                    if (backgroundMusicEnabled && audioController) {
                                        var musicPath = ""
                                        if (selectedMusic === "Relaxing") {
                                            musicPath = "qrc:/Sounds/soundIntellect.mp3"
                                        } else if (selectedMusic === "Energetic") {
                                            musicPath = "qrc:/Sounds/soundIntellect.mp3"
                                        } else if (selectedMusic === "Classic") {
                                            musicPath = "qrc:/Sounds/soundIntellect.mp3"
                                        }

                                        audioController.playSound(musicPath)
                                        audioController.setVolume(volume / 100.0)
                                    } else if (audioController) {
                                        audioController.stop()
                                    }
                                })
                            }
                        }

                        settingsWindow.visible = true
                    }
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
                }

                Text {
                    id: settingsText
                    text: translations.t("settings")
                    color: theme.counterTextColor
                    font { family: "Source Sans Pro"; pixelSize: settingsButton.height * 0.35 }
                    anchors.centerIn: parent
                }
            }

            states: State {
                name: "hovered"
                when: settingsArea.containsMouse
                PropertyChanges { target: settingsButton; scale: 0.98 }
                PropertyChanges { target: settingsText; color: theme.highlightColor }
                PropertyChanges { target: settingsIcon; rotation: -90 }
            }

            transitions: Transition {
                from: ""; to: "hovered"; reversible: true
                ParallelAnimation {
                    NumberAnimation { properties: "scale"; duration: 200 }
                    ColorAnimation { properties: "color"; duration: 200 }
                    NumberAnimation { properties: "rotation"; duration: 200 }
                }
            }
        }

        Rectangle {
            id: aboutButton
            width: timeCounter.width * 2.1
            height: timeCounter.height
            radius: timeCounter.radius
            color: theme.counterBackgroundColor
            border { color: theme.tileBorderColor; width: 2 }
            anchors {
                top: settingsButton.bottom
                topMargin: height * 0.2
                left: timeCounter.left
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

            Item {
                anchors.fill: parent

                Image {
                    id: aboutIcon
                    source: themeIndex === 0 ? "qrc:/Img/Icons/aboutGameIcons/aboutgameLight.svg" :
                            themeIndex === 1 ? "qrc:/Img/Icons/aboutGameIcons/aboutGameDark.svg" :
                                             "qrc:/Img/Icons/aboutGameIcons/aboutGameDark.svg"
                    width: aboutButton.height * 0.5
                    height: width
                    anchors {
                        left: parent.left
                        leftMargin: aboutButton.width * 0.15
                        verticalCenter: parent.verticalCenter
                    }
                    smooth: true
                    mipmap: true
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    id: aboutText
                    text: translations.t("about")
                    color: theme.counterTextColor
                    font { family: "Source Sans Pro"; pixelSize: aboutButton.height * 0.35 }
                    anchors.centerIn: parent
                }
            }

            states: State {
                name: "hovered"
                when: aboutArea.containsMouse
                PropertyChanges { target: aboutButton; scale: 0.98 }
                PropertyChanges { target: aboutText; color: theme.highlightColor }
            }

            transitions: Transition {
                from: ""; to: "hovered"; reversible: true
                ParallelAnimation {
                    NumberAnimation { properties: "scale"; duration: 200 }
                    ColorAnimation { properties: "color"; duration: 200 }
                }
            }
        }

        Rectangle {
            id: mainMenuButton
            width: timeCounter.width * 2.1
            height: timeCounter.height
            radius: timeCounter.radius
            color: theme.counterBackgroundColor
            border { color: theme.tileBorderColor; width: 2 }
            anchors {
                top: aboutButton.bottom
                topMargin: height * 0.2
                left: timeCounter.left
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

            Item {
                anchors.fill: parent

                Image {
                    id: menuIcon
                    source: themeIndex === 0 ? "qrc:/Img/Icons/menuIcons/menuLight.svg" :
                            themeIndex === 1 ? "qrc:/Img/Icons/menuIcons/menuDark.svg" :
                                             "qrc:/Img/Icons/menuIcons/menuDark.svg"
                    width: mainMenuButton.height * 0.7
                    height: width
                    anchors {
                        left: parent.left
                        leftMargin: mainMenuButton.width * 0.15
                        verticalCenter: parent.verticalCenter
                    }
                    smooth: true
                    mipmap: true
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    id: menuText
                    text: translations.t("mainMenu")
                    color: theme.counterTextColor
                    font { family: "Source Sans Pro"; pixelSize: mainMenuButton.height * 0.35 }
                    anchors.centerIn: parent
                }
            }

            states: State {
                name: "hovered"
                when: mainMenuArea.containsMouse
                PropertyChanges { target: mainMenuButton; scale: 0.98 }
                PropertyChanges { target: menuText; color: theme.highlightColor }
            }

            transitions: Transition {
                from: ""; to: "hovered"; reversible: true
                ParallelAnimation {
                    NumberAnimation { properties: "scale"; duration: 200 }
                    ColorAnimation { properties: "color"; duration: 200 }
                }
            }
        }

        Rectangle {
            id: gameBoardBackground
            property real minMargin: Math.min(root.width, root.height) * 0.10
            property real boardSize: Math.min(root.width * 0.65, root.height - (2 * minMargin))

            width: boardSize
            height: width
            radius: 25
            color: theme.gameBoardBackgroundColor
            border.color: theme.tileBorderColor

            anchors {
                top: parent.top
                bottom: parent.bottom
                right: parent.right
                topMargin: minMargin
                bottomMargin: minMargin
                rightMargin: minMargin * 2
            }

            onWidthChanged: height = width
            onHeightChanged: width = height

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 5
                verticalOffset: 5
                radius: 16
                samples: 32
                color: "#40000000"
            }

            GameBoard {
                id: gameBoard
                width: parent.width * 0.975
                height: width
                anchors.centerIn: parent
                themeIndex: root.themeIndex

                onCounterChanged: {
                    displayCounter = gameBoard.counter
                    if (!timerRunning && displayCounter > 0) timerRunning = true
                }

                onGameWon: {
                    isGameWon = true
                    showWinDialog()
                }
            }
        }
        Dialog {
            id: winDialog
            title: translations.t("congratulations")
            modal: true
            anchors.centerIn: parent
            closePolicy: Popup.CloseOnEscape

            background: Rectangle {
                color: theme.counterBackgroundColor
                radius: 10
                border { color: theme.tileBorderColor; width: 2 }
            }

            contentItem: Column {
                spacing: 15
                padding: 20

                Text {
                    text: translations.t("puzzleSolved")
                    color: theme.counterTextColor
                    font { family: "Source Sans Pro"; pixelSize: 24; bold: true }
                }

                Text {
                    text: translations.t("timeLabel") + formatTime(elapsedTime)
                    color: theme.counterTextColor
                    font { family: "Source Sans Pro"; pixelSize: 18 }
                }

                Text {
                    text: translations.t("movesLabel") + displayCounter
                    color: theme.counterTextColor
                    font { family: "Source Sans Pro"; pixelSize: 18 }
                }
            }

            footer: DialogButtonBox {
                Button {
                    text: translations.t("playAgain")
                    DialogButtonBox.buttonRole: DialogButtonBox.ResetRole
                    onClicked: {
                        restartGame()
                        winDialog.close()
                    }
                }
                Button {
                    text: translations.t("close")
                    DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
                    onClicked: winDialog.close()
                }
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
        if (gameBoard) {
            gameBoard.counter = 0
            gameBoard.lastMovedIndex = -1
            gameBoard.model.shuffle()
        }
    }
    function formatTime(seconds) {
        var minutes = Math.floor(seconds / 60)
        var secs = seconds % 60
        return minutes + ":" + (secs < 10 ? "0" + secs : secs)
    }

    function showWinDialog() {
        winDialog.open()
    }
}
