import QtQuick 2.15
import QtQuick.Controls 2.15
import Game 1.0
import AudioComponents 1.0
import GameComponents 1.0

Item {
    id: root
    anchors.fill: parent

    property int themeIndex: 0
    property int counter: 0
    property int lastMovedIndex: -1
    property int currentDimension: 4
    property var scoreManager: parent.scoreManager

    property bool timerRunning: false
    property int displayCounter: 0

    signal gameWon()
    signal countChanged(int count)
    signal moveMade()

    function initializeBoard() {
        boardModel.setDimension(currentDimension);
        root.counter = 0;
    }

    function resetCounter() {
        root.counter = 0;
    }

    property var model: boardModel

    GameBoardModel {
        id: boardModel

        onCounterChanged: {
            root.counter = boardModel.counter;
            if (!root.timerRunning && root.counter > 0) {
                root.timerRunning = true;
            }
            root.countChanged(root.counter);
        }

        onGameWon: {
            root.gameWon();
        }

        Component.onCompleted: {
            boardModel.setDimension(currentDimension);
        }
    }

    GridView {
        id: gridView
        anchors.fill: parent
        anchors.margins: Math.min(width, height) * 0.02
        model: boardModel

        cellWidth: width / boardModel.dimension
        cellHeight: height / boardModel.dimension
        interactive: false

        delegate: Item {
            id: tileItem
            width: gridView.cellWidth
            height: gridView.cellHeight
            visible: display !== boardModel.hiddenElementValue

            Tile {
                id: tile
                anchors.fill: parent
                anchors.margins: Math.min(width, height) * 0.01
                displayText: display
                themeIndex: root.themeIndex
                isLastMoved: index === root.lastMovedIndex
                originalValue: parseInt(display)
                dimension: boardModel.dimension

                Behavior on x {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.OutBack
                        easing.overshoot: 0.3
                    }
                }

                Behavior on y {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.OutBack
                        easing.overshoot: 0.3
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (boardModel.move(index)) {
                            root.lastMovedIndex = index;
                            audioController.playSound("qrc:/Img/sound.mp3");
                            root.moveMade();

                            if (boardModel.checkWin()) {
                                showWinDialog()
                            }
                        }
                    }
                }
            }
        }
    }

    AudioController {
        id: audioController
    }

    Keys.onPressed: function(event) {
        let dimension = boardModel.dimension;
        let currentEmptyIndex = -1;

        for (let i = 0; i < boardModel.boardSize; i++) {
            if (boardModel.data(boardModel.index(i, 0), Qt.DisplayRole) === boardModel.hiddenElementValue) {
                currentEmptyIndex = i;
                break;
            }
        }

        if (currentEmptyIndex === -1) return;

        let targetIndex = -1;

        switch (event.key) {
            case Qt.Key_Left:
            case Qt.Key_A:
                if ((currentEmptyIndex % dimension) > 0) {
                    targetIndex = currentEmptyIndex - 1;
                }
                break;
            case Qt.Key_Right:
            case Qt.Key_D:
                if ((currentEmptyIndex % dimension) < (dimension - 1)) {
                    targetIndex = currentEmptyIndex + 1;
                }
                break;
            case Qt.Key_Up:
            case Qt.Key_W:
                if (Math.floor(currentEmptyIndex / dimension) > 0) {
                    targetIndex = currentEmptyIndex - dimension;
                }
                break;
            case Qt.Key_Down:
            case Qt.Key_S:
                if (Math.floor(currentEmptyIndex / dimension) < (dimension - 1)) {
                    targetIndex = currentEmptyIndex + dimension;
                }
                break;
        }

        if (targetIndex !== -1) {
            if (boardModel.move(targetIndex)) {
                root.lastMovedIndex = targetIndex;
                audioController.playSound("qrc:/Img/sound.mp3");
                root.moveMade();

                if (boardModel.checkWin()) {
                    showWinDialog()
                }
            }
        }

        event.accepted = true;
    }

    Component.onCompleted: {
        forceActiveFocus();
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
