import QtQuick 2.15
import QtQuick.Controls 2.15
import Game 1.0
import AudioComponents 1.0

GridView {
    id: root
    anchors.centerIn: parent
    anchors.margins: Math.min(width, height) * 0.02
    model: GameBoardModel {
        Component.onCompleted: {
            this.boardSize = 16
        }
    }

    AudioController {
        id: audioController
    }

    cellWidth: width / root.model.dimension
    cellHeight: height / root.model.dimension
    interactive: false

    property int themeIndex: 0
    property int counter: 0
    property int lastMovedIndex: -1
    property int currentEmptyIndex: -1

    signal gameWon()

    focus: true
    Keys.onPressed: function(event) {
        if (root.model) {
            for (let i = 0; i < root.model.boardSize; i++) {
                if (root.model.data(root.model.index(i, 0), Qt.DisplayRole) === root.model.hiddenElementValue) {
                    currentEmptyIndex = i;
                    break;
                }
            }

            let dimension = root.model.dimension;
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
                if (root.model.move(targetIndex)) {
                    root.counter += 1;
                    root.lastMovedIndex = targetIndex;
                    audioController.playSound("qrc:/Img/sound.mp3");
                    if (root.model.checkWin()) {
                        root.gameWon();
                    }
                }
            }
        }
        event.accepted = true;
    }

    delegate: Item {
        id: tileItem
        width: root.cellWidth
        height: root.cellHeight
        visible: display !== root.model.hiddenElementValue

        Tile {
            id: tile
            anchors.fill: parent
            anchors.margins: Math.min(width, height) * 0.01
            displayText: display
            themeIndex: root.themeIndex
            isLastMoved: index === root.lastMovedIndex

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
                    if (root.model.move(index)) {
                        root.counter += 1;
                        root.lastMovedIndex = index;
                        audioController.playSound("qrc:/Img/sound.mp3");
                        if (root.model.checkWin()) {
                            root.gameWon();
                        }
                    }
                }
            }
        }
    }

    function resetCounter() {
        root.counter = 0;
    }
}
