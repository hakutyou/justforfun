import QtQuick 2.9

Rectangle {
    id: input_rect
    width: parent.width
    height: 33
    border.width: 2
    border.color: 'grey'
    function refreshList(_switch) {
        if (_switch === 1) {
            show_rect.switch_detail('')
        }
        resultList.clear()
        resultList.append(con.finder(input.text))
    }
    TextInput {
        id: input
        x: 4
        y: 4
        width: parent.width - 4
        height: parent.height - 4
        focus: true
        font.family: main.font_family
        font.pixelSize: main.font_size
        maximumLength: 20
        selectByMouse: true
        wrapMode: TextEdit.NoWrap
        onAccepted: input_rect.refreshList(1)
        onTextChanged: input_rect.refreshList(1)
    }
}
