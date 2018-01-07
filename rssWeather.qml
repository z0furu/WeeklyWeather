import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.XmlListModel 2.0
import QtQuick.LocalStorage 2.0
Window {
    visible: true
    width: 800
    height: 480
    property alias list: list
    property bool isPortrait: Screen.primaryOrientation === Qt.PortraitOrientation
    title: qsTr("台中市一週氣象預報")
    Component.onCompleted: {
          init();
    }

    //Weather ListView
    ListView {
        id: list
        flickDeceleration: 1494
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
            deleteAllDB();
            var list_weather = getSubDescription(weather_xml_list_model);
            for(var i = 0; i < list_weather.length -1 ; i++) {
                insertDB(i, list_weather[i])
            }

            list.model = getAllWeather()
        }
    }

    function getSubDescription(x) {
        var des = x.get(1).description;
        var subDes = des.split("<BR>");
        return subDes;
    }



    //取得DB
    //參考 http://doc.qt.io/qt-5.6/qtquick-localstorage-qmlmodule.html
    function getDB() {
        return LocalStorage.openDatabaseSync("WeatherList", "1.0", "The Example QML SQL!", 1000000);
    }

    //初始化
    function init() {
        var db = getDB();
        db.transaction(
            function(tx) {
                // Create the database if it doesn't already exist
                tx.executeSql('CREATE TABLE IF NOT EXISTS WeekWeather (uid TEXT UNIQUE, content TEXT)');
            }
        )
    }

    //新增
    function insertDB(uid, content) {
        var db = getDB();
        db.transaction(
            function(tx) {
                //Insert or Replace
                var a = tx.executeSql('INSERT OR REPLACE INTO WeekWeather VALUES(?, ?)', [ uid, content ]);
                if (a.rowsAffected > 0) {
                    console.log("OK")
                } else {
                    console.log("Error")
                }
            }
        )
    }

    //刪除
    function deleteDB(content) {
        var db = getDB();
        db.transaction(
            function(tx) {
                //Delete
                tx.executeSql('DELETE FROM WeekWeather WHERE content=?;', content);
            }
        )
    }

    //取得全部列表
    function getAllWeather() {
        var db = getDB();
        var  res= "" ;
         db.transaction( function (tx) {
             var  rs = tx.executeSql( 'SELECT * FROM WeekWeather ');
             var data = [];
             for(var i = 0; i < rs.rows.length; i++) {
                       console.log(rs.rows.item(i).content)
                    data.push(rs.rows.item(i).content);
                }
                res = data;
            })
        return  res
    }

    //刪除所有DB
    function deleteAllDB() {
       var db = getDB();

       db.transaction( function (tx) {
            var  rs = tx.executeSql( 'DELETE FROM WeekWeather');
      })
    }



}
