#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "gameboard.h"
#include <QQmlContext>
#include "AudioController.h"
#include <QIcon>
int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setOrganizationName("SmaktaTeam");
    app.setApplicationName("15-Puzzles");
    app.setApplicationVersion("0.7.2.7");
    GameBoard model;
    app.setWindowIcon(QIcon(":/Img/Icons/app_icon.png"));
    qmlRegisterType<GameBoard>("Game", 1, 0, "GameBoardModel");
    qmlRegisterType<AudioController>("AudioComponents", 1, 0, "AudioController");
    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("TagGame", "Main");

    return app.exec();
}
