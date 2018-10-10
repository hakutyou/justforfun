import QtQuick 2.9
import QtQuick.Controls 1.4

Row {
    id: input_item
    height: parent.height
    spacing: 2

    property string item_name: 'default'
    property string item_value: ''
    property string item_extra: ''
    property string attribute: ''

    function refreshList(value, ex) {
        // con.output(value)
        con.set_attribute(attribute, value)
        resultList.clear()
        resultList.append(con.get_result()) //con.get_result()
    }

    Text {
        id: prompt
        width: (parent.width - 4) / 5
        height: parent.height
        font.family: main.font_family
        font.pixelSize: main.font_size
        wrapMode: TextEdit.NoWrap
        text: input_item.item_name
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }
    Rectangle {
        width: (parent.width - 4) / 5 * 3
        height: parent.height
        border.width: 2
        border.color: 'grey'
        color: '#00000000'
        TextInput {
            x: 5
            width: parent.width - 10
            height: parent.width / 5
            font.family: main.font_family
            font.pixelSize: main.font_size
            maximumLength: 10
            wrapMode: TextEdit.NoWrap
            text: input_item.item_value
            selectByMouse: true
            verticalAlignment: Text.AlignVCenter
            validator: RegExpValidator{regExp:/(0|[1-9]\d{0,5})/}
            onTextChanged: refreshList(text, 0)
        }
    }
    Rectangle {
        width: (parent.width - 4) / 5
        height: parent.height
        border.width: 2
        border.color: 'grey'
        color: '#00000000'
        TextInput {
            x: 5
            width: parent.width - 10
            height: parent.height
            font.family: main.font_family
            font.pixelSize: main.font_size
            maximumLength: 10
            wrapMode: TextEdit.NoWrap
            text: input_item.item_extra
            selectByMouse: true
            verticalAlignment: Text.AlignVCenter
            validator: RegExpValidator{regExp:/(0|[1-9]\d{1,9})/}
        }
    }
}
