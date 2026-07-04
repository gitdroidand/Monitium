cmake_minimum_required(VERSION 3.25)

project(MonitiumDesktop LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 REQUIRED COMPONENTS
    Core
    Gui
    Qml
    Quick
    Sql
)

qt_policy(SET QTP0001 NEW)

file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS
    src/*.cpp
)

file(GLOB_RECURSE HEADERS CONFIGURE_DEPENDS
    include/*.hpp
    include/*.h
)

file(GLOB_RECURSE QML_FILES
    RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
    CONFIGURE_DEPENDS
    qml/*.qml
)

file(GLOB_RECURSE RESOURCES CONFIGURE_DEPENDS
    resources/*.qrc
)

qt_add_executable(MonitoDesktopApp
    ${SOURCES}
    ${HEADERS}
    ${RESOURCES}
)

qt_add_qml_module(MonitoDesktopApp
    URI MonitoDesktop
    VERSION 1.0
    QML_FILES
        ${QML_FILES}
)

target_include_directories(MonitoDesktopApp PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_link_libraries(MonitoDesktopApp PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::Sql
)