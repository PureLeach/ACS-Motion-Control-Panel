import QtQuick 6
import QtQuick.Window 2.15
import QtQuick.Controls 6
import QtQuick.Controls.Material 2.15

ApplicationWindow{
    id: window 
    width: 500
    height: 400
    visible: true
    title: qsTr("ACS Motion Control Panel")


    // Установка стиля
    Material.theme: Material.Dark
    Material.accent: Material.LightBlue

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

    // Поле ввода
    TextField{
        id: speed_set
        width: 150
        text: qsTr("")
        selectByMouse: true
        placeholderText: qsTr("Скорость °/сек")
        verticalAlignment: Text.AlignVCenter        
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: image.bottom
        anchors.topMargin: 10 // Отступ от края изображения
    }




    
    Connections {
        // Соединяемся с main.py
        target: backend

    }    
}
