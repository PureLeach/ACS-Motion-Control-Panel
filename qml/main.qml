import QtQuick 6
import QtQuick.Window 2.15
import QtQuick.Controls 6
import QtQuick.Controls.Material 2.15

ApplicationWindow{
    id: window 
    width: 720
    height: 600
    minimumWidth: 720  
    minimumHeight: 600  
    visible: true
    title: qsTr("ACS Motion Control Panel")


    // Установка стиля
    Material.theme: Material.Dark
    Material.accent: Material.color(Material.Red)

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

    // Поле ввода скорости 
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
        anchors.top: image.bottom
        anchors.topMargin: 10 // Отступ от края изображения
    }

    // Поле ввода угла
    TextField{
        id: angleField
        width: 150
        text: qsTr("")
        validator: IntValidator {bottom: 1; top: 99999999;}
        selectByMouse: true
        placeholderText: qsTr("Угол поворота, °")
        // placeholderTextColor: "#EE202E"
        verticalAlignment: Text.AlignVCenter        
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: speedField.bottom
    }

    Button {
        id: buttonRewrite
        text: qsTr("Перезаписать")
        anchors.top: angleField.bottom
        anchors.left: angleField.left
        anchors.right: angleField.right
        // anchors.horizontalCenter: angleField.horizontalCenter
        onClicked: {console.log(speedField.text, angleField.text)
                    speedField.text = ""
                    angleField.text = ""}
        }

    Rectangle {
        id: bottomMenu
        width: 530
        // height: 600 
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 50

        Button {
        id: buttonInit
        text: qsTr("Инициализация")
        
        
        // Material.foreground: Material.Red
        // anchors.top: angleField.bottom
        // anchors.topMargin: 50 
        // anchors.leftMargin: 10 
        // anchors.left: parent.right
        onClicked: backend.initialize()
        // onClicked: backend.checkLogin(usernameField.text, passwordField.text)
        }

        Button {
        id: buttonZeroSet
        text: qsTr("Установка нуля")
        // Material.foreground: Material.Red
        anchors.left: buttonInit.right
        anchors.leftMargin: 5
        anchors.top: buttonInit.top
        onClicked: backend.zero_position()
        // anchors.horizontalCenter: parent.horizontalCenter
        
        // anchors.horizontalCenter: buttonInit.baseline
        // anchors.topMargin: 50 
        // anchors.horizontalCenter: parent.horizontalCenter
        // onClicked: backend.checkLogin(usernameField.text, passwordField.text)
        }

        Button {
        id: buttonRotation
        text: qsTr("Поворот по часовой")
        // Material.foreground: Material.Red
        anchors.left: buttonZeroSet.right
        anchors.leftMargin: 5
        anchors.top: buttonInit.top
        onClicked: backend.rotation(123, 456)
        // anchors.horizontalCenter: buttonInit.baseline
        // anchors.topMargin: 50 
        // anchors.horizontalCenter: parent.horizontalCenter
        // onClicked: backend.checkLogin(usernameField.text, passwordField.text)
        }

        Button {
        id: buttonRotationReverse
        text: qsTr("Поворот против часовой")
        anchors.left: buttonRotation.right
        anchors.leftMargin: 5
        anchors.top: buttonInit.top
        onClicked: backend.reverse_rotation(123, 456)
        }
    }    


    
    Connections {
        // Соединяемся с main.py
        target: backend

    }    
}
