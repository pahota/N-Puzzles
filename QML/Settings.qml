import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import Qt.labs.settings 1.0
import AudioComponents 1.0

Window {
    id: settingsWindow
    width: 640
    height: 720
    title: "Settings"
    flags: Qt.FramelessWindowHint
    color: "transparent"
    visible: true

    property var audioController
    property int themeIndex: 0
    property bool isEnglish: true
    property bool settingsChanged: false

    Settings {
        id: savedSettings
        property int savedTheme: 0
        property bool savedLanguage: true

        Component.onCompleted: {
            themeIndex = savedTheme
            isEnglish = savedLanguage
        }
    }

    property Theme appTheme: Theme {
        themeIndex: settingsWindow.themeIndex
    }

    QtObject {
            id: translations
            property var texts: ({
                "settings": { "en": "Settings", "ru": "Настройки" },
                "themeSelection": { "en": "Theme Selection:", "ru": "Выбор темы:" },
                "light": { "en": "Light", "ru": "Светлая" },
                "dark": { "en": "Dark", "ru": "Тёмная" },
                "colorful": { "en": "Colorful", "ru": "Цветная" },
                "cleanBright": { "en": "Clean and bright", "ru": "Чистая и яркая" },
                "easyEyes": { "en": "Easy on the eyes", "ru": "Комфорт для глаз" },
                "vibrantFun": { "en": "Vibrant and fun", "ru": "Яркая и весёлая" },
                "apply": { "en": "Apply", "ru": "Применить" },
                "cancel": { "en": "Cancel", "ru": "Отмена" },
                "language": { "en": "Language:", "ru": "Язык:" },
                "unsavedChanges": { "en": "Unsaved changes", "ru": "Несохраненные изменения" },
                "confirmExit": { "en": "Do you want to save changes before exiting?", "ru": "Сохранить изменения перед выходом?" },
                "yes": { "en": "Yes", "ru": "Да" },
                "no": { "en": "No", "ru": "Нет" },
                "screenSettings": { "en": "Screen Settings", "ru": "Настройки экрана" },
                "brightness": { "en": "Brightness", "ru": "Яркость" },
                "contrast": { "en": "Contrast", "ru": "Контрастность" },
                "nightMode": { "en": "Night Mode", "ru": "Ночной режим" },
                "autoAdjust": { "en": "Auto Adjust", "ru": "Автоподстройка" },
                "on": { "en": "On", "ru": "Вкл" },
                "off": { "en": "Off", "ru": "Выкл" },
                "displayMode": { "en": "Display Mode", "ru": "Режим отображения" },
                "windowMode": { "en": "Window Mode", "ru": "Режим окна" },
                "windowed": { "en": "Windowed", "ru": "Оконный" },
                "fullscreen": { "en": "Fullscreen", "ru": "Полноэкранный" },
                "resolution": { "en": "Resolution", "ru": "Разрешение" },
                "refreshRate": { "en": "Refresh Rate", "ru": "Частота обновления" },
                "vsync": { "en": "VSync", "ru": "Вертикальная синхронизация" },
                "testSettings": { "en": "Test Settings", "ru": "Тестировать настройки" },
                "applyDisplaySettings": { "en": "Apply Display Settings", "ru": "Применить настройки экрана" }
            })
            function t(key) {
                return texts[key][isEnglish ? "en" : "ru"]
            }
        }

    Rectangle {
        id: mainBackground
        anchors.fill: parent
        color: appTheme.backgroundColor
        radius: 24
        opacity: 0

        NumberAnimation {
            id: openAnimation
            target: mainBackground
            property: "opacity"
            from: 0
            to: 1
            duration: 300
            easing.type: Easing.OutCubic
            running: true
        }

        Rectangle {
            id: backgroundShadow
            anchors.fill: parent
            anchors.margins: -2
            radius: 24
            color: appTheme.shadowColor
            z: -1
        }

        Rectangle {
            id: innerBackground
            anchors.fill: parent
            anchors.margins: 1
            radius: 24
            gradient: Gradient {
                GradientStop { position: 0.0; color: appTheme.backgroundSecondaryColor }
                GradientStop { position: 1.0; color: appTheme.backgroundColor }
            }
        }

        MouseArea {
            id: dragArea
            anchors.fill: header
            property point clickPos: "0,0"
            onPressed: {
                clickPos = Qt.point(mouse.x, mouse.y)
                dragStartAnim.start()
            }
            onPositionChanged: {
                if (pressed) {
                    var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
                    settingsWindow.x += delta.x
                    settingsWindow.y += delta.y
                }
            }
            onReleased: dragEndAnim.start()

            ParallelAnimation {
                id: dragStartAnim
                NumberAnimation { target: header; property: "scale"; to: 0.98; duration: 150; easing.type: Easing.OutQuad }
                NumberAnimation { target: header; property: "opacity"; to: 0.95; duration: 150; easing.type: Easing.OutQuad }
            }

            ParallelAnimation {
                id: dragEndAnim
                NumberAnimation { target: header; property: "scale"; to: 1.0; duration: 200; easing.type: Easing.OutElastic; easing.amplitude: 1.2 }
                NumberAnimation { target: header; property: "opacity"; to: 1.0; duration: 200; easing.type: Easing.OutQuad }
            }
        }

        Rectangle {
            id: header
            height: 64
            color: "transparent"
            radius: 16
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            transform: Scale { origin.x: header.width/2; origin.y: header.height/2 }

            Rectangle {
                anchors.fill: parent
                radius: 24
                gradient: Gradient {
                    GradientStop { position: 0.0; color: appTheme.accentGradientStartColor }
                    GradientStop { position: 1.0; color: appTheme.accentGradientEndColor }
                }
            }

            Text {
                id: headerText
                anchors.centerIn: parent
                text: translations.t("settings")
                font {
                    family: "Inter"
                    pixelSize: 30
                    weight: Font.Bold
                }
                color: "#FFFFFF"

                SequentialAnimation {
                    running: true
                    loops: 1
                    NumberAnimation { target: headerText; property: "opacity"; from: 0; to: 1; duration: 400; easing.type: Easing.OutCubic }
                    NumberAnimation { target: headerText; property: "scale"; from: 0.9; to: 1.0; duration: 400; easing.type: Easing.OutBack }
                }
            }

            Row {
                anchors {
                    right: parent.right
                    rightMargin: 20
                    verticalCenter: parent.verticalCenter
                }
                spacing: 12

                Rectangle {
                    id: minimizeButton
                    width: 32
                    height: 32
                    radius: 16
                    color: appTheme.backgroundColor
                    opacity: 0.85

                    Rectangle {
                        width: 12
                        height: 2
                        color: "#555555"
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: settingsWindow.showMinimized()
                        onEntered: {
                            minimizeButton.scale = 1.2
                            minimizeButton.opacity = 1
                        }
                        onExited: {
                            minimizeButton.scale = 1
                            minimizeButton.opacity = 0.85
                        }
                    }

                    Behavior on scale {
                        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                    }
                    Behavior on opacity {
                        NumberAnimation { duration: 150 }
                    }
                }

                Rectangle {
                    id: closeButton
                    width: 32
                    height: 32
                    radius: 16
                    color: appTheme.backgroundColor
                    opacity: 0.85

                    Image {
                        source: "qrc:/Img/Icons/closeButton.png"
                        width: 10
                        height: 10
                        anchors.centerIn: parent
                        opacity: 0.85
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            if (settingsChanged) {
                                confirmExitDialog.open()
                            } else {
                                closeWindowAnimation.start()
                            }
                        }
                        onEntered: {
                            closeButton.scale = 1.2
                            closeButton.opacity = 1
                        }
                        onExited: {
                            closeButton.scale = 1
                            closeButton.opacity = 0.85
                        }
                    }

                    Behavior on scale {
                        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                    }
                    Behavior on opacity {
                        NumberAnimation { duration: 150 }
                    }
                }
            }
        }

        Item {
            id: contentArea
            anchors {
                top: header.bottom
                left: parent.left
                right: parent.right
                bottom: footerButtons.top
                margins: 20
            }
            clip: true

            Flickable {
                id: contentFlickable
                anchors.fill: parent
                contentWidth: mainContent.width
                contentHeight: mainContent.height
                boundsBehavior: Flickable.StopAtBounds
                flickDeceleration: 2000
                maximumFlickVelocity: 3000

                ColumnLayout {
                    id: mainContent
                    width: contentArea.width
                    spacing: 20
                    opacity: 0

                    SequentialAnimation {
                        running: true
                        PauseAnimation { duration: 100 }
                        NumberAnimation {
                            target: mainContent
                            property: "opacity"
                            from: 0
                            to: 1
                            duration: 400
                            easing.type: Easing.OutCubic
                        }
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: translations.t("themeSelection")
                        font {
                            family: "Inter"
                            pixelSize: 26
                            weight: Font.DemiBold
                        }
                        color: appTheme.textColor
                    }

                    GridLayout {
                        id: themeGrid
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter
                        columns: 3
                        columnSpacing: 32
                        rowSpacing: 32

                        Repeater {
                            model: [
                                {name: "light", icon: "🌞", description: "cleanBright"},
                                {name: "dark", icon: "🌙", description: "easyEyes"},
                                {name: "colorful", icon: "🎨", description: "vibrantFun"}
                            ]

                            delegate: Item {
                                id: themeItem
                                Layout.preferredWidth: 160
                                Layout.preferredHeight: 200

                                property bool isSelected: settingsWindow.themeIndex === index

                                SequentialAnimation {
                                    running: true
                                    PauseAnimation { duration: 150 + index * 120 }
                                    ParallelAnimation {
                                        NumberAnimation {
                                            target: themeItem
                                            property: "scale"
                                            from: 0.6
                                            to: 1.0
                                            duration: 500
                                            easing.type: Easing.OutElastic
                                            easing.amplitude: 1.2
                                            easing.period: 0.4
                                        }
                                        NumberAnimation {
                                            target: themeItem
                                            property: "opacity"
                                            from: 0
                                            to: 1
                                            duration: 400
                                            easing.type: Easing.OutCubic
                                        }
                                    }
                                }

                                Rectangle {
                                    id: cardShadow
                                    anchors.centerIn: parent
                                    width: themeCard.width + 12
                                    height: themeCard.height + 12
                                    radius: 22
                                    color: themeItem.isSelected ?
                                        Qt.rgba(appTheme.accentColor.r, appTheme.accentColor.g, appTheme.accentColor.b, 0.35) :
                                        Qt.rgba(0, 0, 0, 0.15)
                                    z: -1

                                    Behavior on color {
                                        ColorAnimation { duration: 200 }
                                    }

                                    Behavior on width {
                                        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                                    }

                                    Behavior on height {
                                        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                                    }
                                }

                                Rectangle {
                                    id: themeCard
                                    anchors.centerIn: parent
                                    width: parent.width
                                    height: parent.height
                                    color: themeItem.isSelected ? Qt.lighter(appTheme.cardSelectedColor, 1.05) : appTheme.cardColor
                                    radius: 20

                                    Rectangle {
                                        visible: themeItem.isSelected
                                        anchors.fill: parent
                                        radius: 20
                                        color: "transparent"
                                        border.color: appTheme.accentColor
                                        border.width: 2

                                        Rectangle {
                                            id: selectionIndicator
                                            width: 12
                                            height: 12
                                            radius: 6
                                            color: appTheme.accentColor
                                            anchors.right: parent.right
                                            anchors.top: parent.top
                                            anchors.margins: 12

                                            SequentialAnimation {
                                                running: themeItem.isSelected
                                                loops: Animation.Infinite
                                                NumberAnimation {
                                                    target: selectionIndicator
                                                    property: "opacity"
                                                    from: 1.0
                                                    to: 0.5
                                                    duration: 800
                                                    easing.type: Easing.InOutSine
                                                }
                                                NumberAnimation {
                                                    target: selectionIndicator
                                                    property: "opacity"
                                                    from: 0.5
                                                    to: 1.0
                                                    duration: 800
                                                    easing.type: Easing.InOutSine
                                                }
                                            }
                                        }
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor

                                        onClicked: {
                                            if (settingsWindow.themeIndex !== index) {
                                                settingsWindow.themeIndex = index
                                                settingsChanged = true
                                                selectAnimation.start()
                                            }
                                        }

                                        onEntered: {
                                            if (!themeItem.isSelected) {
                                                hoverAnimation.start()
                                            }
                                        }

                                        onExited: {
                                            if (!themeItem.isSelected) {
                                                exitAnimation.start()
                                            }
                                        }

                                        ParallelAnimation {
                                            id: hoverAnimation
                                            NumberAnimation {
                                                target: themeCard
                                                property: "scale"
                                                to: 1.06
                                                duration: 200
                                                easing.type: Easing.OutCubic
                                            }
                                            NumberAnimation {
                                                target: cardShadow
                                                property: "width"
                                                to: themeCard.width * 1.06 + 16
                                                duration: 200
                                                easing.type: Easing.OutCubic
                                            }
                                            NumberAnimation {
                                                target: cardShadow
                                                property: "height"
                                                to: themeCard.height * 1.06 + 16
                                                duration: 200
                                                easing.type: Easing.OutCubic
                                            }
                                            ColorAnimation {
                                                target: cardShadow
                                                property: "color"
                                                to: Qt.rgba(appTheme.accentColor.r, appTheme.accentColor.g, appTheme.accentColor.b, 0.25)
                                                duration: 200
                                            }
                                        }

                                        ParallelAnimation {
                                            id: exitAnimation
                                            NumberAnimation {
                                                target: themeCard
                                                property: "scale"
                                                to: 1.0
                                                duration: 200
                                                easing.type: Easing.OutCubic
                                            }
                                            NumberAnimation {
                                                target: cardShadow
                                                property: "width"
                                                to: themeCard.width + 12
                                                duration: 200
                                                easing.type: Easing.OutCubic
                                            }
                                            NumberAnimation {
                                                target: cardShadow
                                                property: "height"
                                                to: themeCard.height + 12
                                                duration: 200
                                                easing.type: Easing.OutCubic
                                            }
                                            ColorAnimation {
                                                target: cardShadow
                                                property: "color"
                                                to: themeItem.isSelected ?
                                                    Qt.rgba(appTheme.accentColor.r, appTheme.accentColor.g, appTheme.accentColor.b, 0.35) :
                                                    Qt.rgba(0, 0, 0, 0.15)
                                                duration: 200
                                            }
                                        }

                                        SequentialAnimation {
                                            id: selectAnimation
                                            ParallelAnimation {
                                                NumberAnimation {
                                                    target: themeCard
                                                    property: "scale"
                                                    to: 0.92
                                                    duration: 120
                                                    easing.type: Easing.OutQuad
                                                }
                                                NumberAnimation {
                                                    target: themeCard
                                                    property: "rotation"
                                                    to: -3
                                                    duration: 120
                                                    easing.type: Easing.OutQuad
                                                }
                                            }
                                            ParallelAnimation {
                                                NumberAnimation {
                                                    target: themeCard
                                                    property: "scale"
                                                    to: 1.0
                                                    duration: 400
                                                    easing.type: Easing.OutElastic
                                                    easing.amplitude: 1.2
                                                    easing.period: 0.3
                                                }
                                                NumberAnimation {
                                                    target: themeCard
                                                    property: "rotation"
                                                    to: 0
                                                    duration: 400
                                                    easing.type: Easing.OutElastic
                                                    easing.amplitude: 1.2
                                                    easing.period: 0.3
                                                }
                                            }
                                        }
                                    }

                                    transform: Scale { origin.x: themeCard.width/2; origin.y: themeCard.height/2 }

                                    Behavior on color {
                                        ColorAnimation { duration: 200 }
                                    }

                                    ColumnLayout {
                                        anchors.centerIn: parent
                                        width: parent.width - 40
                                        spacing: 16

                                        Text {
                                            id: themeIcon
                                            text: modelData.icon
                                            font.pixelSize: 48
                                            Layout.alignment: Qt.AlignHCenter
                                            Layout.topMargin: 10

                                            SequentialAnimation {
                                                running: themeItem.isSelected
                                                loops: Animation.Infinite
                                                alwaysRunToEnd: true

                                                ParallelAnimation {
                                                    NumberAnimation {
                                                        target: themeIcon
                                                        property: "scale"
                                                        to: 1.15
                                                        duration: 1000
                                                        easing.type: Easing.InOutQuad
                                                    }
                                                    RotationAnimation {
                                                        target: themeIcon
                                                        property: "rotation"
                                                        from: -2
                                                        to: 2
                                                        duration: 1000
                                                        easing.type: Easing.InOutQuad
                                                    }
                                                }

                                                ParallelAnimation {
                                                    NumberAnimation {
                                                        target: themeIcon
                                                        property: "scale"
                                                        to: 1.0
                                                        duration: 1000
                                                        easing.type: Easing.InOutQuad
                                                    }
                                                    RotationAnimation {
                                                        target: themeIcon
                                                        property: "rotation"
                                                        from: 2
                                                        to: -2
                                                        duration: 1000
                                                        easing.type: Easing.InOutQuad
                                                    }
                                                }
                                            }
                                        }

                                        Text {
                                            id: themeName
                                            text: translations.t(modelData.name)
                                            color: appTheme.textColor
                                            font {
                                                family: "Inter"
                                                pixelSize: 24
                                                weight: Font.Bold
                                            }
                                            Layout.alignment: Qt.AlignHCenter

                                            Behavior on color {
                                                ColorAnimation { duration: 200 }
                                            }
                                        }

                                        Text {
                                            text: translations.t(modelData.description)
                                            color: appTheme.textSecondaryColor
                                            font {
                                                family: "Inter"
                                                pixelSize: 16
                                                weight: Font.Medium
                                            }
                                            Layout.alignment: Qt.AlignHCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            wrapMode: Text.WordWrap

                                            Behavior on color {
                                                ColorAnimation { duration: 200 }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 1
                        color: appTheme.accentColor
                        opacity: 0.2
                    }

                    ScreenSettings {
                        id: screenSettings
                        Layout.fillWidth: true
                        themeIndex: settingsWindow.themeIndex
                        appTheme: settingsWindow.appTheme
                        mainWindow: window
                        gameWindow: gameWindow
                        clip: true
                        onApplySettings: {
                            settingsChanged = true
                        }
                        onSettingsChanged: {
                            settingsChanged = true
                        }
                    }

                    Sound {
                        id: soundSettings
                        Layout.fillWidth: true
                        themeIndex: settingsWindow.themeIndex
                        audioController: settingsWindow.audioController
                        onApplySettings: {
                            settingsChanged = true
                        }
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 10

                        ColumnLayout {
                            spacing: 14

                            Text {
                                text: translations.t("language")
                                color: appTheme.textColor
                                font {
                                    family: "Inter"
                                    pixelSize: 20
                                    weight: Font.DemiBold
                                }
                            }

                            Item {
                                width: 170
                                height: 52

                                Rectangle {
                                    id: langButton
                                    anchors.fill: parent
                                    radius: 14
                                    color: appTheme.cardColor
                                    border.color: appTheme.accentColor
                                    border.width: 1

                                    Rectangle {
                                        id: langButtonShadow
                                        anchors.fill: parent
                                        anchors.margins: -2
                                        radius: 14
                                        color: appTheme.shadowColor
                                        z: -1
                                    }

                                    Rectangle {
                                        id: langFlagContainer
                                        width: 30
                                        height: 30
                                        radius: 15
                                        anchors {
                                            left: parent.left
                                            leftMargin: 10
                                            verticalCenter: parent.verticalCenter
                                        }
                                        color: "#FFFFFF"

                                        Text {
                                            anchors.centerIn: parent
                                            text: settingsWindow.isEnglish ? "🇺🇸" : "🇷🇺"
                                            font.pixelSize: 16
                                        }
                                    }

                                    Text {
                                        anchors {
                                            left: langFlagContainer.right
                                            leftMargin: 10
                                            right: parent.right
                                            rightMargin: 10
                                            verticalCenter: parent.verticalCenter
                                        }
                                        text: settingsWindow.isEnglish ? "English" : "Русский"
                                        color: appTheme.textColor
                                        font {
                                            family: "Inter"
                                            pixelSize: 17
                                            weight: Font.DemiBold
                                        }
                                        horizontalAlignment: Text.AlignHCenter
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        onClicked: {
                                            settingsWindow.isEnglish = !settingsWindow.isEnglish
                                            settingsChanged = true
                                            langChangeAnimation.start()
                                        }
                                        onEntered: langButton.scale = 1.05
                                        onExited: langButton.scale = 1.0
                                    }

                                    Behavior on scale {
                                        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                                    }

                                    SequentialAnimation {
                                        id: langChangeAnimation
                                        NumberAnimation { target: langButton; property: "opacity"; to: 0.5; duration: 150 }
                                        NumberAnimation { target: langButton; property: "opacity"; to: 1.0; duration: 150 }
                                    }
                                }
                            }
                        }
                    }

                    Item {
                        Layout.preferredHeight: 20
                    }
                }
            }

            Rectangle {
                id: customScrollBar
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: scrollDragArea.containsMouse ? 6 : 4
                radius: width / 2
                opacity: contentFlickable.movingVertically || scrollbarHoverArea.containsMouse ? 1.0 : 0.5
                color: "transparent"
                visible: contentFlickable.contentHeight > contentFlickable.height

                Rectangle {
                    id: scrollTrack
                    anchors.fill: parent
                    radius: width / 2
                    color: Qt.rgba(0, 0, 0, 0.1)
                }

                Rectangle {
                    id: scrollHandle
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
                    radius: width / 2
                    color: "#4CAF50"
                    y: (contentFlickable.contentY / (contentFlickable.contentHeight - contentFlickable.height)) *
                       (contentFlickable.height - height)
                    height: Math.max(contentFlickable.height * 0.15, 30)

                    Behavior on opacity {
                        NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
                    }

                    Behavior on width {
                        NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
                    }
                }

                MouseArea {
                    id: scrollDragArea
                    anchors.fill: scrollHandle
                    drag.target: scrollHandle
                    drag.axis: Drag.YAxis
                    drag.minimumY: 0
                    drag.maximumY: contentFlickable.height - scrollHandle.height
                    hoverEnabled: true
                    onMouseYChanged: {
                        if (pressed) {
                            var contentPos = scrollHandle.y / (contentFlickable.height - scrollHandle.height) *
                                           (contentFlickable.contentHeight - contentFlickable.height)
                            contentFlickable.contentY = contentPos
                        }
                    }
                    cursorShape: Qt.PointingHandCursor
                }

                MouseArea {
                    id: scrollbarHoverArea
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: 20
                    hoverEnabled: true
                    propagateComposedEvents: true
                    onWheel: wheel.accepted = false
                    onPressed: mouse.accepted = false
                    onReleased: mouse.accepted = false
                    cursorShape: Qt.ArrowCursor
                }
            }
        }


        RowLayout {
            id: footerButtons
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
                bottomMargin: 20
            }
            spacing: 28
            height: 52

            Item {
                width: 170
                height: 52

                Rectangle {
                    id: applyButton
                    anchors.fill: parent
                    radius: 26
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: appTheme.accentGradientStartColor }
                        GradientStop { position: 1.0; color: appTheme.accentGradientEndColor }
                    }
                    opacity: settingsChanged ? 1.0 : 0.5

                    Rectangle {
                        id: applyButtonShadow
                        anchors.fill: parent
                        anchors.margins: -2
                        radius: 26
                        color: Qt.rgba(appTheme.accentColor.r, appTheme.accentColor.g, appTheme.accentColor.b, 0.3)
                        z: -1
                    }

                    Text {
                        anchors.centerIn: parent
                        text: translations.t("apply")
                        color: "#FFFFFF"
                        font {
                            family: "Inter"
                            pixelSize: 17
                            weight: Font.Bold
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: settingsChanged
                        onClicked: {
                            savedSettings.savedTheme = themeIndex
                            savedSettings.savedLanguage = isEnglish
                            settingsChanged = false
                            saveAnimation.start()
                            themeChanged(themeIndex)
                            languageChanged(isEnglish)
                            soundSettings.applyAudioSettings()
                            screenSettings.applyScreenSettings()
                            closeWindowAnimation.start()
                        }
                        onEntered: if (settingsChanged) applyButton.scale = 1.05
                        onExited: if (settingsChanged) applyButton.scale = 1.0
                    }

                    SequentialAnimation {
                        id: saveAnimation
                        NumberAnimation { target: applyButton; property: "scale"; to: 0.95; duration: 100; easing.type: Easing.OutQuad }
                        NumberAnimation { target: applyButton; property: "scale"; to: 1.0; duration: 200; easing.type: Easing.OutBack }
                    }

                    Behavior on scale {
                        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                    }

                    Behavior on opacity {
                        NumberAnimation { duration: 200 }
                    }
                }
            }

            Item {
                width: 170
                height: 52

                Rectangle {
                    id: cancelButton
                    anchors.fill: parent
                    radius: 26
                    color: appTheme.cardColor
                    border.color: appTheme.accentColor
                    border.width: 1

                    Rectangle {
                        id: cancelButtonShadow
                        anchors.fill: parent
                        anchors.margins: -2
                        radius: 26
                        color: appTheme.shadowColor
                        z: -1
                    }

                    Text {
                        anchors.centerIn: parent
                        text: translations.t("cancel")
                        color: appTheme.textColor
                        font {
                            family: "Inter"
                            pixelSize: 17
                            weight: Font.Bold
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: closeWindowAnimation.start()
                        onEntered: cancelButton.scale = 1.05
                        onExited: cancelButton.scale = 1.0
                    }

                    Behavior on scale {
                        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                    }
                }
            }
        }
    }

    Dialog {
        id: confirmExitDialog
        title: translations.t("unsavedChanges")
        standardButtons: Dialog.Yes | Dialog.No
        anchors.centerIn: parent
        width: 300

        contentItem: Text {
            text: translations.t("confirmExit")
            color: appTheme.textColor
            wrapMode: Text.WordWrap
        }

        onAccepted: {
            savedSettings.savedTheme = themeIndex
            savedSettings.savedLanguage = isEnglish
            themeChanged(themeIndex)
            languageChanged(isEnglish)
            soundSettings.applyAudioSettings()
            screenSettings.applyScreenSettings()
            settingsWindow.close()
        }

        onRejected: {
            closeWindowAnimation.start()
        }
    }

    SequentialAnimation {
        id: closeWindowAnimation
        NumberAnimation {
            target: mainBackground
            property: "opacity"
            to: 0
            duration: 200
            easing.type: Easing.InQuad
        }
        ScriptAction { script: settingsWindow.close() }
    }

    signal themeChanged(int newTheme)
    signal languageChanged(bool newIsEnglish)

    Component.onCompleted: {
        themeChanged(themeIndex)
        languageChanged(isEnglish)

        var screenCenter = Qt.point(Screen.width / 2, Screen.height / 2)
        var windowCenter = Qt.point(width / 2, height / 2)
        x = screenCenter.x - windowCenter.x
        y = screenCenter.y - windowCenter.y
    }
}
