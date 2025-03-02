import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: audioSettingsContainer
    width: parent.width
    height: contentHeight
    color: "transparent"
    property int contentHeight: audioSettingsContent.height + 40
    property bool backgroundMusicEnabled: true
    property int volume: 75
    property string selectedMusic: "Relaxing"
    property int themeIndex: 0
    property var audioController
    signal applySettings()

    Theme {
        id: theme
        themeIndex: audioSettingsContainer.themeIndex
    }

    Rectangle {
        id: audioSettingsContent
        width: parent.width - 10
        height: columnLayout.height + 40
        anchors.centerIn: parent
        radius: 10
        color: theme.cardColor
        border.color: theme.separatorColor
        border.width: 1

        ColumnLayout {
            id: columnLayout
            width: parent.width - 40
            anchors.centerIn: parent
            spacing: 20

            Label {
                text: "Audio Settings:"
                font.pixelSize: 18
                font.bold: true
                Layout.alignment: Qt.AlignLeft
                color: theme.textColor
            }

            RowLayout {
                Layout.fillWidth: true

                CheckBox {
                    id: backgroundMusicCheck
                    checked: audioSettingsContainer.backgroundMusicEnabled
                    onCheckedChanged: {
                        audioSettingsContainer.backgroundMusicEnabled = checked
                        audioSettingsContainer.applySettings()
                    }
                }

                Label {
                    text: "Enable background music"
                    Layout.fillWidth: true
                    color: theme.textColor
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 10
                enabled: backgroundMusicCheck.checked
                opacity: backgroundMusicCheck.checked ? 1.0 : 0.5

                RowLayout {
                    Layout.fillWidth: true

                    Label {
                        text: "Volume: " + volumeSlider.value + "%"
                        color: theme.textColor
                    }
                }

                Slider {
                    id: volumeSlider
                    Layout.fillWidth: true
                    from: 0
                    to: 100
                    stepSize: 1
                    value: audioSettingsContainer.volume
                    live: true

                    onValueChanged: {
                        audioSettingsContainer.volume = Math.round(value)
                        audioSettingsContainer.applySettings()
                    }

                    background: Rectangle {
                        x: volumeSlider.leftPadding
                        y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                        implicitWidth: 200
                        implicitHeight: 8
                        width: volumeSlider.availableWidth
                        height: 8
                        radius: 4
                        color: theme.backgroundSecondaryColor

                        Rectangle {
                            width: volumeSlider.visualPosition * parent.width
                            height: parent.height
                            color: theme.accentColor
                            radius: 4
                        }
                    }

                    handle: Rectangle {
                        x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
                        y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                        implicitWidth: 20
                        implicitHeight: 20
                        width: 20
                        height: 20
                        radius: 10
                        color: volumeSlider.pressed ? theme.accentColor : theme.buttonBackgroundColor
                        border.color: theme.accentColor
                        border.width: 2

                        Behavior on x {
                            enabled: !volumeSlider.pressed
                            NumberAnimation {
                                duration: 100
                                easing.type: Easing.OutQuad
                            }
                        }
                    }

                    Behavior on value {
                        enabled: !volumeSlider.pressed
                        NumberAnimation {
                            duration: 100
                            easing.type: Easing.OutQuad
                        }
                    }
                }

                Label {
                    text: "Select music:"
                    Layout.topMargin: 10
                    color: theme.textColor
                }

                Flow {
                    Layout.fillWidth: true
                    spacing: 10

                    Rectangle {
                        id: relaxingOption
                        width: 120
                        height: 40
                        radius: 8
                        color: audioSettingsContainer.selectedMusic === "Relaxing" ? theme.accentColor : theme.inputFieldBackgroundColor
                        border.color: audioSettingsContainer.selectedMusic === "Relaxing" ? theme.accentColor : theme.separatorColor
                        border.width: 1

                        Row {
                            anchors.centerIn: parent
                            spacing: 5

                            Image {
                                source: "qrc:/icons/music_note.png"
                                width: 20
                                height: 20
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Text {
                                text: "Relaxing"
                                color: audioSettingsContainer.selectedMusic === "Relaxing" ? "white" : theme.textColor
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                audioSettingsContainer.selectedMusic = "Relaxing"
                                audioSettingsContainer.applySettings()
                            }
                        }
                    }

                    Rectangle {
                        id: energeticOption
                        width: 120
                        height: 40
                        radius: 8
                        color: audioSettingsContainer.selectedMusic === "Energetic" ? theme.accentColor : theme.inputFieldBackgroundColor
                        border.color: audioSettingsContainer.selectedMusic === "Energetic" ? theme.accentColor : theme.separatorColor
                        border.width: 1

                        Row {
                            anchors.centerIn: parent
                            spacing: 5

                            Image {
                                source: "qrc:/icons/music_energetic.png"
                                width: 20
                                height: 20
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Text {
                                text: "Energetic"
                                color: audioSettingsContainer.selectedMusic === "Energetic" ? "white" : theme.textColor
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                audioSettingsContainer.selectedMusic = "Energetic"
                                audioSettingsContainer.applySettings()
                            }
                        }
                    }

                    Rectangle {
                        id: classicOption
                        width: 120
                        height: 40
                        radius: 8
                        color: audioSettingsContainer.selectedMusic === "Classic" ? theme.accentColor : theme.inputFieldBackgroundColor
                        border.color: audioSettingsContainer.selectedMusic === "Classic" ? theme.accentColor : theme.separatorColor
                        border.width: 1

                        Row {
                            anchors.centerIn: parent
                            spacing: 5

                            Image {
                                source: "qrc:/icons/music_classic.png"
                                width: 20
                                height: 20
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Text {
                                text: "Classic"
                                color: audioSettingsContainer.selectedMusic === "Classic" ? "white" : theme.textColor
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                audioSettingsContainer.selectedMusic = "Classic"
                                audioSettingsContainer.applySettings()
                            }
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        loadCurrentSettings()
    }

    function loadCurrentSettings() {
        volumeSlider.value = volume
    }

    function applyAudioSettings() {
        if (backgroundMusicEnabled && audioController) {
            var musicPath = ""
            if (selectedMusic === "Relaxing") {
                musicPath = "qrc:/Sounds/soundIntellect.mp3"
            } else if (selectedMusic === "Energetic") {
                musicPath = "qrc:/Sounds/soundIntellect.mp3"
            } else if (selectedMusic === "Classic") {
                musicPath = "qrc:/Sounds/soundIntellect.mp3"
            }

            audioController.playSound(musicPath)
            audioController.setVolume(volume / 100.0)
        } else if (audioController) {
             audioController.stop()
        }

        applySettings()
    }
}
