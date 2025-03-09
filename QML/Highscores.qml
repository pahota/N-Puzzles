import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt.labs.settings 1.0
import Qt5Compat.GraphicalEffects

Rectangle {
    id: highscoresWindow
    width: parent ? parent.width * 0.8 : 500
    height: parent ? parent.height * 0.85 : 600
    anchors.centerIn: parent
    color: theme.windowColor
    radius: 10

    property int themeIndex: 0
    property bool isEnglish: true
    property int maxHighscores: 10
    property var categories: ["all", "easy", "normal", "hard"]
    property string currentCategory: "all"
    property bool canExport: true
    property QtObject translations
    signal closed()

    Settings {
        id: highscoresSettings
        category: "Highscores"
        property var scores: []
    }

    Rectangle {
        id: closeButtonRect
        width: 30
        height: 30
        radius: width / 2
        color: closeMouseArea.containsMouse ? Qt.darker(theme.counterBackgroundColor, 1.2) : theme.counterBackgroundColor
        anchors {
            top: parent.top
            right: parent.right
            topMargin: 10
            rightMargin: 10
        }

        Text {
            text: translations.t("closeWindow")
            color: theme.counterTextColor
            font.pixelSize: 16
            font.bold: true
            anchors.centerIn: parent
        }

        MouseArea {
            id: closeMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: highscoresWindow.closed()

            PropertyAnimation {
                target: closeButtonRect
                property: "scale"
                to: closeMouseArea.pressed ? 0.9 : closeMouseArea.containsMouse ? 1.1 : 1.0
                duration: 150
                easing.type: Easing.OutQuad
                running: true
            }
        }

        Behavior on color {
            ColorAnimation { duration: 150 }
        }
    }

    Rectangle {
        id: headerBackground
        width: parent.width
        height: parent.height * 0.12
        color: theme.counterBackgroundColor
        radius: 10

        Text {
            id: headerText
            text: translations.t("highscores")
            anchors.centerIn: parent
            color: theme.counterTextColor
            font {
                family: "Source Sans Pro"
                pixelSize: parent.height * 0.4
                bold: true
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

    Row {
        id: categorySelector
        anchors {
            top: headerBackground.bottom
            topMargin: 15
            horizontalCenter: parent.horizontalCenter
        }
        spacing: 20

        Repeater {
            model: categories

            Item {
                width: 120
                height: 35

                property bool isSelected: currentCategory === modelData

                Rectangle {
                    id: categoryButtonBg
                    anchors.fill: parent
                    radius: 5
                    color: isSelected ? theme.tileBorderColor : theme.counterBackgroundColor
                    border.width: 1
                    border.color: theme.tileBorderColor

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }

                    scale: categoryMouseArea.pressed ? 0.95 : categoryMouseArea.containsMouse ? 1.05 : 1.0

                    Behavior on scale {
                        NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: translations.t(modelData)
                    font.family: "Source Sans Pro"
                    font.pixelSize: 14
                    color: isSelected ? theme.windowColor : theme.counterTextColor
                }

                MouseArea {
                    id: categoryMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        currentCategory = modelData
                        filterScores()
                    }
                }
            }
        }
    }

    Rectangle {
        id: tableContainer
        width: parent.width * 0.9
        height: parent.height * 0.55
        color: theme.gameBoardBackgroundColor
        radius: 10
        anchors {
            top: categorySelector.bottom
            topMargin: 15
            horizontalCenter: parent.horizontalCenter
        }
        border {
            color: theme.tileBorderColor
            width: 1
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

        ListView {
            id: highscoresList
            anchors {
                fill: parent
                margins: 10
            }
            clip: true
            model: ListModel {
                id: scoresModel
            }

            header: Rectangle {
                width: highscoresList.width
                height: 50
                color: theme.tileBorderColor
                radius: 5

                Row {
                    anchors.fill: parent

                    Text {
                        width: parent.width * 0.1
                        height: parent.height
                        text: translations.t("rank")
                        color: theme.windowColor
                        font {
                            family: "Source Sans Pro"
                            pixelSize: 16
                            bold: true
                        }
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    Text {
                        width: parent.width * 0.25
                        height: parent.height
                        text: translations.t("player")
                        color: theme.windowColor
                        font {
                            family: "Source Sans Pro"
                            pixelSize: 16
                            bold: true
                        }
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    Text {
                        width: parent.width * 0.15
                        height: parent.height
                        text: translations.t("time")
                        color: theme.windowColor
                        font {
                            family: "Source Sans Pro"
                            pixelSize: 16
                            bold: true
                        }
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    Text {
                        width: parent.width * 0.15
                        height: parent.height
                        text: translations.t("moves")
                        color: theme.windowColor
                        font {
                            family: "Source Sans Pro"
                            pixelSize: 16
                            bold: true
                        }
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    Text {
                        width: parent.width * 0.2
                        height: parent.height
                        text: translations.t("date")
                        color: theme.windowColor
                        font {
                            family: "Source Sans Pro"
                            pixelSize: 16
                            bold: true
                        }
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    Text {
                        width: parent.width * 0.15
                        height: parent.height
                        text: translations.t("difficulty")
                        color: theme.windowColor
                        font {
                            family: "Source Sans Pro"
                            pixelSize: 16
                            bold: true
                        }
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }

            delegate: Rectangle {
                width: highscoresList.width
                height: 45
                color: index % 2 === 0 ? theme.counterBackgroundColor : Qt.darker(theme.counterBackgroundColor, 1.05)
                radius: 3

                Row {
                    anchors.fill: parent

                    Text {
                        width: parent.width * 0.1
                        height: parent.height
                        text: index + 1
                        color: theme.counterTextColor
                        font {
                            family: "Source Sans Pro"
                            pixelSize: 16
                        }
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    Text {
                        width: parent.width * 0.25
                        height: parent.height
                        text: name
                        color: theme.counterTextColor
                        font {
                            family: "Source Sans Pro"
                            pixelSize: 16
                        }
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }

                    Text {
                        width: parent.width * 0.15
                        height: parent.height
                        text: time
                        color: theme.counterTextColor
                        font {
                            family: "Source Sans Pro"
                            pixelSize: 16
                        }
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    Text {
                        width: parent.width * 0.15
                        height: parent.height
                        text: moves
                        color: theme.counterTextColor
                        font {
                            family: "Source Sans Pro"
                            pixelSize: 16
                        }
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    Text {
                        width: parent.width * 0.2
                        height: parent.height
                        text: date
                        color: theme.counterTextColor
                        font {
                            family: "Source Sans Pro"
                            pixelSize: 16
                        }
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    Text {
                        width: parent.width * 0.15
                        height: parent.height
                        text: translations.t(difficulty)
                        color: theme.counterTextColor
                        font {
                            family: "Source Sans Pro"
                            pixelSize: 16
                        }
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onDoubleClicked: {
                        showScoreDetails(index)
                    }
                }
            }

            Text {
                anchors.centerIn: parent
                text: translations.t("noRecords")
                visible: scoresModel.count === 0
                color: theme.counterTextColor
                font {
                    family: "Source Sans Pro"
                    pixelSize: 18
                }
            }
        }
    }

    Row {
        id: buttonRow
        anchors {
            top: tableContainer.bottom
            topMargin: 20
            horizontalCenter: parent.horizontalCenter
        }
        spacing: 20

        Item {
            width: 120
            height: 40

            Rectangle {
                id: clearButtonBg
                anchors.fill: parent
                radius: 5
                color: theme.counterBackgroundColor
                border.width: 1
                border.color: theme.tileBorderColor

                scale: clearMouseArea.pressed ? 0.95 : clearMouseArea.containsMouse ? 1.05 : 1.0

                Behavior on scale {
                    NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
                }

                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    horizontalOffset: clearMouseArea.containsMouse ? 2 : 1
                    verticalOffset: clearMouseArea.containsMouse ? 2 : 1
                    radius: clearMouseArea.containsMouse ? 6 : 3
                    samples: 12
                    color: "#33000000"
                }
            }

            Text {
                anchors.centerIn: parent
                text: translations.t("clearAll")
                font.family: "Source Sans Pro"
                font.pixelSize: 16
                color: theme.counterTextColor
            }

            MouseArea {
                id: clearMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: confirmClearDialog.open()
            }
        }

        Item {
            width: 120
            height: 40
            visible: canExport

            Rectangle {
                id: exportButtonBg
                anchors.fill: parent
                radius: 5
                color: theme.counterBackgroundColor
                border.width: 1
                border.color: theme.tileBorderColor

                scale: exportMouseArea.pressed ? 0.95 : exportMouseArea.containsMouse ? 1.05 : 1.0

                Behavior on scale {
                    NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
                }

                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    horizontalOffset: exportMouseArea.containsMouse ? 2 : 1
                    verticalOffset: exportMouseArea.containsMouse ? 2 : 1
                    radius: exportMouseArea.containsMouse ? 6 : 3
                    samples: 12
                    color: "#33000000"
                }
            }

            Text {
                anchors.centerIn: parent
                text: translations.t("export")
                font.family: "Source Sans Pro"
                font.pixelSize: 16
                color: theme.counterTextColor
            }

            MouseArea {
                id: exportMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: exportScores()
            }
        }

        Item {
            width: 120
            height: 40

            Rectangle {
                id: shareButtonBg
                anchors.fill: parent
                radius: 5
                color: theme.counterBackgroundColor
                border.width: 1
                border.color: theme.tileBorderColor

                scale: shareMouseArea.pressed ? 0.95 : shareMouseArea.containsMouse ? 1.05 : 1.0

                Behavior on scale {
                    NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
                }

                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    horizontalOffset: shareMouseArea.containsMouse ? 2 : 1
                    verticalOffset: shareMouseArea.containsMouse ? 2 : 1
                    radius: shareMouseArea.containsMouse ? 6 : 3
                    samples: 12
                    color: "#33000000"
                }
            }

            Text {
                anchors.centerIn: parent
                text: translations.t("share")
                font.family: "Source Sans Pro"
                font.pixelSize: 16
                color: theme.counterTextColor
            }

            MouseArea {
                id: shareMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: shareScores()
            }
        }

        Item {
            width: 120
            height: 40

            Rectangle {
                id: backButtonBg
                anchors.fill: parent
                radius: 5
                color: theme.counterBackgroundColor
                border.width: 1
                border.color: theme.tileBorderColor

                scale: backMouseArea.pressed ? 0.95 : backMouseArea.containsMouse ? 1.05 : 1.0

                Behavior on scale {
                    NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
                }

                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    horizontalOffset: backMouseArea.containsMouse ? 2 : 1
                    verticalOffset: backMouseArea.containsMouse ? 2 : 1
                    radius: backMouseArea.containsMouse ? 6 : 3
                    samples: 12
                    color: "#33000000"
                }
            }

            Text {
                anchors.centerIn: parent
                text: translations.t("back")
                font.family: "Source Sans Pro"
                font.pixelSize: 16
                color: theme.counterTextColor
            }

            MouseArea {
                id: backMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: highscoresWindow.visible = false
            }
        }
    }

    Dialog {
        id: nameInputDialog
        modal: true
        anchors.centerIn: parent
        closePolicy: Popup.CloseOnEscape
        width: parent.width * 0.5
        height: parent.height * 0.3

        property int timeScore: 0
        property int movesScore: 0
        property string difficultyLevel: "normal"

        background: Rectangle {
            color: theme.counterBackgroundColor
            radius: 10
            border {
                color: theme.tileBorderColor
                width: 2
            }
        }

        header: Rectangle {
            width: parent.width
            height: 50
            color: "transparent"

            Text {
                anchors.centerIn: parent
                text: translations.t("congrats")
                color: theme.counterTextColor
                font {
                    family: "Source Sans Pro"
                    pixelSize: 20
                    bold: true
                }
            }
        }

        contentItem: Column {
            spacing: 15
            padding: 20

            Text {
                text: translations.t("enterName")
                color: theme.counterTextColor
                font {
                    family: "Source Sans Pro"
                    pixelSize: 16
                }
            }

            TextField {
                id: nameInput
                width: parent.width
                placeholderText: "Player"
                color: theme.counterTextColor

                background: Rectangle {
                    color: theme.gameBoardBackgroundColor
                    radius: 5
                    border {
                        width: 1
                        color: theme.tileBorderColor
                    }
                }
            }
        }

        footer: DialogButtonBox {
            Button {
                text: translations.t("save")
                DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
            }

            Button {
                text: translations.t("cancel")
                DialogButtonBox.buttonRole: DialogButtonBox.RejectRole
            }

            onAccepted: {
                saveHighscore(nameInput.text || "Player", nameInputDialog.timeScore, nameInputDialog.movesScore, nameInputDialog.difficultyLevel)
                nameInputDialog.close()
            }

            onRejected: {
                nameInputDialog.close()
            }
        }
    }

    Dialog {
        id: scoreDetailsDialog
        modal: true
        anchors.centerIn: parent
        width: parent.width * 0.6
        height: parent.height * 0.4

        property string playerName: ""
        property string playerTime: ""
        property int playerMoves: 0
        property string playerDate: ""
        property string playerDifficulty: ""

        background: Rectangle {
            color: theme.counterBackgroundColor
            radius: 10
            border {
                color: theme.tileBorderColor
                width: 2
            }
        }

        header: Rectangle {
            width: parent.width
            height: 50
            color: "transparent"

            Text {
                anchors.centerIn: parent
                text: playerName
                color: theme.counterTextColor
                font {
                    family: "Source Sans Pro"
                    pixelSize: 20
                    bold: true
                }
            }
        }

        contentItem: Column {
            spacing: 15
            padding: 20

            Grid {
                columns: 2
                spacing: 10
                width: parent.width

                Text {
                    text: translations.t("time") + ":"
                    color: theme.counterTextColor
                    font {
                        family: "Source Sans Pro"
                        pixelSize: 16
                        bold: true
                    }
                }

                Text {
                    text: playerTime
                    color: theme.counterTextColor
                    font {
                        family: "Source Sans Pro"
                        pixelSize: 16
                    }
                }

                Text {
                    text: translations.t("moves") + ":"
                    color: theme.counterTextColor
                    font {
                        family: "Source Sans Pro"
                        pixelSize: 16
                        bold: true
                    }
                }

                Text {
                    text: playerMoves
                    color: theme.counterTextColor
                    font {
                        family: "Source Sans Pro"
                        pixelSize: 16
                    }
                }

                Text {
                    text: translations.t("date") + ":"
                    color: theme.counterTextColor
                    font {
                        family: "Source Sans Pro"
                        pixelSize: 16
                        bold: true
                    }
                }

                Text {
                    text: playerDate
                    color: theme.counterTextColor
                    font {
                        family: "Source Sans Pro"
                        pixelSize: 16
                    }
                }

                Text {
                    text: translations.t("difficulty") + ":"
                    color: theme.counterTextColor
                    font {
                        family: "Source Sans Pro"
                        pixelSize: 16
                        bold: true
                    }
                }

                Text {
                    text: translations.t(playerDifficulty)
                    color: theme.counterTextColor
                    font {
                        family: "Source Sans Pro"
                        pixelSize: 16
                    }
                }
            }
        }

        footer: DialogButtonBox {
            Button {
                text: translations.t("back")
                DialogButtonBox.buttonRole: DialogButtonBox.RejectRole
            }

            onRejected: {
                scoreDetailsDialog.close()
            }
        }
    }

    Dialog {
        id: confirmClearDialog
        modal: true
        anchors.centerIn: parent
        width: parent.width * 0.5

        background: Rectangle {
            color: theme.counterBackgroundColor
            radius: 10
            border {
                color: theme.tileBorderColor
                width: 2
            }
        }

        contentItem: Text {
            padding: 20
            text: isEnglish ? "Are you sure you want to clear all highscores?" : "Вы уверены, что хотите удалить все рекорды?"
            color: theme.counterTextColor
            font {
                family: "Source Sans Pro"
                pixelSize: 16
            }
            horizontalAlignment: Text.AlignHCenter
        }

        footer: DialogButtonBox {
            Button {
                text: isEnglish ? "Yes" : "Да"
                DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
            }

            Button {
                text: isEnglish ? "No" : "Нет"
                DialogButtonBox.buttonRole: DialogButtonBox.RejectRole
            }

            onAccepted: {
                highscoresSettings.scores = []
                loadScores()
                confirmClearDialog.close()
            }

            onRejected: {
                confirmClearDialog.close()
            }
        }
    }

    Component.onCompleted: {
        loadScores()
    }

    function loadScores() {
        var scores = highscoresSettings.scores || []
        filterScores()
    }

    function filterScores() {
        scoresModel.clear()
        var scores = highscoresSettings.scores || []

        if (scores && scores.length > 0) {
            var filteredScores = currentCategory === "all"
                ? scores
                : scores.filter(function(score) {
                    return score.difficulty === currentCategory
                })

            for (var i = 0; i < filteredScores.length; i++) {
                scoresModel.append(filteredScores[i])
            }
        }
    }

    function saveHighscore(playerName, time, moves, difficulty) {
        var scores = highscoresSettings.scores || []
        var date = new Date()
        var formattedDate = date.toLocaleDateString()
        var formattedTime = formatTime(time)

        var newScore = {
            "name": playerName,
            "time": formattedTime,
            "moves": moves,
            "date": formattedDate,
            "rawTime": time,
            "rawMoves": moves,
            "difficulty": difficulty
        }

        scores.push(newScore)

        scores.sort(function(a, b) {
            if (a.rawMoves === b.rawMoves) {
                return a.rawTime - b.rawTime
            }
            return a.rawMoves - b.rawMoves
        })

        if (scores.length > maxHighscores) {
            scores = scores.slice(0, maxHighscores)
        }

        highscoresSettings.scores = scores
        loadScores()
    }

    function formatTime(seconds) {
        var minutes = Math.floor(seconds / 60)
        var secs = seconds % 60
        return minutes + ":" + (secs < 10 ? "0" + secs : secs)
    }

    function checkHighscore(time, moves, difficulty) {
        var scores = highscoresSettings.scores || []

        if (scores.length < maxHighscores) {
            showNameInputDialog(time, moves, difficulty)
            return true
        }

        for (var i = 0; i < scores.length; i++) {
            if (moves < scores[i].rawMoves ||
                (moves === scores[i].rawMoves && time < scores[i].rawTime)) {
                showNameInputDialog(time, moves, difficulty)
                return true
            }
        }

        return false
    }

    function showNameInputDialog(time, moves, difficulty) {
        nameInputDialog.timeScore = time
        nameInputDialog.movesScore = moves
        nameInputDialog.difficultyLevel = difficulty || "medium"
        nameInput.text = ""
        nameInputDialog.open()
    }

    function showScoreDetails(index) {
        if (index >= 0 && index < scoresModel.count) {
            var score = scoresModel.get(index)
            scoreDetailsDialog.playerName = score.name
            scoreDetailsDialog.playerTime = score.time
            scoreDetailsDialog.playerMoves = score.moves
            scoreDetailsDialog.playerDate = score.date
            scoreDetailsDialog.playerDifficulty = score.difficulty
            scoreDetailsDialog.open()
        }
    }

    function exportScores() {
        var fileContent = ""
        fileContent += isEnglish ? "Rank,Player,Time,Moves,Date,Difficulty\n" : "Место,Игрок,Время,Ходы,Дата,Сложность\n"

        for (var i = 0; i < scoresModel.count; i++) {
            var score = scoresModel.get(i)
            fileContent += (i + 1) + "," + score.name + "," + score.time + "," + score.moves + "," + score.date + "," + translations.t(score.difficulty) + "\n"
        }

        exportFile(fileContent, "highscores.csv")
    }

    function exportFile(content, filename) {
        if (Qt.platform.os === "windows" || Qt.platform.os === "linux" || Qt.platform.os === "osx") {
            var request = new XMLHttpRequest()
            request.open("POST", "file:///" + filename, true)
            request.send(content)
        }
    }

    function shareScores() {
        if (scoresModel.count === 0) return

        var shareText = isEnglish ? "My Highscores:\n" : "Мои рекорды:\n"
        var topScores = Math.min(scoresModel.count, 3)

        for (var i = 0; i < topScores; i++) {
            var score = scoresModel.get(i)
            shareText += "#" + (i + 1) + ": " + score.name + " - " + score.time + " / " + score.moves + " " + translations.t("moves") + " (" + translations.t(score.difficulty) + ")\n"
        }

        if (typeof Qt.openUrlExternally === "function") {
            var encoded = encodeURIComponent(shareText)
            Qt.openUrlExternally("https://twitter.com/intent/tweet?text=" + encoded)
        }
    }
}
