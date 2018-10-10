import QtQuick 2.9

Rectangle {
    Component {
        id: resultComponent
        Item {
            property var result_model: model
            width: parent.width
            height: 30
            Rectangle {
                color: '#00000000'
                width: parent.width
                height: parent.height
                Text {
                    id: resultName
                    x: 10
                    width: (parent.width - 20) / 4
                    height: parent.height
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    text: name
                    font.family: main.font_family
                    font.pixelSize: main.small_font_size
                    clip: true
                }
                Text {
                    x: 10 + resultName.width
                    width: (parent.width - 20) / 4 * 3
                    height: parent.height
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    text: value
                    font.family: main.font_family
                    font.pixelSize: main.small_font_size
                    clip: true
                }
            }
        }
    }
    ListView {
        id: resultView
        anchors.fill: parent
        model: resultList
        delegate: resultComponent
        focus: true
    }
}
