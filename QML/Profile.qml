import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import Qt.labs.settings 1.0

Rectangle {
    id: profileWindow
    width: 400
    height: 500
    color: Qt.rgba(theme.windowColor.r, theme.windowColor.g, theme.windowColor.b, 0.9)
    radius: 10

    property int themeIndex: 0
    property bool isEnglish: true

    Settings {
        id: profileSettings
        property string savedUsername: "pahota"
        property string savedPassword: ""
        property int performance: 7221
        property int level: 100
        property bool isLoggedIn: false
        property bool rememberMe: false
    }

    Component.onCompleted: {
        usernameField.text = profileSettings.savedUsername
        if (profileSettings.rememberMe && profileSettings.savedPassword !== "") {
            passwordField.text = profileSettings.savedPassword
            rememberCheckbox.checked = true
        }
    }

    QtObject {
        id: translations
        property var texts: ({
            "title": { "en": "Player Profile", "ru": "Профиль игрока" },
            "username": { "en": "Username", "ru": "Имя пользователя" },
            "password": { "en": "Password", "ru": "Пароль" },
            "login": { "en": "Login", "ru": "Войти" },
            "register": { "en": "Register", "ru": "Зарегистрироваться" },
            "logout": { "en": "Logout", "ru": "Выйти" },
            "welcome": { "en": "Welcome", "ru": "Добро пожаловать" },
            "remember": { "en": "Remember me", "ru": "Запомнить меня" },
            "close": { "en": "Close", "ru": "Закрыть" },
            "stats": { "en": "Player Statistics", "ru": "Статистика игрока" },
            "performance": { "en": "Performance", "ru": "Производительность" },
            "accuracy": { "en": "Accuracy", "ru": "Точность" },
            "level": { "en": "Level", "ru": "Уровень" },

        })

        function t(key) {
            return texts[key][isEnglish ? "en" : "ru"]
        }
    }

    Theme {
        id: theme
        themeIndex: profileWindow.themeIndex
    }

    Rectangle {
        id: headerBar
        width: parent.width
        height: 50
        color: Qt.rgba(theme.highlightColor.r, theme.highlightColor.g, theme.highlightColor.b, 0.95)
        radius: 10

        Text {
            id: titleText
            anchors.centerIn: parent
            text: translations.t("title")
            color: "white"
            font {
                family: "Source Sans Pro"
                pixelSize: 20
                bold: true
            }
            width: parent.width - 80
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideNone
        }

        Rectangle {
            width: parent.width
            height: parent.height / 2
            anchors.bottom: parent.bottom
            color: parent.color
        }
    }

    MouseArea {
        id: windowDrag
        anchors.fill: headerBar
        property point clickPos: "0,0"
        onPressed: {
            clickPos = Qt.point(mouse.x, mouse.y)
        }
        onPositionChanged: {
            var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
            profileWindow.x += delta.x
            profileWindow.y += delta.y
        }
    }

    Rectangle {
        id: closeButton
        width: 30
        height: 30
        radius: 15
        color: "transparent"

        anchors {
            right: parent.right
            top: parent.top
            margins: 10
        }

        Text {
            anchors.centerIn: parent
            text: "✕"
            color: "white"
            font.pixelSize: 18
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.color = "#20ffffff"
            onExited: parent.color = "transparent"
            onClicked: profileWindow.visible = false
        }
    }

    Item {
        id: contentArea
        anchors {
            top: headerBar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: 20
        }

        states: [
            State {
                name: "loggedOut"
                when: !profileSettings.isLoggedIn
                PropertyChanges { target: loginForm; visible: true }
                PropertyChanges { target: profileView; visible: false }
            },
            State {
                name: "loggedIn"
                when: profileSettings.isLoggedIn
                PropertyChanges { target: loginForm; visible: false }
                PropertyChanges { target: profileView; visible: true }
            }
        ]

        Item {
            id: loginForm
            visible: true
            anchors.fill: parent

            Column {
                anchors.centerIn: parent
                width: parent.width - 40
                spacing: 20

                Text {
                    text: translations.t("username")
                    color: theme.textColor
                    font.pixelSize: 16
                }

                Rectangle {
                    id: usernameRect
                    width: parent.width
                    height: 40
                    radius: 8
                    color: Qt.rgba(theme.tileBackgroundColor.r, theme.tileBackgroundColor.g, theme.tileBackgroundColor.b, 0.8)
                    border.color: theme.tileBorderColor
                    border.width: 1

                    TextInput {
                        id: usernameField
                        anchors {
                            fill: parent
                            margins: 10
                        }
                        color: theme.tileTextColor
                        font.pixelSize: 16
                        clip: true
                    }
                }

                Text {
                    text: translations.t("password")
                    color: theme.textColor
                    font.pixelSize: 16
                }

                Rectangle {
                    id: passwordRect
                    width: parent.width
                    height: 40
                    radius: 8
                    color: Qt.rgba(theme.tileBackgroundColor.r, theme.tileBackgroundColor.g, theme.tileBackgroundColor.b, 0.8)
                    border.color: theme.tileBorderColor
                    border.width: 1

                    TextInput {
                        id: passwordField
                        anchors {
                            fill: parent
                            margins: 10
                        }
                        color: theme.tileTextColor
                        font.pixelSize: 16
                        echoMode: TextInput.Password
                        clip: true
                    }
                }

                Row {
                    spacing: 10

                    CheckBox {
                        id: rememberCheckbox
                        indicator: Rectangle {
                            implicitWidth: 20
                            implicitHeight: 20
                            radius: 3
                            border.color: theme.tileBorderColor

                            Rectangle {
                                width: 10
                                height: 10
                                radius: 2
                                color: theme.highlightColor
                                anchors.centerIn: parent
                                visible: rememberCheckbox.checked
                            }
                        }

                        contentItem: Text {
                            text: translations.t("remember")
                            color: theme.textColor
                            font.pixelSize: 14
                            leftPadding: rememberCheckbox.indicator.width + 10
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }

                Row {
                    width: parent.width
                    spacing: 10

                    Rectangle {
                        width: (parent.width - 10) / 2
                        height: 40
                        radius: 8
                        color: Qt.rgba(theme.highlightColor.r, theme.highlightColor.g, theme.highlightColor.b, 0.95)

                        Text {
                            anchors.centerIn: parent
                            text: translations.t("login")
                            color: "white"
                            font.pixelSize: 16
                            font.bold: true
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: parent.color = Qt.lighter(theme.highlightColor, 1.1)
                            onExited: parent.color = Qt.rgba(theme.highlightColor.r, theme.highlightColor.g, theme.highlightColor.b, 0.95)
                            onClicked: {
                                if (usernameField.text.length > 0 && passwordField.text.length > 0) {
                                    profileSettings.savedUsername = usernameField.text
                                    profileSettings.isLoggedIn = true

                                    if (rememberCheckbox.checked) {
                                        profileSettings.savedPassword = passwordField.text
                                        profileSettings.rememberMe = true
                                    } else {
                                        profileSettings.savedPassword = ""
                                        profileSettings.rememberMe = false
                                    }
                                }
                            }
                        }
                    }

                    Rectangle {
                        width: (parent.width - 10) / 2
                        height: 40
                        radius: 8
                        color: "transparent"
                        border.color: theme.highlightColor
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: translations.t("register")
                            color: theme.highlightColor
                            font.pixelSize: 16
                            font.bold: true
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: parent.color = Qt.alpha(theme.highlightColor, 0.1)
                            onExited: parent.color = "transparent"
                            onClicked: {
                                if (usernameField.text.length > 0 && passwordField.text.length > 0) {
                                    profileSettings.savedUsername = usernameField.text
                                    profileSettings.performance = 0
                                    profileSettings.accuracy = 0
                                    profileSettings.level = 1
                                    profileSettings.isLoggedIn = true

                                    if (rememberCheckbox.checked) {
                                        profileSettings.savedPassword = passwordField.text
                                        profileSettings.rememberMe = true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        Item {
            id: profileView
            visible: false
            anchors.fill: parent

            Column {
                anchors.centerIn: parent
                width: parent.width - 40
                spacing: 20

                Text {
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: translations.t("welcome") + ", " + profileSettings.savedUsername + "!"
                    color: theme.textColor
                    font.pixelSize: 24
                    font.bold: true
                    wrapMode: Text.WordWrap
                }

                Rectangle {
                    width: 100
                    height: 100
                    radius: 50
                    color: Qt.rgba(theme.tileBackgroundColor.r, theme.tileBackgroundColor.g, theme.tileBackgroundColor.b, 0.8)
                    border.color: theme.tileBorderColor
                    border.width: 2
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        anchors.centerIn: parent
                        text: profileSettings.savedUsername.charAt(0).toUpperCase()
                        color: theme.highlightColor
                        font.pixelSize: 48
                        font.bold: true
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 150
                    radius: 10
                    color: Qt.rgba(theme.tileBackgroundColor.r, theme.tileBackgroundColor.g, theme.tileBackgroundColor.b, 0.8)
                    border.color: theme.tileBorderColor
                    border.width: 1

                    Column {
                        anchors {
                            fill: parent
                            margins: 15
                        }
                        spacing: 15

                        Text {
                            text: translations.t("stats")
                            color: theme.tileTextColor
                            font {
                                pixelSize: 18
                                bold: true
                            }
                        }

                        Grid {
                            width: parent.width
                            columns: 2
                            rowSpacing: 10
                            columnSpacing: 10

                            Text {
                                text: translations.t("performance") + ":"
                                color: theme.tileTextColor
                                font.pixelSize: 16
                            }

                            Text {
                                text: profileSettings.performance + "pp"
                                color: theme.highlightColor
                                font {
                                    pixelSize: 16
                                    bold: true
                                }
                            }

                            Text {
                                text: translations.t("accuracy") + ":"
                                color: theme.tileTextColor
                                font.pixelSize: 16
                            }

                            Text {
                                text: profileSettings.accuracy + "%"
                                color: theme.highlightColor
                                font {
                                    pixelSize: 16
                                    bold: true
                                }
                            }

                            Text {
                                text: translations.t("level") + ":"
                                color: theme.tileTextColor
                                font.pixelSize: 16
                            }

                            Text {
                                text: "Lv" + profileSettings.level
                                color: theme.highlightColor
                                font {
                                    pixelSize: 16
                                    bold: true
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    width: parent.width / 2
                    height: 40
                    radius: 8
                    color: Qt.rgba(theme.highlightColor.r, theme.highlightColor.g, theme.highlightColor.b, 0.95)
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        anchors.centerIn: parent
                        text: translations.t("logout")
                        color: "white"
                        font.pixelSize: 16
                        font.bold: true
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: parent.color = Qt.lighter(theme.highlightColor, 1.1)
                        onExited: parent.color = Qt.rgba(theme.highlightColor.r, theme.highlightColor.g, theme.highlightColor.b, 0.95)
                        onClicked: {
                            profileSettings.isLoggedIn = false
                            if (!rememberCheckbox.checked) {
                                usernameField.text = profileSettings.savedUsername
                                passwordField.text = ""
                            }
                        }
                    }
                }
            }
        }
    }

    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 5
        verticalOffset: 5
        radius: 15
        samples: 20
        color: "#80000000"
    }
}
