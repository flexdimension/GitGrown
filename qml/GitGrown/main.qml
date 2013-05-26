import QtQuick 2.0

Rectangle {
    id: main

    width: 360
    height: 360
//    Text {
//        text: qsTr("Hello World")
//        anchors.centerIn: parent
//    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            Qt.quit();
        }
    }

    property variant model: GitStatus {id:status}


    ListView {
        width: parent.width;
        height: parent.height;
        model: main.model;
        delegate: Rectangle {
            width: parent.width;
            height: 30;
            color: "#DDDDDD";
            Rectangle { id: workingItem
                x:0
                width: parent.width / 2;
                height: parent.height;
                color: "#EEDDDD"
                radius: 5;
                border.width: 2;
                border.color: "#C0A0A0"

                visible: model.status.charAt(1) != " "

                Text {
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                    anchors.margins: 5;
                    text: model.name;
                    clip: true;
                }

                MouseArea {
                    anchors.fill: parent;
                    onClicked: {
                        main.model.stageFile(model.index);
                    }
                }
            }
            Rectangle { id: stagedItem
                x: parent.width / 2;
                width: parent.width / 2;
                height: parent.height;
                color: "#DDEEDD"
                radius: 5;
                border.width: 2;
                border.color: "#A0C0A0"

                visible: String(" ?").indexOf(model.status.charAt(0)) == -1

                Text {
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                    anchors.margins: 5;
                    text: model.name;
                    clip: true;
                }

                MouseArea {
                    anchors.fill: parent;
                    onClicked: {
                        if (model.status.charAt(1) != " ")
                            console.log("cannot unstage: " + model.name);

                        main.model.unstageFile(model.index);
                    }
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
