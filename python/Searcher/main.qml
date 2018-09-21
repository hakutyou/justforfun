import QtQuick 2.9
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0

import './Component'

Window {
    id: main
    visible: true
    width: 320
    height: 240
    title: qsTr("Searcher")

    property int tiny_font_size: 10
    property int small_font_size: 13
    property int font_size: 15
    property string font_family: 'LiHu Mono Regular'
    ListModel {
            id: resultList
    }
    Component.onCompleted: {
        input_rect.refreshList(0)
    }

    InputRect {
        id: input_rect
        z: 10
    }
    Rectangle {
        id: show_rect
        y: input_rect.height
        width: parent.width
        height: parent.height - input_rect.height
        z: 5
        LinearGradient {
            width: parent.width;
            height: parent.height;
            gradient: Gradient {
                GradientStop{ position: 0.0; color: "#300A0AEA";}
                GradientStop{ position: 1.0; color: "#00D0D8EF";}
            }
            start: Qt.point(0, 0);
            end: Qt.point(0, 180);
        }
        OutputRect {
            id: output_rect
            color: "#00000000"
            width: parent.width
            height: parent.height
            Behavior on x {PropertyAnimation {duration: 300} }
        }
        DetailRect {
            id: detail_rect
            x: parent.width
            color: "#00000000"
            width: parent.width
            height: parent.height
            Behavior on x {PropertyAnimation {duration: 300} }
        }
        function switch_detail(detail) {
            if (detail === '') {
                output_rect.x = 0
                detail_rect.x = show_rect.width
            }
            else {
                detail_rect.detail_get(detail)
                output_rect.x = -show_rect.width
                detail_rect.x = 0
            }
        }
    }
}
