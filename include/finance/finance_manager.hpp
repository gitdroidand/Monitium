#pragma once

#include <QObject>
#include <QVector>
#include <QString>
#include <QtSql/QSqlDatabase>
#include <QAbstractListModel>

#include "finance/budget.hpp"
#include "finance/transaction.hpp"

class FinanceManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(double budget READ budget NOTIFY budgetChanged FINAL)
    Q_PROPERTY(QAbstractListModel* transactions READ transactions CONSTANT FINAL)
    Q_PROPERTY(int transactionCount READ transactionCount NOTIFY transactionCountChanged FINAL)

public:
    explicit FinanceManager(QObject *parent = nullptr);
    ~FinanceManager();

    double budget() const;
    QAbstractListModel* transactions() const;
    int transactionCount() const;

    Q_INVOKABLE void setBudget(double amount);

    Q_INVOKABLE bool addExpense(const QString &title, double amount);
    Q_INVOKABLE bool addIncome(const QString &title, double amount);

signals:
    void budgetChanged();
    void transactionCountChanged();

private:
    void initDatabase();
    void loadState();
    void loadTransactions();

    bool saveBudget(double amount);
    bool insertTransaction(const Transaction *tx);

    void applyTransaction(Transaction *tx);

private:
    QSqlDatabase db;
    Budget m_budget;

    class TransactionModel : public QAbstractListModel
    {
    public:
        enum Roles {
            TitleRole = Qt::UserRole + 1,
            TypeRole,
            AmountRole,
            DateRole
        };

        explicit TransactionModel(FinanceManager *manager);

        int rowCount(const QModelIndex &parent = QModelIndex()) const override;
        QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
        QHash<int, QByteArray> roleNames() const override;

        void addTransaction(Transaction *tx);
        void loadFromDatabase();

        QVector<Transaction*> m_transactions;
        FinanceManager *m_manager;  // برای emit کردن سیگنال
    };

    TransactionModel *m_model;
};