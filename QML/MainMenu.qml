import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import Qt5Compat.GraphicalEffects
import Qt.labs.settings 1.0

Rectangle {
    id: mainMenu
    width: parent.width
    height: parent.height
    color: theme.windowColor

    property bool isEnglish: true
    property int themeIndex: 0
    property bool showAnimation: true

    Settings {
        id: settings
        property int savedTheme: themeIndex
        property bool savedLanguage: isEnglish
        property bool savedShowAnimation: showAnimation
    }

    Component.onCompleted: {
        themeIndex = settings.savedTheme
        isEnglish = settings.savedLanguage
        showAnimation = settings.savedShowAnimation

        if (showAnimation) {
            particleTimer.start()
        }
        Window.window.visibility = Window.Maximized
    }

    Component.onDestruction: {
        settings.savedTheme = themeIndex
        settings.savedLanguage = isEnglish
        settings.savedShowAnimation = showAnimation
    }

    signal playClicked()

    QtObject {
        id: translations
        property var texts: ({
            "gameTitle": { "en": "15 Puzzle", "ru": "Пятнашки" },
            "play": { "en": "Play", "ru": "Играть" },
            "settings": { "en": "Settings", "ru": "Настройки" },
            "about": { "en": "About Game", "ru": "Об игре" },
            "exit": { "en": "Exit", "ru": "Выход" },
            "highscores": { "en": "High Scores", "ru": "Рекорды" },
            "version": { "en": "Version 0.7.2.7", "ru": "Версия 0.7.2.7" },
            "author": { "en": "Created by pahota", "ru": "Создал босс тузарни"},
            "profile": { "en": "Profile", "ru": "Профиль" }
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
        interval: 500
        running: false
        repeat: true
        onTriggered: {
            if (particles.count < 15) {
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
            property int size: Math.floor(Math.random() * 20) + 10
            width: size
            height: size
            radius: size / 2
            x: Math.random() * mainMenu.width
            y: mainMenu.height + size
            color: theme.highlightColor
            opacity: 0.3 + (Math.random() * 0.4)

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
                    duration: 10000 + (Math.random() * 15000)
                    easing.type: Easing.InOutQuad
                }

                NumberAnimation {
                    target: particle
                    property: "x"
                    to: particle.x + (Math.random() * 100 - 50)
                    duration: 10000 + (Math.random() * 15000)
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
        width: Math.min(parent.width * 0.6, 600)
        height: Math.min(parent.height * 0.18, 120)
        radius: height / 3
        color: theme.counterBackgroundColor
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

        Row {
            anchors {
                centerIn: parent
            }
            spacing: parent.width * 0.06

            Rectangle {
                width: titleText.height * 0.8
                height: width
                radius: 6
                color: theme.tileBackgroundColor
                border { color: theme.tileBorderColor; width: 2 }

                Text {
                    anchors.centerIn: parent
                    text: "15"
                    color: theme.tileTextColor
                    font {
                        family: "Source Sans Pro"
                        pixelSize: parent.height * 0.6
                        bold: true
                    }
                }

                transform: Rotation {
                    origin.x: width / 2
                    origin.y: height / 2
                    angle: -5
                }
            }

            Text {
                id: titleText
                text: translations.t("gameTitle")
                color: theme.highlightColor
                font {
                    family: "Source Sans Pro"
                    pixelSize: titleBackground.height * 0.5
                    bold: true
                }

                layer.enabled: true
                layer.effect: DropShadow {
                    horizontalOffset: 2
                    verticalOffset: 2
                    radius: 4
                    samples: 8
                    color: "#40000000"
                }
            }

            Rectangle {
                width: titleText.height * 0.8
                height: width
                radius: 6
                color: theme.tileBackgroundColor
                border { color: theme.tileBorderColor; width: 2 }

                Text {
                    anchors.centerIn: parent
                    text: "+"
                    color: theme.tileTextColor
                    font {
                        family: "Source Sans Pro"
                        pixelSize: parent.height * 0.6
                        bold: true
                    }
                }

                transform: Rotation {
                    origin.x: width / 2
                    origin.y: height / 2
                    angle: 5
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
        spacing: Math.min(parent.height * 0.035, 25)
        width: Math.min(parent.width * 0.45, 450)

        MenuButton {
            id: playButton
            buttonText: translations.t("play")
            width: parent.width
            height: Math.min(parent.parent.height * 0.11, 70)
            themeIndex: mainMenu.themeIndex
            onClicked: mainMenu.playClicked()

            Rectangle {
                width: parent.height * 0.5
                height: width
                radius: width / 2
                color: "transparent"
                border.color: parent.textColor
                border.width: 2
                anchors {
                    left: parent.left
                    leftMargin: parent.width * 0.07
                    verticalCenter: parent.verticalCenter
                }

                Text {
                    anchors.centerIn: parent
                    text: "▶"
                    color: parent.parent.textColor
                    font {
                        pixelSize: parent.width * 0.5
                        bold: true
                    }
                }
            }
        }

        MenuButton {
            id: highscoreButton
            buttonText: translations.t("highscores")
            width: parent.width
            height: playButton.height
            themeIndex: mainMenu.themeIndex
            onClicked: {
                var component = Qt.createComponent("Highscores.qml")
                if (component.status === Component.Ready) {
                    var highscoresWindow = component.createObject(mainMenu, {
                        "themeIndex": mainMenu.themeIndex,
                        "isEnglish": mainMenu.isEnglish
                    })
                    highscoresWindow.visible = true
                } else if (component.status === Component.Error) {
                    console.error("Error creating Highscores:", component.errorString())
                }
            }

            Rectangle {
                width: parent.height * 0.5
                height: width
                radius: width / 2
                color: "transparent"
                border.color: parent.textColor
                border.width: 2
                anchors {
                    left: parent.left
                    leftMargin: parent.width * 0.07
                    verticalCenter: parent.verticalCenter
                }

                Text {
                    anchors.centerIn: parent
                    text: "🏆"
                    color: parent.parent.textColor
                    font {
                        pixelSize: parent.width * 0.5
                        bold: true
                    }
                }
            }
        }

        MenuButton {
            id: settingsButton
            buttonText: translations.t("settings")
            width: parent.width
            height: playButton.height
            themeIndex: mainMenu.themeIndex
            onClicked: {
                var component = Qt.createComponent("Settings.qml")
                if (component.status === Component.Ready) {
                    var settingsWindow = component.createObject(mainMenu, {
                        "themeIndex": mainMenu.themeIndex,
                        "isEnglish": mainMenu.isEnglish,
                        "showAnimation": mainMenu.showAnimation
                    })

                    // Исправленные подключения сигналов
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

            Rectangle {
                width: parent.height * 0.5
                height: width
                radius: width / 2
                color: "transparent"
                border.color: parent.textColor
                border.width: 2
                anchors {
                    left: parent.left
                    leftMargin: parent.width * 0.07
                    verticalCenter: parent.verticalCenter
                }

                Text {
                    anchors.centerIn: parent
                    text: "⚙"
                    color: parent.parent.textColor
                    font {
                        pixelSize: parent.width * 0.5
                        bold: true
                    }
                }
            }
        }

        MenuButton {
            id: aboutButton
            buttonText: translations.t("about")
            width: parent.width
            height: playButton.height
            themeIndex: mainMenu.themeIndex
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

            Rectangle {
                width: parent.height * 0.5
                height: width
                radius: width / 2
                color: "transparent"
                border.color: parent.textColor
                border.width: 2
                anchors {
                    left: parent.left
                    leftMargin: parent.width * 0.07
                    verticalCenter: parent.verticalCenter
                }

                Text {
                    anchors.centerIn: parent
                    text: "ⓘ"
                    color: parent.parent.textColor
                    font {
                        pixelSize: parent.width * 0.5
                        bold: true
                    }
                }
            }
        }

        MenuButton {
            id: exitButton
            buttonText: translations.t("exit")
            width: parent.width
            height: playButton.height
            themeIndex: mainMenu.themeIndex
            onClicked: Qt.quit()

            Rectangle {
                width: parent.height * 0.5
                height: width
                radius: width / 2
                color: "transparent"
                border.color: parent.textColor
                border.width: 2
                anchors {
                    left: parent.left
                    leftMargin: parent.width * 0.07
                    verticalCenter: parent.verticalCenter
                }

                Text {
                    anchors.centerIn: parent
                    text: "✕"
                    color: parent.parent.textColor
                    font {
                        pixelSize: parent.width * 0.5
                        bold: true
                    }
                }
            }
        }
    }
    Rectangle {
        id: profileWidget
        width: Math.min(parent.width * 0.3, 250)
        height: Math.min(parent.height * 0.12, 70)
        color: Qt.rgba(0, 0, 0, 0.7)
        radius: height / 5
        anchors {
            top: parent.top
            left: parent.left
            margins: parent.height * 0.02
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.color = Qt.rgba(0, 0, 0, 0.8)
            onExited: parent.color = Qt.rgba(0, 0, 0, 0.7)
            onClicked: {
                var component = Qt.createComponent("Profile.qml")
                if (component.status === Component.Ready) {
                    var profileWindow = component.createObject(mainMenu, {
                        "themeIndex": mainMenu.themeIndex,
                        "isEnglish": mainMenu.isEnglish
                    })
                    profileWindow.visible = true
                } else if (component.status === Component.Error) {
                    console.error("Error creating Profile:", component.errorString())
                }
            }
        }

        Settings {
            id: profileSettings
            property string savedUsername: "pahota"
            property int performance: 1488
            property int level: 17
            property bool isLoggedIn: false
        }

        Rectangle {
            id: avatarContainer
            width: parent.height * 0.85
            height: width
            radius: 8
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
                radius: 5
                visible: !avatarImage.status === Image.Ready

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
                    radius: 5
                }
            }
        }

        Column {
            anchors {
                left: avatarContainer.right
                leftMargin: 10
                right: parent.right
                rightMargin: 10
                verticalCenter: parent.verticalCenter
            }
            spacing: 2

            Text {
                text: profileSettings.savedUsername ? profileSettings.savedUsername : "pahota"
                color: "white"
                font {
                    family: "Source Sans Pro"
                    pixelSize: profileWidget.height * 0.28
                    bold: true
                }
            }

            Text {
                text: "Performance:" + profileSettings.performance + "pp"
                color: "#cccccc"
                font {
                    family: "Source Sans Pro"
                    pixelSize: profileWidget.height * 0.22
                }
            }

            Text {
                text: "Lv" + profileSettings.level
                color: "#cccccc"
                font {
                    family: "Source Sans Pro"
                    pixelSize: profileWidget.height * 0.22
                }
            }
        }

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 2
            radius: 8
            samples: 16
            color: "#80000000"
        }
    }
}
