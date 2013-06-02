import QtQuick 2.0

QtObject {
    id: git

    signal resulted(string output)

    function execute(cmd, args, sync) {
        if (!sync)
            sync = true;
        if (!args)
            args = "";

        return gGit.execute(cmd, args, sync);
    }

    function cmd(gitCmd, args, sync) {
        if (!sync)
            sync = true;
        if (!args)
            args = "";

        return gGit.execute("git", [gitCmd].concat(args), sync);
    }

    Component.onCompleted: {
        gGit.resulted.connect(resulted);
    }
}
