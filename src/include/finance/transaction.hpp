#pragma once

#include <QString>
#include <QDateTime>
#include <QObject>

class Transaction : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString title MEMBER title CONSTANT)
    Q_PROPERTY(int type MEMBER typeVal CONSTANT)
    Q_PROPERTY(double amount MEMBER amount CONSTANT)
    Q_PROPERTY(QDateTime date MEMBER date CONSTANT)

public:
    explicit Transaction(QObject *parent = nullptr) : QObject(parent) {}

    QString title;
    int typeVal = 0; // 0 = Expense, 1 = Income
    double amount = 0.0;
    QDateTime date = QDateTime::currentDateTime();
};