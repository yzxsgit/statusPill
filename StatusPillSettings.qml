import QtQuick
import qs.Common
import qs.Modules.Plugins

PluginSettings {
    id: root
    pluginId: "statusPill"
    width: parent?.width ?? 400

    property string instanceId: ""
    property var instanceData: null

    readonly property bool isZh: (I18n.locale || "").indexOf("zh") !== -1

    // 1. Transparency / Opacity (参考时钟 backgroundOpacity)
    SliderSetting {
        settingKey: "backgroundOpacity"
        label: root.isZh ? "背景透明度" : "Background Opacity"
        description: root.isZh ? "卡片背景透明度（0% 为无背景浮动数字，100% 为实体卡片）" : "Transparency of the dock card background (0% for borderless floating numbers, 100% for solid card)"
        defaultValue: 35
        minimum: 0
        maximum: 100
        unit: "%"
    }

    ToggleSetting {
        settingKey: "showBorder"
        label: root.isZh ? "显示边框" : "Show Border"
        description: root.isZh ? "在胶囊卡片与外框周围显示微妙边框" : "Display subtle borders around dock and capsules"
        defaultValue: true
    }

    // 2. Metrics Display Toggles (参考时钟 showSeconds, showDate)
    ToggleSetting {
        settingKey: "showCpu"
        label: root.isZh ? "显示 CPU" : "Show CPU"
        description: root.isZh ? "显示 CPU 占用率与当前时钟频率胶囊" : "Display CPU usage and clock frequency capsule"
        defaultValue: true
    }

    ToggleSetting {
        settingKey: "showMemory"
        label: root.isZh ? "显示内存" : "Show Memory"
        description: root.isZh ? "显示 RAM 与 Swap 交换分区使用率胶囊" : "Display RAM and Swap usage capsule"
        defaultValue: true
    }

    ToggleSetting {
        settingKey: "showBattery"
        label: root.isZh ? "显示电池" : "Show Battery"
        description: root.isZh ? "显示电池电量与充放电状态胶囊" : "Display battery percentage and charging state capsule"
        defaultValue: true
    }

    ToggleSetting {
        settingKey: "showTemperature"
        label: root.isZh ? "显示温度" : "Show Temperature"
        description: root.isZh ? "显示 CPU 硬件温度胶囊" : "Display hardware CPU package temperature capsule"
        defaultValue: true
    }

    // 3. Theme & Colors (参考时钟 colorMode)
    SelectionSetting {
        id: themeChoiceSetting
        settingKey: "themeColorChoice"
        label: root.isZh ? "主题强调色" : "Theme Accent Color"
        description: root.isZh ? "应用到所有监控胶囊的统一强调色风格" : "Unified color style applied across all metric capsules"
        defaultValue: "primary"
        options: root.isZh ? [
            { label: "主要主题色 (Primary)",   value: "primary" },
            { label: "次要主题色 (Secondary)", value: "secondary" },
            { label: "第三主题色 (Tertiary)",  value: "tertiary" },
            { label: "自定义颜色 (Custom)",    value: "custom" }
        ] : [
            { label: "Primary (Main Theme Accent)", value: "primary" },
            { label: "Secondary",                  value: "secondary" },
            { label: "Tertiary",                   value: "tertiary" },
            { label: "Custom Color",               value: "custom" }
        ]
    }

    ColorSetting {
        settingKey: "customColor"
        label: root.isZh ? "自定义强调色" : "Custom Accent Color"
        description: root.isZh ? "当主题强调色设为自定义时使用的颜色" : "Accent color used when Theme Accent Color is set to Custom"
        defaultValue: Theme.primary
        visible: (themeChoiceSetting.value || "primary") === "custom"
    }

    // 4. Performance & Refresh
    SliderSetting {
        settingKey: "refreshInterval"
        label: root.isZh ? "刷新间隔" : "Refresh Interval"
        description: root.isZh ? "硬件指标采样与界面刷新频率" : "Hardware metrics polling and update frequency"
        defaultValue: 1000
        minimum: 500
        maximum: 3000
        unit: "ms"
    }

    // 5. Click Action Command
    StringSetting {
        settingKey: "launchCommand"
        label: root.isZh ? "点击启动命令" : "Click Launch Command"
        description: root.isZh ? "点击监控胶囊时执行的终端命令" : "Terminal command to execute when clicking a metric capsule"
        defaultValue: "kitty -e btop"
    }

    // 6. Alert Warning Thresholds
    SliderSetting {
        settingKey: "cpuWarnThreshold"
        label: root.isZh ? "CPU 警告阈值" : "CPU Warning Threshold"
        description: root.isZh ? "CPU 使用率超过该百分比时卡片以高亮告警色显示" : "Usage percentage above which the CPU card highlights in alert color"
        defaultValue: 80
        minimum: 50
        maximum: 100
        unit: "%"
    }

    SliderSetting {
        settingKey: "memWarnThreshold"
        label: root.isZh ? "内存警告阈值" : "Memory Warning Threshold"
        description: root.isZh ? "内存使用率超过该百分比时卡片以高亮告警色显示" : "Usage percentage above which the Memory card highlights in alert color"
        defaultValue: 85
        minimum: 50
        maximum: 100
        unit: "%"
    }

    SliderSetting {
        settingKey: "tempWarnThreshold"
        label: root.isZh ? "温度警告阈值" : "Temperature Warning Threshold"
        description: root.isZh ? "CPU 温度超过该数值时卡片以高亮告警色显示" : "CPU temperature in °C above which the card highlights in alert color"
        defaultValue: 80
        minimum: 50
        maximum: 100
        unit: "°C"
    }
}
