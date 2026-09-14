/*
 *  SPDX-FileCopyrightText: 2026 iyhome
 *  SPDX-License-Identifier: AGPL-3.0-or-later
 */

import QtQuick
import QtQuick.Controls as QQC2
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.extras as PlasmaExtras
import org.kde.kirigami as Kirigami

import "functions" as Functions
import "code/tools.js" as Tools
import "code/pinyin.js" as Pinyin

// Flat All Programs list grouped by the first character of every entry, with a
// Windows 10 style letter header in front of each group.
FocusScope {
    id: view

    property var sourceModel: null
    property int iconSize: 32
    property int cellHeight: 44

    signal exitTop()
    signal exitBottom()
    signal exitLeft()

    property alias count: listView.count
    property alias currentIndex: listView.currentIndex
    readonly property alias listView: listView

    property var actionOwner: null

    ListModel {
        id: groupedModel
        dynamicRoles: true
    }

    Functions.ModelRoles {
        id: reader
        sourceModel: view.sourceModel
    }

    Connections {
        target: reader
        function onCountChanged() { Qt.callLater(view.rebuild); }
    }

    onSourceModelChanged: Qt.callLater(rebuild)
    Component.onCompleted: Qt.callLater(rebuild)

    // Latin letters use themselves, Han characters use their pinyin initial,
    // anything else shares "#".
    function sectionOf(text) {
        return Pinyin.initialOf(text);
    }

    // A-Z first, then "#", so every section stays contiguous in the ListView.
    function sectionKey(section) {
        return /^[A-Z]$/.test(section) ? section.charCodeAt(0) - 65 : 26;
    }

    function rebuild() {
        groupedModel.clear();
        if (!view.sourceModel) return;

        var rows = [];
        for (var i = 0; i < view.sourceModel.count; i++) {
            var entry = reader.row(i);
            if (!entry) continue;

            var display = entry.roleDisplay;
            if (!display) continue;

            var decoration = entry.roleDecoration;
            if (typeof decoration === "object" && decoration !== null) decoration = "";

            rows.push({
                "section": sectionOf(display),
                "sourceIndex": i,
                "display": display,
                "decoration": decoration || "",
                "favoriteId": entry.roleFavoriteId || "",
                "actionList": entry.roleActionList || []
            });
        }

        rows.sort(function (a, b) {
            const ka = sectionKey(a.section);
            const kb = sectionKey(b.section);
            if (ka !== kb) return ka - kb;
            return a.sourceIndex - b.sourceIndex;
        });

        for (var j = 0; j < rows.length; j++) groupedModel.append(rows[j]);
    }

    function focusFirst() {
        if (listView.count > 0) listView.currentIndex = 0;
        listView.forceActiveFocus();
    }

    function activateCurrent() {
        const item = groupedModel.get(listView.currentIndex);
        if (item) trigger(item.sourceIndex);
    }

    function trigger(sourceIndex) {
        if (view.sourceModel && typeof view.sourceModel.trigger === "function") {
            view.sourceModel.trigger(sourceIndex, "", null);
        }
        kicker.expanded = false;
    }

    function openActionMenuFor(item, x, y) {
        const actions = item && item.actionList ? item.actionList : [];
        const favorites = view.sourceModel ? view.sourceModel.favoritesModel : null;
        Tools.fillActionMenu(i18n, sharedActionMenu, actions, favorites, item ? item.favoriteId : "");
        if (!sharedActionMenu.actionList || sharedActionMenu.actionList.length === 0) return;
        sharedActionMenu.visualParent = item;
        sharedActionMenu.open(x, y);
    }

    ActionMenu {
        id: sharedActionMenu
        onActionClicked: (actionId, actionArgument) => {
            if (view.actionOwner) {
                Tools.triggerAction(view.sourceModel, view.actionOwner.sourceIndex, actionId, actionArgument);
            }
        }
    }

    QQC2.ScrollView {
        id: scrollView
        anchors.fill: parent

        ListView {
            id: listView
            clip: true
            focus: true
            currentIndex: -1
            keyNavigationEnabled: false
            highlightFollowsCurrentItem: false
            boundsBehavior: Flickable.StopAtBounds
            model: groupedModel

            section.property: "section"
            section.criteria: ViewSection.FullString
            section.delegate: PlasmaExtras.ListSectionHeader {
                required property string section
                width: listView.width
                label: section
            }

            delegate: Item {
                id: appItem

                required property int index
                required property int sourceIndex
                required property string display
                required property var decoration
                required property string favoriteId
                required property var actionList

                readonly property bool isCurrent: listView.currentIndex === appItem.index

                width: listView.width
                height: view.cellHeight

                PlasmaExtras.Highlight {
                    anchors.fill: parent
                    hovered: mouseArea.containsMouse || appItem.isCurrent
                    pressed: mouseArea.containsPress
                    visible: hovered || pressed
                }

                Kirigami.Icon {
                    id: appIcon
                    anchors.left: parent.left
                    anchors.leftMargin: Kirigami.Units.smallSpacing * 2
                    anchors.verticalCenter: parent.verticalCenter
                    width: view.iconSize
                    height: width
                    animated: false
                    source: appItem.decoration
                }

                PlasmaComponents3.Label {
                    anchors.left: appIcon.right
                    anchors.right: parent.right
                    anchors.leftMargin: Kirigami.Units.smallSpacing * 2
                    anchors.rightMargin: Kirigami.Units.smallSpacing * 2
                    anchors.verticalCenter: parent.verticalCenter
                    text: appItem.display
                    elide: Text.ElideRight
                    maximumLineCount: 1
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onEntered: listView.currentIndex = appItem.index
                    onClicked: mouse => {
                        if (mouse.button === Qt.LeftButton) {
                            view.trigger(appItem.sourceIndex);
                        } else {
                            listView.currentIndex = appItem.index;
                            view.actionOwner = appItem;
                            view.openActionMenuFor(appItem, mouse.x, mouse.y);
                        }
                    }
                }
            }

            Keys.onUpPressed: event => {
                event.accepted = true;
                if (listView.currentIndex <= 0) {
                    view.exitTop();
                } else {
                    listView.decrementCurrentIndex();
                    listView.positionViewAtIndex(listView.currentIndex, ListView.Contain);
                }
            }
            Keys.onDownPressed: event => {
                event.accepted = true;
                if (listView.currentIndex >= listView.count - 1) {
                    view.exitBottom();
                } else {
                    listView.incrementCurrentIndex();
                    listView.positionViewAtIndex(listView.currentIndex, ListView.Contain);
                }
            }
            Keys.onLeftPressed: event => { event.accepted = true; view.exitLeft(); }
            Keys.onReturnPressed: event => { event.accepted = true; view.activateCurrent(); }
            Keys.onEnterPressed: event => { event.accepted = true; view.activateCurrent(); }
        }
    }
}
