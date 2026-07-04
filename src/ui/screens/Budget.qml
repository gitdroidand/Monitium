/*
@file Budget.qml
@brief This file contains the budget screen.
@author Droidand Inc
@date 2026-07-04
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: budgetPage

    // دسترسی به تم والد (ApplicationWindow)
    property var theme: ({
        primaryBg: "#0a0f24",
        surface: "#131a33",
        surfaceLight: "#1c2541",
        accent: "#3b82f6",
        accentHover: "#2563eb",
        textPrimary: "#f1f5f9",
        textSecondary: "#94a3b8",
        success: "#10b981",
        warning: "#f59e0b",
        danger: "#ef4444",
        radiusSmall: 8,
        radiusMedium: 12,
        radiusLarge: 16,
        animDuration: 350
    })

    // ----- محاسبه درصد باقی‌مانده -----
    property double totalSpent: {
        let sum = 0
        if (financeManager.transactions) {
            for (let i = 0; i < financeManager.transactions.rowCount(); i++) {
                let tx = financeManager.transactions.data(
                    financeManager.transactions.index(i, 0),
                    financeManager.transactions.roleNames().TypeRole
                ) // به دلیل ساختار مدل، باید مستقیماً از C++ بخونیم
            }
        }
        // روش بهتر: استفاده از مدل با role
        // ما یک روش ساده با حلقه روی مدل پیاده می‌کنیم
        // (نیاز به دسترسی به roleNames)
        // اما می‌توانیم یک تابع C++ صدا کنیم، ولی در QML محدودیم
        // در اینجا یک loop ساده با data و role انجام می‌دهیم
    }

    // چون دسترسی مستقیم به model داده‌ها پیچیده است، یک روش جایگزین:
    // از connection to financeManager استفاده می‌کنیم، اما برای محاسبه زنده
    // بهتر است یک تابع کمکی C++ به FinanceManager اضافه کنیم (اختیاری)
    // در این نسخه ما درصد را با یک Connection به روز می‌کنیم.

    property double spentAmount: 0

    // هر بار که تراکنش‌ها تغییر می‌کنند، spent را دوباره محاسبه کن
    Connections {
        target: financeManager
        function onTransactionsChanged() { updateSpent() }
        function onBudgetChanged() { budgetValue = financeManager.budget }
    }

    function updateSpent() {
        let sum = 0
        let model = financeManager.transactions
        if (model) {
            for (let i = 0; i < model.rowCount(); i++) {
                let idx = model.index(i, 0)
                let type = model.data(idx, model.roleNames().TypeRole)   // دسترسی به نقش‌ها
                let amount = model.data(idx, model.roleNames().AmountRole)
                if (type === 0) sum += amount   // 0 = Expense
            }
        }
        spentAmount = sum
    }

    property double budgetValue: financeManager.budget
    property double remainingPercent: budgetValue > 0 ? Math.max(0, ((budgetValue - spentAmount) / budgetValue) * 100) : 0

    // انیمیشن شمارش
    property double animatedBudget: 0
    NumberAnimation on animatedBudget {
        id: countUp
        from: 0
        to: budgetValue
        duration: 800
        easing.type: Easing.OutCubic
        running: false
    }

    // هنگام نمایش صفحه انیمیشن اجرا شود
    Connections {
        target: budgetPage.StackView.view  // دسترسی به StackView والد
        function onCurrentIndexChanged() {
            if (budgetPage.StackView.view.currentIndex === 3) { // index بودجه
                animatedBudget = 0
                countUp.to = budgetValue
                countUp.restart()
            }
        }
    }

    ColumnLayout {
        anchors.centerIn: parent
        width: Math.min(parent.width * 0.6, 500)
        spacing: 32

        // کارت نمایش بودجه
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 180
            radius: theme.radiusLarge
            color: theme.surface

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 16

                Label {
                    text: "Current Budget"
                    font.pixelSize: 16
                    color: theme.textSecondary
                    Layout.alignment: Qt.AlignHCenter
                }

                // عدد بودجه با انیمیشن
                Label {
                    text: "$" + animatedBudget.toFixed(2)
                    font.pixelSize: 48
                    font.bold: true
                    color: {
                        if (remainingPercent < 50) return theme.danger
                        if (remainingPercent <= 75) return theme.warning
                        return theme.success
                    }
                    Layout.alignment: Qt.AlignHCenter
                }

                // نوار درصد مصرف
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 8

                    Label {
                        text: remainingPercent.toFixed(0) + "% remaining"
                        font.pixelSize: 12
                        color: {
                            if (remainingPercent < 50) return theme.danger
                            if (remainingPercent <= 75) return theme.warning
                            return theme.success
                        }
                    }

                    Rectangle {
                        Layout.preferredWidth: 120
                        Layout.preferredHeight: 6
                        radius: 3
                        color: theme.surfaceLight

                        Rectangle {
                            width: parent.width * (remainingPercent / 100)
                            height: parent.height
                            radius: 3
                            color: {
                                if (remainingPercent < 50) return theme.danger
                                if (remainingPercent <= 75) return theme.warning
                                return theme.success
                            }
                            Behavior on width { NumberAnimation { duration: 300 } }
                        }
                    }
                }
            }
        }

        // تنظیم بودجه
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 12

            TextField {
                id: budgetField
                Layout.fillWidth: true
                placeholderText: "Enter new budget"
                placeholderTextColor: theme.textSecondary
                color: theme.textPrimary
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                validator: DoubleValidator { bottom: 0 }

                background: Rectangle {
                    color: theme.surfaceLight
                    radius: theme.radiusSmall
                    border.color: budgetField.activeFocus ? theme.accent : "transparent"
                    border.width: 2
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Button {
                    text: "Set Budget"
                    Layout.fillWidth: true
                    background: Rectangle {
                        color: theme.accent
                        radius: theme.radiusSmall
                    }
                    contentItem: Label {
                        text: "Set Budget"
                        color: "white"
                        font.pixelSize: 14
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: {
                        if (budgetField.text.length > 0) {
                            financeManager.setBudget(Number(budgetField.text))
                            budgetField.clear()
                            // انیمیشن دوباره اجرا شود
                            animatedBudget = 0
                            countUp.to = financeManager.budget
                            countUp.restart()
                        }
                    }
                }

                Button {
                    text: "Reset"
                    Layout.fillWidth: true
                    background: Rectangle {
                        color: theme.danger
                        radius: theme.radiusSmall
                    }
                    contentItem: Label {
                        text: "Reset Budget"
                        color: "white"
                        font.pixelSize: 14
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: {
                        financeManager.setBudget(0)
                        budgetField.clear()
                        animatedBudget = 0
                        countUp.to = 0
                        countUp.restart()
                    }
                }
            }
        }

        // راهنمای رنگ‌ها
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 16

            Repeater {
                model: [
                    { color: theme.danger, text: "Critical (<50%)" },
                    { color: theme.warning, text: "Warning (50-75%)" },
                    { color: theme.success, text: "Healthy (>75%)" }
                ]
                RowLayout {
                    spacing: 6
                    Rectangle {
                        width: 10; height: 10; radius: 5; color: modelData.color
                    }
                    Label {
                        text: modelData.text
                        font.pixelSize: 11
                        color: theme.textSecondary
                    }
                }
            }
        }
    }

    // راه‌اندازی اولیه
    Component.onCompleted: {
        updateSpent()
        animatedBudget = budgetValue
        if (budgetPage.StackView.view && budgetPage.StackView.view.currentIndex === 3)
            countUp.restart()
    }
}