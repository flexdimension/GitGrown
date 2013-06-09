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

        output = output.split("\n");

        console.log("log:\n" + output);

        for (var i = 0; i < output.length; i++) {
            var lineStr = output[i];

            var hash = lineStr.split(":")[0];
            var parents = [];

            var parentsString = lineStr.split(":")[1];
            if (parentsString && parentsString.length > 0) {
                parents = parentsString.split(" ");
            }

            var subject = "";
            var files = [];

            if (parents.length == 1) {
                i++;
                subject = output[i];

                while (true) {
                    i++;
                    if(output[i].length == 0)
                        break;

                    files.push(output[i]);
                }
            } else {
                i++;
                subject = output[i];
            }

            append(new Item([hash, subject]));
        }
    }

    Component.onCompleted: {
        update();
    }
}
