import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import Qt5Compat.GraphicalEffects
import Qt.labs.settings 1.0
import Game 1.0

Rectangle {
    id: mainMenu
    width: parent.width
    height: parent.height
    color: theme.windowColor

    property bool isEnglish: true
    property int themeIndex: 0
    property bool showAnimation: true
    property bool difficultyMenuVisible: false
    property int dimension: 4
    property int selectedDimension: 4

    Settings {
        id: settings
        property int savedTheme: themeIndex
        property bool savedLanguage: isEnglish
        property bool savedShowAnimation: showAnimation
        property int savedDimension: selectedDimension
    }

    Component.onCompleted: {
        themeIndex = settings.savedTheme
        isEnglish = settings.savedLanguage
        showAnimation = settings.savedShowAnimation
        selectedDimension = settings.savedDimension

        if (showAnimation) {
            particleTimer.start()
        }
        Window.window.visibility = Window.Maximized
    }

    Component.onDestruction: {
        settings.savedTheme = themeIndex
        settings.savedLanguage = isEnglish
        settings.savedShowAnimation = showAnimation
        settings.savedDimension = selectedDimension
    }

    signal playClicked()
    signal startGame(int dimension)

    QtObject {
        id: translations
        property var texts: ({
            "gameTitle": { "en": "N-Puzzle", "ru": "N-Пятнашки" },
            "play": { "en": "Play", "ru": "Играть" },
            "settings": { "en": "Settings", "ru": "Настройки" },
            "about": { "en": "About Game", "ru": "Об игре" },
            "exit": { "en": "Exit", "ru": "Выход" },
            "highscores": { "en": "High Scores", "ru": "Рекорды" },
            "version": { "en": "Version 0.8.5", "ru": "Версия 0.8.5" },
            "author": { "en": "Created by pahota", "ru": "Создал босс тузарни"},
            "profile": { "en": "Profile", "ru": "Профиль" },
            "easy": { "en": "Easy (3×3)", "ru": "Легко (3×3)" },
            "normal": { "en": "Normal (4×4)", "ru": "Нормально (4×4)" },
            "hard": { "en": "Hard (5×5)", "ru": "Сложно (5×5)" },
            "impossible": { "en": "Impossible (6×6)", "ru": "Невозможно (6×6)" },
            "highscores": { "en": "Highscores", "ru": "Рекорды" },
            "rank": { "en": "Rank", "ru": "Место" },
            "player": { "en": "Player", "ru": "Игрок" },
            "time": { "en": "Time", "ru": "Время" },
            "moves": { "en": "Moves", "ru": "Ходы" },
            "date": { "en": "Date", "ru": "Дата" },
            "difficulty": { "en": "Difficulty", "ru": "Сложность" },
            "clearAll": { "en": "Clear All", "ru": "Очистить" },
            "back": { "en": "Back", "ru": "Назад" },
            "noRecords": { "en": "No records yet", "ru": "Нет рекордов" },
            "enterName": { "en": "Enter Your Name", "ru": "Введите имя" },
            "save": { "en": "Save", "ru": "Сохранить" },
            "cancel": { "en": "Cancel", "ru": "Отмена" },
            "congrats": { "en": "New Highscore!", "ru": "Новый рекорд!" },
            "export": { "en": "Export", "ru": "Экспорт" },
            "all": { "en": "All", "ru": "Все" },
            "share": { "en": "Share", "ru": "Поделиться" },
            "closeWindow": { "en": "X", "ru": "X" },
            "puzzlesCompleted": { "en": "Puzzles Completed", "ru": "Собрано пятнашек" }
        })

        function t(key) {
            return texts[key][isEnglish ? "en" : "ru"]
        }
    }

    Theme {
        id: theme
        themeIndex: mainMenu.themeIndex
    }

    Rectangle {
        id: backgroundGradient
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.lighter(theme.windowColor, 1.2) }
            GradientStop { position: 1.0; color: theme.windowColor }
        }
    }

    Timer {
        id: particleTimer
        interval: 800
        running: false
        repeat: true
        onTriggered: {
            if (particles.count < 10) {
                particleComponent.createObject(particlesContainer)
            }
        }
    }

    Item {
        id: particlesContainer
        anchors.fill: parent
        visible: showAnimation
    }

    Component {
        id: particleComponent

        Rectangle {
            id: particle
            property int size: Math.floor(Math.random() * 15) + 8
            width: size
            height: size
            radius: size / 2
            x: Math.random() * mainMenu.width
            y: mainMenu.height + size
            color: theme.highlightColor
            opacity: 0.2 + (Math.random() * 0.3)

            Component.onCompleted: {
                particles.count++
                animation.start()
            }

            ParallelAnimation {
                id: animation
                NumberAnimation {
                    target: particle
                    property: "y"
                    to: -particle.height
                    duration: 12000 + (Math.random() * 10000)
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    target: particle
                    property: "x"
                    to: particle.x + (Math.random() * 80 - 40)
                    duration: 12000 + (Math.random() * 10000)
                    easing.type: Easing.InOutSine
                }
                onFinished: {
                    particles.count--
                    particle.destroy()
                }
            }
        }
    }

    QtObject {
        id: particles
        property int count: 0
    }

    Rectangle {
        id: titleBackground
        width: Math.min(parent.width * 0.7, 700)
        height: Math.min(parent.height * 0.22, 160)
        radius: height / 3
        color: Qt.rgba(theme.counterBackgroundColor.r, theme.counterBackgroundColor.g, theme.counterBackgroundColor.b, 0.9)
        border { color: theme.tileBorderColor; width: 3 }
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: parent.height * 0.08
        }

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 4
            verticalOffset: 4
            radius: 12
            samples: 24
            color: "#80000000"
        }

        Item {
            id: titleContainer
            anchors {
                fill: parent
                margins: parent.height * 0.15
            }

            Row {
                anchors.centerIn: parent
                spacing: titleBackground.width * 0.06

                Rectangle {
                    id: leftTile
                    width: titleText.height * 1.1
                    height: width
                    radius: 12
                    color: theme.tileBackgroundColor
                    border { color: theme.tileBorderColor; width: 2 }

                    Text {
                        anchors.centerIn: parent
                        text: "N"
                        color: Qt.darker(theme.tileBackgroundColor, 3.5)
                        font {
                            family: "Source Sans Pro"
                            pixelSize: parent.height * 0.6
                            bold: true
                        }
                        layer.enabled: true
                        layer.effect: DropShadow {
                            horizontalOffset: 1
                            verticalOffset: 1
                            radius: 1
                            samples: 3
                            color: "#80FFFFFF"
                        }
                    }

                    transform: Rotation {
                        id: leftTileRotation
                        origin.x: leftTile.width / 2
                        origin.y: leftTile.height / 2
                        angle: -5
                        Behavior on angle {
                            NumberAnimation { duration: 300; easing.type: Easing.OutBack }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: leftTileRotation.angle = 5
                        onExited: leftTileRotation.angle = -5
                        onClicked: {
                            var rotationAnim = Qt.createQmlObject('
                                import QtQuick 2.15
                                SequentialAnimation {
                                    NumberAnimation {
                                        target: leftTileRotation
                                        property: "angle"
                                        to: 360
                                        duration: 800
                                        easing.type: Easing.OutBack
                                    }
                                    NumberAnimation {
                                        target: leftTileRotation
                                        property: "angle"
                                        to: -5
                                        duration: 300
                                    }
                                    running: true
                                }', leftTile)
                        }
                    }
                }

                Text {
                    id: titleText
                    text: translations.t("gameTitle")
                    color: theme.highlightColor
                    font {
                        family: "Source Sans Pro"
                        pixelSize: titleContainer.height * 0.7
                        bold: true
                    }

                    layer.enabled: true
                    layer.effect: DropShadow {
                        horizontalOffset: 2
                        verticalOffset: 2
                        radius: 6
                        samples: 12
                        color: "#40000000"
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: titleScaleAnim.start()

                        SequentialAnimation {
                            id: titleScaleAnim
                            PropertyAction { target: titleText; property: "scale"; value: 1.0 }
                            NumberAnimation {
                                target: titleText
                                property: "scale"
                                to: 1.05
                                duration: 150
                                easing.type: Easing.OutQuad
                            }
                            NumberAnimation {
                                target: titleText
                                property: "scale"
                                to: 1.0
                                duration: 200
                                easing.type: Easing.OutBounce
                            }
                        }
                    }
                }

                Rectangle {
                    id: rightTile
                    width: titleText.height * 1.1
                    height: width
                    radius: 12
                    color: theme.tileBackgroundColor
                    border { color: theme.tileBorderColor; width: 2 }

                    Text {
                        anchors.centerIn: parent
                        text: selectedDimension.toString()
                        color: Qt.darker(theme.tileBackgroundColor, 3.5)
                        font {
                            family: "Source Sans Pro"
                            pixelSize: parent.height * 0.6
                            bold: true
                        }
                        layer.enabled: true
                        layer.effect: DropShadow {
                            horizontalOffset: 1
                            verticalOffset: 1
                            radius: 1
                            samples: 3
                            color: "#80FFFFFF"
                        }
                    }

                    transform: Rotation {
                        id: rightTileRotation
                        origin.x: rightTile.width / 2
                        origin.y: rightTile.height / 2
                        angle: 5
                        Behavior on angle {
                            NumberAnimation { duration: 300; easing.type: Easing.OutBack }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: rightTileRotation.angle = -5
                        onExited: rightTileRotation.angle = 5
                        onClicked: {
                            var rotationAnim = Qt.createQmlObject('
                                import QtQuick 2.15
                                SequentialAnimation {
                                    NumberAnimation {
                                        target: rightTileRotation
                                        property: "angle"
                                        to: -360
                                        duration: 800
                                        easing.type: Easing.OutBack
                                    }
                                    NumberAnimation {
                                        target: rightTileRotation
                                        property: "angle"
                                        to: 5
                                        duration: 300
                                    }
                                    running: true
                                }', rightTile)
                        }
                    }
                }
            }
        }
    }

    Text {
        id: versionText
        text: translations.t("version")
        color: theme.moveCounterTextColor
        opacity: 0.7
        font {
            family: "Source Sans Pro"
            pixelSize: Math.min(parent.height * 0.02, 16)
        }
        anchors {
            bottom: parent.bottom
            right: parent.right
            margins: parent.height * 0.02
        }
    }

    Text {
        id: authorText
        text: translations.t("author")
        color: theme.moveCounterTextColor
        opacity: 0.7
        font {
            family: "Source Sans Pro"
            pixelSize: Math.min(parent.height * 0.02, 16)
        }
        anchors {
            bottom: parent.bottom
            left: parent.left
            margins: parent.height * 0.02
        }
    }

    Column {
        id: buttonColumn
        anchors {
            top: titleBackground.bottom
            topMargin: parent.height * 0.08
            horizontalCenter: parent.horizontalCenter
        }
        spacing: Math.min(parent.height * 0.04, 30)
        width: Math.min(parent.width * 0.45, 480)

        MenuButton {
            id: playButton
            buttonText: translations.t("play")
            width: parent.width
            height: Math.min(parent.parent.height * 0.11, 75)
            themeIndex: mainMenu.themeIndex
            icon: themeIndex === 0 ? "qrc:/Img/Icons/pauseIcons/playLight.svg" : "qrc:/Img/Icons/pauseIcons/playDark.svg"
            onClicked: {
                difficultyMenuVisible = !difficultyMenuVisible
            }
        }

        MenuButton {
            id: highscoreButton
            buttonText: translations.t("highscores")
            width: parent.width
            height: playButton.height
            themeIndex: mainMenu.themeIndex
            icon: themeIndex === 0 ? "qrc:/Img/Icons/scoreIcons/scoreLight.svg" : "qrc:/Img/Icons/scoreIcons/scoreDark.svg"
            onClicked: {
                var component = Qt.createComponent("Highscores.qml")
                if (component.status === Component.Ready) {
                    var highscoresWindow = component.createObject(mainMenu, {
                        "themeIndex": mainMenu.themeIndex,
                        "isEnglish": mainMenu.isEnglish,
                        "translations": translations
                    })
                    highscoresWindow.visible = true
                } else if (component.status === Component.Error) {
                    console.error("Error creating Highscores:", component.errorString())
                }
            }
        }

        MenuButton {
            id: settingsButton
            buttonText: translations.t("settings")
            width: parent.width
            height: playButton.height
            themeIndex: mainMenu.themeIndex
            icon: themeIndex === 0 ? "qrc:/Img/Icons/settingsIcon/settingsLight.svg" : "qrc:/Img/Icons/settingsIcon/settingsDark.svg"
            onClicked: {
                var component = Qt.createComponent("Settings.qml")
                if (component.status === Component.Ready) {
                    var settingsWindow = component.createObject(mainMenu, {
                        "themeIndex": mainMenu.themeIndex,
                        "isEnglish": mainMenu.isEnglish,
                        "showAnimation": mainMenu.showAnimation
                    })

                    settingsWindow.themeChanged.connect(function(newTheme) {
                        mainMenu.themeIndex = newTheme
                    })
                    settingsWindow.languageChanged.connect(function(newIsEnglish) {
                        mainMenu.isEnglish = newIsEnglish
                    })
                    settingsWindow.animationChanged.connect(function(newShowAnimation) {
                        mainMenu.showAnimation = newShowAnimation
                        if (newShowAnimation) {
                            particleTimer.start()
                        } else {
                            particleTimer.stop()
                            for (var i = 0; i < particlesContainer.children.length; ++i) {
                                particlesContainer.children[i].destroy()
                            }
                            particles.count = 0
                        }
                    })

                    settingsWindow.visible = true
                } else if (component.status === Component.Error) {
                    console.error("Error creating Settings:", component.errorString())
                }
            }
        }

        MenuButton {
            id: aboutButton
            buttonText: translations.t("about")
            width: parent.width
            height: playButton.height
            themeIndex: mainMenu.themeIndex
            icon: themeIndex === 0 ? "qrc:/Img/Icons/aboutGameIcons/aboutgameLight.svg" : "qrc:/Img/Icons/aboutGameIcons/aboutGameDark.svg"
            onClicked: {
                var component = Qt.createComponent("AboutGame.qml")
                if (component.status === Component.Ready) {
                    var aboutWindow = component.createObject(mainMenu, {
                        "themeIndex": mainMenu.themeIndex,
                        "isEnglish": mainMenu.isEnglish
                    })
                    aboutWindow.visible = true
                } else if (component.status === Component.Error) {
                    console.error("Error creating AboutGame:", component.errorString())
                }
            }
        }

        MenuButton {
            id: exitButton
            buttonText: translations.t("exit")
            width: parent.width
            height: playButton.height
            themeIndex: mainMenu.themeIndex
            icon: "qrc:/Img/Icons/closeButton.png"
            onClicked: Qt.quit()
        }
    }

    Rectangle {
        id: difficultyMenu
        visible: difficultyMenuVisible
        width: Math.min(parent.width * 0.35, 400)
        height: difficultyColumn.height + 40
        color: Qt.rgba(0, 0, 0, 0.8)
        radius: 20
        anchors {
            left: buttonColumn.right
            leftMargin: 40
            top: buttonColumn.top
        }

        Column {
            id: difficultyColumn
            anchors {
                top: parent.top
                topMargin: 20
                horizontalCenter: parent.horizontalCenter
            }
            spacing: 15
            width: parent.width - 40

            DifficultyButton {
                id: easyButton
                buttonText: translations.t("easy")
                width: parent.width
                height: playButton.height
                buttonColor: "#4CAF50"
                onClicked: {
                    selectedDimension = 3
                    difficultyMenuVisible = false
                    mainMenu.startGame(3)
                    showMainMenu = false
                }
            }

            DifficultyButton {
                id: normalButton
                buttonText: translations.t("normal")
                width: parent.width
                height: playButton.height
                buttonColor: "#2196F3"
                onClicked: {
                    selectedDimension = 4
                    difficultyMenuVisible = false
                    mainMenu.startGame(4)
                    showMainMenu = false
                }
            }

            DifficultyButton {
                id: hardButton
                buttonText: translations.t("hard")
                width: parent.width
                height: playButton.height
                buttonColor: "#FF9800"
                onClicked: {
                    selectedDimension = 5
                    difficultyMenuVisible = false
                    mainMenu.startGame(5)
                    showMainMenu = false
                }
            }

            DifficultyButton {
                id: impossibleButton
                buttonText: translations.t("impossible")
                width: parent.width
                height: playButton.height
                buttonColor: "#F44336"
                onClicked: {
                    selectedDimension = 6
                    difficultyMenuVisible = false
                    mainMenu.startGame(6)
                    showMainMenu = false
                }
            }
        }

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 4
            verticalOffset: 4
            radius: 12
            samples: 24
            color: "#80000000"
        }

        SequentialAnimation {
            running: difficultyMenuVisible
            PropertyAnimation {
                target: difficultyMenu
                property: "opacity"
                from: 0
                to: 1
                duration: 250
                easing.type: Easing.OutCubic
            }
            PropertyAnimation {
                target: difficultyMenu
                property: "scale"
                from: 0.9
                to: 1.0
                duration: 250
                easing.type: Easing.OutBack
            }
        }
    }

    Settings {
        id: profileSettings
        property string savedUsername: "pahota"
        property int performance: 1488
        property bool isLoggedIn: false
        property var puzzlesCompleted: ({
            "easy": 32,
            "normal": 24,
            "hard": 11,
            "impossible": 3
        })
        property int totalPuzzlesCompleted: puzzlesCompleted.easy + puzzlesCompleted.normal + puzzlesCompleted.hard + puzzlesCompleted.impossible
    }

    Rectangle {
        id: profileWidget
        width: Math.min(parent.width * 0.3, 280)
        height: Math.min(parent.height * 0.12, 80)
        color: Qt.rgba(0, 0, 0, 0.7)
        radius: height / 4
        anchors {
            top: parent.top
            left: parent.left
            margins: parent.height * 0.025
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                profileHoverAnimation.start()
            }
            onExited: {
                profileExitAnimation.start()
            }
            onClicked: {
                if (profileSettings.isLoggedIn) {
                    var component = Qt.createComponent("Profile.qml")
                    if (component.status === Component.Ready) {
                        var profileWindow = component.createObject(mainMenu, {
                            "themeIndex": mainMenu.themeIndex,
                            "isEnglish": mainMenu.isEnglish,
                            "translations": translations
                        })
                        profileWindow.visible = true
                    } else {
                        console.log("Loading component:", component.status)
                        if (component.status === Component.Error) {
                            console.error("Error creating Profile:", component.errorString())
                        } else if (component.status === Component.Loading) {
                            component.statusChanged.connect(function() {
                                if (component.status === Component.Ready) {
                                    var profileWindow = component.createObject(mainMenu, {
                                        "themeIndex": mainMenu.themeIndex,
                                        "isEnglish": mainMenu.isEnglish,
                                        "translations": translations
                                    })
                                    profileWindow.visible = true
                                } else if (component.status === Component.Error) {
                                    console.error("Error creating Profile:", component.errorString())
                                }
                            })
                        }
                    }
                } else {
                    var loginComponent = Qt.createComponent("Login.qml")
                    if (loginComponent.status === Component.Ready) {
                        var loginWindow = loginComponent.createObject(mainMenu, {
                            "themeIndex": mainMenu.themeIndex,
                            "isEnglish": mainMenu.isEnglish,
                            "translations": translations
                        })
                        loginWindow.visible = true
                    } else {
                        console.log("Loading component:", loginComponent.status)
                        if (loginComponent.status === Component.Error) {
                            console.error("Error creating Login:", loginComponent.errorString())
                        } else if (loginComponent.status === Component.Loading) {
                            loginComponent.statusChanged.connect(function() {
                                if (loginComponent.status === Component.Ready) {
                                    var loginWindow = loginComponent.createObject(mainMenu, {
                                        "themeIndex": mainMenu.themeIndex,
                                        "isEnglish": mainMenu.isEnglish,
                                        "translations": translations
                                    })
                                    loginWindow.visible = true
                                } else if (loginComponent.status === Component.Error) {
                                    console.error("Error creating Login:", loginComponent.errorString())
                                }
                            })
                        }
                    }
                }
            }
        }

        ParallelAnimation {
            id: profileHoverAnimation
            PropertyAnimation { target: profileWidget; property: "color"; to: Qt.rgba(0, 0, 0, 0.8); duration: 150 }
            PropertyAnimation { target: profileWidget; property: "scale"; to: 1.02; duration: 150; easing.type: Easing.OutQuad }
            PropertyAnimation { target: profileGlow; property: "opacity"; to: 0.6; duration: 300 }
        }

        ParallelAnimation {
            id: profileExitAnimation
            PropertyAnimation { target: profileWidget; property: "color"; to: Qt.rgba(0, 0, 0, 0.7); duration: 150 }
            PropertyAnimation { target: profileWidget; property: "scale"; to: 1.0; duration: 150; easing.type: Easing.OutQuad }
            PropertyAnimation { target: profileGlow; property: "opacity"; to: 0; duration: 200 }
        }

        Rectangle {
            id: avatarContainer
            width: parent.height * 0.85
            height: width
            radius: 10
            color: "transparent"
            anchors {
                left: parent.left
                leftMargin: parent.height * 0.08
                verticalCenter: parent.verticalCenter
            }

            Image {
                id: avatarImage
                anchors.fill: parent
                source: "qrc:/Img/defaultAvatar.png"
                fillMode: Image.PreserveAspectCrop
                visible: true
            }

            Rectangle {
                id: defaultAvatar
                anchors.fill: parent
                color: theme.tileBackgroundColor
                radius: 8
                visible: avatarImage.status !== Image.Ready

                Text {
                    anchors.centerIn: parent
                    text: profileSettings.savedUsername ? profileSettings.savedUsername.charAt(0).toUpperCase() : "P"
                    color: theme.highlightColor
                    font {
                        pixelSize: parent.height * 0.6
                        bold: true
                    }
                }
            }

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: avatarContainer.width
                    height: avatarContainer.height
                    radius: 8
                }
            }
        }

        Column {
            anchors {
                left: avatarContainer.right
                leftMargin: 15
                right: parent.right
                rightMargin: 15
                verticalCenter: parent.verticalCenter
            }
            spacing: 3

            Text {
                text: profileSettings.savedUsername ? profileSettings.savedUsername : "pahota"
                color: "white"
                font {
                    family: "Source Sans Pro"
                    pixelSize: profileWidget.height * 0.3
                    bold: true
                }
            }

            Text {
                text: "Performance: " + profileSettings.performance + "pp"
                color: "#cccccc"
                font {
                    family: "Source Sans Pro"
                    pixelSize: profileWidget.height * 0.22
                }
            }

            Text {
                text: translations.t("puzzlesCompleted") + ": " + profileSettings.totalPuzzlesCompleted
                color: "#cccccc"
                font {
                    family: "Source Sans Pro"
                    pixelSize: profileWidget.height * 0.22
                }
            }
        }

        Rectangle {
            id: profileGlow
            anchors.fill: parent
            radius: parent.radius
            color: "transparent"
            border { color: theme.highlightColor; width: 2 }
            opacity: 0
        }

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 3
            verticalOffset: 3
            radius: 10
            samples: 16
            color: "#80000000"
        }
    }

}
