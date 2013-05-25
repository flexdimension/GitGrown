import QtQuick 2.0

QtObject {
    id: git
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
        return gGit.execute("git", gitCmd + " " + args, sync);
    }
}
