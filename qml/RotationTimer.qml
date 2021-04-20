import QtQuick 6



Item {
    height: textTimer.height
    width: textTimer.width

    // Вывод таймера
    Text {
        id: textTimer
        renderType: Text.NativeRendering
        text: "Время вращения: " + Math.round(rotation_time)
        color: "#ff033e" 
        }

    // Настройка таймера
    Timer {
        interval: 1000 // Обновление раз в секунду (1000 мс)
        repeat: true     
        running: timerFlag // Флаг включение/отключения
        // Действия при срабатывании таймера
        onTriggered: {
            if (rotation_time > 1)      
                rotation_time--
            else if (rotation_time <= 1)
                {rotation_time = 0;
                timerFlag = false;}
        }
    }
}








