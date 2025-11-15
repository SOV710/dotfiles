pragma Singleton

import Quickshell
import Quickshell.Services.UPower
import QtQuick

Singleton {
    id: root

    // battery charge level as a percentage
    property real percentage: UPower.displayDevice?.percentage ?? 1
    property string iconName: UPower.displayDevice?.iconName ?? "not-found-icon"

    property var chargeState: UPower.displayDevice.state
    property bool isCharging: chargeState == UPowerDeviceState.Charging
    property bool isPluggedIn: isCharging || chargeState == UPowerDeviceState.PendingCharge

    // battery health percentage
    property real health: (function () {
            const devList = UPower.devices.values;
            for (let i = 0; i < devList.length; ++i) {
                const dev = devList[i];
                if (dev.isLaptopBattery && dev.healthSupported) {
                    const health = dev.healthPercentage;
                    if (health === 0) {
                        return 0.01;
                    } else if (health < 1) {
                        return health * 100;
                    } else {
                        return health;
                    }
                }
            }
            return 0;
        })()

    // battery charging time to full / nocharging time to empty
    property real timeToFull: UPower.displayDevice?.timeToFull ?? 0
    property real timeToEmpty: UPower.displayDevice?.timeToEmpty ?? 0
}
