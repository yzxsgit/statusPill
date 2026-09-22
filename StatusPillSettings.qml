import QtQuick
import qs.Common
import qs.Modules.Plugins

PluginSettings {
    id: root
    pluginId: "statusPill"

    // 1. Background Opacity Setting
    SliderSetting {
        settingKey: "bgOpacity"
        label: I18n.tr("Background Opacity")
        description: I18n.tr("Card background transparency (0% for borderless floating numbers, 100% for solid Material 3 card)")
        defaultValue: 35
        minimum: 0
        maximum: 100
        stepSize: 5
        unit: "%"
    }

    // 2. Refresh Interval
    SliderSetting {
        settingKey: "refreshInterval"
        label: I18n.tr("Refresh Interval")
        description: I18n.tr("Hardware metrics polling and update frequency")
        defaultValue: 1000
        minimum: 500
        maximum: 3000
        stepSize: 100
        unit: "ms"
    }

    // 3. Click Command
    StringSetting {
        settingKey: "launchCommand"
        label: I18n.tr("Click Launch Command")
        description: I18n.tr("Command executed when clicking on any metric card")
        defaultValue: "kitty -e btop"
    }

    // 4. Warning Alert Thresholds
    SliderSetting {
        settingKey: "cpuWarnThreshold"
        label: I18n.tr("CPU Alert Threshold")
        description: I18n.tr("CPU usage percentage above which the card highlights in alert color")
        defaultValue: 80
        minimum: 50
        maximum: 100
        stepSize: 5
        unit: "%"
    }

    SliderSetting {
        settingKey: "memWarnThreshold"
        label: I18n.tr("Memory Alert Threshold")
        description: I18n.tr("Memory usage percentage above which the card highlights in alert color")
        defaultValue: 85
        minimum: 50
        maximum: 100
        stepSize: 5
        unit: "%"
    }

    SliderSetting {
        settingKey: "tempWarnThreshold"
        label: I18n.tr("Temperature Alert Threshold")
        description: I18n.tr("CPU temperature in °C above which the card highlights in alert color")
        defaultValue: 80
        minimum: 50
        maximum: 100
        stepSize: 5
        unit: "°C"
    }
}
