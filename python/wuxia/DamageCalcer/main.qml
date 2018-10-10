import QtQuick 2.9
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0

import './Component'

Window {
    id: main
    visible: true
    width: 640
    height: 480
    title: qsTr("Damage Calcer")

    property int tiny_font_size: 10
    property int small_font_size: 13
    property int font_size: 15
    property string font_family: 'LiHu Mono Regular'

    ListModel {
            id: resultList
    }

    InputRect {
        id: input_rect
        z: 5
    }
    OutputRect {
        id: output_rect
        y: input_rect.height
        width: parent.width
        height: parent.height - input_rect.height
        z: 5
        LinearGradient {
            width: parent.width;
            height: parent.height;
            gradient: Gradient {
                GradientStop{ position: 0.0; color: "#00D0D8EF";}
                GradientStop{ position: 0.5; color: "#300A0AEA";}
                GradientStop{ position: 1.0; color: "#00D0D8EF";}
            }
            start: Qt.point(0, 0);
            end: Qt.point(0, 300);
        }
    }
}
