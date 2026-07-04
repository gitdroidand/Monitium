/*
@file Launcher.qml
@brief This file contains the launcher for the application.
@author Droidand Inc
@date 2026-07-04
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "screens"

ApplicationWindow {
    id: root

    visible: true
    width: 1280
    height: 800
    minimumWidth: 900
    minimumHeight: 600

    property int currentIndex: 0
    property bool railExpanded: false

    // تم
    readonly property var theme: ({
        primaryBg: "#0a0f24",
        surface: "#131a33",
        surfaceLight: "#1c2541",
        accent: "#3b82f6",
        accentHover: "#2563eb",
        textPrimary: "#f1f5f9",
        textSecondary: "#94a3b8",
        success: "#10b981",
        danger: "#ef4444",
        radiusSmall: 8,
        radiusMedium: 12,
        radiusLarge: 16,
        animDuration: 350
    })

    readonly property var pages: [
        { title: "Transactions", icon: "💳" },
        { title: "Note",          icon: "📝" },
        { title: "Stream",        icon: "📺" },
        { title: "Budget",        icon: "📊" }
    ]

    title: pages[currentIndex].title

    Rectangle {
        anchors.fill: parent
        color: root.theme.primaryBg
    }

    // نوار کناری
    Rectangle {
        id: navRail

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        // عرض بر اساس حالت باز/بسته
        property int collapsedWidth: 80
        property int expandedWidth: 200

        width: railExpanded ? expandedWidth : collapsedWidth
        color: root.theme.surface

        Behavior on width {
            NumberAnimation { 
                duration: 350
                easing.type: Easing.OutCubic 
            }
        }

        // خط جداکننده
        Rectangle {
            anchors.right: parent.right
            width: 1
            height: parent.height
            color: Qt.rgba(255, 255, 255, 0.05)
        }

        // محتوای نوار کناری
        Item {
            anchors.fill: parent
            anchors.margins: 12

            // هدر با لوگو
            Rectangle {
                id: logoArea
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 48
                color: "transparent"

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: railExpanded = !railExpanded
                }

                RowLayout {
                    anchors.fill: parent
                    spacing: 12

                    // آیکون لوگو
                    Rectangle {
                        Layout.preferredWidth: 44
                        Layout.preferredHeight: 44
                        radius: root.theme.radiusMedium
                        color: root.theme.accent

                        Label {
                            anchors.centerIn: parent
                            text: railExpanded ? "M" : "M"
                            font.pixelSize: 22
                            font.bold: true
                            color: "white"
                        }
                    }

                    // نام برند (نمایش با انیمیشن)
                    Label {
                        text: "Monitium"
                        font.pixelSize: 18
                        font.bold: true
                        color: root.theme.textPrimary
                        opacity: railExpanded ? 1 : 0

                        Behavior on opacity {
                            NumberAnimation { 
                                duration: 200
                                easing.type: Easing.OutCubic 
                            }
                        }
                    }
                }
            }

            // آیتم‌های نویگیشن
            Repeater {
                model: root.pages

                Item {
                    id: navItem
                    x: 0
                    y: 76 + index * 72
                    width: parent.width
                    height: 64

                    // پس‌زمینه آیتم فعال
                    Rectangle {
                        anchors.fill: parent
                        radius: root.theme.radiusMedium
                        color: root.currentIndex === index
                               ? Qt.rgba(59,130,246,0.2) : "transparent"

                        Behavior on color {
                            ColorAnimation { duration: 250; easing.type: Easing.OutCubic }
                        }
                    }

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: railExpanded ? 12 : 0

                        // آیکون
                        Label {
                            Layout.alignment: Qt.AlignCenter
                            text: modelData.icon
                            font.pixelSize: 22
                            opacity: root.currentIndex === index ? 1 : 0.5

                            Behavior on opacity { NumberAnimation { duration: 200 } }
                        }

                        // عنوان (فقط در حالت باز)
                        ColumnLayout {
                            Layout.alignment: Qt.AlignVCenter
                            spacing: 2
                            opacity: railExpanded ? 1 : 0

                            Behavior on opacity { 
                                NumberAnimation { duration: 200 } 
                            }

                            Label {
                                text: modelData.title
                                font.pixelSize: 14
                                font.bold: root.currentIndex === index
                                color: root.currentIndex === index
                                       ? root.theme.textPrimary : root.theme.textSecondary

                                Behavior on color { ColorAnimation { duration: 200 } }
                            }

                            Label {
                                text: modelData.title.substring(0, 4)
                                font.pixelSize: 9
                                color: root.theme.textSecondary
                                visible: false  // وقتی عنوان کامل هست، این مخفی باشه
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.currentIndex = index
                    }
                }
            }

            // نشانگر متحرک
            Rectangle {
                id: slidingIndicator

                x: 0
                y: 76 + root.currentIndex * 72
                width: 4
                height: 28
                radius: 2
                color: root.theme.accent

                Behavior on y {
                    NumberAnimation {
                        duration: 350
                        easing.type: Easing.OutCubic
                    }
                }

                // glow
                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    color: root.theme.accent
                    opacity: 0.3
                    anchors.leftMargin: -3
                    anchors.rightMargin: -3
                }
            }

            // فوتر با آواتار کاربر
            Item {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 48

                RowLayout {
                    anchors.fill: parent
                    spacing: 12

                    // آواتار
                    Rectangle {
                        Layout.preferredWidth: 40
                        Layout.preferredHeight: 40
                        radius: 20
                        color: root.theme.surfaceLight

                        Label {
                            anchors.centerIn: parent
                            text: "👤"
                            font.pixelSize: 18
                        }
                    }

                    // نام کاربر (فقط در حالت باز)
                    ColumnLayout {
                        spacing: 0
                        opacity: railExpanded ? 1 : 0

                        Behavior on opacity {
                            NumberAnimation { duration: 200 }
                        }

                        Label {
                            text: "User Name"
                            font.pixelSize: 12
                            font.bold: true
                            color: root.theme.textPrimary
                        }

                        Label {
                            text: "Pro Plan"
                            font.pixelSize: 10
                            color: root.theme.accent
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }

        // دستگیره تغییر عرض (فقط در حالت باز)
        Rectangle {
            anchors.right: parent.right
            width: railExpanded ? 4 : 0
            height: parent.height
            color: "transparent"

            Behavior on width {
                NumberAnimation { duration: 200 }
            }

            MouseArea {
                anchors.fill: parent
                anchors.margins: -4
                cursorShape: railExpanded ? Qt.SplitHCursor : Qt.ArrowCursor
                enabled: railExpanded

                property real startX: 0
                onPressed: startX = mouseX
                onPositionChanged: {
                    let newWidth = navRail.expandedWidth + (mouseX - startX)
                    navRail.expandedWidth = Math.max(160, Math.min(300, newWidth))
                    startX = mouseX
                }
            }
        }
    }

    // محتوای اصلی
    StackLayout {
        id: viewStack

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: navRail.right
        anchors.right: parent.right
        anchors.margins: 20

        currentIndex: root.currentIndex

        Transactions {
            opacity: viewStack.currentIndex === 0 ? 1 : 0
            scale: viewStack.currentIndex === 0 ? 1 : 0.95

            Behavior on opacity {
                NumberAnimation { duration: root.theme.animDuration; easing.type: Easing.OutCubic }
            }
            Behavior on scale {
                NumberAnimation { duration: root.theme.animDuration; easing.type: Easing.OutCubic }
            }
        }

        Note {
            opacity: viewStack.currentIndex === 1 ? 1 : 0
            scale: viewStack.currentIndex === 1 ? 1 : 0.95

            Behavior on opacity {
                NumberAnimation { duration: root.theme.animDuration; easing.type: Easing.OutCubic }
            }
            Behavior on scale {
                NumberAnimation { duration: root.theme.animDuration; easing.type: Easing.OutCubic }
            }
        }

        Stream {
            opacity: viewStack.currentIndex === 2 ? 1 : 0
            scale: viewStack.currentIndex === 2 ? 1 : 0.95

            Behavior on opacity {
                NumberAnimation { duration: root.theme.animDuration; easing.type: Easing.OutCubic }
            }
            Behavior on scale {
                NumberAnimation { duration: root.theme.animDuration; easing.type: Easing.OutCubic }
            }
        }

        Budget {
            opacity: viewStack.currentIndex === 3 ? 1 : 0
            scale: viewStack.currentIndex === 3 ? 1 : 0.95

            Behavior on opacity {
                NumberAnimation { duration: root.theme.animDuration; easing.type: Easing.OutCubic }
            }
            Behavior on scale {
                NumberAnimation { duration: root.theme.animDuration; easing.type: Easing.OutCubic }
            }
        }
    }
}