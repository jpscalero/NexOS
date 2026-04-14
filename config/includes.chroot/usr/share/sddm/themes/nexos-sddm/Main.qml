import QtQuick 2.0
import SddmComponents 2.0

Rectangle {
    width: 640
    height: 480

    LayoutMirroring.enabled: Qt.locale().textDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    TextConstants { id: textConstants }

    Connections {
        target: sddm
        onLoginSucceeded: {
        }
        onLoginFailed: {
            password.text = ""
        }
    }

    Background {
        anchors.fill: parent
        source: config.background
        fillMode: Image.PreserveAspectCrop
        onStatusChanged: {
            if (status == Image.Error && source == config.background) {
                source = "background.png"
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 0.4
    }

    Column {
        anchors.centerIn: parent
        spacing: 20

        Image {
            id: logo
            width: 128
            height: 128
            source: config.logo
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectFit
        }

        Text {
            text: "NexOS Vanguard"
            color: "white"
            font.pixelSize: 24
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Rectangle {
            width: 300
            height: 150
            color: "transparent"
            anchors.horizontalCenter: parent.horizontalCenter

            Column {
                anchors.fill: parent
                spacing: 12

                TextBox {
                    id: name
                    width: parent.width
                    text: userModel.lastUser
                    font.pixelSize: 14
                    anchors.horizontalCenter: parent.horizontalCenter
                    KeyNavigation.backtab: loginButton; KeyNavigation.tab: password
                }

                PasswordBox {
                    id: password
                    width: parent.width
                    font.pixelSize: 14
                    anchors.horizontalCenter: parent.horizontalCenter
                    KeyNavigation.backtab: name; KeyNavigation.tab: loginButton

                    Keys.onPressed: {
                        if (event.key == Qt.Key_Return || event.key == Qt.Key_Enter) {
                            sddm.login(name.text, password.text, sessionIndex)
                            event.accepted = true
                        }
                    }
                }

                Button {
                    id: loginButton
                    text: textConstants.login
                    width: parent.width
                    height: 40
                    color: "#1dc1d1"
                    activeColor: "#17a2b8"
                    font.pixelSize: 14
                    anchors.horizontalCenter: parent.horizontalCenter

                    onClicked: sddm.login(name.text, password.text, sessionIndex)
                    KeyNavigation.backtab: password; KeyNavigation.tab: name
                }
            }
        }
    }
}
