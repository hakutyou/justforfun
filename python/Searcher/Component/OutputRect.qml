import QtQuick 2.9

Rectangle {
    Component {
        id: resultCompoent
        Item {
            property var result_model: model
            width: parent.width
            height: 30
            Rectangle {
                color: '#00000000'
                width: parent.width
                height: parent.height
                Text {
                    x: 10
                    width: parent.width - 20
                    height: parent.height
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    text: name
                    font.family: main.font_family
                    font.pixelSize: main.small_font_size
                    clip: true
                }
                //Text {
                //    x: 10
                //    anchors.left: parent.left
                //    width: parent.width - 10
                //    height: parent.height
                //    horizontalAlignment: Text.AlignRight
                //    verticalAlignment: Text.AlignVCenter
                //    text: '<b>Number:</b> ' + number
                //    font.family: main.font_family
                //    font.pixelSize: main.tiny_font_size
                //    font.italic: true
                //    color: "grey"
                //    clip: true
                //}
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    parent.ListView.view.currentIndex = index
                }
                onDoubleClicked: {
                    show_rect.switch_detail(con.reader(
                        resultView.currentItem.result_model.path))
                }
            }
        }
    }
    ListView {
        id: resultView
        anchors.fill: parent
        model: resultList
        delegate: resultCompoent
        highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
        focus: true
    }
}
