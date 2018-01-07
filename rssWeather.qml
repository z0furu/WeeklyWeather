import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.XmlListModel 2.0
Window {
    visible: true
    width: 800
    height: 480
    property bool isPortrait: Screen.primaryOrientation === Qt.PortraitOrientation
    title: qsTr("台中市一週氣象預報")

    //Weather ListView
    ListView {
        id: list
        anchors.fill: parent
        clip: isPortrait
        spacing: 10
        model: weather_xml_list_model
        delegate: WeatherDelegate {}
    }


    //Downloading XML Data
    XmlListModel {
        id: weather_xml_list_model
        //rss url
        source: "http://www.cwb.gov.tw/rss/forecast/36_08.xml"
        query: "/rss/channel/item"
        XmlRole { name: "description"; query: "description/string()" }

        onStatusChanged: {
            var list_weather = getSubDescription(weather_xml_list_model);
            list.model = list_weather
        }
    }

    function getSubDescription(x) {
        var des = x.get(1).description;
        var subDes = des.split("<BR>");
        return subDes;
    }

}
