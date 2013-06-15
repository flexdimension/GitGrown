import QtQuick 2.0

ListModel {
    id: gitCommitList

    property variant git:Git {

    }

    function concat(a, b) {
        for (var i = 0; i < b.length; i++) {
            a.push(b[i]);
        }

        return a;
    }


    function update() {
        clear();
        var commitList = buildTable();
        var arrangedList = rearrange(commitList);

        console.log("arrangedList length " + arrangedList.length);
    }

    function buildTable() {
        var commitList = {};

        var Item = function(item) {
            this.hash = item[0];
            this.name = item[1];
            this.parents = item[2];
            this.indent = -1;
            this.index = -1;
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

            //append(new Item([hash, subject]));
            commitList[hash] = new Item([hash, subject, parents]);

            if (commitList.HEAD == undefined) {
                commitList.HEAD = commitList[hash];
                console.log("headCommit :"  + commitList.HEAD);
            }
        }

        return commitList;
    }

    function rearrange(commitList) {
        if (commitList.HEAD == undefined)
            return;

        var head = commitList.HEAD;

        head.indent = 0;
        var commitTree = tree(head, commitList);

        for (var i = 0; i < commitTree.length; i++) {
            append(commitTree[i]);
        }






        return commitTree;
    }

    function tree(child, commitList) {
        var t = [];
        console.log("child length " + child.parents.length);

        for (var i = 0; i < child.parents.length; i++) {
            var parent = commitList[child.parents[i]];

            if (parent.indent != -1)
                continue;

            parent.indent = child.indent + i;
            var pTree = tree(parent, commitList);
            t = concat(pTree, t);
            console.log("concat : " + t.length);
        }

        t.unshift(child);

        return t;
    }

    Component.onCompleted: {
        update();
    }
}
