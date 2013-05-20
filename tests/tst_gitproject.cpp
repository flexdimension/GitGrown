#include <QtTest/QtTest>
#include <QDebug>
#include "../gitproject/gitproject.h"

class tst_GitProject: public QObject
{
    Q_OBJECT

private slots:
    void construction();
    void execute();
};

void test_GitProject::construction()
{
    GitProject git(NULL);
    QCOMPARE(git.currentPath(), QString("."));
}

void test_GitProject::execute()
{
    GitProject git(NULL);

    QString result = git.execute("git", "version");

    QStringList firstLine = result.split(" ");
    QCOMPARE(firstLine[0], QString("git"));
    QCOMPARE(firstLine[1], QString("version"));
}

QTEST_MAIN(TestGitProject)
#include "testgitproject.moc"
