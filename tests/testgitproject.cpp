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
        git.execute("version", true);

        QCOMPARE(git.output().length(), 1);
        QStringList result = git.output()[0].split(" ");
        QCOMPARE(result[0], QString("git"));
        QCOMPARE(result[1], QString("version"));
    }
};

QTEST_MAIN(TestGitProject)
#include "testgitproject.moc"
