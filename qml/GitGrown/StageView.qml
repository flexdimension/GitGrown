import QtQuick 2.0

Rectangle {
    property alias statusModel: stageListView.statusModel

    Git {
        id: git
    }

    Rectangle {
        id: commitWidget
        width: parent.width;
        height: parent.height * 0.3;

        Rectangle {
            id: textArea
            anchors.fill: parent
            anchors.margins: 10
            anchors.bottomMargin: 50
            border.width: 1
            border.color: "#D0D0D0"
            radius: 2
            clip: true

            TextEdit {
                anchors.fill: parent
                anchors.margins: 5
            }
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            anchors.top: textArea.bottom
            anchors.bottom: parent.bottom
            color: "#aaaaaa"

            Row {
                anchors.fill: parent
                anchors.margins: 5

                layoutDirection: Qt.RightToLeft

                Row {
                    spacing: 10
                    anchors.verticalCenter: parent.verticalCenter

                    Rectangle {
                       width: 80
                       height: 20
                       color: "#EEEEEE"

                       radius: 5
                    }

                    Rectangle {
                       width: 80
                       height: 20
                       color: "#EEEEEE"

                       radius: 5
                    }

                    Rectangle {
                       width: 80
                       height: 20
                       color: "#AAEEAA"
                       radius: 5

                       MouseArea {
                           anchors.fill: parent
                           onClicked: {
                               //git.cmd("commit")
                           }
                       }
                    }
                }
            }
        }
    }

    Rectangle {
        y: commitWidget.height;
        width: parent.width;
        height: parent.height - y;

        Rectangle {
            anchors.margins: 10
            anchors.fill: parent

            border.width: 1
            border.color: "#D0D0D0"
            radius: 5

            ListView {
                id:stageListView
                property variant statusModel: null
                anchors.margins: 2
                anchors.fill: parent

                clip: true;

                model: statusModel
                delegate: Rectangle {
                    width: parent.width;
                    height: 30;
                    color: "#EEEEEE";
                    radius: 3

                    border.width: 1
                    border.color: "#DDDDDD"

                    Rectangle { id: workingItem
                        x:0
                        width: parent.width / 2;
                        height: parent.height;
                        color: "#EEDDCC"
                        radius: 5;
                        border.width: 2;
                        border.color: "#E0C099"

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
                                stageListView.statusModel.stageFile(model.index);
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
                                stageListView.statusModel.unstageFile(model.index);
                            }
                        }
                    }
                }
            }
        }
    }
}
