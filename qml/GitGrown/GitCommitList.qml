import QtQuick 2.0

ListModel {
    id: gitCommitList

    property variant git:Git {

    }

    function update() {
        clear();

        var Item = function(item) {
            this.hash = item[0];
            this.name = item[1];

        }

        var output = git.cmd("log", ["--pretty=format:%h:%p%n%s", "--name-only"]);
        if (output.length == 0)
            return;

        console.log("log:\n" + output);
    }

    Component.onCompleted: {
        update();
    }
}
