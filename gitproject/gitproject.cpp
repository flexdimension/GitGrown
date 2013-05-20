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

QString GitProject::execute(QString cmd, QString args, bool sync)
{
    if(_process)
        delete _process;

    QStringList arguments = args.split(" ", QString::SkipEmptyParts);

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

        _process->start(cmd, arguments);

        return QString();
    }
}

void GitProject::onReadyToRead()
{
    _output = _process->readAllStandardOutput();
}

QString GitProject::currentPath()
{
    return _currentPath;
}

QString GitProject::output()
{
    return _output;
}
