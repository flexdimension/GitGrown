import QtQuick 2.0

ListModel {
    property variant git:Git {}

    function update() {
        clear();

        var output = git.cmd("status", "-s").split("\n");

        for (var i = 0; i < output.length; i++) {
            var itemStatus = output[i].substring(0, 2);
            var fileName = output[i].substring(3);

            append({"status":itemStatus, "name":fileName});

            //console.log();
        }
    }

    function stageFile(idx) {
        var item = get(idx);
        git.cmd("add", item.name);
        update();
    }

    function unstageFile(idx) {
        var item = get(idx);
        git.cmd("rm", "--cached " + item.name);
        update();
    }

    Component.onCompleted: {
        update();
    }
}
