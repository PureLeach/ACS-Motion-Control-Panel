import QtQuick 6
import QtQuick.Window 2.15
import QtQuick.Controls 6
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.0

ApplicationWindow{
    id: window 
    width: 520
    height: 500
    minimumWidth: 520  
    minimumHeight: 500  
    visible: true
    title: qsTr("ACS Motion Control Panel")


    // Установка стиля
    Material.theme: Material.Dark
    Material.accent: Material.color(Material.Red)

    // Объявляем переменные и задаём начальные значения
    property int speed: 15
    property int angle: 360
    property int acceleration: 500
    property int deceleration: 100


    // Загружаем изображение
    Image{
        id: image 
        width: 200
        height: 100
        source: "../images/logo.png"  
        anchors{
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            margins: 20 // Отступ от края окна
        }      
    }

    // Вывод параметров привода
    Rectangle {
            id: rectangleVisible
            width: 250
            height: 100
            radius: 10
            color: "#1d2128"
            anchors{
                top: image.bottom
                horizontalCenter: parent.horizontalCenter
                margins: 60 // Отступ от края
            } 
            Label {
                id: labelTextName
                height: 25
                color: "#55aaff"
                text: qsTr("Параметры")
                anchors.top: rectangleVisible.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 2
                font.pointSize: 14
            }
            Text {
                id: textSpeed
                anchors.left: rectangleVisible.left
                anchors.leftMargin: 5
                anchors.top: labelTextName.bottom
                color: "#a9b2c8"
                text: "Скорость: " + speed + " °/с"
                font.pixelSize: 12
            }
            Text {
                id: textAngle
                anchors.top: textSpeed.bottom
                anchors.left: textSpeed.left
                color: "#a9b2c8"
                text: "Угол поворота: " + angle + "°"
                font.pixelSize: 12
            }
            Text {
                id: textAcceleration
                anchors.top: textAngle.bottom
                anchors.left: textAngle.left
                color: "#a9b2c8"
                text: "Максимальное ускорение: " + acceleration + " °/с²" 
                font.pixelSize: 12
            }
            Text {
                id: textDeceleration
                anchors.top: textAcceleration.bottom
                anchors.left: textAcceleration.left
                color: "#a9b2c8"
                text: "Максимальное замедление: " + deceleration + " °/с²" 
                font.pixelSize: 12
            }
        }


    // Ввод скорости 
    TextField{
        id: speedField
        width: 150
        text: qsTr("")
        // Разрешаем ввод только чисел в диапазоне от 0 до 150
        validator: IntValidator {bottom: 1; top: 150;}
        // validator: RegularExpressionValidator { regularExpression: /^[0-9,/]+$/ }
        selectByMouse: true
        placeholderText: qsTr("Скорость, °/сек")
        // placeholderTextColor: "#EE202E"
        verticalAlignment: Text.AlignVCenter        
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: rectangleVisible.bottom
        anchors.topMargin: 30 // Отступ 
    }
    // Ввод угла
    TextField{
        id: angleField
        width: 150
        text: qsTr("")
        validator: IntValidator {bottom: 1; top: 99999999;}
        selectByMouse: true
        placeholderText: qsTr("Угол поворота, °")
        verticalAlignment: Text.AlignVCenter        
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: speedField.bottom
    }
    // Кнопка перезаписи параметров
    Button {
        id: buttonRewrite
        text: qsTr("Перезаписать")
        anchors.top: angleField.bottom
        anchors.left: angleField.left
        anchors.right: angleField.right
        onClicked: {
                    // console.log(speedField.text instanceof int)
                   if(speedField.text > 0)
                        {speed = speedField.text}
                   if(angleField.text > 0)
                        {angle = angleField.text}
                    speedField.text = ""
                    angleField.text = ""}
        }
    // Кнопки управления приводом
    Rectangle {
        id: bottomMenu
        width: 505
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 50
            Button {
            id: buttonInit
            text: qsTr("Инициализация")
            onClicked: backend.initialize()
            }
            Button {
            id: buttonZeroSet
            text: qsTr("Установка нуля")
            anchors.left: buttonInit.right
            anchors.leftMargin: 5
            anchors.top: buttonInit.top
            onClicked: backend.zero_position()
            }
            Button {
            id: buttonRotation
            text: qsTr("Поворот по часовой")
            anchors.left: buttonZeroSet.right
            anchors.leftMargin: 5
            anchors.top: buttonInit.top
            onClicked: backend.rotation(speed, angle)
            }
            Button {
            id: buttonRotationReverse
            text: qsTr("Поворот против часовой")
            anchors.left: buttonRotation.right
            anchors.leftMargin: 5
            anchors.top: buttonInit.top
            onClicked: backend.reverse_rotation(speed, angle)
            }
    }    

    Connections {
        // Соединяемся с main.py
        target: backend
    }    
}
