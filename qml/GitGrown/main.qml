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

                    border.color: "gray"

                    Rectangle {
                        id:background
                        Column {
                            y: 15
                            Repeater {
                                model: graphString.split(',').length;
                                Rectangle {
                                    width: 80
                                    height: 50
                                    clip: true

                                    Image {
                                        anchors.verticalCenter: parent.verticalCenter
                                        source: graphString.split(',')[index] == '\\' ? "link_merge.svg"
                                                                                      : ( graphString.split(',')[index] == '/' ? "link_branch.svg" : "link_through.svg")
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

                        Image {
                            z: -1
                            anchors.fill: parent
                            anchors.verticalCenter: parent.verticalCenter
                            source: "link_through.svg"
                            visible: index != 0
                        }
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
