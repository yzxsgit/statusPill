import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins

DesktopPluginComponent {
    id: root

    // Widget dimension constraints for DesktopPluginWrapper
    minWidth: 480
    minHeight: 66
    implicitWidth: 496
    implicitHeight: 66

    // ---------------------------------------------------------------
    // Configuration & Settings (reactive from pluginData)
    // ---------------------------------------------------------------
    readonly property real bgOpacity: (pluginData.bgOpacity ?? 35) / 100.0
    readonly property int refreshInterval: pluginData.refreshInterval ?? 1000
    readonly property string launchCommand: pluginData.launchCommand || "kitty -e btop"
    readonly property real cpuWarnThreshold: pluginData.cpuWarnThreshold ?? 80
    readonly property real memWarnThreshold: pluginData.memWarnThreshold ?? 85
    readonly property real tempWarnThreshold: pluginData.tempWarnThreshold ?? 80

    readonly property color themeColor: {
        const choice = pluginData.themeColorChoice ?? "primary"
        if (choice === "secondary") return Theme.secondary
        if (choice === "tertiary") return Theme.tertiary
        return Theme.primary
    }

    // ---------------------------------------------------------------
    // Service Lifecycle Management
    // ---------------------------------------------------------------
    readonly property var activeModules: ["cpu", "memory", "system"]

    Component.onCompleted: {
        DgopService.addRef(activeModules)
        if (root.requestResize && root.widgetWidth < root.minWidth) {
            root.requestResize(root.minWidth, root.minHeight)
        }
    }

    Component.onDestruction: {
        DgopService.removeRef(activeModules)
    }

    // Process launcher for system monitor
    Process {
        id: monitorLauncher
        command: ["sh", "-c", root.launchCommand]
    }

    function openSystemMonitor() {
        if (root.launchCommand && root.launchCommand.trim().length > 0) {
            monitorLauncher.running = false
            monitorLauncher.command = ["sh", "-c", root.launchCommand]
            monitorLauncher.running = true
        }
    }

    // Refresh rate poll timer
    Timer {
        id: refreshTimer
        interval: Math.max(500, Math.min(5000, root.refreshInterval))
        running: true
        repeat: true
    }

    // ---------------------------------------------------------------
    // Main Visual Container (Horizontal Dock)
    // ---------------------------------------------------------------
    Rectangle {
        id: mainDock
        anchors.fill: parent
        radius: 18

        color: Theme.withAlpha(Theme.surfaceContainer, root.bgOpacity * 0.6)
        border.color: Theme.withAlpha(Theme.outlineVariant, Math.min(1.0, root.bgOpacity + 0.15))
        border.width: root.bgOpacity > 0.05 ? 1 : 0

        Behavior on color {
            ColorAnimation { duration: 200 }
        }
        Behavior on border.color {
            ColorAnimation { duration: 200 }
        }

        RowLayout {
            id: dockRow
            anchors.fill: parent
            anchors.margins: 5
            spacing: 6

            // 1. CPU Card
            PillCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 115
                Layout.minimumWidth: 100

                iconName: "memory"
                title: "CPU"
                valueText: (DgopService.cpuUsage !== undefined && DgopService.cpuUsage !== null) 
                    ? DgopService.cpuUsage.toFixed(0) + "%" 
                    : "--%"
                progress: (DgopService.cpuUsage ?? 0) / 100.0
                accentColor: isWarning ? Theme.error : root.themeColor
                isWarning: (DgopService.cpuUsage > root.cpuWarnThreshold)
                bgOpacity: root.bgOpacity
                detailText: {
                    let text = "CPU: " + ((DgopService.cpuUsage ?? 0).toFixed(1)) + "%\n"
                    if (DgopService.cpuModel) text += DgopService.cpuModel + "\n"
                    if (DgopService.cpuCores) text += "Cores: " + DgopService.cpuCores + "\n"
                    if (DgopService.cpuFrequency > 0) text += "Clock: " + (DgopService.cpuFrequency / 1000).toFixed(2) + " GHz\n"
                    text += "Click to open task monitor"
                    return text
                }
                onClicked: root.openSystemMonitor()
            }

            // 2. Memory Card
            PillCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 115
                Layout.minimumWidth: 100

                iconName: "storage"
                title: "MEM"
                valueText: (DgopService.memoryUsage !== undefined && DgopService.memoryUsage !== null)
                    ? DgopService.memoryUsage.toFixed(0) + "%"
                    : "--%"
                progress: (DgopService.memoryUsage ?? 0) / 100.0
                accentColor: isWarning ? Theme.error : root.themeColor
                isWarning: (DgopService.memoryUsage > root.memWarnThreshold)
                bgOpacity: root.bgOpacity
                detailText: {
                    let text = "Memory: " + ((DgopService.memoryUsage ?? 0).toFixed(1)) + "%\n"
                    if (DgopService.usedMemoryKB && DgopService.totalMemoryKB) {
                        let usedG = (DgopService.usedMemoryKB / 1048576).toFixed(1)
                        let totalG = (DgopService.totalMemoryKB / 1048576).toFixed(1)
                        text += "Used: " + usedG + " GiB / " + totalG + " GiB\n"
                    }
                    if (DgopService.totalSwapKB > 0) {
                        let swapG = (DgopService.usedSwapKB / 1048576).toFixed(1)
                        text += "Swap: " + swapG + " GiB\n"
                    }
                    text += "Click to open task monitor"
                    return text
                }
                onClicked: root.openSystemMonitor()
            }

            // 3. Battery Card
            PillCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 115
                Layout.minimumWidth: 100

                iconName: BatteryService.batteryAvailable 
                    ? (BatteryService.getBatteryIcon ? BatteryService.getBatteryIcon() : "battery_std") 
                    : "power"
                title: BatteryService.batteryAvailable 
                    ? (BatteryService.isCharging ? "CHARGING" : "BATTERY") 
                    : "AC POWER"
                valueText: BatteryService.batteryAvailable 
                    ? (BatteryService.batteryLevel.toFixed(0) + "%") 
                    : "AC"
                progress: BatteryService.batteryAvailable 
                    ? (BatteryService.batteryLevel / 100.0) 
                    : 1.0
                accentColor: isWarning ? Theme.error : root.themeColor
                isWarning: (!BatteryService.isCharging && BatteryService.isLowBattery)
                bgOpacity: root.bgOpacity
                detailText: {
                    if (!BatteryService.batteryAvailable) {
                        return "Connected to AC Power\nNo battery detected"
                    }
                    let text = "Battery: " + BatteryService.batteryLevel.toFixed(0) + "%\n"
                    text += "Status: " + (BatteryService.isCharging ? "Charging" : (BatteryService.isPluggedIn ? "Plugged in (Not charging)" : "Discharging")) + "\n"
                    text += "Click to open task monitor"
                    return text
                }
                onClicked: root.openSystemMonitor()
            }

            // 4. Temperature Card
            PillCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 115
                Layout.minimumWidth: 100

                iconName: "thermostat"
                title: "TEMP"
                valueText: (DgopService.cpuTemperature > 0) 
                    ? (DgopService.cpuTemperature.toFixed(0) + "°C") 
                    : "--°C"
                progress: (DgopService.cpuTemperature > 0) 
                    ? Math.max(0, Math.min(1.0, DgopService.cpuTemperature / 100.0)) 
                    : 0.0
                accentColor: isWarning ? Theme.error : root.themeColor
                isWarning: (DgopService.cpuTemperature > root.tempWarnThreshold)
                bgOpacity: root.bgOpacity
                detailText: {
                    let text = "CPU Package: " + (DgopService.cpuTemperature > 0 ? (DgopService.cpuTemperature.toFixed(1) + "°C") : "N/A") + "\n"
                    text += "Warning Alert at: " + root.tempWarnThreshold + "°C\n"
                    text += "Click to open task monitor"
                    return text
                }
                onClicked: root.openSystemMonitor()
            }
        }
    }
}
