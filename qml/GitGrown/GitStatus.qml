import QtQuick 2.0

ListModel {
    id: gitStatus

    property variant git:Git {
        onResulted: {
            //console.log("git status resulted");
        }
    }

    function update() {
        clear();

        var Item = function(itemStatus, fileName) {
            this.status = itemStatus;
            this.name = fileName;
        };

        Item.prototype.isStaging = function() {
            return String(" ?").indexOf(this.status.charAt(0)) == -1;
        };

        Item.prototype.isWorking = function() {
            return this.status.charAt(1) != " ";
        };



        var output = git.cmd("status", ["-s"]);
        if (output.length == 0)
            return;


        output = output.split("\n");


        console.log("status:" + output.length + "-" + output + "-");

        for (var i = 0; i < output.length; i++) {
            var itemStatus = output[i].substring(0, 2);
            var fileName = output[i].substring(3);

            var item = new Item(itemStatus, fileName);
            append(item);

            console.log("item:" + item);
        }
    }

    function stageFile(idx) {
        var item = get(idx);
        git.cmd("add", [item.name]);
        update();
    }

    function unstageFile(idx) {
        var item = get(idx);
        git.cmd("rm", ["--cached", item.name]);
        update();
    }

    function commit(comment) {

        var rslt = git.cmd("commit", ["-m", "\"" + comment + "\"" ]);
        update();
        return rslt;
    }

    Component.onCompleted: {
        update();
    }
}
