import QtQuick 2.9

Rectangle {
    function detail_get(text) {
        detail_text.text = text
    }
    color: '#00000000'
    width: parent.width
    height: parent.height
    Text {
        id: detail_text
        font.family: main.font_family
        font.pixelSize: main.small_font_size
        width: parent.width
        height: parent.height
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
