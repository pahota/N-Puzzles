import QtQuick 2.15
import Qt5Compat.GraphicalEffects
import GameComponents 1.0
Rectangle {
    id: scorePanel
    width: timeCounter.width
    height: timeCounter.height * 0.8
    radius: timeCounter.radius
    color: theme.counterBackgroundColor
    border { color: theme.tileBorderColor; width: 2 }
    layer.enabled: true
    anchors{
        top: timeCounter.bottom
        topMargin: timeCounter.height/6
        left: timeCounter.left
    }
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 3
        verticalOffset: 3
        radius: 8
        samples: 16
        color: "#66000000"
    }

    Row {
        anchors.centerIn: parent
        spacing: parent.width * 0.05

        Image {
            id: scoreIcon
            source: themeIndex === 0 ? "qrc:/Img/Icons/scoreIcons/scoreLight.svg" :
                    themeIndex === 1 ? "qrc:/Img/Icons/scoreIcons/scoreDark.svg" :
                                     "qrc:/Img/Icons/scoreIcons/scoreDark.svg"
            width: parent.height * 0.6
            height: width
            smooth: true
            mipmap: true
            anchors.verticalCenter: parent.verticalCenter
            fillMode: Image.PreserveAspectFit
        }

        Rectangle {
            width: 1
            height: scoreIcon.height * 0.8
            color: theme.tileBorderColor
            anchors.verticalCenter: parent.verticalCenter
        }

        Row {
            anchors.verticalCenter: parent.verticalCenter
            spacing: scorePanel.width * 0.03

            Text {
                id: scoreLabel
                text: translations.t("score") + ":"
                color: theme.counterTextColor
                font { family: "Source Sans Pro"; pixelSize: scorePanel.height * 0.4 }
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                id: scoreValueText
                text: scoreManager ? scoreManager.currentScore : "1000"
                color: theme.counterTextColor
                font { family: "Source Sans Pro"; pixelSize: scorePanel.height * 0.4; bold: true }
                anchors.verticalCenter: parent.verticalCenter

                Behavior on text {
                    SequentialAnimation {
                        NumberAnimation { target: scoreValueText; property: "scale"; to: 1.2; duration: 150 }
                        NumberAnimation { target: scoreValueText; property: "scale"; to: 1.0; duration: 150 }
                    }
                }
            }
        }
    }

    Connections {
        target: scoreManager
        function onCurrentScoreChanged() {
            scoreValueText.text = scoreManager.currentScore
        }
    }
}
