import sys
import os

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QObject, Slot, Signal


class MainWindow(QObject):
    def __init__(self):
        QObject.__init__(self)


if __name__ == "__main__":
    # Создаём экземпляр приложения
    app = QGuiApplication(sys.argv)
    # Создаём QML движок
    engine = QQmlApplicationEngine()

    # Создаём класс окна
    main = MainWindow()
    engine.rootContext().setContextProperty("backend", main)

    # Загружаем файл qml в движок
    engine.load(os.path.join(os.path.dirname(__file__), "qml/main.qml"))

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
