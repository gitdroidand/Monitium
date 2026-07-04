# Monito Desktop

<div align="center">

# Monito Desktop

Modern desktop productivity suite built with **Qt 6**, **QML**, and **C++23**.

A fast, modular, and native desktop application designed around the **Launcher Structure** architecture.

---

Finance • Notes • Streaming • Calendar • Calculator • HTML Reader

GPL-3.0 License

</div>

---

# About

Monito Desktop is an open-source productivity suite focused on performance, modularity, and a modern user experience.

Unlike traditional desktop applications where every feature is tightly coupled together, Monito is organized as a collection of independent modules managed through a lightweight launcher.

Each module owns its own UI, business logic, and data layer while sharing a common application framework.

The long-term goal is to provide a complete desktop productivity environment while keeping the codebase clean, scalable, and enjoyable to maintain.

---

# Features

## Finance

- Budget Management
- Income & Expense Tracking
- SQLite Persistence
- Automatic Budget Updates
- Transaction History
- Native C++ Backend
- QML User Interface

## Notes

- Rich Notes *(Work in Progress)*

## Streaming

- Media Streaming *(Work in Progress)*

## Upcoming Modules

- Calendar
- Calculator
- HTML Reader
- Settings
- Theme Manager

---

# Launcher Structure

Monito follows a modular architecture internally called **Launcher Structure**.

Instead of placing every feature inside one large application, every module behaves like a small application living inside the launcher.

```
Application
│
├── Launcher
│
├── Finance
│
├── Notes
│
├── Streaming
│
├── Calendar
│
├── Calculator
│
└── HTML Reader
```

Each module contains its own:

- User Interface
- Models
- Business Logic
- Database Layer
- Backend Services

Modules communicate through clean APIs rather than depending on each other's internal implementation.

This architecture makes the project:

- Modular
- Maintainable
- Scalable
- Testable
- Easy to extend

---

# Project Structure

```
MonitoDesktop/

├── src/
│   ├── finance/
│   ├── stream/
│   ├── ui/
│   ├── include/
│   ├── app_screen.cpp
│   └── main.cpp
│
├── scripts/
│   ├── build_linux.sh
│   ├── build_macos.sh
│   ├── build_windows.ps1
│   └── cross_build_windows.sh
│
├── container/
│
├── CMakeLists.txt
│
└── README.md
```

The project keeps implementation and interface files together inside the `src` tree, making modules self-contained and easier to navigate.

---

# Technologies

- C++23
- Qt 6
- Qt Quick
- Qt Quick Controls
- QML
- SQLite
- CMake
- Ninja

---

# Database

The Finance module currently uses SQLite.

Current tables:

- budget
- transactions

Future schema additions:

- Accounts
- Categories
- Recurring Transactions
- Statistics
- Reports
- Encryption
- Backup / Restore

---

# Requirements

- Qt 6.10+
- CMake
- Ninja *(recommended)*
- C++23 Compiler

Typical Linux packages:

```text
qt6-base
qt6-declarative
qt6-shadertools
sqlite
cmake
ninja
```

---

# Build

Clone the repository

```bash
git clone https://github.com/gitdroidand/MonitoDesktop.git
cd MonitoDesktop
```

---

## Linux

```bash
./scripts/build_linux.sh
```

---

## macOS

Monito can be built directly from source.

```bash
./scripts/build_macos.sh
```

The script automatically configures the project, builds it, and generates the macOS application bundle.

Building from source is currently the recommended installation method.

---

## Windows

Open PowerShell and execute:

```powershell
.\scripts\build_windows.ps1
```

---

## Cross-build Windows (Linux)

If MinGW-w64 is installed:

```bash
./scripts/cross_build_windows.sh
```

This produces a native Windows executable directly from Linux.

---

# Philosophy

Monito is built around several core principles.

- Native performance
- Clean architecture
- Modular design
- Modern desktop UI
- Small dependency footprint
- Readable code
- Long-term maintainability

---

# Roadmap

## Finance

- [x] Budget
- [x] Transactions
- [x] SQLite Persistence
- [ ] Categories
- [ ] Accounts
- [ ] Monthly Reports
- [ ] Charts
- [ ] XLSX Export
- [ ] PDF Export
- [ ] Backup / Restore
- [ ] Encryption

---

## Notes

- [ ] Rich Text Editor
- [ ] Markdown
- [ ] HTML Export

---

## Streaming

- [ ] Local Playback
- [ ] Network Streaming
- [ ] Drag & Drop
- [ ] Playback History
- [ ] Resume Playback

---

## Application

- [ ] Theme Manager
- [ ] Settings
- [ ] Localization
- [ ] Plugin Support

---

# Contributing

Contributions are welcome.

Please follow these guidelines:

- Keep modules independent.
- Follow the existing coding style.
- Write readable C++ and QML.
- Keep commits focused on a single feature.
- Test changes before submitting a pull request.

---

# License

Monito Desktop is licensed under the GNU General Public License v3.0.

See the **LICENSE** file for details.

---

# Author

Developed and maintained by **Droidand**.

Built with **Qt 6**, **QML**, and **C++23**.