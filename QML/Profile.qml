import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import Qt.labs.settings 1.0

Rectangle {
    id: profileWindow
    width: 680
    height: 600
    color: Qt.rgba(theme.loginWindowBackgroundColor.r, theme.loginWindowBackgroundColor.g, theme.loginWindowBackgroundColor.b, 0.95)
    radius: 15
    visible: false

    property int themeIndex: 0
    property bool isEnglish: true

    Settings {
        id: profileSettings
        property string savedUsername: "pahota"
        property int performance: 7221
        property string bestScore: "15487"
        property var puzzlesCompleted: {
            "easy": 32,
            "normal": 24,
            "hard": 11,
            "impossible": 3
        }
    }

    QtObject {
        id: translations
        property var texts: ({
            "title": { "en": "Player Profile", "ru": "Профиль игрока" },
            "welcome": { "en": "Welcome", "ru": "Добро пожаловать" },
            "logout": { "en": "Logout", "ru": "Выйти" },
            "close": { "en": "Close", "ru": "Закрыть" },
            "stats": { "en": "Player Statistics", "ru": "Статистика игрока" },
            "performance": { "en": "Performance", "ru": "Производительность" },
            "bestScore": { "en": "Best Score", "ru": "Лучший результат" },
            "puzzlesCompleted": { "en": "Puzzles Completed", "ru": "Собрано пятнашек" },
            "easy": { "en": "Easy (3x3)", "ru": "Легкий (3x3)" },
            "normal": { "en": "Normal (4x4)", "ru": "Нормальный (4x4)" },
            "hard": { "en": "Hard (5x5)", "ru": "Сложный (5x5)" },
            "impossible": { "en": "Impossible (6x6)", "ru": "Невозможный (6x6)" }
        })

        function t(key) {
            return texts[key][isEnglish ? "en" : "ru"]
        }
    }

    Item {
        id: theme
        property color loginWindowBackgroundColor: themeIndex === 0 ? "#f5f5f5" : "#1e1e1e"
        property color loginHeaderGradientStartColor: themeIndex === 0 ? "#3498db" : "#2c3e50"
        property color loginHeaderGradientEndColor: themeIndex === 0 ? "#2980b9" : "#1a2533"
        property color loginHeaderTextColor: "#ffffff"
        property color loginTextColor: themeIndex === 0 ? "#333333" : "#e0e0e0"
        property color loginHeaderGlowColor: themeIndex === 0 ? Qt.rgba(0, 0, 0, 0.2) : Qt.rgba(0, 0, 0, 0.4)
        property color loginAvatarCircleColor: themeIndex === 0 ? "#ecf0f1" : "#2c3e50"
        property color loginAvatarCircleBorderColor: themeIndex === 0 ? "#3498db" : "#1abc9c"
        property color loginAvatarNumberColor: themeIndex === 0 ? "#3498db" : "#ecf0f1"
        property color loginInputFieldBackgroundColor: themeIndex === 0 ? "#ffffff" : "#2c3e50"
        property color loginInputFieldBorderColor: themeIndex === 0 ? "#3498db" : "#1abc9c"
        property color loginButtonGradientStartColor: themeIndex === 0 ? "#3498db" : "#16a085"
        property color loginButtonGradientEndColor: themeIndex === 0 ? "#2980b9" : "#1abc9c"
        property color loginButtonTextColor: "#ffffff"
        property color loginButtonShadowColor: themeIndex === 0 ? Qt.rgba(0, 0, 0, 0.2) : Qt.rgba(0, 0, 0, 0.4)
        property color loginWindowShadowColor: themeIndex === 0 ? Qt.rgba(0, 0, 0, 0.3) : Qt.rgba(0, 0, 0, 0.5)
    }

    Rectangle {
        id: headerBar
        width: parent.width
        height: 60
        color: "transparent"
        radius: 15

        gradient: Gradient {
            GradientStop { position: 0.0; color: theme.loginHeaderGradientStartColor }
            GradientStop { position: 1.0; color: theme.loginHeaderGradientEndColor }
        }

        Text {
            id: titleText
            anchors.centerIn: parent
            text: translations.t("title")
            color: theme.loginHeaderTextColor
            font {
                family: "Source Sans Pro"
                pixelSize: 24
                bold: true
            }
            width: parent.width - 100
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
        }

        Rectangle {
            width: parent.width
            height: parent.height
            anchors.top: parent.top
            radius: 15
            color: "transparent"
            gradient: parent.gradient
            clip: true
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
        width: 36
        height: 36
        radius: 18
        color: "transparent"

        anchors {
            right: parent.right
            top: parent.top
            margins: 12
        }

        Text {
            anchors.centerIn: parent
            text: "✕"
            color: theme.loginHeaderTextColor
            font.pixelSize: 18
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.color = Qt.rgba(1, 1, 1, 0.2)
            onExited: parent.color = "transparent"
            onClicked: profileWindow.visible = false
            cursorShape: Qt.PointingHandCursor
        }
    }

    Item {
        id: profileView
        anchors {
            top: headerBar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: 20
        }

        Column {
            anchors.centerIn: parent
            width: parent.width - 40
            spacing: 20

            Text {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: translations.t("welcome") + ", " + profileSettings.savedUsername + "!"
                color: theme.loginTextColor
                font {
                    pixelSize: 24
                    bold: true
                }
                wrapMode: Text.WordWrap
            }

            Rectangle {
                width: 100
                height: 100
                radius: 50
                color: theme.loginAvatarCircleColor
                border.color: theme.loginAvatarCircleBorderColor
                border.width: 3
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    anchors.centerIn: parent
                    text: profileSettings.savedUsername.charAt(0).toUpperCase()
                    color: theme.loginAvatarNumberColor
                    font {
                        pixelSize: 48
                        bold: true
                    }
                }

                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    horizontalOffset: 0
                    verticalOffset: 2
                    radius: 8
                    samples: 17
                    color: theme.loginHeaderGlowColor
                }
            }

            Rectangle {
                width: parent.width
                height: 280
                radius: 15
                color: Qt.rgba(theme.loginInputFieldBackgroundColor.r, theme.loginInputFieldBackgroundColor.g, theme.loginInputFieldBackgroundColor.b, 0.8)
                border.color: theme.loginInputFieldBorderColor
                border.width: 1

                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    horizontalOffset: 0
                    verticalOffset: 2
                    radius: 6
                    samples: 17
                    color: Qt.rgba(0, 0, 0, 0.2)
                }

                Column {
                    anchors {
                        fill: parent
                        margins: 15
                    }
                    spacing: 15

                    Text {
                        text: translations.t("stats")
                        color: theme.loginTextColor
                        font {
                            pixelSize: 20
                            bold: true
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: 15

                        Rectangle {
                            width: parent.width
                            height: 30
                            radius: 5
                            color: Qt.rgba(1, 1, 1, 0.1)

                            Text {
                                text: translations.t("performance") + ":"
                                color: theme.loginTextColor
                                font.pixelSize: 16
                                anchors {
                                    left: parent.left
                                    leftMargin: 10
                                    verticalCenter: parent.verticalCenter
                                }
                            }

                            Text {
                                text: profileSettings.performance + " pp"
                                color: theme.loginInputFieldBorderColor
                                font {
                                    pixelSize: 16
                                    bold: true
                                }
                                anchors {
                                    right: parent.right
                                    rightMargin: 10
                                    verticalCenter: parent.verticalCenter
                                }
                            }
                        }

                        Rectangle {
                            width: parent.width
                            height: 30
                            radius: 5
                            color: Qt.rgba(1, 1, 1, 0.1)

                            Text {
                                text: translations.t("bestScore") + ":"
                                color: theme.loginTextColor
                                font.pixelSize: 16
                                anchors {
                                    left: parent.left
                                    leftMargin: 10
                                    verticalCenter: parent.verticalCenter
                                }
                            }

                            Text {
                                text: profileSettings.bestScore
                                color: theme.loginInputFieldBorderColor
                                font {
                                    pixelSize: 16
                                    bold: true
                                }
                                anchors {
                                    right: parent.right
                                    rightMargin: 10
                                    verticalCenter: parent.verticalCenter
                                }
                            }
                        }

                        Rectangle {
                            width: parent.width
                            height: 30
                            radius: 5
                            color: Qt.rgba(1, 1, 1, 0.1)

                            Text {
                                text: translations.t("puzzlesCompleted") + ":"
                                color: theme.loginTextColor
                                font.pixelSize: 16
                                font.bold: true
                                anchors {
                                    left: parent.left
                                    leftMargin: 10
                                    verticalCenter: parent.verticalCenter
                                }
                            }
                        }

                        Rectangle {
                            width: parent.width - 10
                            height: 30
                            radius: 5
                            color: Qt.rgba(1, 1, 1, 0.08)
                            anchors.left: parent.left
                            anchors.leftMargin: 10

                            Text {
                                text: translations.t("easy") + ":"
                                color: theme.loginTextColor
                                font.pixelSize: 16
                                anchors {
                                    left: parent.left
                                    leftMargin: 10
                                    verticalCenter: parent.verticalCenter
                                }
                            }

                            Text {
                                text: profileSettings.puzzlesCompleted.easy
                                color: theme.loginInputFieldBorderColor
                                font {
                                    pixelSize: 16
                                    bold: true
                                }
                                anchors {
                                    right: parent.right
                                    rightMargin: 10
                                    verticalCenter: parent.verticalCenter
                                }
                            }
                        }

                        Rectangle {
                            width: parent.width - 10
                            height: 30
                            radius: 5
                            color: Qt.rgba(1, 1, 1, 0.08)
                            anchors.left: parent.left
                            anchors.leftMargin: 10

                            Text {
                                text: translations.t("normal") + ":"
                                color: theme.loginTextColor
                                font.pixelSize: 16
                                anchors {
                                    left: parent.left
                                    leftMargin: 10
                                    verticalCenter: parent.verticalCenter
                                }
                            }

                            Text {
                                text: profileSettings.puzzlesCompleted.normal
                                color: theme.loginInputFieldBorderColor
                                font {
                                    pixelSize: 16
                                    bold: true
                                }
                                anchors {
                                    right: parent.right
                                    rightMargin: 10
                                    verticalCenter: parent.verticalCenter
                                }
                            }
                        }

                        Rectangle {
                            width: parent.width - 10
                            height: 30
                            radius: 5
                            color: Qt.rgba(1, 1, 1, 0.08)
                            anchors.left: parent.left
                            anchors.leftMargin: 10

                            Text {
                                text: translations.t("hard") + ":"
                                color: theme.loginTextColor
                                font.pixelSize: 16
                                anchors {
                                    left: parent.left
                                    leftMargin: 10
                                    verticalCenter: parent.verticalCenter
                                }
                            }

                            Text {
                                text: profileSettings.puzzlesCompleted.hard
                                color: theme.loginInputFieldBorderColor
                                font {
                                    pixelSize: 16
                                    bold: true
                                }
                                anchors {
                                    right: parent.right
                                    rightMargin: 10
                                    verticalCenter: parent.verticalCenter
                                }
                            }
                        }

                        Rectangle {
                            width: parent.width - 10
                            height: 30
                            radius: 5
                            color: Qt.rgba(1, 1, 1, 0.08)
                            anchors.left: parent.left
                            anchors.leftMargin: 10

                            Text {
                                text: translations.t("impossible") + ":"
                                color: theme.loginTextColor
                                font.pixelSize: 16
                                anchors {
                                    left: parent.left
                                    leftMargin: 10
                                    verticalCenter: parent.verticalCenter
                                }
                            }

                            Text {
                                text: profileSettings.puzzlesCompleted.impossible
                                color: theme.loginInputFieldBorderColor
                                font {
                                    pixelSize: 16
                                    bold: true
                                }
                                anchors {
                                    right: parent.right
                                    rightMargin: 10
                                    verticalCenter: parent.verticalCenter
                                }
                            }
                        }
                    }
                }
            }

            Row {
                width: parent.width
                spacing: 10
                anchors.horizontalCenter: parent.horizontalCenter

                Rectangle {
                    width: parent.width / 2 - 5
                    height: 50
                    radius: 25
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: theme.loginButtonGradientStartColor }
                        GradientStop { position: 1.0; color: theme.loginButtonGradientEndColor }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: translations.t("logout")
                        color: theme.loginButtonTextColor
                        font {
                            pixelSize: 18
                            bold: true
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: parent.opacity = 0.9
                        onExited: parent.opacity = 1.0
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            var loginSettings = Qt.createQmlObject('
                                import Qt.labs.settings 1.0
                                Settings {
                                    property bool isLoggedIn: false
                                }
                            ', profileWindow, "LoginSettings");
                            loginSettings.isLoggedIn = false;
                            profileWindow.visible = false;

                            var loginComponent = Qt.createComponent("Login.qml")
                            if (loginComponent.status === Component.Ready) {
                                var loginWindow = loginComponent.createObject(profileWindow.parent, {
                                    "themeIndex": profileWindow.themeIndex,
                                    "isEnglish": profileWindow.isEnglish
                                })
                                loginWindow.visible = true
                            } else if (loginComponent.status === Component.Error) {
                                console.error("Error creating Login window:", loginComponent.errorString())
                            }
                        }
                    }

                    layer.enabled: true
                    layer.effect: DropShadow {
                        transparentBorder: true
                        horizontalOffset: 0
                        verticalOffset: 3
                        radius: 8
                        samples: 17
                        color: theme.loginButtonShadowColor
                    }
                }

                Rectangle {
                    width: parent.width / 2 - 5
                    height: 50
                    radius: 25
                    color: "transparent"
                    border.color: theme.loginInputFieldBorderColor
                    border.width: 2

                    Text {
                        anchors.centerIn: parent
                        text: translations.t("close")
                        color: theme.loginInputFieldBorderColor
                        font {
                            pixelSize: 18
                            bold: true
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: parent.color = Qt.rgba(theme.loginInputFieldBorderColor.r, theme.loginInputFieldBorderColor.g, theme.loginInputFieldBorderColor.b, 0.1)
                        onExited: parent.color = "transparent"
                        cursorShape: Qt.PointingHandCursor
                        onClicked: profileWindow.visible = false
                    }
                }
            }
        }
    }

    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 0
        verticalOffset: 5
        radius: 12
        samples: 25
        color: theme.loginWindowShadowColor
    }
}
