#include <QtGui/QGuiApplication>
#include <QQmlContext>
#include "qtquick2applicationviewer.h"
#include "gitproject/gitproject.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QString path(".");

    if (argc == 2) {
        path = argv[1];
    }

    QtQuick2ApplicationViewer viewer;

    GitProject git;
    git.setCurrentPath(path);

    QQmlContext *context = viewer.rootContext();
    context->setContextProperty("gGit", &git);

    viewer.setMainQmlFile(QStringLiteral("qml/GitGrown/main.qml"));
    viewer.showExpanded();

    return app.exec();
}
