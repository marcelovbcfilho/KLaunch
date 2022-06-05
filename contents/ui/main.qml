/***************************************************************************
 *   Copyright (C) 2014-2015 by Eike Hein <hein@kde.org>                   *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .        *
 ***************************************************************************/

import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.private.kicker 0.1 as Kicker

Item {
    id: kicker

    property bool isDash: false
    property Item dragSource: null

    signal reset()

    function action_menuedit() {
        processRunner.runMenuEditor();
    }

    function resetDragSource() {
        dragSource = null;
    }

    anchors.fill: parent
    Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation
    Plasmoid.compactRepresentation: null
    Plasmoid.fullRepresentation: compactRepresentation
    Component.onCompleted: {
        plasmoid.setAction("menuedit", i18n("Edit Applications..."));
        rootModel.refreshed.connect(reset);
        dragHelper.dropped.connect(resetDragSource);
    }

    Component {
        id: compactRepresentation

        CompactRepresentation {
        }

    }

    Component {
        id: menuRepresentation

        MenuRepresentation {
        }

    }

    Kicker.RootModel {
        id: rootModel

        autoPopulate: false
        appNameFormat: plasmoid.configuration.appNameFormat
        flat: true
        sorted: true
        showSeparators: false
        appletInterface: plasmoid
        paginate: true
        showAllApps: true
        showRecentApps: false
        showRecentDocs: false
        showRecentContacts: false
        showPowerSession: false
        Component.onCompleted: {
            rootModel.refresh();
        }
    }

    Connections {
        function onHiddenApplicationsChanged() {
            // Force refresh on hidden
            rootModel.refresh();
        }

        target: plasmoid.configuration
    }

    Kicker.RunnerModel {
        id: runnerModel

        runners: {
            var runners = ["services", "krunner_systemsettings"];
            if (plasmoid.configuration.useExtraRunners)
                runners = runners.concat(plasmoid.configuration.extraRunners);

            return runners;
        }
        appletInterface: plasmoid
        deleteWhenEmpty: false
    }

    Kicker.DragHelper {
        id: dragHelper
    }

    Kicker.ProcessRunner {
        id: processRunner
    }

    PlasmaCore.FrameSvgItem {
        id: highlightItemSvg

        visible: false
        imagePath: "widgets/viewitem"
        prefix: "hover"
    }

    PlasmaCore.FrameSvgItem {
        id: panelSvg

        visible: false
        imagePath: "widgets/panel-background"
    }

    PlasmaComponents.Label {
        id: toolTipDelegate

        property Item toolTip

        width: contentWidth
        height: contentHeight
        text: (toolTip != null) ? toolTip.text : ""
    }

    PlasmaCore.DataSource {
        id: pmEngine

        function performOperation(what) {
            var service = serviceForSource("PowerDevil");
            var operation = service.operationDescription(what);
            service.startOperationCall(operation);
        }

        engine: "powermanagement"
        connectedSources: ["PowerDevil", "Sleep States"]
    }

}