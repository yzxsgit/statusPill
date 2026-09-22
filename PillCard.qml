import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.Common
import qs.Widgets

Rectangle {
    id: root

    property string iconName: ""
    property string title: ""
    property string valueText: "--"
    property real progress: 0.0 // 0.0 to 1.0
    property color accentColor: Theme.primary
    property string detailText: ""
    property real bgOpacity: 0.4
    property bool isWarning: false

    signal clicked()

    implicitWidth: 116
    implicitHeight: 56
    radius: 16

    color: Theme.withAlpha(Theme.surfaceContainerHigh, bgOpacity)
    border.color: Theme.withAlpha(
        mouseArea.containsMouse ? accentColor : (isWarning ? Theme.error : Theme.outlineVariant),
        Math.min(1.0, bgOpacity + 0.3)
    )
    border.width: isWarning || mouseArea.containsMouse ? 1.5 : 1

    Behavior on border.color {
        ColorAnimation { duration: 180 }
    }
    Behavior on color {
        ColorAnimation { duration: 180 }
    }

    // Ripple / click feedback scale
    scale: mouseArea.pressed ? 0.96 : (mouseArea.containsMouse ? 1.02 : 1.0)
    Behavior on scale {
        NumberAnimation { duration: 120; easing.type: Easing.OutQuad }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 4

        // Upper info row: Icon + Values
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 8

            Rectangle {
                Layout.preferredWidth: 32
                Layout.preferredHeight: 32
                radius: 10
                color: Theme.withAlpha(root.accentColor, mouseArea.containsMouse ? 0.25 : 0.12)

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }

                DankIcon {
                    anchors.centerIn: parent
                    name: root.iconName
                    size: 18
                    color: root.accentColor
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 1

                Text {
                    text: root.valueText
                    color: root.isWarning ? Theme.error : Theme.surfaceText
                    font.pixelSize: 14
                    font.weight: Font.DemiBold
                    font.family: Theme.bodyFont
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }

                Text {
                    text: root.title
                    color: Theme.surfaceVariantText
                    font.pixelSize: 10
                    font.weight: Font.Medium
                    font.family: Theme.bodyFont
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
            }
        }

        // Bottom micro indicator bar
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 3
            radius: 1.5
            color: Theme.withAlpha(root.accentColor, 0.18)
            clip: true

            Rectangle {
                height: parent.height
                width: Math.max(0, Math.min(parent.width, parent.width * root.progress))
                radius: 1.5
                color: root.accentColor

                Behavior on width {
                    SmoothedAnimation { velocity: 120 }
                }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()

        ToolTip {
            id: tip
            visible: mouseArea.containsMouse && root.detailText.length > 0
            delay: 350
            timeout: 5000

            contentItem: Text {
                text: root.detailText
                color: Theme.surfaceText
                font.pixelSize: 11
                font.family: Theme.bodyFont
            }

            background: Rectangle {
                radius: 8
                color: Theme.surfaceContainerHighest
                border.color: Theme.outlineVariant
                border.width: 1
            }
        }
    }
}
