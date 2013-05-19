#ifndef GITPROJECT_H
#define GITPROJECT_H

#include <QObject>
#include <QProcess>

class GitProject : public QObject
{
    Q_OBJECT
public:
    explicit GitProject(QObject *parent = 0);
    ~GitProject();

signals:
    
public slots:
    void execute(QString input, bool wait = false);
    void onReadyToRead();

private:
    QString _currentPath;
    QStringList _output;

    QProcess* _process;

public:
    QString currentPath();
    QStringList output();
};

#endif // GITPROJECT_H
