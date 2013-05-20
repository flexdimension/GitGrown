#include <QtTest/QtTest>
#include <QDebug>
#include "../gitproject/gitproject.h"

class TestGitProject: public QObject
{
    Q_OBJECT

private slots:
    void test_constructor() {
        GitProject git(NULL);
        QCOMPARE(git.currentPath(), QString("."));
    }

    void test_execute() {
        GitProject git(NULL);

        QString result = git.execute("git", "version");

        QStringList firstLine = result.split(" ");
        QCOMPARE(firstLine[0], QString("git"));
        QCOMPARE(firstLine[1], QString("version"));
    }
};

QTEST_MAIN(TestGitProject)
#include "testgitproject.moc"
