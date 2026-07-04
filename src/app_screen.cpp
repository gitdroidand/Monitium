#include "app_screen.hpp"
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

int AppScreen::run(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // Finance Manager
    auto financeManager = new FinanceManager(&app);
    engine.rootContext()->setContextProperty("financeManager", financeManager);

    engine.loadFromModule("MonitoDesktop", "Launcher");

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}