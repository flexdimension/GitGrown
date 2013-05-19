#include <QtTest/QtTest>
#include "../gitproject/gitproject.h"

class TestGitProject: public QObject
{
    Q_OBJECT

private slots:
    void testConstructor();
};

void TestGitProject::testConstructor()
{
    GitProject git(NULL);

    QCOMPARE(git.currentPath(), QString("."));
}

QTEST_MAIN(TestGitProject)
#include "testgitproject.moc"
