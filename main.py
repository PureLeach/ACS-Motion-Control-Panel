import sys
import os

from PySide6.QtGui import QGuiApplication, QIcon
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QObject, Slot, Signal

from acspy import acsc  # Библиотека управления контроллером сервопривода


class MainWindow(QObject):
    def __init__(self):
        QObject.__init__(self)
        # Подключаемся к драйверу по COM порту
        try:
            self.hc = acsc.OpenCommSerial()  # Подключаемся к драйверу по COM порту
            acsc.enable(self.hc, 0)  # Включаем ось 0
            # Максимальный крутящий момент, приложенный к двигателю, который вызывает срабатывание механизма остановки
            acsc.setJerk(self.hc, 0, 1000)
            acsc.setAcceleration(self.hc, 0, 500)  # Максимальное ускорение
            acsc.setDeceleration(self.hc, 0, 100)  # Максимальное замедление
            self.flags = acsc.AMF_RELATIVE
            print('Подключились к приводу')
        except acsc.AcscError:
            print('Ошибка подключения к драйверу сервопривода')

        # Обработка ошибок
        def my_excepthook(exctype, value, traceback):
            sys.__excepthook__(exctype, value, traceback)
            print('exctype = ', exctype)
            print('value = ', value)
            if str(value) == "name 'hc' is not defined":
                print('Сервопривод не подключен')
        sys.excepthook = my_excepthook

    # Инициализация привода
    @Slot()
    def initialize(self):
        # Запускаем скрипт инициализации из 1 буфера флеш контроллера
        acsc.runBuffer(self.hc, 1)
        print("Запуск инициализации привода")

    @Slot()
    def zero_position(self):
        acsc.runBuffer(self.hc, 20)  # Set the drive to the zero position
        print("Установка привода в положение нуля ")

    # Поворот двигателя по часовой
    @Slot(int, int)
    def rotation(self, speed, angle):
        acsc.setVelocity(self.hc, 0, speed)
        acsc.toPoint(self.hc, self.hc, 0, angle * -1)
        acsc.waitMotionEnd(self.hc, 0)  # Ждём конца остановки
        print(
            f"Поворот двигателя по часовой на угол {angle} со скоростью {speed}")

    # Поворот двигателя против часовой
    @Slot(int, int)
    def reverse_rotation(self, speed, angle):
        acsc.setVelocity(self.hc, 0, speed)
        acsc.toPoint(self.hc, self.hc, 0, angle)
        acsc.waitMotionEnd(self.hc, 0)  # Ждём конца остановки
        print(
            f"Поворот двигателя против часовой на угол {angle} со скоростью {speed}")


if __name__ == "__main__":
    # Создаём экземпляр приложения
    app = QGuiApplication(sys.argv)
    # Создаём QML движок
    engine = QQmlApplicationEngine()
    # Создаём класс окна
    main = MainWindow()
    engine.rootContext().setContextProperty("backend", main)
    # Устанавливаем иконку
    app.setWindowIcon(QIcon("icon.ico"))
    # Загружаем файл qml в движок
    engine.load(os.path.join(os.path.dirname(__file__), "qml/main.qml"))

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
