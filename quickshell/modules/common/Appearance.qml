pragma Singleton
import QtQuick
import Quickshell

QtObject {
    id: root
    property QtObject colors

    colors: QtObject {
        // === 背景层次 ===
        property color bg: "#1a1b26"
        property color bgDark: "#16161e"

        property color bgHighlight: "#292e42"
        property color bgVisual: "#283457"

        // === 前景/文字 ===
        property color fg: "#c0caf5"
        property color fgDark: "#a9b1d6"
        property color comment: "#565f89"

        // === 边框 ===
        property color border: "#15161e"
        property color borderHighlight: "#27a1b9"

        // === 基础色彩 ===
        property color red: "#f7768e"
        property color orange: "#ff9e64"
        property color yellow: "#e0af68"
        property color green: "#9ece6a"
        property color cyan: "#7dcfff"
        property color blue: "#7aa2f7"
        property color purple: "#9d7cd8"
        property color magenta: "#bb9af7"
        property color teal: "#1abc9c"

        // === 语义颜色 ===
        property color error: "#db4b4b"
        property color warning: "#e0af68"
        property color info: "#0db9d7"
        property color success: "#9ece6a"
        property color hint: "#1abc9c"
    }
}
