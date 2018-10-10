import sys
import PyQt5.QtWidgets
import PyQt5.QtQml
import PyQt5.QtQuick

import interactive

if __name__ == '__main__':
        con = interactive.Interactive()
        app = PyQt5.QtWidgets.QApplication(sys.argv)
        engine = PyQt5.QtQml.QQmlApplicationEngine()
        context = engine.rootContext()
        context.setContextProperty('con', con)
        engine.load('main.qml')
        app.exec_()
