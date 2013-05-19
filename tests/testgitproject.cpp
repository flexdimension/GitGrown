#include <QtTest/QtTest>
#include <QDebug>
#include "../gitproject/gitproject.h"

class TestGitProject: public QObject
{
    Q_OBJECT

private slots:
    void testConstructor() {
        GitProject git(NULL);
        QCOMPARE(git.currentPath(), QString("."));
    }

    void testExecute() {
        GitProject git(NULL);

        QStringList result = git.execute("version");

        QCOMPARE(result.length(), 1);
        QStringList firstLine = result[0].split(" ");
        QCOMPARE(firstLine[0], QString("git"));
        QCOMPARE(firstLine[1], QString("version"));
    }
};

QTEST_MAIN(TestGitProject)
#include "testgitproject.moc"
