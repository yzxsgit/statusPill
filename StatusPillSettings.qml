import QtQuick
import qs.Common
import qs.Modules.Plugins

PluginSettings {
    id: root
    pluginId: "statusPill"

    // 1. Transparency / Opacity (参考时钟 backgroundOpacity)
    SliderSetting {
        settingKey: "backgroundOpacity"
        label: I18n.tr("Background Opacity")
        description: I18n.tr("Transparency of the dock card background (0% for borderless floating numbers, 100% for solid card)")
        defaultValue: 35
        minimum: 0
        maximum: 100
        stepSize: 5
        unit: "%"
    }

    ToggleSetting {
        settingKey: "showBorder"
        label: I18n.tr("Show Border")
        description: I18n.tr("Display subtle borders around dock and capsules")
        defaultValue: true
    }

    // 2. Metrics Display Toggles (参考时钟 showSeconds, showDate)
    ToggleSetting {
        settingKey: "showCpu"
        label: I18n.tr("Show CPU")
        description: I18n.tr("Display CPU usage and clock frequency capsule")
        defaultValue: true
    }

    ToggleSetting {
        settingKey: "showMemory"
        label: I18n.tr("Show Memory")
        description: I18n.tr("Display RAM and Swap usage capsule")
        defaultValue: true
    }

    ToggleSetting {
        settingKey: "showBattery"
        label: I18n.tr("Show Battery")
        description: I18n.tr("Display battery percentage and charging state capsule")
        defaultValue: true
    }

    ToggleSetting {
        settingKey: "showTemperature"
        label: I18n.tr("Show Temperature")
        description: I18n.tr("Display hardware CPU package temperature capsule")
        defaultValue: true
    }

    // 3. Theme & Colors (参考时钟 colorMode)
    SelectionSetting {
        settingKey: "themeColorChoice"
        label: I18n.tr("Theme Accent Color")
        description: I18n.tr("Unified color style applied across all metric capsules")
        defaultValue: "primary"
        options: [
            { label: I18n.tr("Primary (Main Theme Accent)"), value: "primary" },
            { label: I18n.tr("Secondary"),                  value: "secondary" },
            { label: I18n.tr("Tertiary"),                   value: "tertiary" },
            { label: I18n.tr("Custom Color"),               value: "custom" }
        ]
    }

    ColorSetting {
        settingKey: "customColor"
        label: I18n.tr("Custom Accent Color")
        description: I18n.tr("Accent color used when Theme Accent Color is set to Custom")
        defaultValue: Theme.primary
    }

    // 4. Performance & Refresh
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

    // 5. Click Action Command
    StringSetting {
        settingKey: "launchCommand"
        label: I18n.tr("Click Launch Command")
        description: I18n.tr("Terminal command to execute when clicking a metric capsule")
        defaultValue: "kitty -e btop"
    }

    // 6. Alert Warning Thresholds
    SliderSetting {
        settingKey: "cpuWarnThreshold"
        label: I18n.tr("CPU Warning Threshold")
        description: I18n.tr("Usage percentage above which the CPU card highlights in alert color")
        defaultValue: 80
        minimum: 50
        maximum: 100
        stepSize: 5
        unit: "%"
    }

    SliderSetting {
        settingKey: "memWarnThreshold"
        label: I18n.tr("Memory Warning Threshold")
        description: I18n.tr("Usage percentage above which the Memory card highlights in alert color")
        defaultValue: 85
        minimum: 50
        maximum: 100
        stepSize: 5
        unit: "%"
    }

    SliderSetting {
        settingKey: "tempWarnThreshold"
        label: I18n.tr("Temperature Warning Threshold")
        description: I18n.tr("CPU temperature in °C above which the card highlights in alert color")
        defaultValue: 80
        minimum: 50
        maximum: 100
        stepSize: 5
        unit: "°C"
    }
}
