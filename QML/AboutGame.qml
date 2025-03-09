import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import Qt5Compat.GraphicalEffects

Window {
    id: aboutWindow
    width: 620
    height: 800
    minimumWidth: 620
    minimumHeight: 800
    maximumWidth: 620
    maximumHeight: 800
    flags: Qt.Window | Qt.FramelessWindowHint
    modality: Qt.ApplicationModal
    title: isEnglish ? "About Game" : "Об игре"
    color: "transparent"

    signal closing()

    property int themeIndex: 0
    property bool isEnglish: true
    property bool headerHovered: false

    Theme {
        id: theme
        themeIndex: aboutWindow.themeIndex
    }

    QtObject {
        id: aboutTranslations
        property var texts: ({
            "title": {
                "en": "15 Puzzle - Classic Sliding Puzzle Game",
                "ru": "Пятнашки - Игра-Головоломка"
            },
            "history": {
                "en": "History",
                "ru": "История"
            },
            "historyText": {
                "en": "The 15 puzzle (also called Gem Puzzle, Boss Puzzle, Game of Fifteen, Mystic Square) is a sliding puzzle that consists of a frame of numbered square tiles in random order with one tile missing. The puzzle was invented in the 1870s and became a worldwide craze in 1880.\n\nNoyes Chapman, who invented the puzzle, had shown the puzzle to puzzlemaker Sam Loyd who popularized it in articles he wrote. The puzzle's popularity peaked around 1880, and by 1900 it was generally well-known internationally.",
                "ru": "Игра в 15 (также известная как Пятнашки, Игра в такси) — классическая головоломка, придуманная в 1878 году почтмейстером из Нью-Йорка Ноем Чепменом. Представляет собой набор одинаковых квадратных костяшек с нанесёнными числами, заключённых в квадратную коробку.\n\nНой Чепмен, который изобрел головоломку, показал ее головоломщику Сэму Лойду, который популяризировал ее в своих статьях. Популярность головоломки достигла пика около 1880 года, а к 1900 году она была широко известна во всем мире."
            },
            "howToPlay": {
                "en": "How To Play",
                "ru": "Как Играть"
            },
            "howToPlayText": {
                "en": "The goal of the puzzle is to arrange the tiles in numerical order (from left to right, top to bottom) by sliding them one at a time into the empty space.\n\nOnly tiles adjacent to the empty space can be moved. A tile can be moved only if it's directly next to the empty position (horizontally or vertically, not diagonally).",
                "ru": "Цель головоломки — перемещая костяшки по коробке, добиться упорядочивания их по номерам (слева направо, сверху вниз), желательно сделав как можно меньше перемещений.\n\nПеремещать можно только костяшки, которые прилегают к пустому месту. Костяшку можно передвинуть только в том случае, если она находится непосредственно рядом с пустой позицией (по горизонтали или вертикали, но не по диагонали)."
            },
            "features": {
                "en": "Game Features",
                "ru": "Особенности Игры"
            },
            "featuresText": {
                "en": "• Multiple themes to customize your experience\n• Track your time and number of moves\n• Ability to pause and resume your game\n• Available in multiple languages\n• Simple yet challenging gameplay suitable for all ages",
                "ru": "• Несколько тем для настройки внешнего вида\n• Отслеживание времени и количества ходов\n• Возможность приостановить и возобновить игру\n• Доступно на нескольких языках\n• Простой, но увлекательный игровой процесс, подходящий для всех возрастов"
            },
            "funFacts": {
                "en": "Fun Facts",
                "ru": "Интересные Факты"
            },
            "funFactsText": {
                "en": "• There are more than 10 trillion possible arrangements of the tiles in the game, but only half of them are solvable.\n• The 15 puzzle has been used in cognitive psychology research to study problem-solving.\n• Digital versions of the 15 puzzle have been included on many computing platforms, from early programmable calculators to modern smartphones.",
                "ru": "• Существует более 10 триллионов возможных расположений плиток в игре, но только половина из них разрешима.\n• Головоломка «Пятнашки» использовалась в исследованиях когнитивной психологии для изучения решения проблем.\n• Цифровые версии игры «Пятнашки» были включены во многие вычислительные платформы, от ранних программируемых калькуляторов до современных смартфонов."
            },
            "close": {
                "en": "Close",
                "ru": "Закрыть"
            },
            "author": {
                "en": "About Author",
                "ru": "Об Авторе"
            },
            "authorText": {
                "en": "This game was created with love for classic puzzles and programming. If you enjoy playing it, feel free to share it with your friends and family!",
                "ru": "Эта игра была создана с любовью к классическим головоломкам и программированию. Если вам нравится играть, не стесняйтесь поделиться игрой с друзьями и семьей!"
            },
            "share": {
                "en": "Share",
                "ru": "Поделиться"
            },
            "rateGame": {
                "en": "Rate Game",
                "ru": "Оценить Игру"
            },
            "feedback": {
                "en": "Send Feedback",
                "ru": "Отправить Отзыв"
            },
            "socialLinks": {
                "en": "Social Links",
                "ru": "Социальные Сети"
            }
        })

        function t(key) {
            return texts[key][isEnglish ? "en" : "ru"]
        }
    }

    Rectangle {
        id: windowBackground
        anchors.fill: parent
        color: theme.windowColor
        radius: 20
        border.width: 1
        border.color: theme.tileBorderColor

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
            id: windowHeader
            width: parent.width
            height: 40
            color: theme.timerCounterTextColor
            radius: 20

            Rectangle {
                width: parent.width
                height: parent.height - radius
                color: theme.timerCounterTextColor
                anchors.bottom: parent.bottom
            }

            Text {
                text: isEnglish ? "About Game" : "Об игре"
                color: theme.windowColor
                font {
                    family: "Source Sans Pro"
                    pixelSize: 16
                    bold: true
                }
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 15
            }

            Row {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 10
                spacing: 10

                Rectangle {
                    id: minimizeButton
                    width: 24
                    height: 24
                    radius: 12
                    color: minimizeArea.containsMouse ? Qt.lighter(theme.windowColor, 1.1) : theme.windowColor

                    Text {
                        text: "−"
                        anchors.centerIn: parent
                        color: theme.timerCounterTextColor
                        font.pixelSize: 18
                        font.bold: true
                    }

                    MouseArea {
                        id: minimizeArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: aboutWindow.showMinimized()
                    }
                }

                Rectangle {
                    id: closeButton
                    width: 24
                    height: 24
                    radius: 12
                    color: closeArea.containsMouse ? "#FF6B6B" : theme.windowColor

                    Text {
                        text: "×"
                        anchors.centerIn: parent
                        color: closeArea.containsMouse ? "white" : theme.timerCounterTextColor
                        font.pixelSize: 18
                        font.bold: true
                    }

                    MouseArea {
                        id: closeArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            aboutWindow.closing()
                            aboutWindow.close()
                        }
                    }
                }
            }

            MouseArea {
                id: dragArea
                anchors.fill: parent
                anchors.rightMargin: 60  // Make room for window control buttons
                property point startPoint: Qt.point(0, 0)

                onPressed: function(mouse) {
                    startPoint = Qt.point(mouse.x, mouse.y)
                }

                onPositionChanged: function(mouse) {
                    if (pressed) {
                        var delta = Qt.point(mouse.x - startPoint.x, mouse.y - startPoint.y)
                        aboutWindow.x += delta.x
                        aboutWindow.y += delta.y
                    }
                }
            }
        }

        Item {
            id: customScrollView
            anchors.top: windowHeader.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 20
            clip: true

            Flickable {
                id: flickable
                anchors.fill: parent
                contentWidth: contentColumn.width
                contentHeight: contentColumn.height
                boundsBehavior: Flickable.StopAtBounds

                Column {
                    id: contentColumn
                    width: customScrollView.width
                    spacing: 20

                    Rectangle {
                        width: parent.width
                        height: 70
                        color: theme.gameBoardBackgroundColor
                        radius: 18

                        layer.enabled: true
                        layer.effect: DropShadow {
                            transparentBorder: true
                            horizontalOffset: 3
                            verticalOffset: 3
                            radius: 8
                            samples: 16
                            color: "#66000000"
                        }

                        Text {
                            id: titleText
                            anchors.centerIn: parent
                            text: aboutTranslations.t("title")
                            font {
                                family: "Source Sans Pro"
                                pixelSize: 26
                                bold: true
                            }
                            color: theme.timerCounterTextColor
                        }

                        SequentialAnimation {
                            running: true
                            loops: Animation.Infinite
                            PropertyAnimation {
                                target: titleText
                                property: "scale"
                                from: 1.0
                                to: 1.05
                                duration: 2000
                                easing.type: Easing.InOutQuad
                            }
                            PropertyAnimation {
                                target: titleText
                                property: "scale"
                                from: 1.05
                                to: 1.0
                                duration: 2000
                                easing.type: Easing.InOutQuad
                            }
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: width * 0.6
                        color: "transparent"

                        Image {
                            id: gameplayImage
                            source: "qrc:/Img/GamePlay.png"
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectFit

                            layer.enabled: true
                            layer.effect: DropShadow {
                                transparentBorder: true
                                horizontalOffset: 3
                                verticalOffset: 3
                                radius: 8
                                samples: 16
                                color: "#66000000"
                            }

                            Rectangle {
                                id: imageOverlay
                                anchors.fill: parent
                                color: theme.tileBorderColor
                                opacity: 0
                                radius: 12

                                Text {
                                    anchors.centerIn: parent
                                    text: isEnglish ? "Tap to play game preview" : "Нажмите для предпросмотра игры"
                                    color: theme.windowColor
                                    font.pixelSize: 18
                                    font.bold: true
                                    opacity: imageOverlay.opacity * 2
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: {
                                    imageHoverAnimation.start()
                                    imageOverlayAnimation.start()
                                }
                                onExited: {
                                    imageExitAnimation.start()
                                    imageOverlayExitAnimation.start()
                                }
                                onClicked: {
                                }
                            }

                            PropertyAnimation {
                                id: imageHoverAnimation
                                target: gameplayImage
                                property: "scale"
                                to: 1.02
                                duration: 200
                                easing.type: Easing.OutQuad
                            }

                            PropertyAnimation {
                                id: imageExitAnimation
                                target: gameplayImage
                                property: "scale"
                                to: 1.0
                                duration: 200
                                easing.type: Easing.OutQuad
                            }

                            PropertyAnimation {
                                id: imageOverlayAnimation
                                target: imageOverlay
                                property: "opacity"
                                to: 0.4
                                duration: 200
                                easing.type: Easing.OutQuad
                            }

                            PropertyAnimation {
                                id: imageOverlayExitAnimation
                                target: imageOverlay
                                property: "opacity"
                                to: 0
                                duration: 200
                                easing.type: Easing.OutQuad
                            }
                        }
                    }

                    ContentSection {
                        width: contentColumn.width
                        sectionTitle: aboutTranslations.t("history")
                        sectionContent: aboutTranslations.t("historyText")
                        theme: theme
                    }

                    ContentSection {
                        width: contentColumn.width
                        sectionTitle: aboutTranslations.t("howToPlay")
                        sectionContent: aboutTranslations.t("howToPlayText")
                        theme: theme
                    }

                    ContentSection {
                        width: contentColumn.width
                        sectionTitle: aboutTranslations.t("features")
                        sectionContent: aboutTranslations.t("featuresText")
                        theme: theme
                    }

                    Text {
                        text: isEnglish ? "Theme Previews" : "Варианты Тем"
                        font {
                            family: "Source Sans Pro"
                            pixelSize: 20
                            bold: true
                        }
                        color: theme.timerCounterTextColor
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Rectangle {
                        width: parent.width
                        height: themeImagesRow.height + 20
                        color: theme.gameBoardBackgroundColor
                        radius: 16

                        Row {
                            id: themeImagesRow
                            anchors.centerIn: parent
                            width: parent.width - 30
                            spacing: 15

                            Repeater {
                                model: [
                                    {src: "qrc:/Img/ScreenLight", title: isEnglish ? "Light Theme" : "Светлая Тема"},
                                    {src: "qrc:/Img/ScreenDark", title: isEnglish ? "Dark Theme" : "Тёмная Тема"},
                                    {src: "qrc:/Img/ScreenColorful", title: isEnglish ? "Colorful Theme" : "Цветная Тема"}
                                ]

                                delegate: Item {
                                    id: themeItem
                                    width: (themeImagesRow.width - 30) / 3
                                    height: width * 0.9

                                    property bool hovered: false

                                    Rectangle {
                                        id: themeImageContainer
                                        anchors.fill: parent
                                        color: "transparent"
                                        border.color: themeItem.hovered ? theme.highlightColor : "transparent"
                                        border.width: 2
                                        radius: 12

                                        Image {
                                            id: themeImage
                                            source: modelData.src
                                            anchors.fill: parent
                                            anchors.margins: 5
                                            fillMode: Image.PreserveAspectFit

                                            layer.enabled: true
                                            layer.effect: DropShadow {
                                                transparentBorder: true
                                                horizontalOffset: 2
                                                verticalOffset: 2
                                                radius: 6
                                                samples: 12
                                                color: "#66000000"
                                            }
                                        }

                                        Rectangle {
                                            anchors.bottom: parent.bottom
                                            width: parent.width
                                            height: themeTitle.contentHeight + 10
                                            color: theme.counterBackgroundColor
                                            opacity: themeItem.hovered ? 0.9 : 0
                                            radius: 8

                                            Behavior on opacity {
                                                NumberAnimation { duration: 200 }
                                            }

                                            Text {
                                                id: themeTitle
                                                anchors.centerIn: parent
                                                text: modelData.title
                                                color: theme.counterTextColor
                                                font {
                                                    family: "Source Sans Pro"
                                                    pixelSize: 14
                                                    bold: true
                                                }
                                            }
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            onEntered: themeItem.hovered = true
                                            onExited: themeItem.hovered = false
                                            onClicked: {
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        layer.enabled: true
                        layer.effect: DropShadow {
                            transparentBorder: true
                            horizontalOffset: 2
                            verticalOffset: 2
                            radius: 6
                            samples: 12
                            color: "#66000000"
                        }
                    }

                    ContentSection {
                        width: contentColumn.width
                        sectionTitle: aboutTranslations.t("funFacts")
                        sectionContent: aboutTranslations.t("funFactsText")
                        theme: theme
                    }

                    ContentSection {
                        width: contentColumn.width
                        sectionTitle: aboutTranslations.t("author")
                        sectionContent: aboutTranslations.t("authorText")
                        theme: theme
                    }

                    Rectangle {
                        width: parent.width
                        height: socialButtons.height + 80
                        color: theme.gameBoardBackgroundColor
                        radius: 18

                        layer.enabled: true
                        layer.effect: DropShadow {
                            transparentBorder: true
                            horizontalOffset: 2
                            verticalOffset: 2
                            radius: 6
                            samples: 12
                            color: "#66000000"
                        }

                        Column {
                            id: socialColumn
                            anchors.centerIn: parent
                            spacing: 30
                            width: parent.width

                            Text {
                                text: aboutTranslations.t("socialLinks")
                                font {
                                    family: "Source Sans Pro"
                                    pixelSize: 20
                                    bold: true
                                }
                                color: theme.timerCounterTextColor
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Row {
                                id: socialButtons
                                spacing: 25
                                anchors.horizontalCenter: parent.horizontalCenter
                                layoutDirection: Qt.LeftToRight

                                SocialButton {
                                    iconText: "✉️"
                                    buttonText: aboutTranslations.t("feedback")
                                }

                                SocialButton {
                                    iconText: "★"
                                    buttonText: aboutTranslations.t("rateGame")
                                }

                                SocialButton {
                                    iconText: "🔗"
                                    buttonText: aboutTranslations.t("share")
                                }
                            }
                        }
                    }

                    Rectangle {
                        id: actionButton
                        width: 220
                        height: 55
                        radius: 18
                        color: actionArea.pressed ? Qt.darker(theme.counterBackgroundColor, 1.1) : theme.counterBackgroundColor
                        border { color: theme.tileBorderColor; width: 2 }
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.topMargin: 50

                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }

                        Text {
                            id: actionText
                            anchors.centerIn: parent
                            text: aboutTranslations.t("close")
                            color: theme.counterTextColor
                            font {
                                family: "Source Sans Pro"
                                pixelSize: 18
                                bold: true
                            }
                        }

                        MouseArea {
                            id: actionArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                aboutWindow.closing()
                                aboutWindow.close()
                            }
                        }

                        states: State {
                            name: "hovered"
                            when: actionArea.containsMouse && !actionArea.pressed
                            PropertyChanges {
                                target: actionButton
                                scale: 1.05
                                border.color: theme.highlightColor
                                border.width: 3
                            }
                            PropertyChanges {
                                target: actionText
                                color: theme.highlightColor
                                scale: 1.05
                            }
                        }

                        transitions: Transition {
                            from: ""; to: "hovered"; reversible: true
                            ParallelAnimation {
                                NumberAnimation { properties: "scale"; duration: 200; easing.type: Easing.OutQuad }
                                ColorAnimation { properties: "color, border.color"; duration: 200 }
                                NumberAnimation { properties: "border.width"; duration: 200 }
                            }
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
                    }

                    Item {
                        width: parent.width
                        height: 30
                    }
                }
            }

            Rectangle {
                id: scrollIndicator
                width: 8
                radius: 4
                color: theme.tileBorderColor
                opacity: flickable.moving || scrollbarArea.containsMouse ? 1.0 : 0.5

                height: Math.max(40, flickable.height * (flickable.height / flickable.contentHeight))
                y: flickable.contentY * (flickable.height / flickable.contentHeight)

                anchors.right: customScrollView.right
                anchors.rightMargin: 2

                visible: flickable.contentHeight > flickable.height

                Behavior on opacity {
                    NumberAnimation { duration: 200 }
                }

                MouseArea {
                    id: scrollbarArea
                    anchors.fill: parent
                    anchors.margins: -5
                    hoverEnabled: true
                    drag {
                        target: parent
                        axis: Drag.YAxis
                        minimumY: 0
                        maximumY: flickable.height - scrollIndicator.height
                    }

                    onMouseYChanged: {
                        if (pressed) {
                            flickable.contentY = scrollIndicator.y * (flickable.contentHeight / flickable.height)
                        }
                    }
                }
            }
        }
    }

    component ContentSection: Rectangle {
        id: section
        property string sectionTitle: "Title"
        property string sectionContent: "Content"
        property var theme

        height: contentLayout.height + 40
        color: theme.gameBoardBackgroundColor
        radius: 18

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 2
            radius: 6
            samples: 12
            color: "#66000000"
        }

        states: State {
            name: "hovered"
            when: sectionArea.containsMouse
            PropertyChanges {
                target: section
                scale: 1.01
            }
            PropertyChanges {
                target: titleText
                color: theme.highlightColor
            }
        }

        transitions: Transition {
            from: ""; to: "hovered"; reversible: true
            ParallelAnimation {
                NumberAnimation { properties: "scale"; duration: 200; easing.type: Easing.OutQuad }
                ColorAnimation { properties: "color"; duration: 200 }
            }
        }

        MouseArea {
            id: sectionArea
            anchors.fill: parent
            hoverEnabled: true
        }

        Column {
            id: contentLayout
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: 20
            }
            spacing: 15

            Text {
                id: titleText1
                text: sectionTitle
                font {
                    family: "Source Sans Pro"
                    pixelSize: 22
                    bold: true
                }
                color: theme.timerCounterTextColor
            }

            Rectangle {
                width: parent.width
                height: 2
                color: theme.tileBorderColor
                radius: 1
            }

            Text {
                id: contentText
                width: parent.width
                text: sectionContent
                wrapMode: Text.WordWrap
                lineHeight: 1.4
                font {
                    family: "Source Sans Pro"
                    pixelSize: 16
                }
                color: theme.counterTextColor
            }
        }
    }

    component SocialButton: Rectangle {
        property string iconText: "🌟"
        property string buttonText: "Button"

        width: 150
        height: 40
        radius: 12
        color: btnArea.containsMouse ? Qt.lighter(theme.counterBackgroundColor, 1.1) : theme.counterBackgroundColor
        border { color: theme.tileBorderColor; width: 1 }

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 2
            radius: 6
            samples: 12
            color: "#66000000"
        }

        Behavior on color {
            ColorAnimation { duration: 150 }
        }

        Row {
            anchors.centerIn: parent
            spacing: 8

            Text {
                text: iconText
                font.pixelSize: 16
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: buttonText
                color: theme.counterTextColor
                font {
                    family: "Source Sans Pro"
                    pixelSize: 14
                    bold: true
                }
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        MouseArea {
            id: btnArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                console.log("Social button clicked: " + buttonText)
            }
        }

        states: [
            State {
                name: "hovered"
                when: btnArea.containsMouse
                PropertyChanges {
                    target: parent
                    scale: 1.05
                }
            }
        ]

        transitions: [
            Transition {
                from: ""
                to: "hovered"
                reversible: true
                NumberAnimation {
                    properties: "scale"
                    duration: 150
                    easing.type: Easing.OutQuad
                }
            }
        ]
    }
}
