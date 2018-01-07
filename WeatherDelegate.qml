import QtQuick 2.2

Rectangle {
    id: weather_delegate
    width: 800
    height: 150
    color: "green"
    Text {
        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }
        font.pixelSize: 18
        textFormat: Text.RichText
        text: modelData
        font.bold: true
        color: "white"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            //Delete
            console.log(modelData)
        }
    }

}
