# Monito Desktop

<div align="center">

Modern Desktop Productivity Suite built with **Qt 6**, **QML** and **C++23**

Budget • Transactions • Notes • Streaming • Calculator • Calendar

GPL-3.0 License

</div>

---

## Overview

Monito Desktop is a modern open-source desktop productivity application focused on simplicity, performance and clean architecture.

Unlike traditional monolithic applications, Monito is designed around independent modules managed by a lightweight launcher architecture. Every feature lives inside its own module while sharing a common application framework.

Current modules include:

- Finance
- Notes
- Streaming
- Calculator *(planned)*
- Calendar *(planned)*
- HTML Reader *(planned)*

---

# Features

## Finance

- Budget Management
- Income
- Expense
- Persistent SQLite Database
- Automatic Budget Updates
- Transaction History
- Clean MVVM-style communication between QML and C++

## Notes

- Rich note management *(Work in Progress)*

## Streaming

- Media streaming *(Work in Progress)*

---

# Architecture

Monito uses a modular architecture called **Launcher Structure**.

```
Application
│
├── Launcher
│
├── Finance Module
│
├── Notes Module
│
├── Streaming Module
│
├── Calculator Module
│
└── Calendar Module
```

Each module is isolated and contains its own:

- Models
- Business Logic
- UI
- Database Layer
- Controllers (when required)

Modules communicate through clean interfaces instead of depending on each other's implementation.

This keeps the project:

- scalable
- maintainable
- testable
- easy to extend

---

# Current Project Structure

```
src/
│
├── finance/
│
├── notes/
│
├── stream/
│
├── ui/
│
├── app/
│
└── main.cpp

include/

resources/

CMakeLists.txt
```

As the project evolves, all QML files will be moved into:

```
src/ui/
```

to keep every module inside the same source tree.

---

# Technologies

- C++23
- Qt 6
- Qt Quick
- Qt Quick Controls
- QML
- SQLite
- CMake

---

# Database

Finance currently stores data using SQLite.

Current tables:

```
budget
transactions
```

Future versions will include:

- Categories
- Accounts
- Tags
- Budgets
- Attachments
- Recurring Transactions

---

# Build Requirements

- Qt 6.8+
- CMake
- Ninja (recommended)
- C++23 Compiler

Linux packages usually required:

```
qt6-base
qt6-declarative
qt6-tools
qt6-shadertools
qt6-svg
sqlite
cmake
ninja
```

---

# Build

Clone the repository

```bash
git clone https://github.com/your-name/MonitoDesktop.git

cd MonitoDesktop
```

Configure

```bash
cmake -B build
```

Compile

```bash
cmake --build build
```

Run

```bash
./build/MonitoDesktopApp
```

---

# macOS

macOS users can build Monito directly from source.

Simply run:

```bash
./build_macos.sh
```

The script will configure the project, compile it using CMake and generate the application bundle automatically.

Building from source is currently the recommended installation method for macOS.

---

# Philosophy

Monito focuses on a few simple ideas.

- Clean code
- Modern UI
- Fast startup
- Native performance
- Modular architecture
- Maintainable codebase
- Minimal dependencies

The goal is to build a desktop application that feels lightweight while remaining powerful enough for everyday productivity.

---

# Roadmap

## Finance

- [x] Budget
- [x] Transactions
- [x] SQLite Persistence
- [ ] Categories
- [ ] Accounts
- [ ] Statistics
- [ ] Charts
- [ ] Monthly Reports
- [ ] XLSX Export
- [ ] PDF Export
- [ ] Backup / Restore
- [ ] Encryption

## Notes

- [ ] Rich Text Editor
- [ ] Markdown
- [ ] HTML Export

## Streaming

- [ ] Local Media
- [ ] Network Streaming
- [ ] History
- [ ] Drag & Drop
- [ ] Resume Playback

## General

- [ ] Settings
- [ ] Themes
- [ ] Localization
- [ ] Plugin System

---

# Contributing

Contributions are welcome.

Before opening a pull request please:

- Follow the project coding style.
- Keep modules independent.
- Write clean and readable code.
- Test your changes.
- Keep commits focused on a single feature.

---

# License

This project is licensed under the GNU General Public License v3.0.

See the LICENSE file for details.

---

# Credits

Developed by **Droidand**

Built with Qt ❤️