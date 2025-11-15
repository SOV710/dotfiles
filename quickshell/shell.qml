//@ pragma Env QT_MEDIA_BACKEND=ffmpeg
//@ pragma Env QT_FFMPEG_DECODING_HW_DEVICE_TYPES=vaapi
//@ pragma Env QT_FFMPEG_ENCODING_HW_DEVICE_TYPES=vaapi

import qs.modules.common
import qs.modules.bar

import Quickshell
import QtQuick

ShellRoot {
    id: entrypoint

    PanelLoader {
        Bar {}
    }

    component PanelLoader: LazyLoader {
        active: true
    }
}
