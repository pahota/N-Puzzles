import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import Qt.labs.settings 1.0

Rectangle {
    id: loginWindow
    width: 550
    height: 480
    color: Qt.rgba(0.12, 0.15, 0.18, 0.95)
    radius: 15
    visible: true

    property bool isEnglish: true
    property QtObject profileWindow

    Settings {
        id: loginSettings
        property string savedUsername: "pahota"
        property string savedPassword: ""
        property bool isLoggedIn: false
        property bool rememberMe: false
    }

    Component.onCompleted: {
        usernameField.text = loginSettings.savedUsername
        if (loginSettings.rememberMe && loginSettings.savedPassword !== "") {
            passwordField.text = loginSettings.savedPassword
            rememberCheckbox.checked = true
        }
    }

    QtObject {
        id: translations
        property var texts: ({
            "title": { "en": "Player Login", "ru": "Вход в игру" },
            "username": { "en": "Username", "ru": "Имя пользователя" },
            "password": { "en": "Password", "ru": "Пароль" },
            "login": { "en": "Login", "ru": "Войти" },
            "register": { "en": "Register", "ru": "Зарегистрироваться" },
            "remember": { "en": "Remember me", "ru": "Запомнить меня" },
            "close": { "en": "Close", "ru": "Закрыть" },
            "forgotPassword": { "en": "Forgot Password?", "ru": "Забыли пароль?" },
            "enterUsername": { "en": "Enter username", "ru": "Введите имя пользователя" },
            "enterPassword": { "en": "Enter password", "ru": "Введите пароль" }
        })

        function t(key) {
            return texts[key][isEnglish ? "en" : "ru"]
        }
    }

    Rectangle {
        id: headerBar
        width: parent.width
        height: 70
        color: "#2e86de"
        radius: 15

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#2e86de" }
            GradientStop { position: 1.0; color: "#54a0ff" }
        }

        Text {
            id: titleText
            anchors.centerIn: parent
            text: translations.t("title")
            color: "#000000"
            font {
                family: "Source Sans Pro"
                pixelSize: 28
                bold: true
            }
            width: parent.width - 100
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
        }

        layer.enabled: true
        layer.effect: DropShadow {
            id: headerGlow
            radius: 10
            samples: 16
            color: "#4056a1"
            spread: 0.2
        }

        Rectangle {
            width: parent.width
            height: parent.height
            anchors.top: parent.top
            radius: 15
            color: parent.color
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
            loginWindow.x += delta.x
            loginWindow.y += delta.y
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
            color: "#ffffff"
            font.pixelSize: 18
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                parent.color = Qt.rgba(1, 1, 1, 0.2)
            }
            onExited: {
                parent.color = "transparent"
                closeButton.rotation = 0
            }
            onClicked: {
                loginWindow.visible = false
                Qt.quit()
            }
            cursorShape: Qt.PointingHandCursor
        }
    }

    Item {
        id: loginForm
        anchors {
            top: headerBar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: 20
        }

        Row {
            anchors.centerIn: parent
            width: parent.width - 40
            height: parent.height - 40
            spacing: 40

            Rectangle {
                id: avatarCircle
                width: 130
                height: 130
                radius: 65
                color: "#212c3d"
                border.color: "#54a0ff"
                border.width: 3
                anchors.verticalCenter: parent.verticalCenter

                layer.enabled: true
                layer.effect: DropShadow {
                    horizontalOffset: 0
                    verticalOffset: 0
                    radius: 12
                    samples: 24
                    color: "#4056a1"
                    transparentBorder: true
                }

                NumberAnimation on rotation {
                    from: 0
                    to: 360
                    duration: 20000
                    loops: Animation.Infinite
                    running: true
                }

                Text {
                    anchors.centerIn: parent
                    text: "15"
                    color: "#54a0ff"
                    font {
                        pixelSize: 54
                        bold: true
                    }

                    SequentialAnimation on opacity {
                        loops: Animation.Infinite
                        NumberAnimation { from: 1; to: 0.7; duration: 1500; easing.type: Easing.InOutQuad }
                        NumberAnimation { from: 0.7; to: 1; duration: 1500; easing.type: Easing.InOutQuad }
                    }
                }

                Rectangle {
                    id: avatarInnerCircle
                    width: parent.width * 0.7
                    height: parent.height * 0.7
                    radius: width / 2
                    color: "transparent"
                    border.color: "#70a1ff"
                    border.width: 2
                    anchors.centerIn: parent
                    opacity: 0.7

                    NumberAnimation on rotation {
                        from: 360
                        to: 0
                        duration: 15000
                        loops: Animation.Infinite
                        running: true
                    }
                }

                Rectangle {
                    id: avatarOuterCircle
                    width: parent.width * 1.2
                    height: parent.height * 1.2
                    radius: width / 2
                    color: "transparent"
                    border.color: "#4056a1"
                    border.width: 1.5
                    anchors.centerIn: parent
                    opacity: 0.4

                    NumberAnimation on rotation {
                        from: 0
                        to: 360
                        duration: 25000
                        loops: Animation.Infinite
                        running: true
                    }
                }
            }

            Column {
                width: parent.width - 170
                spacing: 16
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    text: translations.t("username")
                    color: "#dfe6e9"
                    font {
                        pixelSize: 16
                        bold: true
                    }
                }

                Rectangle {
                    id: usernameRect
                    width: parent.width
                    height: 48
                    radius: 10
                    color: Qt.rgba(0.15, 0.18, 0.22, 0.8)
                    border.color: "#54a0ff"
                    border.width: 2

                    TextInput {
                        id: usernameField
                        anchors {
                            fill: parent
                            margins: 12
                        }
                        color: "#ffffff"
                        font.pixelSize: 16
                        clip: true
                        selectByMouse: true

                        Text {
                            anchors.fill: parent
                            anchors.leftMargin: 0
                            text: translations.t("enterUsername")
                            color: "#8395a7"
                            font.pixelSize: 16
                            visible: !usernameField.text && !usernameField.activeFocus
                        }
                    }

                    Behavior on scale {
                        NumberAnimation { duration: 100 }
                    }
                }

                Text {
                    text: translations.t("password")
                    color: "#dfe6e9"
                    font {
                        pixelSize: 16
                        bold: true
                    }
                }

                Rectangle {
                    id: passwordRect
                    width: parent.width
                    height: 48
                    radius: 10
                    color: Qt.rgba(0.15, 0.18, 0.22, 0.8)
                    border.color: "#54a0ff"
                    border.width: 2

                    TextInput {
                        id: passwordField
                        anchors {
                            fill: parent
                            margins: 12
                            rightMargin: 40
                        }
                        color: "#ffffff"
                        font.pixelSize: 16
                        echoMode: TextInput.Password
                        clip: true
                        selectByMouse: true

                        Text {
                            anchors.fill: parent
                            anchors.leftMargin: 0
                            text: translations.t("enterPassword")
                            color: "#8395a7"
                            font.pixelSize: 16
                            visible: !passwordField.text && !passwordField.activeFocus
                        }
                    }

                    Behavior on scale {
                        NumberAnimation { duration: 100 }
                    }

                    Rectangle {
                        id: togglePasswordVisibility
                        width: 30
                        height: 30
                        anchors {
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                            rightMargin: 8
                        }
                        color: "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: passwordField.echoMode === TextInput.Normal ? "👁️" : "👁️‍🗨️"
                            font.pixelSize: 16
                            color: "#54a0ff"
                        }

                        MouseArea {
                            anchors.fill: parent
                            onPressed: {
                                passwordField.echoMode = TextInput.Normal
                            }
                            onReleased: passwordField.echoMode = TextInput.Password
                            cursorShape: Qt.PointingHandCursor
                        }

                        Behavior on scale {
                            NumberAnimation { duration: 50 }
                        }
                    }
                }

                Row {
                    width: parent.width
                    height: 20
                    spacing: 10

                    Item {
                        id: rememberCheckbox
                        width: 20
                        height: 20
                        property bool checked: false

                        Rectangle {
                            anchors.fill: parent
                            radius: 4
                            border.color: "#54a0ff"
                            border.width: 2
                            color: "transparent"

                            Rectangle {
                                id: checkboxInner
                                width: parent.parent.checked ? 12 : 0
                                height: parent.parent.checked ? 12 : 0
                                radius: 2
                                color: "#54a0ff"
                                anchors.centerIn: parent

                                Behavior on width {
                                    NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
                                }

                                Behavior on height {
                                    NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: rememberCheckbox.checked = !rememberCheckbox.checked
                            cursorShape: Qt.PointingHandCursor
                        }
                    }

                    Text {
                        width: parent.width / 2 - 30
                        text: translations.t("remember")
                        color: "#dfe6e9"
                        font.pixelSize: 14
                        anchors.verticalCenter: parent.verticalCenter

                        MouseArea {
                            anchors.fill: parent
                            onClicked: rememberCheckbox.checked = !rememberCheckbox.checked
                            cursorShape: Qt.PointingHandCursor
                        }
                    }

                    Text {
                        width: parent.width / 2
                        text: translations.t("forgotPassword")
                        color: "#48dbfb"
                        font {
                            pixelSize: 14
                            underline: true
                        }
                        horizontalAlignment: Text.AlignRight
                        anchors.verticalCenter: parent.verticalCenter

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (usernameField.text.length > 0) {
                                    passwordField.text = "password123"
                                }
                            }
                            cursorShape: Qt.PointingHandCursor
                        }
                    }
                }

                Row {
                    width: parent.width
                    spacing: 10
                    topPadding: 20

                    Rectangle {
                        id: loginButton
                        width: parent.width * 0.6
                        height: 52
                        radius: 26
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "#2e86de" }
                            GradientStop { position: 1.0; color: "#54a0ff" }
                        }

                        layer.enabled: true
                        layer.effect: DropShadow {
                            horizontalOffset: 0
                            verticalOffset: 2
                            radius: 8
                            samples: 16
                            color: "#4056a1"
                            transparentBorder: true
                        }

                        Text {
                            anchors.centerIn: parent
                            text: translations.t("login")
                            color: "#ffffff"
                            font {
                                pixelSize: 18
                                bold: true
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (usernameField.text.length > 0 && passwordField.text.length > 0) {
                                    loginSettings.savedUsername = usernameField.text
                                    loginSettings.isLoggedIn = true

                                    if (rememberCheckbox.checked) {
                                        loginSettings.savedPassword = passwordField.text
                                        loginSettings.rememberMe = true
                                    } else {
                                        loginSettings.savedPassword = ""
                                        loginSettings.rememberMe = false
                                    }

                                    var component = Qt.createComponent("Profile.qml")
                                    if (component.status === Component.Ready) {
                                        profileWindow = component.createObject(loginWindow.parent, {
                                            "savedUsername": usernameField.text
                                        })
                                        if (profileWindow) {
                                            loginWindow.visible = false
                                            profileWindow.visible = true
                                        }
                                    } else if (component.status === Component.Error) {
                                        console.error("Error creating Profile component:", component.errorString())
                                    }
                                }
                            }
                        }

                        Behavior on scale {
                            NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
                        }
                    }

                    Rectangle {
                        id: registerButton
                        width: parent.width * 0.4 - 10
                        height: 52
                        radius: 26
                        color: "transparent"
                        border.color: "#5f27cd"
                        border.width: 2

                        Text {
                            id: registerText
                            anchors.centerIn: parent
                            text: translations.t("register")
                            color: "#c8d6e5"
                            font {
                                pixelSize: 16
                                bold: true
                            }
                            width: parent.width - 20
                            horizontalAlignment: Text.AlignHCenter
                            elide: Text.ElideRight
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (usernameField.text.length > 0 && passwordField.text.length > 0) {
                                    loginSettings.savedUsername = usernameField.text
                                    loginSettings.isLoggedIn = true

                                    if (rememberCheckbox.checked) {
                                        loginSettings.savedPassword = passwordField.text
                                        loginSettings.rememberMe = true
                                    }

                                    var component = Qt.createComponent("Profile.qml")
                                    if (component.status === Component.Ready) {
                                        profileWindow = component.createObject(loginWindow.parent, {
                                            "savedUsername": usernameField.text,
                                            "performance": 0,
                                            "accuracy": 0,
                                            "level": 1
                                        })
                                        if (profileWindow) {
                                            loginWindow.visible = false
                                            profileWindow.visible = true
                                        }
                                    } else if (component.status === Component.Error) {
                                        console.error("Error creating Profile component:", component.errorString())
                                    }
                                }
                            }
                        }

                        Behavior on scale {
                            NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
                        }
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
        radius: 20
        samples: 24
        color: "#0a0e17"
    }
}
