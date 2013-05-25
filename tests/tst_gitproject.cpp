#include <QtTest/QtTest>
#include <QDir>
#include <QDebug>
#include "../gitproject/gitproject.h"

class tst_GitProject: public QObject
{
    Q_OBJECT

private slots:
    void initTestCase();
    void construction();
    void execute();
    void setCurrentPath();

    void mkdir();
    void cleanupTestCase();
};

void tst_GitProject::initTestCase()
{
    QDir dir;

    if (dir.exists("tst_project")) {
        dir.rmpath("tst_project");
    }

    dir.mkdir("tst_project");

    QDir::setCurrent("tst_project");

    qDebug() << "created tst_project folder";
    qDebug() << QDir::currentPath();
}

void tst_GitProject::cleanupTestCase()
{
}

void tst_GitProject::construction()
{
    GitProject git(NULL);
    QCOMPARE(git.currentPath(), QString("."));
}

void tst_GitProject::execute()
{
    GitProject git(NULL);

    QString result = git.execute("git", "version");

    QStringList firstLine = result.split(" ");
    QCOMPARE(firstLine[0], QString("git"));
    QCOMPARE(firstLine[1], QString("version"));
}

void tst_GitProject::mkdir()
{
    GitProject git(NULL);

}

void tst_GitProject::setCurrentPath()
{
    GitProject git;
    git.setCurrentPath("..");
    QString result = git.execute("pwd");

    qDebug() << "current path:" << result;
}

QTEST_MAIN(tst_GitProject)
#include "tst_gitproject.moc"
