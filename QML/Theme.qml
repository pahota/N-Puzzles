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
            accent: "#2ECFCA",
            accentGradientStart: "#2ECFCA",
            accentGradientEnd: "#20B2AE",
            shadow: "#40000000"
        }
    ]

    property var windowColors: ["#F5F0E6", "#1A1A1A", "#1E1E2E"]
    property var tileColors: ["#D2B48C", "#2E2E2E", "#2A2A3A"]
    property var tileBorderColors: ["#A67C52", "#444444", "#444455"]
    property var tileTextColors: ["#242424", "#FFFFFF", "#F0F0F0"]
    property var highlightColors: ["#8B4513", "#52EF9B", "#2ECFCA"]
    property var alternateHighlightColors: ["#CD853F", "#38BD75", "#20B2AE"]
    property var lastMovedTileColors: ["#DEB887", "#4CAF50", "#4DDBD7"]
    property var counterBackgroundColors: ["#F8F0E3", "#262626", "#333344"]
    property var counterTextColors: ["#242424", "#FFFFFF", "#F0F0F0"]
    property var moveCounterTextColors: ["#242424", "#FFFFFF", "#14FF5B"]
    property var timerCounterTextColors: ["#242424", "#FFFFFF", "#FF6347"]
    property var gameBoardBackgroundColors: ["#E8D0AA", "#242424", "#222233"]

    property var buttonBackgroundColors: ["#FFFFFF", "#2E2E2E", "#2E2E2E"]
    property var buttonBorderColors: ["#52EF9B", "#52EF9B", "#2ECFCA"]

    property var pauseButtonBackgroundColors: ["#FFFFFF", "#2E2E2E", "#2E2E2E"]
    property var pauseButtonBorderColors: ["#52EF9B", "#52EF9B", "#FF5D8F"]
    property var pauseButtonTextColors: ["#242424", "#FFFFFF", "#FF5D8F"]
    property var pauseButtonIconColors: ["#52EF9B", "#52EF9B", "#FF5D8F"]

    property var restartButtonBackgroundColors: ["#FFFFFF", "#2E2E2E", "#2E2E2E"]
    property var restartButtonBorderColors: ["#52EF9B", "#52EF9B", "#9370DB"]
    property var restartButtonTextColors: ["#242424", "#FFFFFF", "#9370DB"]
    property var restartButtonIconColors: ["#52EF9B", "#52EF9B", "#9370DB"]

    property var menuButtonBackgroundColors: ["#FFFFFF", "#2E2E2E", "#2E2E2E"]
    property var menuButtonBorderColors: ["#52EF9B", "#52EF9B", "#FFB86C"]
    property var menuButtonTextColors: ["#242424", "#FFFFFF", "#FFB86C"]
    property var menuButtonIconColors: ["#52EF9B", "#52EF9B", "#FFB86C"]

    property var settingsButtonBackgroundColors: ["#FFFFFF", "#2E2E2E", "#2E2E2E"]
    property var settingsButtonBorderColors: ["#52EF9B", "#52EF9B", "#1E90FF"]
    property var settingsButtonTextColors: ["#242424", "#FFFFFF", "#1E90FF"]
    property var settingsButtonIconColors: ["#52EF9B", "#52EF9B", "#1E90FF"]

    property var aboutGameButtonBackgroundColors: ["#FFFFFF", "#2E2E2E", "#2E2E2E"]
    property var aboutGameButtonBorderColors: ["#52EF9B", "#52EF9B", "#4CAF50"]
    property var aboutGameButtonTextColors: ["#242424", "#FFFFFF", "#4CAF50"]
    property var aboutGameButtonIconColors: ["#52EF9B", "#52EF9B", "#4CAF50"]

    property var disabledButtonColors: ["#E0E0E0", "#3A3A3A", "#3A3A3A"]
    property var navigationBarColors: ["#FFFFFF", "#1A1A1A", "#1A1A1A"]
    property var separatorColors: ["#EEEEEE", "#333333", "#333344"]
    property var inputFieldBackgroundColors: ["#F5F5F5", "#262626", "#262626"]
    property var tooltipBackgroundColors: ["#F0F0F0", "#333333", "#333344"]
    property var tooltipTextColors: ["#000000", "#FFFFFF", "#F0F0F0"]
    property var successColors: ["#4CAF50", "#4CAF50", "#50FA7B"]
    property var warningColors: ["#FF9800", "#FF9800", "#FFB86C"]
    property var errorColors: ["#F44336", "#F44336", "#FF5555"]
    property var infoColors: ["#2196F3", "#2196F3", "#2ECFCA"]

    property var loginWindowBackgroundColors: ["#FFFFFF", "#1A1A1A", "#1E1E2E"]
    property var loginHeaderBackgroundColors: ["#2196F3", "#2e86de", "#54a0ff"]
    property var loginHeaderGradientStartColors: ["#1E88E5", "#2e86de", "#2e86de"]
    property var loginHeaderGradientEndColors: ["#42A5F5", "#54a0ff", "#54a0ff"]
    property var loginHeaderTextColors: ["#FFFFFF", "#FFFFFF", "#FFFFFF"]
    property var loginHeaderGlowColors: ["#1565C0", "#4056a1", "#4056a1"]
    property var loginInputFieldBackgroundColors: ["#F5F5F5", "rgba(0.15, 0.18, 0.22, 0.8)", "rgba(0.15, 0.18, 0.22, 0.8)"]
    property var loginInputFieldBorderColors: ["#2196F3", "#54a0ff", "#54a0ff"]
    property var loginInputTextColors: ["#000000", "#FFFFFF", "#FFFFFF"]
    property var loginPlaceholderTextColors: ["#9E9E9E", "#8395a7", "#8395a7"]
    property var loginButtonGradientStartColors: ["#1E88E5", "#2e86de", "#2e86de"]
    property var loginButtonGradientEndColors: ["#42A5F5", "#54a0ff", "#54a0ff"]
    property var loginButtonTextColors: ["#FFFFFF", "#FFFFFF", "#FFFFFF"]
    property var loginButtonShadowColors: ["#1565C0", "#4056a1", "#4056a1"]
    property var registerButtonBorderColors: ["#673AB7", "#5f27cd", "#5f27cd"]
    property var registerButtonHoverBorderColors: ["#7E57C2", "#8e44ad", "#8e44ad"]
    property var registerButtonTextColors: ["#FFFFFF", "#c8d6e5", "#c8d6e5"]
    property var loginForgotPasswordTextColors: ["#2196F3", "#48dbfb", "#48dbfb"]
    property var loginAvatarCircleColors: ["#263238", "#212c3d", "#212c3d"]
    property var loginAvatarCircleBorderColors: ["#2196F3", "#54a0ff", "#54a0ff"]
    property var loginAvatarNumberColors: ["#2196F3", "#54a0ff", "#54a0ff"]
    property var loginAvatarInnerCircleColors: ["#1E88E5", "#70a1ff", "#70a1ff"]
    property var loginAvatarOuterCircleColors: ["#1565C0", "#4056a1", "#4056a1"]
    property var loginCheckboxBorderColors: ["#2196F3", "#54a0ff", "#54a0ff"]
    property var loginCheckboxInnerColors: ["#2196F3", "#54a0ff", "#54a0ff"]
    property var loginTextColors: ["#212121", "#dfe6e9", "#dfe6e9"]
    property var loginWindowShadowColors: ["#212121", "#0a0e17", "#0a0e17"]

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

    property color pauseButtonBackgroundColor: pauseButtonBackgroundColors[themeIndex]
    property color pauseButtonBorderColor: pauseButtonBorderColors[themeIndex]
    property color pauseButtonTextColor: pauseButtonTextColors[themeIndex]
    property color pauseButtonIconColor: pauseButtonIconColors[themeIndex]

    property color restartButtonBackgroundColor: restartButtonBackgroundColors[themeIndex]
    property color restartButtonBorderColor: restartButtonBorderColors[themeIndex]
    property color restartButtonTextColor: restartButtonTextColors[themeIndex]
    property color restartButtonIconColor: restartButtonIconColors[themeIndex]

    property color menuButtonBackgroundColor: menuButtonBackgroundColors[themeIndex]
    property color menuButtonBorderColor: menuButtonBorderColors[themeIndex]
    property color menuButtonTextColor: menuButtonTextColors[themeIndex]
    property color menuButtonIconColor: menuButtonIconColors[themeIndex]

    property color settingsButtonBackgroundColor: settingsButtonBackgroundColors[themeIndex]
    property color settingsButtonBorderColor: settingsButtonBorderColors[themeIndex]
    property color settingsButtonTextColor: settingsButtonTextColors[themeIndex]
    property color settingsButtonIconColor: settingsButtonIconColors[themeIndex]

    property color aboutGameButtonBackgroundColor: aboutGameButtonBackgroundColors[themeIndex]
    property color aboutGameButtonBorderColor: aboutGameButtonBorderColors[themeIndex]
    property color aboutGameButtonTextColor: aboutGameButtonTextColors[themeIndex]
    property color aboutGameButtonIconColor: aboutGameButtonIconColors[themeIndex]

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

    property color loginWindowBackgroundColor: loginWindowBackgroundColors[themeIndex]
    property color loginHeaderBackgroundColor: loginHeaderBackgroundColors[themeIndex]
    property color loginHeaderGradientStartColor: loginHeaderGradientStartColors[themeIndex]
    property color loginHeaderGradientEndColor: loginHeaderGradientEndColors[themeIndex]
    property color loginHeaderTextColor: loginHeaderTextColors[themeIndex]
    property color loginHeaderGlowColor: loginHeaderGlowColors[themeIndex]
    property color loginInputFieldBackgroundColor: loginInputFieldBackgroundColors[themeIndex]
    property color loginInputFieldBorderColor: loginInputFieldBorderColors[themeIndex]
    property color loginInputTextColor: loginInputTextColors[themeIndex]
    property color loginPlaceholderTextColor: loginPlaceholderTextColors[themeIndex]
    property color loginButtonGradientStartColor: loginButtonGradientStartColors[themeIndex]
    property color loginButtonGradientEndColor: loginButtonGradientEndColors[themeIndex]
    property color loginButtonTextColor: loginButtonTextColors[themeIndex]
    property color loginButtonShadowColor: loginButtonShadowColors[themeIndex]
    property color registerButtonBorderColor: registerButtonBorderColors[themeIndex]
    property color registerButtonHoverBorderColor: registerButtonHoverBorderColors[themeIndex]
    property color registerButtonTextColor: registerButtonTextColors[themeIndex]
    property color loginForgotPasswordTextColor: loginForgotPasswordTextColors[themeIndex]
    property color loginAvatarCircleColor: loginAvatarCircleColors[themeIndex]
    property color loginAvatarCircleBorderColor: loginAvatarCircleBorderColors[themeIndex]
    property color loginAvatarNumberColor: loginAvatarNumberColors[themeIndex]
    property color loginAvatarInnerCircleColor: loginAvatarInnerCircleColors[themeIndex]
    property color loginAvatarOuterCircleColor: loginAvatarOuterCircleColors[themeIndex]
    property color loginCheckboxBorderColor: loginCheckboxBorderColors[themeIndex]
    property color loginCheckboxInnerColor: loginCheckboxInnerColors[themeIndex]
    property color loginTextColor: loginTextColors[themeIndex]
    property color loginWindowShadowColor: loginWindowShadowColors[themeIndex]

    property var accentGradient: Gradient {
        GradientStop { position: 0.0; color: accentGradientStartColor }
        GradientStop { position: 1.0; color: accentGradientEndColor }
    }

    property var loginHeaderGradient: Gradient {
        GradientStop { position: 0.0; color: loginHeaderGradientStartColor }
        GradientStop { position: 1.0; color: loginHeaderGradientEndColor }
    }

    property var loginButtonGradient: Gradient {
        GradientStop { position: 0.0; color: loginButtonGradientStartColor }
        GradientStop { position: 1.0; color: loginButtonGradientEndColor }
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

    Behavior on pauseButtonBackgroundColor { ColorAnimation { duration: 200 } }
    Behavior on pauseButtonBorderColor { ColorAnimation { duration: 200 } }
    Behavior on pauseButtonTextColor { ColorAnimation { duration: 200 } }
    Behavior on pauseButtonIconColor { ColorAnimation { duration: 200 } }

    Behavior on restartButtonBackgroundColor { ColorAnimation { duration: 200 } }
    Behavior on restartButtonBorderColor { ColorAnimation { duration: 200 } }
    Behavior on restartButtonTextColor { ColorAnimation { duration: 200 } }
    Behavior on restartButtonIconColor { ColorAnimation { duration: 200 } }

    Behavior on menuButtonBackgroundColor { ColorAnimation { duration: 200 } }
    Behavior on menuButtonBorderColor { ColorAnimation { duration: 200 } }
    Behavior on menuButtonTextColor { ColorAnimation { duration: 200 } }
    Behavior on menuButtonIconColor { ColorAnimation { duration: 200 } }

    Behavior on settingsButtonBackgroundColor { ColorAnimation { duration: 200 } }
    Behavior on settingsButtonBorderColor { ColorAnimation { duration: 200 } }
    Behavior on settingsButtonTextColor { ColorAnimation { duration: 200 } }
    Behavior on settingsButtonIconColor { ColorAnimation { duration: 200 } }

    Behavior on aboutGameButtonBackgroundColor { ColorAnimation { duration: 200 } }
    Behavior on aboutGameButtonBorderColor { ColorAnimation { duration: 200 } }
    Behavior on aboutGameButtonTextColor { ColorAnimation { duration: 200 } }
    Behavior on aboutGameButtonIconColor { ColorAnimation { duration: 200 } }

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

    Behavior on loginWindowBackgroundColor { ColorAnimation { duration: 200 } }
    Behavior on loginHeaderBackgroundColor { ColorAnimation { duration: 200 } }
    Behavior on loginHeaderGradientStartColor { ColorAnimation { duration: 200 } }
    Behavior on loginHeaderGradientEndColor { ColorAnimation { duration: 200 } }
    Behavior on loginHeaderTextColor { ColorAnimation { duration: 200 } }
    Behavior on loginHeaderGlowColor { ColorAnimation { duration: 200 } }
    Behavior on loginInputFieldBackgroundColor { ColorAnimation { duration: 200 } }
    Behavior on loginInputFieldBorderColor { ColorAnimation { duration: 200 } }
    Behavior on loginInputTextColor { ColorAnimation { duration: 200 } }
    Behavior on loginPlaceholderTextColor { ColorAnimation { duration: 200 } }
    Behavior on loginButtonGradientStartColor { ColorAnimation { duration: 200 } }
    Behavior on loginButtonGradientEndColor { ColorAnimation { duration: 200 } }
    Behavior on loginButtonTextColor { ColorAnimation { duration: 200 } }
    Behavior on loginButtonShadowColor { ColorAnimation { duration: 200 } }
    Behavior on registerButtonBorderColor { ColorAnimation { duration: 200 } }
    Behavior on registerButtonHoverBorderColor { ColorAnimation { duration: 200 } }
    Behavior on registerButtonTextColor { ColorAnimation { duration: 200 } }
    Behavior on loginForgotPasswordTextColor { ColorAnimation { duration: 200 } }
    Behavior on loginAvatarCircleColor { ColorAnimation { duration: 200 } }
    Behavior on loginAvatarCircleBorderColor { ColorAnimation { duration: 200 } }
    Behavior on loginAvatarNumberColor { ColorAnimation { duration: 200 } }
    Behavior on loginAvatarInnerCircleColor { ColorAnimation { duration: 200 } }
    Behavior on loginAvatarOuterCircleColor { ColorAnimation { duration: 200 } }
    Behavior on loginCheckboxBorderColor { ColorAnimation { duration: 200 } }
    Behavior on loginCheckboxInnerColor { ColorAnimation { duration: 200 } }
    Behavior on loginTextColor { ColorAnimation { duration: 200 } }
    Behavior on loginWindowShadowColor { ColorAnimation { duration: 200 } }

    function setTheme(index) {
        themeIndex = index;
    }
}
