import QtQuick 2.15

QtObject {
    id: theme
    property int themeIndex: 0

    property var baseColors: [
        {
            background: "#FFFFFF",
            backgroundSecondary: "#F5F5F5",
            card: "#FFFFFF",
            cardSelected: "#F0F0F0",
            text: "#000000",
            textSecondary: "#666666",
            accent: "#52EF9B",
            accentGradientStart: "#52EF9B",
            accentGradientEnd: "#38BD75",
            shadow: "#20000000"
        },
        {
            background: "#1A1A1A",
            backgroundSecondary: "#262626",
            card: "#242424",
            cardSelected: "#2E2E2E",
            text: "#FFFFFF",
            textSecondary: "#CCCCCC",
            accent: "#52EF9B",
            accentGradientStart: "#52EF9B",
            accentGradientEnd: "#38BD75",
            shadow: "#40000000"
        },
        {
            background: "#1A1A1A",
            backgroundSecondary: "#262626",
            card: "#242424",
            cardSelected: "#2E2E2E",
            text: "#FFFFFF",
            textSecondary: "#CCCCCC",
            accent: "#FF6B6B",
            accentGradientStart: "#FF6B6B",
            accentGradientEnd: "#FF4141",
            shadow: "#40000000"
        }
    ]

    property var windowColors: ["#F5F0E6", "#1A1A1A", "#1E1E2E"]
    property var tileColors: ["#D2B48C", "#2E2E2E", "#2A2A3A"]
    property var tileBorderColors: ["#A67C52", "#444444", "#444455"]
    property var tileTextColors: ["#242424", "#FFFFFF", "#F0F0F0"]
    property var highlightColors: ["#8B4513", "#52EF9B", "#8BE9FD"]
    property var alternateHighlightColors: ["#CD853F", "#38BD75", "#79DFDF"]
    property var lastMovedTileColors: ["#DEB887", "#4CAF50", "#64FFDA"]
    property var counterBackgroundColors: ["#F8F0E3", "#262626", "#333344"]
    property var counterTextColors: ["#242424", "#FFFFFF", "#F0F0F0"]
    property var moveCounterTextColors: ["#242424", "#FFFFFF", "#52EF9B"]
    property var timerCounterTextColors: ["#242424", "#FFFFFF", "#FF6B6B"]
    property var gameBoardBackgroundColors: ["#E8D0AA", "#242424", "#222233"]

    property var buttonBackgroundColors: ["#FFFFFF", "#2E2E2E", "#2E2E2E"]
    property var buttonBorderColors: ["#52EF9B", "#52EF9B", "#8BE9FD"]
    property var disabledButtonColors: ["#E0E0E0", "#3A3A3A", "#3A3A3A"]
    property var navigationBarColors: ["#FFFFFF", "#1A1A1A", "#1A1A1A"]
    property var separatorColors: ["#EEEEEE", "#333333", "#333344"]
    property var inputFieldBackgroundColors: ["#F5F5F5", "#262626", "#262626"]
    property var tooltipBackgroundColors: ["#F0F0F0", "#333333", "#333344"]
    property var tooltipTextColors: ["#000000", "#FFFFFF", "#F0F0F0"]
    property var successColors: ["#4CAF50", "#4CAF50", "#50FA7B"]
    property var warningColors: ["#FF9800", "#FF9800", "#FFB86C"]
    property var errorColors: ["#F44336", "#F44336", "#FF5555"]
    property var infoColors: ["#2196F3", "#2196F3", "#8BE9FD"]

    property color backgroundColor: baseColors[themeIndex].background
    property color backgroundSecondaryColor: baseColors[themeIndex].backgroundSecondary
    property color cardColor: baseColors[themeIndex].card
    property color cardSelectedColor: baseColors[themeIndex].cardSelected
    property color textColor: baseColors[themeIndex].text
    property color textSecondaryColor: baseColors[themeIndex].textSecondary
    property color accentColor: baseColors[themeIndex].accent
    property color accentGradientStartColor: baseColors[themeIndex].accentGradientStart
    property color accentGradientEndColor: baseColors[themeIndex].accentGradientEnd
    property color shadowColor: baseColors[themeIndex].shadow

    property color windowColor: windowColors[themeIndex]
    property color tileColor: tileColors[themeIndex]
    property color tileBorderColor: tileBorderColors[themeIndex]
    property color tileTextColor: tileTextColors[themeIndex]
    property color highlightColor: highlightColors[themeIndex]
    property color alternateHighlightColor: alternateHighlightColors[themeIndex]
    property color lastMovedTileColor: lastMovedTileColors[themeIndex]
    property color counterBackgroundColor: counterBackgroundColors[themeIndex]
    property color counterTextColor: counterTextColors[themeIndex]
    property color moveCounterTextColor: moveCounterTextColors[themeIndex]
    property color timerCounterTextColor: timerCounterTextColors[themeIndex]
    property color gameBoardBackgroundColor: gameBoardBackgroundColors[themeIndex]
    property color primaryColor: highlightColors[themeIndex]

    property color buttonBackgroundColor: buttonBackgroundColors[themeIndex]
    property color buttonBorderColor: buttonBorderColors[themeIndex]
    property color disabledButtonColor: disabledButtonColors[themeIndex]
    property color navigationBarColor: navigationBarColors[themeIndex]
    property color separatorColor: separatorColors[themeIndex]
    property color inputFieldBackgroundColor: inputFieldBackgroundColors[themeIndex]
    property color tooltipBackgroundColor: tooltipBackgroundColors[themeIndex]
    property color tooltipTextColor: tooltipTextColors[themeIndex]
    property color successColor: successColors[themeIndex]
    property color warningColor: warningColors[themeIndex]
    property color errorColor: errorColors[themeIndex]
    property color infoColor: infoColors[themeIndex]

    property var accentGradient: Gradient {
        GradientStop { position: 0.0; color: accentGradientStartColor }
        GradientStop { position: 1.0; color: accentGradientEndColor }
    }

    Behavior on backgroundColor { ColorAnimation { duration: 200 } }
    Behavior on backgroundSecondaryColor { ColorAnimation { duration: 200 } }
    Behavior on cardColor { ColorAnimation { duration: 200 } }
    Behavior on cardSelectedColor { ColorAnimation { duration: 200 } }
    Behavior on textColor { ColorAnimation { duration: 200 } }
    Behavior on textSecondaryColor { ColorAnimation { duration: 200 } }
    Behavior on accentColor { ColorAnimation { duration: 200 } }
    Behavior on accentGradientStartColor { ColorAnimation { duration: 200 } }
    Behavior on accentGradientEndColor { ColorAnimation { duration: 200 } }
    Behavior on shadowColor { ColorAnimation { duration: 200 } }

    Behavior on windowColor { ColorAnimation { duration: 200 } }
    Behavior on tileColor { ColorAnimation { duration: 200 } }
    Behavior on tileBorderColor { ColorAnimation { duration: 200 } }
    Behavior on tileTextColor { ColorAnimation { duration: 200 } }
    Behavior on highlightColor { ColorAnimation { duration: 200 } }
    Behavior on alternateHighlightColor { ColorAnimation { duration: 200 } }
    Behavior on lastMovedTileColor { ColorAnimation { duration: 200 } }
    Behavior on counterBackgroundColor { ColorAnimation { duration: 200 } }
    Behavior on counterTextColor { ColorAnimation { duration: 200 } }
    Behavior on gameBoardBackgroundColor { ColorAnimation { duration: 200 } }
    Behavior on primaryColor { ColorAnimation { duration: 200 } }
    Behavior on moveCounterTextColor { ColorAnimation { duration: 200 } }
    Behavior on timerCounterTextColor { ColorAnimation { duration: 200 } }

    Behavior on buttonBackgroundColor { ColorAnimation { duration: 200 } }
    Behavior on buttonBorderColor { ColorAnimation { duration: 200 } }
    Behavior on disabledButtonColor { ColorAnimation { duration: 200 } }
    Behavior on navigationBarColor { ColorAnimation { duration: 200 } }
    Behavior on separatorColor { ColorAnimation { duration: 200 } }
    Behavior on inputFieldBackgroundColor { ColorAnimation { duration: 200 } }
    Behavior on tooltipBackgroundColor { ColorAnimation { duration: 200 } }
    Behavior on tooltipTextColor { ColorAnimation { duration: 200 } }
    Behavior on successColor { ColorAnimation { duration: 200 } }
    Behavior on warningColor { ColorAnimation { duration: 200 } }
    Behavior on errorColor { ColorAnimation { duration: 200 } }
    Behavior on infoColor { ColorAnimation { duration: 200 } }

    function setTheme(index) {
        themeIndex = index;
    }
}
