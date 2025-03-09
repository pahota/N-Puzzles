#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "gameboard.h"
#include "score.h"
#include "AudioController.h"
#include <QQmlContext>
#include <QIcon>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setOrganizationName("SmaktaTeam");
    app.setApplicationName("15-Puzzles");
    app.setApplicationVersion("0.7.2.7");

    QQmlApplicationEngine engine;

    GameBoard model;
    app.setWindowIcon(QIcon(":/Img/Icons/app_icon.png"));

    qmlRegisterType<GameBoard>("Game", 1, 0, "GameBoardModel");
    qmlRegisterType<AudioController>("AudioComponents", 1, 0, "AudioController");
    qmlRegisterType<Score>("GameComponents", 1, 0, "Score");

    Score* scoreManager = new Score(&engine);
    engine.rootContext()->setContextProperty("scoreManager", scoreManager);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("TagGame", "Main");

    return app.exec();
}
