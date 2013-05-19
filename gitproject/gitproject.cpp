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

QStringList GitProject::execute(QString input, bool sync)
{
    if(_process)
        delete _process;

    QStringList arguments = input.split(" ", QString::SkipEmptyParts);

    _process = new QProcess(this);

    _process->setWorkingDirectory(_currentPath);
    _process->setReadChannel(QProcess::StandardOutput);

    if (sync) {
        _process->start("git", arguments);

        _process->waitForFinished();
        onReadyToRead();

        return _output;
    } else {
        connect(_process, &QProcess::readyReadStandardOutput,
                this, &GitProject::onReadyToRead);

        _process->start("git", arguments);

        return QStringList();
    }
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
