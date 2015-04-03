#-------------------------------------------------
#
# Project created by QtCreator 2015-04-03T09:36:51
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = helloworld
TEMPLATE = app


SOURCES += main.cpp\
        helloworldwidget.cpp

HEADERS  += helloworldwidget.h

FORMS    += helloworldwidget.ui

# Target deploy support:
target.path = /home/root/
INSTALLS += target
