import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import Qt5Compat.GraphicalEffects

Item {
    id: screenSettingsView
    width: parent.width
    height: 560
    clip: true

    property int themeIndex: 0
    property var appTheme
    property var mainWindow: Window.window
    property var gameWindow: null

    signal applySettings()
    signal settingsChanged()

    function applyScreenSettings() {
        applySettings()
    }

    function applyResolutionSettings() {
        var res = resolutionComboBox.selectedResolution

        if (gameWindow) {
            if (windowModeComboBox.isFullscreen) {
                gameWindow.visibility = Window.FullScreen
            } else {
                gameWindow.visibility = Window.Windowed
                gameWindow.width = res.width
                gameWindow.height = res.height
                gameWindow.x = Screen.width / 2 - res.width / 2
                gameWindow.y = Screen.height / 2 - res.height / 2
            }
        } else if (mainWindow) {
            if (windowModeComboBox.isFullscreen) {
                mainWindow.visibility = Window.FullScreen
            } else {
                mainWindow.visibility = Window.Windowed
                mainWindow.width = res.width
                mainWindow.height = res.height
                mainWindow.x = Screen.width / 2 - res.width / 2
                mainWindow.y = Screen.height / 2 - res.height / 2
            }
        }
    }

    Item {
        id: screenSettings
        width: screenSettingsView.width
        height: screenSettingsView.height

        ColumnLayout {
            id: screenLayout
            width: parent.width
            spacing: 20
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 10

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: translations.t("screenSettings")
                font {
                    family: "Inter"
                    pixelSize: 26
                    weight: Font.DemiBold
                }
                color: appTheme.textColor
            }

            GridLayout {
                Layout.fillWidth: true
                columns: 2
                columnSpacing: 25
                rowSpacing: a8

                Text {
                    text: translations.t("brightness")
                    font {
                        family: "Inter"
                        pixelSize: 18
                        weight: Font.Medium
                    }
                    color: appTheme.textColor
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 15

                    Slider {
                        id: brightnessSlider
                        Layout.fillWidth: true
                        from: 0
                        to: 100
                        value: 80
                        stepSize: 1
                        live: true
                        hoverEnabled: true

                        onValueChanged: {
                            brightnessValueText.text = Math.round(value) + "%"
                            settingsChanged()
                        }

                        background: Rectangle {
                            x: brightnessSlider.leftPadding
                            y: brightnessSlider.topPadding + brightnessSlider.availableHeight / 2 - height / 2
                            width: brightnessSlider.availableWidth
                            height: 8
                            radius: 4
                            color: appTheme.sliderBackgroundColor

                            Rectangle {
                                width: brightnessSlider.visualPosition * parent.width
                                height: parent.height
                                color: appTheme.accentColor
                                radius: 4
                            }
                        }

                        handle: Rectangle {
                            x: brightnessSlider.leftPadding + brightnessSlider.visualPosition * brightnessSlider.availableWidth - width / 2
                            y: brightnessSlider.topPadding + brightnessSlider.availableHeight / 2 - height / 2
                            implicitWidth: 22
                            implicitHeight: 22
                            radius: 11
                            color: brightnessSlider.pressed ? Qt.darker(appTheme.accentColor, 1.1) :
                                   brightnessSlider.hovered ? Qt.lighter(appTheme.accentColor, 1.1) : appTheme.accentColor
                            border.color: "#ffffff"
                            border.width: 2

                            Behavior on color {
                                ColorAnimation {
                                    duration: 150
                                    easing.type: Easing.InOutQuad
                                }
                            }
                        }
                    }

                    Text {
                        id: brightnessValueText
                        text: "80%"
                        Layout.preferredWidth: 45
                        font {
                            family: "Inter"
                            pixelSize: 16
                            weight: Font.Medium
                        }
                        color: appTheme.textColor
                    }
                }

                Text {
                    text: translations.t("contrast")
                    font {
                        family: "Inter"
                        pixelSize: 18
                        weight: Font.Medium
                    }
                    color: appTheme.textColor
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 15

                    Slider {
                        id: contrastSlider
                        Layout.fillWidth: true
                        from: 0
                        to: 100
                        value: 50
                        stepSize: 1
                        live: true
                        hoverEnabled: true

                        onValueChanged: {
                            contrastValueText.text = Math.round(value) + "%"
                            settingsChanged()
                        }

                        background: Rectangle {
                            x: contrastSlider.leftPadding
                            y: contrastSlider.topPadding + contrastSlider.availableHeight / 2 - height / 2
                            width: contrastSlider.availableWidth
                            height: 8
                            radius: 4
                            color: appTheme.sliderBackgroundColor

                            Rectangle {
                                width: contrastSlider.visualPosition * parent.width
                                height: parent.height
                                color: appTheme.accentColor
                                radius: 4
                            }
                        }

                        handle: Rectangle {
                            x: contrastSlider.leftPadding + contrastSlider.visualPosition * contrastSlider.availableWidth - width / 2
                            y: contrastSlider.topPadding + contrastSlider.availableHeight / 2 - height / 2
                            implicitWidth: 22
                            implicitHeight: 22
                            radius: 11
                            color: contrastSlider.pressed ? Qt.darker(appTheme.accentColor, 1.1) :
                                   contrastSlider.hovered ? Qt.lighter(appTheme.accentColor, 1.1) : appTheme.accentColor
                            border.color: "#ffffff"
                            border.width: 2

                            Behavior on color {
                                ColorAnimation {
                                    duration: 150
                                    easing.type: Easing.InOutQuad
                                }
                            }
                        }
                    }

                    Text {
                        id: contrastValueText
                        text: "50%"
                        Layout.preferredWidth: 45
                        font {
                            family: "Inter"
                            pixelSize: 16
                            weight: Font.Medium
                        }
                        color: appTheme.textColor
                    }
                }

                Text {
                    text: translations.t("autoAdjust")
                    font {
                        family: "Inter"
                        pixelSize: 18
                        weight: Font.Medium
                    }
                    color: appTheme.textColor
                }

                Switch {
                    id: autoAdjustSwitch
                    checked: true
                    hoverEnabled: true
                    Layout.maximumWidth: parent.width / 2
                    Layout.fillWidth: true

                    onCheckedChanged: {
                        brightnessSlider.enabled = !checked
                        contrastSlider.enabled = !checked
                        settingsChanged()
                    }

                    indicator: Rectangle {
                        implicitWidth: 56
                        implicitHeight: 28
                        x: autoAdjustSwitch.leftPadding
                        y: parent.height / 2 - height / 2
                        radius: 14
                        color: autoAdjustSwitch.checked ?
                               (autoAdjustSwitch.hovered ? Qt.lighter(appTheme.accentColor, 1.1) : appTheme.accentColor) :
                               (autoAdjustSwitch.hovered ? Qt.lighter(appTheme.sliderBackgroundColor, 1.1) : appTheme.sliderBackgroundColor)

                        Behavior on color {
                            ColorAnimation {
                                duration: 150
                                easing.type: Easing.InOutQuad
                            }
                        }

                        Rectangle {
                            x: autoAdjustSwitch.checked ? parent.width - width - 3 : 3
                            y: 3
                            width: 22
                            height: 22
                            radius: 11
                            color: "#ffffff"

                            Behavior on x {
                                NumberAnimation {
                                    duration: 150
                                    easing.type: Easing.InOutQuad
                                }
                            }
                        }
                    }

                    contentItem: Text {
                        text: autoAdjustSwitch.checked ? translations.t("on") : translations.t("off")
                        font {
                            family: "Inter"
                            pixelSize: 16
                            weight: Font.Medium
                        }
                        color: appTheme.textSecondaryColor
                        leftPadding: autoAdjustSwitch.indicator.width + 12
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: appTheme.accentColor
                opacity: 0.2
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: translations.t("displayMode")
                font {
                    family: "Inter"
                    pixelSize: 22
                    weight: Font.Medium
                }
                color: appTheme.textColor
                Layout.topMargin: 5
            }

            GridLayout {
                Layout.fillWidth: true
                columns: 2
                columnSpacing: 25
                rowSpacing: 18

                Text {
                    text: translations.t("windowMode")
                    font {
                        family: "Inter"
                        pixelSize: 18
                        weight: Font.Medium
                    }
                    color: appTheme.textColor
                }

                ComboBox {
                    id: windowModeComboBox
                    Layout.fillWidth: true
                    Layout.maximumWidth: parent.width / 2
                    model: [
                        translations.t("windowed"),
                        translations.t("fullscreen")
                    ]
                    hoverEnabled: true

                    property bool isFullscreen: currentIndex === 1

                    onCurrentIndexChanged: {
                        resolutionComboBox.enabled = !isFullscreen
                        refreshRateComboBox.enabled = !isFullscreen
                        settingsChanged()
                    }

                    delegate: ItemDelegate {
                        width: windowModeComboBox.width
                        contentItem: Text {
                            text: modelData
                            color: appTheme.textColor
                            font.family: "Inter"
                            font.pixelSize: 16
                            elide: Text.ElideRight
                            verticalAlignment: Text.AlignVCenter
                            leftPadding: 12
                        }
                        highlighted: windowModeComboBox.highlightedIndex === index
                        background: Rectangle {
                            color: highlighted ? appTheme.accentColor : "transparent"
                            opacity: highlighted ? 0.2 : 1
                        }
                    }

                    contentItem: Text {
                        leftPadding: 12
                        text: windowModeComboBox.displayText
                        font.family: "Inter"
                        font.pixelSize: 16
                        font.weight: Font.Medium
                        color: appTheme.textColor
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }

                    background: Rectangle {
                        implicitWidth: 120
                        implicitHeight: 42
                        color: "transparent"
                        border.color: appTheme.accentColor
                        border.width: 2
                        radius: 6

                        Rectangle {
                            anchors.fill: parent
                            radius: 6
                            color: windowModeComboBox.hovered ? appTheme.accentColor : "transparent"
                            opacity: windowModeComboBox.hovered ? 0.1 : 0

                            Behavior on opacity {
                                NumberAnimation {
                                    duration: 200
                                    easing.type: Easing.InOutQuad
                                }
                            }
                        }
                    }

                    popup: Popup {
                        y: windowModeComboBox.height
                        width: windowModeComboBox.width
                        implicitHeight: contentItem.implicitHeight
                        padding: 2

                        contentItem: ListView {
                            clip: true
                            implicitHeight: contentHeight
                            model: windowModeComboBox.popup.visible ? windowModeComboBox.delegateModel : null
                            currentIndex: windowModeComboBox.highlightedIndex
                            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AlwaysOff }
                        }

                        background: Rectangle {
                            color: appTheme.backgroundColor
                            border.color: appTheme.accentColor
                            border.width: 2
                            radius: 6

                            layer.enabled: true
                            layer.effect: DropShadow {
                                transparentBorder: true
                                horizontalOffset: 0
                                verticalOffset: 3
                                radius: 8.0
                                samples: 17
                                color: "#40000000"
                            }
                        }
                    }
                }

                Text {
                    text: translations.t("resolution")
                    font {
                        family: "Inter"
                        pixelSize: 18
                        weight: Font.Medium
                    }
                    color: appTheme.textColor
                    opacity: windowModeComboBox.isFullscreen ? 0.5 : 1
                }

                ComboBox {
                    id: resolutionComboBox
                    Layout.fillWidth: true
                    Layout.maximumWidth: parent.width / 2
                    model: [
                        "1280 × 720",
                        "1366 × 768",
                        "1600 × 900",
                        "1920 × 1080",
                        "2560 × 1440",
                        "3840 × 2160"
                    ]
                    currentIndex: 3
                    enabled: !windowModeComboBox.isFullscreen
                    hoverEnabled: true

                    onCurrentIndexChanged: settingsChanged()

                    property var resolutions: [
                        { width: 1280, height: 720 },
                        { width: 1366, height: 768 },
                        { width: 1600, height: 900 },
                        { width: 1920, height: 1080 },
                        { width: 2560, height: 1440 },
                        { width: 3840, height: 2160 }
                    ]

                    property var selectedResolution: resolutions[currentIndex]

                    delegate: ItemDelegate {
                        width: resolutionComboBox.width
                        contentItem: Text {
                            text: modelData
                            color: appTheme.textColor
                            font.family: "Inter"
                            font.pixelSize: 16
                            elide: Text.ElideRight
                            verticalAlignment: Text.AlignVCenter
                            leftPadding: 12
                        }
                        highlighted: resolutionComboBox.highlightedIndex === index
                        background: Rectangle {
                            color: highlighted ? appTheme.accentColor : "transparent"
                            opacity: highlighted ? 0.2 : 1
                        }
                    }

                    contentItem: Text {
                        leftPadding: 12
                        text: resolutionComboBox.displayText
                        font.family: "Inter"
                        font.pixelSize: 16
                        font.weight: Font.Medium
                        color: appTheme.textColor
                        opacity: resolutionComboBox.enabled ? 1 : 0.5
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }

                    background: Rectangle {
                        implicitWidth: 120
                        implicitHeight: 42
                        color: "transparent"
                        border.color: appTheme.accentColor
                        border.width: 2
                        radius: 6
                        opacity: resolutionComboBox.enabled ? 1 : 0.5

                        Rectangle {
                            anchors.fill: parent
                            radius: 6
                            color: resolutionComboBox.enabled && resolutionComboBox.hovered ? appTheme.accentColor : "transparent"
                            opacity: resolutionComboBox.enabled && resolutionComboBox.hovered ? 0.1 : 0

                            Behavior on opacity {
                                NumberAnimation {
                                    duration: 200
                                    easing.type: Easing.InOutQuad
                                }
                            }
                        }
                    }

                    popup: Popup {
                        y: resolutionComboBox.height
                        width: resolutionComboBox.width
                        implicitHeight: contentItem.implicitHeight
                        padding: 2

                        contentItem: ListView {
                            clip: true
                            implicitHeight: contentHeight
                            model: resolutionComboBox.popup.visible ? resolutionComboBox.delegateModel : null
                            currentIndex: resolutionComboBox.highlightedIndex
                            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AlwaysOff }
                        }

                        background: Rectangle {
                            color: appTheme.backgroundColor
                            border.color: appTheme.accentColor
                            border.width: 2
                            radius: 6

                            layer.enabled: true
                            layer.effect: DropShadow {
                                transparentBorder: true
                                horizontalOffset: 0
                                verticalOffset: 3
                                radius: 8.0
                                samples: 17
                                color: "#40000000"
                            }
                        }
                    }
                }

                Text {
                    text: translations.t("refreshRate")
                    font {
                        family: "Inter"
                        pixelSize: 18
                        weight: Font.Medium
                    }
                    color: appTheme.textColor
                    opacity: windowModeComboBox.isFullscreen ? 0.5 : 1
                }

                ComboBox {
                    id: refreshRateComboBox
                    Layout.fillWidth: true
                    Layout.maximumWidth: parent.width / 2
                    model: ["60 Hz", "75 Hz", "120 Hz", "144 Hz", "165 Hz", "240 Hz"]
                    currentIndex: 0
                    enabled: !windowModeComboBox.isFullscreen
                    hoverEnabled: true

                    onCurrentIndexChanged: settingsChanged()

                    property var rates: [60, 75, 120, 144, 165, 240]
                    property int selectedRate: rates[currentIndex]

                    delegate: ItemDelegate {
                        width: refreshRateComboBox.width
                        contentItem: Text {
                            text: modelData
                            color: appTheme.textColor
                            font.family: "Inter"
                            font.pixelSize: 16
                            elide: Text.ElideRight
                            verticalAlignment: Text.AlignVCenter
                            leftPadding: 12
                        }
                        highlighted: refreshRateComboBox.highlightedIndex === index
                        background: Rectangle {
                            color: highlighted ? appTheme.accentColor : "transparent"
                            opacity: highlighted ? 0.2 : 1
                        }
                    }

                    contentItem: Text {
                        leftPadding: 12
                        text: refreshRateComboBox.displayText
                        font.family: "Inter"
                        font.pixelSize: 16
                        font.weight: Font.Medium
                        color: appTheme.textColor
                        opacity: refreshRateComboBox.enabled ? 1 : 0.5
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }

                    background: Rectangle {
                        implicitWidth: 120
                        implicitHeight: 42
                        color: "transparent"
                        border.color: appTheme.accentColor
                        border.width: 2
                        radius: 6
                        opacity: refreshRateComboBox.enabled ? 1 : 0.5

                        Rectangle {
                            anchors.fill: parent
                            radius: 6
                            color: refreshRateComboBox.enabled && refreshRateComboBox.hovered ? appTheme.accentColor : "transparent"
                            opacity: refreshRateComboBox.enabled && refreshRateComboBox.hovered ? 0.1 : 0

                            Behavior on opacity {
                                NumberAnimation {
                                    duration: 200
                                    easing.type: Easing.InOutQuad
                                }
                            }
                        }
                    }

                    popup: Popup {
                        y: refreshRateComboBox.height
                        width: refreshRateComboBox.width
                        implicitHeight: contentItem.implicitHeight
                        padding: 2

                        contentItem: ListView {
                            clip: true
                            implicitHeight: contentHeight
                            model: refreshRateComboBox.popup.visible ? refreshRateComboBox.delegateModel : null
                            currentIndex: refreshRateComboBox.highlightedIndex
                            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AlwaysOff }
                        }

                        background: Rectangle {
                            color: appTheme.backgroundColor
                            border.color: appTheme.accentColor
                            border.width: 2
                            radius: 6

                            layer.enabled: true
                            layer.effect: DropShadow {
                                transparentBorder: true
                                horizontalOffset: 0
                                verticalOffset: 3
                                radius: 8.0
                                samples: 17
                                color: "#40000000"
                            }
                        }
                    }
                }

                Text {
                    text: translations.t("vsync")
                    font {
                        family: "Inter"
                        pixelSize: 18
                        weight: Font.Medium
                    }
                    color: appTheme.textColor
                }

                Switch {
                    id: vsyncSwitch
                    checked: true
                    hoverEnabled: true
                    Layout.maximumWidth: parent.width / 2
                    Layout.fillWidth: true

                    onCheckedChanged: settingsChanged()

                    indicator: Rectangle {
                        implicitWidth: 56
                        implicitHeight: 28
                        x: vsyncSwitch.leftPadding
                        y: parent.height / 2 - height / 2
                        radius: 14
                        color: vsyncSwitch.checked ?
                               (vsyncSwitch.hovered ? Qt.lighter(appTheme.accentColor, 1.1) : appTheme.accentColor) :
                               (vsyncSwitch.hovered ? Qt.lighter(appTheme.sliderBackgroundColor, 1.1) : appTheme.sliderBackgroundColor)

                        Behavior on color {
                            ColorAnimation {
                                duration: 150
                                easing.type: Easing.InOutQuad
                            }
                        }

                        Rectangle {
                            x: vsyncSwitch.checked ? parent.width - width - 3 : 3
                            y: 3
                            width: 22
                            height: 22
                            radius: 11
                            color: "#ffffff"

                            Behavior on x {
                                NumberAnimation {
                                    duration: 150
                                    easing.type: Easing.InOutQuad
                                }
                            }
                        }
                    }

                    contentItem: Text {
                        text: vsyncSwitch.checked ? translations.t("on") : translations.t("off")
                        font {
                            family: "Inter"
                            pixelSize: 16
                            weight: Font.Medium
                        }
                        color: appTheme.textSecondaryColor
                        leftPadding: vsyncSwitch.indicator.width + 12
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 10
                Layout.bottomMargin: 10
                spacing: 25

                Button {
                    id: testButton
                    text: translations.t("testSettings")
                    hoverEnabled: true
                    contentItem: Text {
                        text: parent.text
                        font {
                            family: "Inter"
                            pixelSize: 16
                            weight: Font.DemiBold
                        }
                        color: "#ffffff"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        opacity: testButton.enabled ? 1.0 : 0.6
                        Behavior on opacity {
                            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                        }
                    }
                    background: Rectangle {
                        implicitWidth: 170
                        implicitHeight: 44
                        radius: 22
                        color: appTheme.accentColor

                        Rectangle {
                            id: hoverEffect
                            anchors.centerIn: parent
                            width: testButton.pressed ? parent.width * 1.05 : (testButton.hovered ? parent.width : 0)
                            height: testButton.pressed ? parent.height * 1.05 : (testButton.hovered ? parent.height : 0)
                            radius: 22
                            color: "#ffffff"
                            opacity: testButton.pressed ? 0.2 : (testButton.hovered ? 0.15 : 0)
                        }

                        ParallelAnimation {
                            id: clickAnimation
                            running: false

                            NumberAnimation {
                                target: testButton.background
                                property: "scale"
                                from: 0.97
                                to: 1.0
                                duration: 200
                                easing.type: Easing.OutBack
                                easing.overshoot: 2.0
                            }

                            NumberAnimation {
                                target: glowEffect
                                property: "opacity"
                                from: 0.8
                                to: 0.0
                                duration: 700
                                easing.type: Easing.OutCubic
                            }
                        }

                        Rectangle {
                            id: glowEffect
                            anchors.fill: parent
                            radius: 22
                            color: "transparent"
                            border.width: 2
                            border.color: Qt.lighter(appTheme.accentColor, 1.3)
                            opacity: 0
                        }

                        layer.enabled: true
                        layer.effect: DropShadow {
                            transparentBorder: true
                            horizontalOffset: 0
                            verticalOffset: testButton.pressed ? 1 : 3
                            radius: testButton.pressed ? 4.0 : 8.0
                            samples: 17
                            color: "#40000000"
                            Behavior on verticalOffset {
                                NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
                            }
                            Behavior on radius {
                                NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
                            }
                        }
                    }

                    states: [
                        State {
                            name: "pressed"
                            when: testButton.pressed
                            PropertyChanges {
                                target: testButton.background
                                scale: 0.97
                            }
                        }
                    ]

                    transitions: [
                        Transition {
                            from: ""; to: "pressed"
                            ScaleAnimator {
                                duration: 120
                                easing.type: Easing.OutQuad
                            }
                        },
                        Transition {
                            from: "pressed"; to: ""
                            ScaleAnimator {
                                duration: 200
                                easing.type: Easing.OutBack
                                easing.overshoot: 2.0
                            }
                        }
                    ]

                    onPressed: {
                        clickAnimation.stop()
                    }

                    onReleased: {
                        if (containsMouse) {
                            clickAnimation.start()
                        }
                    }

                    onClicked: {
                        applyResolutionSettings()
                        var timer = Qt.createQmlObject('import QtQml 2.12; Timer {interval: 5000; repeat: false; running: true;}',
                            screenSettingsView, "revertTimer");
                        timer.triggered.connect(function() {
                            if (mainWindow && mainWindow.visibility === Window.FullScreen) {
                                mainWindow.visibility = Window.Windowed
                            }
                            if (gameWindow && gameWindow.visibility === Window.FullScreen) {
                                gameWindow.visibility = Window.Windowed
                            }
                        });
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        settingsChanged.connect(function() {
            var settings = {
                brightness: brightnessSlider.value,
                contrast: contrastSlider.value,
                autoAdjust: autoAdjustSwitch.checked,
                windowMode: windowModeComboBox.currentIndex,
                resolution: resolutionComboBox.currentIndex,
                refreshRate: refreshRateComboBox.currentIndex,
                vsync: vsyncSwitch.checked
            };

            if (Qt.application.arguments.indexOf("--debug") !== -1) {
                console.log("Screen settings changed:", JSON.stringify(settings));
            }
        });
    }
}
