import qs.modules.common
import qs.services
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick

Scope {
    id: bar
    property string time

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: root
            required property var modelData
            screen: modelData
            color: Appearance.colors.bgDark

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 30

            Text {
                anchors.centerIn: parent
                text: bar.time
                font.bold: true
                color: Appearance.colors.fg
            }

            Text {
                anchors.right: parent
                text: Battery.percentage
                color: Appearance.colors.fg
            }

            Rectangle {
                id: barContect
                anchors.fill: parent
                color: "transparent"
            }
        }
    }

    Process {
        id: dateProc
        command: ["date", "+%a %b %H:%M:%S %Y"]
        running: true

        environment: ({
                TZ: "UTC-8",
                PATH: null
            })

        stdout: StdioCollector {
            onStreamFinished: bar.time = this.text
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: dateProc.running = true
    }
}
