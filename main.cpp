#include <QtGui/QGuiApplication>
#include <QQmlContext>
#include "qtquick2applicationviewer.h"
#include "gitproject/gitproject.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QtQuick2ApplicationViewer viewer;

    GitProject git;

    QQmlContext *context = viewer.rootContext();
    context->setContextProperty("git", &git);

    viewer.setMainQmlFile(QStringLiteral("qml/GitGrown/main.qml"));
    viewer.showExpanded();

    return app.exec();
}
