import sys
import os
import time

from PySide6.QtGui import QGuiApplication, QIcon
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QObject, Slot, Signal

from acspy import acsc


class MainWindow(QObject):
    def __init__(self):
        QObject.__init__(self)
        # Connect to the driver via COM port
        try:
            self.hc: object = acsc.OpenCommSerial()
            # Activating axis 0
            acsc.enable(self.hc, 0)
            # Maximum torque applied to the motor that triggers the stopping mechanism
            acsc.setJerk(self.hc, 0, 1000)
            acsc.setAcceleration(self.hc, 0, 500)
            acsc.setDeceleration(self.hc, 0, 100)
            self.flags: int = acsc.AMF_RELATIVE
        except acsc.AcscError as e:
            print(f"Connection error to the servo driver: {e}")

        # Error Handling
        def my_excepthook(exctype, value, traceback):
            sys.__excepthook__(exctype, value, traceback)
            print("exctype = ", exctype)
            print("value = ", value)
            if str(value) == "name 'self.hc' is not defined":
                print("The servo is not connected")

        sys.excepthook = my_excepthook

    @Slot()
    def initializing_drive(self):
        # Run the initialization script from 1 buffer of the flash controller
        acsc.runBuffer(self.hc, 1)
        print("Starting drive initialization")

    @Slot()
    def zero_position(self):
        # Set the drive to the zero position
        acsc.runBuffer(self.hc, 20)
        print("Setting the drive to the zero position")

    @Slot(float, int)
    def rotation(self, speed: float, angle: int):
        """Turning the engine clockwise

        Args:
            speed (float): Turning speed
            angle (int): Turning angle
        """
        # If the axis is disabled, then turn it on
        if not acsc.getMotorEnabled(self.hc, 0):
            # Activating axis 0
            acsc.enable(self.hc, 0)
            time.sleep(0.3)
        acsc.setVelocity(self.hc, 0, speed)
        acsc.toPoint(self.hc, self.flags, 0, angle * -1)
        print(
            f"Turning the motor counterclockwise by an angle {angle} with speed {speed}"
        )

    @Slot(float, int)
    def reverse_rotation(self, speed: float, angle: int):
        """Turning the engine counterclockwise

        Args:
            speed (float): Turning speed
            angle (int): Turning angle
        """
        # If the axis is disabled, then turn it on
        if not acsc.getMotorEnabled(self.hc, 0):
            # Activating axis 0
            acsc.enable(self.hc, 0)
            time.sleep(0.3)
        acsc.setVelocity(self.hc, 0, speed)
        acsc.toPoint(self.hc, self.flags, 0, angle)
        print(
            f"Turning the motor counterclockwise by an angle {angle} with speed {speed}"
        )

    @Slot()
    def stop_rotation(self):
        # Disabling the axis
        acsc.disable(self.hc, 0)
        print("The engine is stopped")


if __name__ == "__main__":
    # Creating an application instance
    app = QGuiApplication(sys.argv)
    # Creating a QML engine
    engine = QQmlApplicationEngine()
    # Create a window class
    main = MainWindow()
    engine.rootContext().setContextProperty("backend", main)
    # Installing the icon
    app.setWindowIcon(QIcon("icon.ico"))
    # Load the QML file into the engine
    engine.load(os.path.join(os.path.dirname(__file__), "qml/main.qml"))

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
