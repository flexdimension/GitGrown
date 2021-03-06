import QtQuick 2.0

Rectangle {
    id: main

    width: 800
    height: 800

    property variant model: GitStatus {id: status}
    property variant commitList: GitCommitList {id: commits}

    StageView {
        statusModel: main.model

        width: 400
        height: 400
    }

    Rectangle {
        y: 400;
        width: 800
        height: 400
        clip: true

        border.width: 1

        ListView {
            id: listView
            width: parent.width
            height: parent.height
            orientation: ListView.Horizontal
            layoutDirection: Qt.RightToLeft

            model: main.commitList
            delegate:
                Rectangle {
                    width: commitItem.width
                    height: listView.height

                    border.color: "#EEEEEE"

                    Rectangle {
                        id:background
                        Image {
                            x: 0
                            y: commitItem.y + 65
                            width: 80
                            height: 50 * calcSideLine();
                            source: "link_side.svg"

                            function calcSideLine() {
                                var rIdx;

                                rIdx = graphString.lastIndexOf('/');
                                rIdx = Math.max(rIdx, graphString.lastIndexOf('\\'));
                                rIdx = Math.max(rIdx, graphString.lastIndexOf('<'));
                                rIdx = Math.max(rIdx, graphString.lastIndexOf('y'));

                                return Math.max(0, rIdx - indent - 1);
                            }
                        }

                        Column {
                            y: 15
                            Repeater {
                                model: graphString.length;
                                Rectangle {
                                    width: 80
                                    height: 50
                                    clip: true
                                    color: "transparent"

                                    Image {
                                        height: parent.height
                                        width: parent.width
                                        //anchors.verticalCenter: parent.verticalCenter
                                        Component.onCompleted: {
                                            var fileName = getImage(graphString.charAt(index));
                                            if (!fileName)
                                                visible = false;
                                            else {
                                                visible = true;
                                                source = fileName;
                                            }
                                        }
                                        function getImage(ch) {
                                            if (ch == '\\')
                                                return "link_merge.svg";
                                            if (ch == '/')
                                                return "link_branch.svg";
                                            if (ch == '|')
                                                return "link_through.svg";
                                            if (ch == 'y')
                                                return "link_through_merge_under.svg";
                                            if (ch == 'r')
                                                return "link_through_merge_over.svg";
                                            if (ch == '<')
                                                return "link_merge_branch.svg";
                                            if (ch == '*')
                                                return "link_through.svg";

                                            //console.log('link line:' + ch);
                                            return '';
                                        }

                                    }

                                }

//                                Component.onCompleted: {
//                                    console.log(graphString);
//                                    var grp = graphString.split(',');
//                                    for (var i = 0; i < grp.length; i++) {
//                                        if (grp[i] == '|')
//                                            Image.createObject()
//                                    }
//                                }
                            }
                        }
                    }

                    CommitItem {
                        id: commitItem
                        text: model.hash
                        y: model.indent * 50
                    }


                }

            header: Item {
                width: index.width * 1.3
                height: index.height

                CommitItem {
                    id: index

                    text: "index"
                    state: "index"
                }

                CommitItem {
                    x: 20
                    y: index.y - 10
                    opacity: 0.7
                    text: "workspace"
                    state: "workspace"
                }
            }
        }
    }

    Git {
        id: git
    }

    Component.onCompleted: {
        console.log("initialized");

        var result = git.execute("pwd");

        console.log("result:" + result);

        result = git.cmd("version");

        console.log("result:" + result);
    }
}
