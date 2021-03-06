#ifndef GITPROJECT_H
#define GITPROJECT_H

#include <QObject>
#include <QProcess>

class GitProject : public QObject
{
    Q_OBJECT
public:
    explicit GitProject(QObject *parent = 0, QString path = ".");
    ~GitProject();

signals:
    void resulted(QString);
    
public slots:
    void onReadyToRead();

    QString execute(QString cmd, QStringList args = QStringList(), bool sync = true);
    bool setCurrentPath(QString path);
    bool isGitProject();

private:
    QString _currentPath;
    QString _output;

    QProcess* _process;

public:
    QString currentPath();
    QString output();
};

#endif // GITPROJECT_H
