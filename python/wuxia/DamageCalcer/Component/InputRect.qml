import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Column{
    id: input_column
    spacing: 2
    width: parent.width
    height: 200 //173

    property int row_height: 33

    function switchSkill(mp) {
        con.set_attribute('mp', mp)
        resultList.clear()
        resultList.append(con.get_result())
    }

    ComboBox {
        id: dropdown_rect
        width: parent.width
        height: input_column.row_height
        x: 0
        currentIndex: 0
        onCurrentIndexChanged: switchSkill(currentText)
        style: ComboBoxStyle {
            label: Text {
                font.family: main.font_family
                font.pixelSize: main.font_size
                color: 'black'
                text: control.currentText
            }
            property Component __dropDownStyle: MenuStyle {
                itemDelegate.label: Text {
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.family: main.font_family
                    font.pixelSize: main.small_font_size
                    color: styleData.selected ? "white" : "black"
                    text: styleData.text
                }
            }
        }
        model: ListModel {
            id: dropdown_model
            ListElement { text: '天香' }
        }
    }

    Row {
        width: parent.width
        height: input_column.row_height

        InputItem {
            width: parent.width / 2
            item_name: '外功防御'
            attribute: 'wf'
        }
        InputItem {
            width: parent.width / 2
            item_name: '内功防御'
            attribute: 'nf'
        }
    }

    Row {
        width: parent.width
        height: input_column.row_height

        InputItem {
            width: parent.width / 2
            item_name: '韧性'
            attribute: 'rx'
        }
        InputItem {
            width: parent.width / 2
            item_name: 'ys'
        }
    }

    Row {
        width: parent.width
        height: input_column.row_height

        InputItem {
            width: parent.width / 2
            item_name: '外功攻击'
            attribute: 'wg'
        }
        InputItem {
            width: parent.width / 2
            item_name: '内功攻击'
            attribute: 'ng'
        }
    }

    Row {
        width: parent.width
        height: input_column.row_height

        InputItem {
            width: parent.width / 2
            item_name: '会心伤害'
            attribute: 'hs'
        }
        InputItem {
            width: parent.width / 2
            item_name: '压制'
            attribute: 'yz'
        }
    }
}
