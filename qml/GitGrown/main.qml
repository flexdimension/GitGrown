import QtQuick 2.0

Rectangle {
    id: main

    width: 800
    height: 800

    property variant model: GitStatus {id: status}
    property variant commitList: GitCommitList {id: commits}

    StageView {
        statusModel: main.model

        width: 500
        height: 500
    }

    Rectangle {
        y: 500;
        width: 800
        height: 300
        clip: true

        border.width: 1

        ListView {
            width: parent.width
            height: parent.height
            orientation: ListView.Horizontal
            layoutDirection: Qt.RightToLeft

            model: main.commitList
            delegate: CommitItem {
                text: model.hash
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
