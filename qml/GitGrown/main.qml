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

    property variant model: GitStatus {id: status}

    property variant commitList: GitCommitList {id: commits}


    StageView {
        statusModel: main.model

        width: parent.width;
        height: parent.height;
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
