/***************************************************************************
 *   Copyright (C) 2013 by Aurélien Gâteau <agateau@kde.org>               *
 *   Copyright (C) 2013-2015 by Eike Hein <hein@kde.org>                   *
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

.pragma library

function fillActionMenu(actionMenu, actionList) {
    // Accessing actionList can be a costly operation, so we don't
    // access it until we need the menu.

    var runWithDiscreteGpuAction = {};

    runWithDiscreteGpuAction.text = "Run with discrete gpu";
    runWithDiscreteGpuAction.icon = "emblem-system-symbolic";
    runWithDiscreteGpuAction.actionId = "_run_with_discrete_gpu";

    actionList.unshift(runWithDiscreteGpuAction)

    console.error("AQUIII!!!!!")

    if (actionList && actionList.length > 0) {
        var separator = { "type": "separator" };
        actionList.unshift(separator);
    }

    actionMenu.actionList = actionList;
}

function triggerAction(plasmoid, model, index, actionId, actionArgument) {
    var closeRequested = model.trigger(index, actionId, actionArgument);

    if (actionId !== null && actionId.startsWith("_run_with_discrete_gpu")) {
        Object.keys(model).forEach((prop)=> console.error(prop));
        // console.error(model.data)
        console.error(model.objectName);
        console.error(model.flags);
        console.error(model.trigger);
        console.error(closeRequested);
        console.error(index)
        console.error("RODANDO COM GPU DISCRETA")
        Object.keys(plasmoid).forEach((prop)=> console.error(prop))

        model.trigger(index, "", ["export __GLX_VENDOR_LIBRARY_NAME=nvidia", "export __NV_PRIME_RENDER_OFFLOAD=1"])
    }

    if (closeRequested) {
        plasmoid.expanded = false;

        return true;
    }

    return false;
}
