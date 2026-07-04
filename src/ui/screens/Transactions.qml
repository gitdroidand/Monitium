import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Pane {
    id: root

    padding: 0
    background: Rectangle { color: "transparent" }

    // تم
    property var theme: ({
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

    Dialog {
        id: addTransactionDialog

        modal: true
        anchors.centerIn: Overlay.overlay

        title: "Add Transaction"

        standardButtons: Dialog.Cancel

        width: 420

        background: Rectangle {
            color: root.theme.surface
            radius: root.theme.radiusLarge
            border.color: Qt.rgba(255, 255, 255, 0.08)
        }

        ColumnLayout {
            width: parent.width
            spacing: 16

            TextField {
                id: titleField

                Layout.fillWidth: true

                placeholderText: "Title"
                placeholderTextColor: root.theme.textSecondary
                color: root.theme.textPrimary

                background: Rectangle {
                    color: root.theme.surfaceLight
                    radius: root.theme.radiusSmall
                    border.color: titleField.activeFocus ? root.theme.accent : "transparent"
                    border.width: 2
                }

                onTextChanged: errorLabel.visible = false
            }

            TextField {
                id: amountField

                Layout.fillWidth: true

                placeholderText: "Amount"
                placeholderTextColor: root.theme.textSecondary
                color: root.theme.textPrimary

                inputMethodHints: Qt.ImhFormattedNumbersOnly
                validator: DoubleValidator { bottom: 0; decimals: 2 }

                background: Rectangle {
                    color: root.theme.surfaceLight
                    radius: root.theme.radiusSmall
                    border.color: amountField.activeFocus ? root.theme.accent : "transparent"
                    border.width: 2
                }

                onTextChanged: errorLabel.visible = false
            }

            // ========================= رفع باگ: حذف title تکراری و تنظیم padding =========================
            GroupBox {
                // title رو برداشتیم
                Layout.fillWidth: true

                // حاشیه‌های داخلی برای فاصله از عنوان
                topPadding: 30
                bottomPadding: 12
                leftPadding: 12
                rightPadding: 12

                background: Rectangle {
                    color: root.theme.surfaceLight
                    radius: root.theme.radiusSmall
                }

                label: Label {
                    text: "Transaction Type"
                    color: root.theme.textSecondary
                    font.pixelSize: 12
                    // label به طور خودکار در بالا قرار می‌گیره
                }

                ColumnLayout {
                    spacing: 8  // فضای بین دو رادیو باتن

                    RadioButton {
                        id: expenseButton
                        checked: true
                        text: ""  // متن رو خالی می‌ذاریم چون contentItem سفارشی داریم
                        
                        contentItem: Label {
                            text: "Expense"
                            color: root.theme.textPrimary
                            font.pixelSize: 14
                            leftPadding: 8
                        }
                        
                        indicator: Rectangle {
                            width: 20
                            height: 20
                            radius: 10
                            color: "transparent"
                            border.color: expenseButton.checked ? root.theme.danger : root.theme.textSecondary
                            border.width: 2
                            
                            Rectangle {
                                anchors.centerIn: parent
                                width: 10
                                height: 10
                                radius: 5
                                color: root.theme.danger
                                opacity: expenseButton.checked ? 1 : 0
                                
                                Behavior on opacity {
                                    NumberAnimation { duration: 150 }
                                }
                            }
                        }
                    }

                    RadioButton {
                        id: incomeButton
                        checked: false   // صریحاً مشخص کردیم که unchecked باشه
                        text: ""
                        
                        contentItem: Label {
                            text: "Income"
                            color: root.theme.textPrimary
                            font.pixelSize: 14
                            leftPadding: 8
                        }
                        
                        indicator: Rectangle {
                            width: 20
                            height: 20
                            radius: 10
                            color: "transparent"
                            border.color: incomeButton.checked ? root.theme.success : root.theme.textSecondary
                            border.width: 2
                            
                            Rectangle {
                                anchors.centerIn: parent
                                width: 10
                                height: 10
                                radius: 5
                                color: root.theme.success
                                opacity: incomeButton.checked ? 1 : 0
                                
                                Behavior on opacity {
                                    NumberAnimation { duration: 150 }
                                }
                            }
                        }
                    }
                }
            }

            Label {
                id: errorLabel

                visible: false

                color: root.theme.danger

                Layout.fillWidth: true

                wrapMode: Text.WordWrap
            }

            RowLayout {
                Layout.fillWidth: true

                Item {
                    Layout.fillWidth: true
                }

                Button {
                    text: "Cancel"
                    
                    background: Rectangle {
                        color: root.theme.surfaceLight
                        radius: root.theme.radiusSmall
                    }
                    
                    contentItem: Label {
                        text: "Cancel"
                        color: root.theme.textSecondary
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        errorLabel.visible = false
                        addTransactionDialog.close()
                    }
                }

                Button {
                    text: "Add"

                    background: Rectangle {
                        color: root.theme.accent
                        radius: root.theme.radiusSmall
                    }
                    
                    contentItem: Label {
                        text: "Add"
                        color: "white"
                        font.pixelSize: 14
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        if (titleField.text.length === 0) {
                            errorLabel.visible = true
                            errorLabel.text = "Please enter a title."
                            return
                        }

                        if (amountField.text.length === 0) {
                            errorLabel.visible = true
                            errorLabel.text = "Please enter an amount."
                            return
                        }

                        let amount = Number(amountField.text.replace(",", "."))

                        if (amount <= 0 || isNaN(amount)) {
                            errorLabel.visible = true
                            errorLabel.text = "Amount must be greater than zero."
                            return
                        }

                        let success = false

                        if (expenseButton.checked)
                            success = financeManager.addExpense(titleField.text, amount)
                        else
                            success = financeManager.addIncome(titleField.text, amount)

                        if (!success) {
                            errorLabel.visible = true
                            errorLabel.text = "Failed to add transaction."
                            return
                        }

                        titleField.clear()
                        amountField.clear()
                        expenseButton.checked = true

                        errorLabel.visible = false

                        addTransactionDialog.close()
                    }
                }
            }
        }
    }

    StackLayout {
        id: viewStack

        anchors.fill: parent

        currentIndex: financeManager.transactionCount > 0 ? 1 : 0

        // حالت خالی (empty state)
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                anchors.centerIn: parent

                width: Math.min(parent.width * 0.55, 520)

                spacing: 24

                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 100
                    Layout.preferredHeight: 100
                    radius: 30
                    color: root.theme.surface
                    
                    Label {
                        anchors.centerIn: parent
                        text: "💳"
                        font.pixelSize: 48
                    }
                }

                Label {
                    Layout.alignment: Qt.AlignHCenter

                    text: "No transactions yet"

                    font.pixelSize: 28
                    font.bold: true
                    color: root.theme.textPrimary
                }

                Label {
                    Layout.fillWidth: true

                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap

                    text: "Start tracking your finances by creating your first transaction. Every expense and income will appear here."

                    opacity: 0.75

                    font.pixelSize: 15
                    color: root.theme.textSecondary
                    lineHeight: 1.6
                }

                Button {
                    Layout.alignment: Qt.AlignHCenter

                    padding: 16
                    leftPadding: 28
                    rightPadding: 28

                    background: Rectangle {
                        color: root.theme.accent
                        radius: root.theme.radiusMedium
                    }
                    
                    contentItem: RowLayout {
                        spacing: 8
                        
                        Label {
                            text: "＋"
                            font.pixelSize: 18
                            color: "white"
                        }
                        
                        Label {
                            text: "Add Transaction"
                            font.pixelSize: 15
                            font.bold: true
                            color: "white"
                        }
                    }

                    onClicked: addTransactionDialog.open()
                }
            }
        }

        // حالت لیست تراکنش‌ها
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            spacing: 20

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                
                radius: root.theme.radiusLarge
                color: root.theme.surface

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 24

                    ColumnLayout {
                        spacing: 6

                        Label {
                            text: "Current Budget"
                            font.pixelSize: 13
                            color: root.theme.textSecondary
                        }

                        Label {
                            text: "$" + financeManager.budget.toFixed(2)
                            font.pixelSize: 32
                            font.bold: true
                            color: financeManager.budget >= 0 ? root.theme.success : root.theme.danger
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Button {
                        padding: 12
                        leftPadding: 24
                        rightPadding: 24

                        background: Rectangle {
                            color: root.theme.accent
                            radius: root.theme.radiusSmall
                        }
                        
                        contentItem: RowLayout {
                            spacing: 6
                            
                            Label {
                                text: "＋"
                                font.pixelSize: 16
                                color: "white"
                            }
                            
                            Label {
                                text: "Add"
                                font.pixelSize: 14
                                font.bold: true
                                color: "white"
                            }
                        }

                        onClicked: addTransactionDialog.open()
                    }
                }
            }

            ListView {
                id: transactionList

                Layout.fillWidth: true
                Layout.fillHeight: true

                model: financeManager.transactions

                clip: true
                spacing: 8

                delegate: Rectangle {
                    width: transactionList.width
                    height: 60

                    radius: root.theme.radiusMedium
                    color: root.theme.surface

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 14

                        ColumnLayout {
                            spacing: 4

                            Label {
                                text: title
                                font.pixelSize: 15
                                font.bold: true
                                color: root.theme.textPrimary
                            }

                            Label {
                                text: type === 0 ? "Expense" : "Income"
                                font.pixelSize: 12
                                color: type === 0 ? root.theme.danger : root.theme.success
                                opacity: 0.8
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        Label {
                            text: (type === 0 ? "-" : "+") + "$" + amount.toFixed(2)
                            font.pixelSize: 18
                            font.bold: true
                            color: type === 0 ? root.theme.danger : root.theme.success
                        }
                    }
                }
            }
        }
    }
}