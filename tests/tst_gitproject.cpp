#include <QtTest/QtTest>
#include <QDir>
#include <QFile>
#include <QDebug>
#include "../gitproject/gitproject.h"

class tst_GitProject: public QObject
{
    Q_OBJECT

private:
    void appendToFile(QString fileName, QString text);

private slots:
    void initTestCase();
    void construction();
    void execute();
    void setCurrentPath();

    void mkdir();
    void cleanupTestCase();

    void git_init();
    void git_status();
};

void tst_GitProject::appendToFile(QString fileName, QString text)
{
    QFile file(fileName);
    if (!file.open(QIODevice::Append | QIODevice::Text))
        return;

    QTextStream out(&file);
    out << text << "\n";
}

void tst_GitProject::initTestCase()
{
    QDir dir;

    //clear tst_project if exists
    if (dir.exists("tst_project")) {
        GitProject git;
        QString result = git.execute("rm", QStringList() << "-rf" << "tst_project");
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
    GitProject git;
    QCOMPARE(git.currentPath(), QString("."));
}

void tst_GitProject::execute()
{
    GitProject git;

    QString result = git.execute("git", QStringList() << "version");

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
    bool isGitProject = git.setCurrentPath(".");
    qDebug() << "isGitProject:" << isGitProject;
    QVERIFY(isGitProject == false);
}

void tst_GitProject::git_init()
{
    GitProject git;
    QString result = git.execute("pwd");
    qDebug() << "current path:" << result;

    QVERIFY(git.setCurrentPath(".") == false);

    git.execute("git", QStringList("init"));

    QVERIFY(git.isGitProject());
}

void tst_GitProject::git_status()
{
    QString fileName("testFile.txt");
    GitProject git;
    git.execute("touch", QStringList() << fileName);
    QString result = git.execute("git", QStringList() << "status" << "-s").split("\n")[0];
    qDebug() << result;

    QString status = result.left(2);
    QString fileName01 = result.mid(3);

    QCOMPARE(status, QString("??"));
    QCOMPARE(fileName01, fileName);

    git.execute("git", QStringList() << "add" << fileName);
    status = git.execute("git", QStringList() << "status" << "-s").split("\n")[0].left(2);
    QCOMPARE(status, QString("A "));

    appendToFile(fileName, "test01");
    status = git.execute("git", QStringList() << "status" << "-s").split("\n")[0].left(2);
    QCOMPARE(status, QString("AM"));

    git.execute("git", QStringList() << "rm" << "--cached" << "-f" << fileName);
    status = git.execute("git", QStringList() << "status" << "-s").split("\n")[0].left(2);
    QCOMPARE(status, QString("??"));
}

QTEST_MAIN(tst_GitProject)
#include "tst_gitproject.moc"
