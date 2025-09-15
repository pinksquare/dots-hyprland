import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import "./weather"
import qs.services

Item {
    id: root
    implicitWidth: gridLayout.implicitWidth
    implicitHeight: gridLayout.implicitHeight
    property bool vertical: false
    property bool invertSide: false
    property bool trayOverflowOpen: false

    property list<var> itemsInUserList: SystemTray.items.values.filter(i => Config.options.bar.tray.pinnedItems.includes(i.id))
    property list<var> itemsNotInUserList: SystemTray.items.values.filter(i => !Config.options.bar.tray.pinnedItems.includes(i.id))
    property bool invertPins: Config.options.bar.tray.invertPinnedItems
    property list<var> pinnedItems: invertPins ? itemsNotInUserList : itemsInUserList
    property list<var> unpinnedItems: invertPins ? itemsInUserList : itemsNotInUserList
    onUnpinnedItemsChanged: if (unpinnedItems.length == 0) root.trayOverflowOpen = false;

    GridLayout {
        id: gridLayout
        columns: root.vertical ? 1 : -1
        anchors.fill: parent
        rowSpacing: 6
        columnSpacing: 15

                    Repeater {
                        model: root.unpinnedItems

                        delegate: SysTrayItem {
                            required property SystemTrayItem modelData
                            item: modelData
                            Layout.fillHeight: !root.vertical
                            Layout.fillWidth: root.vertical
                        }
                    }
                }
            }
        }

        Repeater {
            model: ScriptModel {
                values: root.pinnedItems
            }

            delegate: SysTrayItem {
                required property SystemTrayItem modelData
                item: modelData
                Layout.fillHeight: !root.vertical
                Layout.fillWidth: root.vertical
            }

        }

      Loader {
        Layout.alignment: Qt.AlignVCenter
                            active: HyprlandXkb.layoutCodes.length > 1
                            visible: active
                            //Layout.rightMargin: indicatorsRowLayout.realSpacing
                            sourceComponent: StyledText {
                                text: HyprlandXkb.currentLayoutCode
                                font.pixelSize: Appearance.font.pixelSize.larger
                                color: rightSidebarButton.colText
                                //verticalAlignment: Text.AlignVCenter 
                            }
                          }

                    Loader {
                    //Layout.leftMargin: 5
                    //Layout.fillWidth: true
                    active: Config.options.bar.weather.enable
                    sourceComponent: WeatherBar {}
                    }


        StyledText {
            Layout.leftMargin: -180          
            //Layout.alignment: Qt.AlignHCenter
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
            font.pixelSize: Appearance.font.pixelSize.larger
            color: Appearance.colors.colSubtext
            text: "•"
            visible: {
                SystemTray.items.values.length > 0
            }
        }

    }

}
