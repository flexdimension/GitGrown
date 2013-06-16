import QtQuick 2.0

Rectangle {
    id: main
    width: 80
    height: 80
    border.color: "gray"
    color: "transparent"
    antialiasing: true

    property alias text: textHash.text

    state: "normal"

    property color outerBorder: "#d5ca72"
    property color innerBorder: "#c6b962"
    property color innerRect: "#dadb82"


    states: [
        State {
            name: "workspace"
            PropertyChanges {
                target: main
                outerBorder: "#FF8080"
                innerBorder: "red"
                innerRect: "white"
            }
        },
        State {
            name: "index"
            PropertyChanges {
                target: main
                outerBorder: "#80FF80"
                innerBorder: "green"
                innerRect: "white"
            }
        }

    ]


    Rectangle {
        id: rectangle3
        //x: 100
        y: 0;
        anchors.horizontalCenter: parent.horizontalCenter
        //anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter

        width: 50
        height: 50
        color: "transparent"
        radius: 12
        clip: true
        border.width: 8
        border.color: main.outerBorder
        antialiasing: true


        Rectangle {
            id: rectangle4
            x: 8
            y: 6
            width: 42
            height: 42
            color: main.innerRect
            radius: 12
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            clip: true
            border.width: 3
            border.color: main.innerBorder
            antialiasing: true
        }

        Item {
            id: item1
            x: 0
            y: 0
            width: 40
            height: 21
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0

            Rectangle {
                anchors.fill: parent
                color: "#ffffff"
                opacity: 0.4
            }

            Text {
                id: textHash
                text: qsTr("A00B")
                anchors.fill: parent
                font.pointSize: 10
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                antialiasing: true
            }
        }
    }
}
