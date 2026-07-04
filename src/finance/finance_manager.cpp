#include "finance/finance_manager.hpp"

#include <QtSql/QSqlQuery>
#include <QtSql/QSqlError>
#include <QDebug>

// ---------- TransactionModel ----------
FinanceManager::TransactionModel::TransactionModel(FinanceManager *manager)
    : QAbstractListModel(manager), m_manager(manager)
{
}

int FinanceManager::TransactionModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return m_transactions.size();
}

QVariant FinanceManager::TransactionModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_transactions.size())
        return QVariant();

    Transaction *tx = m_transactions.at(index.row());

    switch (role) {
    case TitleRole:  return tx->title;
    case TypeRole:   return tx->typeVal;
    case AmountRole: return tx->amount;
    case DateRole:   return tx->date;
    default:         return QVariant();
    }
}

QHash<int, QByteArray> FinanceManager::TransactionModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[TitleRole]  = "title";
    roles[TypeRole]   = "type";
    roles[AmountRole] = "amount";
    roles[DateRole]   = "date";
    return roles;
}

void FinanceManager::TransactionModel::addTransaction(Transaction *tx)
{
    int newRow = m_transactions.size();
    beginInsertRows(QModelIndex(), newRow, newRow);
    m_transactions.append(tx);
    endInsertRows();
}

void FinanceManager::TransactionModel::loadFromDatabase()
{
    QSqlQuery q("SELECT title, amount, type, date FROM transactions ORDER BY id");

    QVector<Transaction*> loaded;
    while (q.next()) {
        Transaction *tx = new Transaction(this);
        tx->title   = q.value(0).toString();
        tx->amount  = q.value(1).toDouble();
        tx->typeVal = q.value(2).toInt();
        tx->date    = q.value(3).toDateTime();
        loaded.append(tx);
    }

    if (!loaded.isEmpty()) {
        beginInsertRows(QModelIndex(), 0, loaded.size() - 1);
        m_transactions = loaded;
        endInsertRows();
    }

    // 💡 بعد از بارگذاری، وضعیت UI را به‌روز می‌کنیم
    if (m_manager)
        emit m_manager->transactionCountChanged();
}

// ---------- FinanceManager ----------
FinanceManager::FinanceManager(QObject *parent)
    : QObject(parent)
{
    m_model = new TransactionModel(this);
    initDatabase();
    loadState();
    loadTransactions();
}

FinanceManager::~FinanceManager()
{
    if (db.isOpen())
        db.close();
}

double FinanceManager::budget() const
{
    return m_budget.amount;
}

QAbstractListModel* FinanceManager::transactions() const
{
    return m_model;
}

int FinanceManager::transactionCount() const
{
    return m_model->rowCount();
}

void FinanceManager::setBudget(double amount)
{
    if (amount < 0.0)
        return;
    if (m_budget.amount == amount)
        return;

    m_budget.amount = amount;

    if (!saveBudget(amount)) {
        qDebug() << "saveBudget failed";
        return;
    }

    emit budgetChanged();
}

bool FinanceManager::addExpense(const QString &title, double amount)
{
    if (amount <= 0.0)
        return false;

    auto *tx = new Transaction(m_model);
    tx->title   = title;
    tx->amount  = amount;
    tx->typeVal = 0; // Expense

    applyTransaction(tx);
    return true;
}

bool FinanceManager::addIncome(const QString &title, double amount)
{
    if (amount <= 0.0)
        return false;

    auto *tx = new Transaction(m_model);
    tx->title   = title;
    tx->amount  = amount;
    tx->typeVal = 1; // Income

    applyTransaction(tx);
    return true;
}

void FinanceManager::applyTransaction(Transaction *tx)
{
    if (tx->typeVal == 0) // Expense
        m_budget.amount -= tx->amount;
    else // Income
        m_budget.amount += tx->amount;

    m_model->addTransaction(tx);

    if (!insertTransaction(tx))
        qDebug() << "insertTransaction failed";

    if (!saveBudget(m_budget.amount))
        qDebug() << "saveBudget failed";

    emit budgetChanged();
    emit transactionCountChanged();
}

void FinanceManager::initDatabase()
{
    db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("monito.db");

    if (!db.open()) {
        qDebug() << "DB open failed:" << db.lastError().text();
        return;
    }

    QSqlQuery q;

    q.exec("CREATE TABLE IF NOT EXISTS budget (id INTEGER PRIMARY KEY, amount REAL)");

    q.exec(R"(
        CREATE TABLE IF NOT EXISTS transactions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            amount REAL,
            type INTEGER,
            date TEXT DEFAULT (datetime('now'))
        )
    )");
}

void FinanceManager::loadState()
{
    QSqlQuery q("SELECT amount FROM budget WHERE id = 1");

    if (q.next())
        m_budget.amount = q.value(0).toDouble();
    else
        m_budget.amount = 0.0;
}

void FinanceManager::loadTransactions()
{
    m_model->loadFromDatabase();
    // اطمینان از emit سیگنال در صورت وجود رکورد در دیتابیس
    emit transactionCountChanged();
}

bool FinanceManager::saveBudget(double amount)
{
    QSqlQuery q;

    q.prepare(R"(
        INSERT INTO budget (id, amount)
        VALUES (1, ?)
        ON CONFLICT(id) DO UPDATE SET amount = excluded.amount
    )");

    q.addBindValue(amount);

    if (!q.exec()) {
        qDebug() << "saveBudget error:" << q.lastError().text();
        return false;
    }

    return true;
}

bool FinanceManager::insertTransaction(const Transaction *tx)
{
    QSqlQuery q;

    q.prepare(R"(
        INSERT INTO transactions (title, amount, type, date)
        VALUES (?, ?, ?, ?)
    )");

    q.addBindValue(tx->title);
    q.addBindValue(tx->amount);
    q.addBindValue(tx->typeVal);
    q.addBindValue(tx->date.toString(Qt::ISODate));

    if (!q.exec()) {
        qDebug() << "insertTransaction error:" << q.lastError().text();
        return false;
    }

    return true;
}