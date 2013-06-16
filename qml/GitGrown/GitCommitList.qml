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
            this.graph = [];
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

    function getGraph(cur, prev) {
        var graph = [];

        if (prev == undefined) {
            //graph[cur.indent] = ['*'];
            //return graph;
            prev = [];
            prev.graph = [];
        }

        graph = prev.graph.slice();

        for (var i = 0; i < prev.graph.length; i++) {

            if (prev.graph[i] == '/')
                graph[i] = ' ';

            if (prev.graph[i] == '\\')
              graph[i] = prev.parents[1];

            if (prev.graph[i] == '*')
                graph[i] = prev.parents[0];

            if (prev.graph[i] == undefined)
                prev.graph[i] = ' ';

            if (prev.graph[i].length > 1)
                prev.graph[i] = '|';

            if (graph[i] == cur.hash && i != cur.indent) {
                graph[i] = '/';
            }
        }

        graph[cur.indent] = '*';

        for (var i = graph.length - 1; i >= 0; i--) {
            if (graph[i] == ' ') {
                graph.pop();
            }
            else
                break;
        }

        if (cur.parents.length == 2) {
            graph[graph.length] = '\\';
        }



        console.log('prv ' + prev.hash + ':' + prev.graph);
        console.log('cur ' + cur.hash + ':' + graph);

        return graph;
    }

    function rearrange(commitList) {
        if (commitList.HEAD == undefined)
            return;

        var head = commitList.HEAD;

        head.indent = 0;
        //head.graph[head.indent] = ['*'];
        head.graph = getGraph(head);
        append(head);

        var commitTree = tree(head, commitList);

        for (var i = 1; i < commitTree.length; i++) {
            var cur = commitTree[i];
            var prev = commitTree[i - 1];

            cur.graph = getGraph(cur, prev);

            append(commitTree[i]);
        }

        for (var i = 0; i < commitTree.length; i++)
            console.log(commitTree[i].hash + ':' + commitTree[i].graph);

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
