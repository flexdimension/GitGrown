#include "gitproject.h"

GitProject::GitProject(QObject *parent) :
    QObject(parent)
    , _currentPath(".")
    , _process(NULL)
{
}

GitProject::~GitProject()
{
}

void GitProject::execute(QString input, bool wait)
{
    if(_process)
        delete _process;

    QStringList arguments = input.split(" ", QString::SkipEmptyParts);

    _process = new QProcess(this);

    _process->setWorkingDirectory(_currentPath);
    _process->setReadChannel(QProcess::StandardOutput);
    connect(_process, SIGNAL(readyReadStandardOutput()),
            this, SLOT(onReadyToRead()));

    _process->start("git", arguments);

    if (wait)
        _process->waitForFinished();
}

void GitProject::onReadyToRead()
{
    _output = QString(_process->readAllStandardOutput()).split("\n", QString::SkipEmptyParts);
}

QString GitProject::currentPath()
{
    return _currentPath;
}

QStringList GitProject::output()
{
    return _output;
}
