import QtQuick 6
import QtQuick.Window 2.15
import QtQuick.Controls 6
import QtQuick.Controls.Material 2.15

ApplicationWindow{
    id: window 
    width: 720
    height: 600
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
            margins: 40 // Отступ от края окна
        }      
    }

    // Поле ввода скорости 
    TextField{
        id: speedField
        width: 150
        text: qsTr("")
        selectByMouse: true
        placeholderText: qsTr("Скорость, °/сек")
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
        selectByMouse: true
        placeholderText: qsTr("Угол поворота, °")
        verticalAlignment: Text.AlignVCenter        
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: speedField.bottom
        anchors.topMargin: 0
    }

        Button {
        id: buttonInit
        text: qsTr("Инициализация")
        // Material.foreground: Material.Red
        anchors.top: angleField.bottom
        anchors.topMargin: 50 
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
        // anchors.horizontalCenter: parent.horizontalCenter
        
        // anchors.horizontalCenter: buttonInit.baseline
        // anchors.topMargin: 50 
        // anchors.horizontalCenter: parent.horizontalCenter
        // onClicked: backend.checkLogin(usernameField.text, passwordField.text)
        }

        Button {
        id: buttonRotation
        text: qsTr("Поворот")
        // Material.foreground: Material.Red
        anchors.left: buttonZeroSet.right
        anchors.leftMargin: 5
        anchors.top: buttonInit.top
        
        // anchors.horizontalCenter: buttonInit.baseline
        // anchors.topMargin: 50 
        // anchors.horizontalCenter: parent.horizontalCenter
        // onClicked: backend.checkLogin(usernameField.text, passwordField.text)
        }


    
    Connections {
        // Соединяемся с main.py
        target: backend

    }    
}
