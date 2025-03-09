import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt.labs.settings 1.0

Rectangle {
    id: audioSettingsContainer
    width: parent.width
    height: contentHeight
    color: "transparent"
    property int contentHeight: audioSettingsContent.height
    property bool backgroundMusicEnabled: true
    property int volume: 75
    property string selectedMusic: "Relaxing"
    property int themeIndex: 0
    property var audioController
    property var appTheme
    property bool settingsChanged: false
    signal applySettings()
    signal settingsValueChanged()

    Settings {
        id: audioSettings
        category: "Audio"
        property bool savedBackgroundMusicEnabled: true
        property int savedVolume: 75
        property string savedSelectedMusic: "Relaxing"
    }

    Theme {
        id: theme
        themeIndex: audioSettingsContainer.themeIndex
    }

    ColumnLayout {
        id: audioSettingsContent
        width: parent.width
        spacing: 20
        opacity: 0

        SequentialAnimation {
            running: true
            PauseAnimation { duration: 200 }
            NumberAnimation {
                target: audioSettingsContent
                property: "opacity"
                from: 0
                to: 1
                duration: 400
                easing.type: Easing.OutCubic
            }
        }

        Text {
            text: "Audio Settings"
            font {
                family: "Inter"
                pixelSize: 26
                weight: Font.DemiBold
            }
            color: theme.textColor
            Layout.alignment: Qt.AlignHCenter
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: theme.accentColor
            opacity: 0.2
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Rectangle {
                id: musicToggleBackground
                Layout.preferredWidth: 56
                Layout.preferredHeight: 30
                radius: 15
                color: audioSettingsContainer.backgroundMusicEnabled ? theme.accentColor : theme.inputFieldBackgroundColor

                Behavior on color {
                    ColorAnimation { duration: 200 }
                }

                Rectangle {
                    id: musicToggleHandle
                    width: 24
                    height: 24
                    radius: 12
                    color: "white"
                    x: audioSettingsContainer.backgroundMusicEnabled ? parent.width - width - 3 : 3
                    anchors.verticalCenter: parent.verticalCenter

                    Behavior on x {
                        NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        audioSettingsContainer.backgroundMusicEnabled = !audioSettingsContainer.backgroundMusicEnabled
                        audioSettingsContainer.settingsChanged = true
                        settingsValueChanged()

                        if (audioController) {
                            if (!audioSettingsContainer.backgroundMusicEnabled) {
                                audioController.stop()
                            } else {
                                updateAudio()
                            }
                        }
                    }
                }
            }

            Text {
                text: "Background Music"
                font {
                    family: "Inter"
                    pixelSize: 18
                }
                Layout.fillWidth: true
                color: theme.textColor
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 14
            enabled: audioSettingsContainer.backgroundMusicEnabled
            opacity: audioSettingsContainer.backgroundMusicEnabled ? 1.0 : 0.5

            Behavior on opacity {
                NumberAnimation { duration: 200 }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Text {
                    text: "Volume: " + volumeSlider.value + "%"
                    font {
                        family: "Inter"
                        pixelSize: 16
                    }
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
                hoverEnabled: true

                onValueChanged: {
                    audioSettingsContainer.volume = Math.round(value)
                    audioSettingsContainer.settingsChanged = true
                    settingsValueChanged()
                    if (audioController && audioSettingsContainer.backgroundMusicEnabled) {
                        audioController.setVolume(audioSettingsContainer.volume / 100.0)
                    }
                }

                background: Rectangle {
                    x: volumeSlider.leftPadding
                    y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
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
                    x: volumeSlider.leftPadding + volumeSlider.visualPosition * volumeSlider.availableWidth - width / 2
                    y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                    implicitWidth: 22
                    implicitHeight: 22
                    radius: 11
                    color: volumeSlider.pressed ? Qt.darker(theme.accentColor, 1.1) :
                           volumeSlider.hovered ? Qt.lighter(theme.accentColor, 1.1) : theme.accentColor
                    border.color: "#ffffff"
                    border.width: 2

                    Behavior on color {
                        ColorAnimation {
                            duration: 150
                        }
                    }
                }
            }

            Text {
                text: "Select Music Style:"
                font {
                    family: "Inter"
                    pixelSize: 16
                }
                color: theme.textColor
                Layout.topMargin: 10
            }

            Flow {
                Layout.fillWidth: true
                spacing: 12

                Repeater {
                    model: ["Relaxing", "Energetic", "Classic"]

                    Rectangle {
                        width: 120
                        height: 40
                        radius: 12
                        color: audioSettingsContainer.selectedMusic === modelData ? theme.accentColor : theme.inputFieldBackgroundColor
                        border.color: audioSettingsContainer.selectedMusic === modelData ? theme.accentColor : theme.separatorColor
                        border.width: 1
                        scale: musicButtonMouse.containsMouse ? 1.05 : 1.0

                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }

                        Behavior on scale {
                            NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                        }

                        Row {
                            anchors.centerIn: parent
                            spacing: 8

                            Image {
                                source: "qrc:/icons/music_" + (modelData === "Relaxing" ? "note" : modelData.toLowerCase()) + ".png"
                                width: 20
                                height: 20
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Text {
                                text: modelData
                                color: audioSettingsContainer.selectedMusic === modelData ? "white" : theme.textColor
                                font {
                                    family: "Inter"
                                    pixelSize: 16
                                    weight: Font.Medium
                                }
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        MouseArea {
                            id: musicButtonMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                audioSettingsContainer.selectedMusic = modelData
                                audioSettingsContainer.settingsChanged = true
                                settingsValueChanged()
                                updateAudio()
                            }
                        }
                    }
                }
            }
        }

        Button {
            id: testAudioButton
            text: "Test Audio"
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 10
            Layout.preferredWidth: 120
            Layout.preferredHeight: 36
            enabled: audioSettingsContainer.backgroundMusicEnabled

            background: Rectangle {
                radius: 10
                color: testAudioButton.pressed ? Qt.darker(theme.accentColor, 1.2) : theme.accentColor

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }

            contentItem: Text {
                text: testAudioButton.text
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font {
                    family: "Inter"
                    pixelSize: 14
                    weight: Font.Medium
                }
            }

            onClicked: {
                testAudio()
            }
        }
    }

    Component.onCompleted: {
        loadCurrentSettings()
    }

    function loadCurrentSettings() {
        backgroundMusicEnabled = audioSettings.savedBackgroundMusicEnabled
        volume = audioSettings.savedVolume
        selectedMusic = audioSettings.savedSelectedMusic
        volumeSlider.value = volume
    }

    function updateAudio() {
        if (backgroundMusicEnabled && audioController) {
            var musicPath = getMusicPath()
            audioController.stop()
            audioController.setLooping(true)
            audioController.playSound(musicPath)
            audioController.setVolume(volume / 100.0)
        }
    }

    function getMusicPath() {
        var musicPath = ""
        if (selectedMusic === "Classic") {
            musicPath = "qrc:/Sounds/soundIntellect.mp3"
        } else if (selectedMusic === "Energetic") {
            musicPath = "qrc:/Sounds/N_Puzzle!Music.mp3"
        } else if (selectedMusic === "Relaxing") {
            musicPath = "qrc:/Sounds/stress.mp3"
        }
        return musicPath
    }

    function applyAudioSettings() {
        audioSettings.savedBackgroundMusicEnabled = backgroundMusicEnabled
        audioSettings.savedVolume = volume
        audioSettings.savedSelectedMusic = selectedMusic

        if (backgroundMusicEnabled && audioController) {
            updateAudio()
        } else if (audioController) {
            audioController.stop()
        }

        applySettings()
    }

    function testAudio() {
        if (audioController) {
            var testPath = getMusicPath()
            audioController.stop()
            audioController.setLooping(false)
            audioController.playSound(testPath)
            audioController.setVolume(volume / 100.0)

            audioSettingsContainer.settingsChanged = true
            settingsValueChanged()
        }
    }
}
