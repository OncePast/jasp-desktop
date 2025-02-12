//
// Copyright (C) 2013-2018 University of Amsterdam
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public
// License along with this program.  If not, see
// <http://www.gnu.org/licenses/>.
//

import QtQuick			2.11
import QtQuick.Controls	2.4
import JASP.Theme		1.0

JASPControl
{
	id:						radioButton
	controlType:			"RadioButton"
	isBound:				false
	implicitWidth:			childrenOnSameRow
							? control.implicitWidth + (childControlsArea.children.length > 0 ? Theme.columnGroupSpacing + childControlsArea.implicitWidth : 0)
							: Math.max(control.implicitWidth, childControlsArea.childControlsPadding + childControlsArea.implicitWidth)
	implicitHeight:			childrenOnSameRow
							? Math.max(control.implicitHeight, childControlsArea.implicitHeight)
							: control.implicitHeight + (childControlsArea.children.length > 0 ? Theme.rowGroupSpacing + childControlsArea.implicitHeight : 0)
	focusIndicator:			focusIndicator
	childControlsArea:		childControlsArea

	default property alias	content:				childControlsArea.children
	property alias	control:				control

	property alias	childrenArea:			childControlsArea
	property alias	text:					control.text
	property alias	label:					control.text
	property alias	checked:				control.checked
	property alias	value:					radioButton.name
	property var	buttonGroup:			null
	property bool	childrenOnSameRow:		false
	property alias	columns:				childControlsArea.columns
	property bool	enableChildrenOnChecked: true
	property bool	indentChildren:			true
	property alias	alignChildrenTopLeft:	childControlsArea.alignChildrenTopLeft

	function click()
	{
		if (!checked)
		{
			control.toggle();
			control.clicked()
		}
	}

	RadioButton
	{
		id:					control
		ButtonGroup.group:	buttonGroup
		padding:			Theme.jaspControlPadding
		focus:				true

		indicator: Rectangle
		{
			id:				radioIndicator
			width:			height
			height:			Math.floor(Math.round(label.height) / 2) * 2
			x:				control.padding
			y:				control.padding

			radius:			width
			color:			control.checked ? (control.enabled ? Theme.buttonBackgroundColor : Theme.disableControlBackgroundColor) : Theme.controlBackgroundColor
			border.color:	control.enabled ? (control.checked ? Theme.buttonBackgroundColor : Theme.borderColor)					: Theme.disableControlBackgroundColor
			border.width:	1

			Rectangle
			{
				anchors.centerIn:	parent
				width:				Math.round(parent.width / 4) * 2
				height:				width
				radius:				width
				visible:			control.checked
				color:				Theme.controlBackgroundColor
			}
		}

		Rectangle
		{
			id:					focusIndicator
			anchors.centerIn:	radioIndicator
			width:				Math.floor(Math.round(radioIndicator.width + Theme.jaspControlHighlightWidth) / 2) * 2
			height:				Math.floor(Math.round(radioIndicator.height + Theme.jaspControlHighlightWidth) / 2) * 2
			radius:				width
			color:				"transparent"
			border.width:		0

		}

		contentItem: Label
		{
			id:				label
			text:			control.text
			leftPadding:	radioIndicator.width + control.spacing
			font:			Theme.font
			color:			enabled ? Theme.textEnabled : Theme.textDisabled
		}

		background: Rectangle { color: "transparent" }
	}

	GridLayout
	{
		id:				childControlsArea
		anchors
		{
			top:		childrenOnSameRow ? control.top : control.bottom
			topMargin:	childrenOnSameRow ? 0 : Theme.rowGroupSpacing
			left:		childrenOnSameRow ? control.right : control.left
			leftMargin: childrenOnSameRow ? Theme.columnGroupSpacing : (indentChildren ? childControlsArea.childControlsPadding : 0)
		}

		enabled:		enableChildrenOnChecked ? control.checked : true
		visible:		children.length > 0
		columns:		childrenOnSameRow ? children.length : 1
		rowSpacing:		Theme.rowGroupSpacing
		columnSpacing:	Theme.columnGridSpacing

		property int childControlsPadding: childrenOnSameRow ? control.implicitWidth + Theme.columnGroupSpacing : control.padding + radioIndicator.width + control.spacing
	}

	Component.onCompleted:
	{
		if (childControlsArea.children.length > 0)
		{
			if (childrenOnSameRow)
			{
				if (childControlsArea.implicitHeight < control.implicitHeight)
					childControlsArea.anchors.topMargin = control.padding - 1 // border width
			}
		}
	}
}

