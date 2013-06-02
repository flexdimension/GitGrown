#include "gitproject.h"

#include <QDir>

GitProject::GitProject(QObject *parent, QString path ) :
    QObject(parent)
    , _currentPath(path)
    , _process(NULL)
{
}

GitProject::~GitProject()
{
}

QString GitProject::execute(QString cmd, QStringList args, bool sync)
{
    if(_process)
        delete _process;

    _process = new QProcess(this);

    _process->setWorkingDirectory(_currentPath);
    _process->setReadChannel(QProcess::StandardOutput);

    if (sync) {
        _process->start(cmd, args);

        _process->waitForFinished();
        onReadyToRead();

        return _output;
    } else {
        connect(_process, &QProcess::readyReadStandardOutput,
                this, &GitProject::onReadyToRead);

        _process->start(cmd, args);

        return QString();
    }
}

void GitProject::onReadyToRead()
{
    _output = _process->readAllStandardOutput();
    _output.resize(_output.length() - 1);

    emit resulted(_output);
}

QString GitProject::currentPath()
{
    return _currentPath;
}

QString GitProject::output()
{
    return _output;
}

bool GitProject::setCurrentPath(QString path)
{
    QDir dir;
    if (!dir.exists(path))
        return false;

    _currentPath = path;
    return isGitProject();
}

bool GitProject::isGitProject()
{
    QDir dir;

    dir.setPath(_currentPath);

    if (dir.exists(".git"))
        return true;
    else
        return false;
}
