cmake_minimum_required(VERSION 3.16)

project(TagGame VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)
find_package(Qt6 REQUIRED COMPONENTS Multimedia)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appTagGame
    main.cpp
)

qt_add_qml_module(appTagGame
    URI TagGame
    VERSION 1.0
    QML_FILES
        Main.qml
        QML_FILES Tile.qml
        QML_FILES GameBoard.qml
        QML_FILES
        SOURCES gameboard.h gameboard.cpp
        RESOURCES recources.qrc
        QML_FILES
        QML_FILES
        QML_FILES
        QML_FILES
        QML_FILES Theme.qml
        QML_FILES
        QML_FILES Settings.qml
        RESOURCES
        SOURCES
        QML_FILES
        QML_FILES AboutGame.qml
        QML_FILES MainMenu.qml
        QML_FILES MenuButton.qml
        QML_FILES Highscores.qml
        QML_FILES Profile.qml
        QML_FILES Sound.qml
        SOURCES AudioController.h AudioController.cpp
        QML_FILES Pause.qml
        QML_FILES ScreenSettings.qml
        QML_FILES Background.qml
        QML_FILES PauseButton.qml
        QML_FILES Score.qml
        SOURCES score.h
        SOURCES score.cpp
        QML_FILES DifficultyButton.qml
        SOURCES gameboardmodel.h gameboardmodel.cpp
        QML_FILES WinDialog.qml
        QML_FILES Login.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appTagGame PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appTagGame
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appTagGame
    PRIVATE Qt6::Quick Qt6::Qml Qt6::Core Qt6::Multimedia
)

include(GNUInstallDirs)
install(TARGETS appTagGame
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
