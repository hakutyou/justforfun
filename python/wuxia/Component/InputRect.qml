import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Rectangle {
    width: parent.width
    height: 33
    Rectangle {
        id: input_rect
        width: parent.width / 3 * 2
        height: parent.height
        border.width: 2
        border.color: 'grey'
        function getRoleInfo(text, zone) {
            output_rect.output_get(text, zone)
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
            maximumLength: 12
            selectByMouse: true
            text: "1654240380"
            wrapMode: TextEdit.NoWrap
            onAccepted: {
                input_rect.getRoleInfo(
                    input.text,
                    dropdown_model.get(dropdown_rect.currentIndex).text)
            }
        }
    }
    ComboBox {
        id: dropdown_rect
        width: parent.width / 3
        height: parent.height
        x: parent.width / 3 * 2
        currentIndex: 0
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
            // 边城浪子
            ListElement { text: '欢乐英雄' }
            // 青龙乱舞
            ListElement { text: '长生剑'}
            ListElement { text: '孔雀翎'}
            ListElement { text: '情人箭'}
            ListElement { text: '多情环'}
            // 大地飞鹰
            ListElement { text: '凤凰集'}
            ListElement { text: '藏锋谷'}
            // 血海飘香
            ListElement { text: '蔷薇'}
            ListElement { text: '吹雪'}
            ListElement { text: '弧光'}
            // 陌上花开
            ListElement { text: '彼岸花'}
            ListElement { text: '月见草'}
            // 天命风流
            ListElement { text: '锦鲤抄'}
            ListElement { text: '千秋月'}
            ListElement { text: '如梦令'}
            ListElement { text: '凤求凰'}
            ListElement { text: '寒梅雪'}
            ListElement { text: '梦回还'}
            ListElement { text: '观沧海'}
            // 沧海云帆
            ListElement { text: '时光沧海'}
            ListElement { text: '青龙永夜'}
            ListElement { text: '今夕何夕'}
            ListElement { text: '长风破浪'}
            ListElement { text: '潜龙之渊'}
            ListElement { text: '月华流照'}
            ListElement { text: '一代宗师'}
            ListElement { text: '幻海花城'}
        }
    }
}