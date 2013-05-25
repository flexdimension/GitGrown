import QtQuick 2.0

Rectangle {
    width: 360
    height: 360
    Text {
        text: qsTr("Hello World")
        anchors.centerIn: parent
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            Qt.quit();
        }
    }

    Git {
        id: git
    }

    Component.onCompleted: {
        console.log("initialized");

        var result = git.execute("git", "version");

        console.log("result:" + result);

        var result = git.cmd("version");

        console.log("result:" + result);
    }
}
