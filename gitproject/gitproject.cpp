#include "gitproject.h"

GitProject::GitProject(QObject *parent) :
    QObject(parent)
    , _currentPath(".")
    , _process(NULL)
{
}

void GitProject::execute(QString input)
{
    if(_process)
        delete _process;

    QStringList arguments = input.split(" ");

    _process = new QProcess(this);

    _process->setWorkingDirectory(_currentPath);
    _process->setReadChannel(QProcess::StandardOutput);
    connect(_process, SIGNAL(readyReadStandardOutput()),
            this, SLOT(onReadyToRead()));
    _process->start("git", arguments);
}

void GitProject::onReadyToRead()
{
    _output = QString(_process->readAllStandardOutput()).split("\n");
}

QString GitProject::currentPath()
{
    return _currentPath;
}
