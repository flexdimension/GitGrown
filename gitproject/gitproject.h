#ifndef GITPROJECT_H
#define GITPROJECT_H

#include <QObject>
#include <QProcess>

class GitProject : public QObject
{
    Q_OBJECT
public:
    explicit GitProject(QObject *parent = 0);
    
signals:
    
public slots:
    void execute(QString input);
    void onReadyToRead();

private:
    QString _currentPath;
    QStringList _output;

    QProcess* _process;

public:
    QString currentPath();
};

#endif // GITPROJECT_H
