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

import QtQuick 2.11
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.12
import JASP.Theme 1.0

FocusScope
{
	id							: menu
	width						: menuRectangle.width
	height						: menuRectangle.height
	visible						: showMe && activeFocus
	x							: Math.min(menuMinPos.x + (menuMinIsMin ? Math.max(0, menuX) : menuX), menuMaxPos.x - (width  + 2) )
	y							: Math.min(menuMinPos.y + (menuMinIsMin ? Math.max(0, menuY) : menuY), menuMaxPos.y - (height + 2) )
	property var	props		: undefined
	property bool	hasIcons	: true
	property real	_iconPad	: 5 * preferencesModel.uiScale
	property int	menuX		: menuOffset.x + menuScroll.x
	property int	menuY		: menuOffset.y + menuScroll.y
	property point	menuOffset	: "0,0"
	property point	menuScroll	: "0,0"
	property point	menuMinPos	: "0,0"
	property point	menuMaxPos	: "0,0"
	property bool	menuMinIsMin: false
	property bool	showMe		: false
	property var    sourceItem  : null

	property point	scrollOri	: "0,0" //Just for other qmls to use as a general storage of the origin of their scrolling

	onPropsChanged:
	{
		hasIcons = (menu.props === undefined || "undefined" === typeof(menu.props["hasIcons"])) ? true : menu.props["hasIcons"]

		if (menu.props === undefined || menu.props["model"] !== resultMenuModel)
			resultsJsInterface.runJavaScript("window.setSelection(false);")
	}

	function toggle(item, props, x_offset, y_offset)
	{
		if (item === menu.sourceItem && menu.visible)
			hide()
		else
		{
			menu.sourceItem     = item;
			menu.menuMaxPos.x	= Qt.binding(function() { return mainWindowRoot.width;  });
			menu.menuMaxPos.y	= Qt.binding(function() { return mainWindowRoot.height; });
			menu.menuMinPos     = item.mapToItem(null, 1, 1);
			menu.props          = props;
			menu.menuOffset.x	= x_offset;
			menu.menuOffset.y	= y_offset;
			menu.menuScroll		= "0,0";
			menu.showMe			= true;
			menu.forceActiveFocus();
		}
	}

	function hide()
	{
		menu.showMe			= false;
		menu.sourceItem     = null;
		menu.props			= undefined;
		menu.menuMinIsMin	= false;
		menu.menuOffset		= "0,0"
		menu.menuScroll		= "0,0"
		menu.menuMinPos		= "0,0"
	}

	function resizeElements(newWidth)
	{
		for (var i = 0; i < repeater.count; ++i)
			repeater.itemAt(i).width = newWidth;
	}

	Rectangle
	{
		id		: menuRectangle
		z		: menuShadow.z + 1
		color	: Theme.fileMenuColorBackground
		focus	: true

		MouseArea
		{
			anchors.fill	: parent
		}

	}

	Column
	{
		id		: column
		x		: menuRectangle.x
		y		: menuRectangle.y + (Theme.menuPadding / 2)
		z		: menuRectangle.z + 1
		spacing	: Theme.menuSpacing

		Repeater
		{
			id		: repeater
			model	: menu.props === undefined ? undefined : menu.props["model"]

			onItemAdded:
			{
				if (index === 0)
				{
					menuRectangle.width  = 0;
					menuRectangle.height = 0;
				}

				menuRectangle.width   = Math.max(item.width, menuRectangle.width);
				menuRectangle.height += (item.height + Theme.menuSpacing)

				if (index === count - 1)
				{
					menuRectangle.height += (Theme.menuPadding - Theme.menuSpacing)
					menu.resizeElements(menuRectangle.width);
				}
			}

			delegate: Loader
			{
				sourceComponent :
				{
					if (model.isSeparator !== undefined && model.isSeparator)			return menuSeparator;
					else if (model.isGroupTitle !== undefined && model.isGroupTitle)	return menuGroupTitle;

					return menuDelegate
				}

				Component
				{
					id: menuDelegate

					Rectangle
					{
						id		: menuItem
						width	: initWidth
						height	: Theme.menuItemHeight
						color	:
						{
							if (!isEnabled)
								return "transparent"
							return mouseArea.pressed ? Theme.buttonColorPressed : mouseArea.containsMouse ? Theme.buttonColorHovered : "transparent"
						}

						property double initWidth: (menu.hasIcons ? menuItemImage.width : 0) + menuItemText.implicitWidth + (menu.hasIcons ? menu._iconPad * 5 : menu._iconPad * 4)
						// 15 = menuItemImage.leftMargin + menuItemText.leftMargin + menuItemText.rightMargin + menuItemImage.smallerBy

						Image
						{
							id		: menuItemImage
							height	: menuItem.height - (2 * menu._iconPad)
							width	: menuItem.height - menu._iconPad

							source					: menuImageSource
							smooth					: true
							mipmap					: true
							fillMode				: Image.PreserveAspectFit

							anchors.left			: parent.left
							anchors.leftMargin		: menu._iconPad * 2
							anchors.verticalCenter	: parent.verticalCenter
						}

						Text
						{
							id					: menuItemText
							text				: displayText
							font				: Theme.font
							color				: isEnabled ? Theme.black : Theme.gray
							anchors
							{
								left			: menu.hasIcons ? menuItemImage.right : parent.left
								leftMargin		: menu.hasIcons ? menu._iconPad : menu._iconPad * 2
								rightMargin		: menu._iconPad * 2
								verticalCenter	: parent.verticalCenter
							}

						}

						MouseArea
						{
							id				: mouseArea
							hoverEnabled	: true
							anchors.fill	: parent
							onClicked		: if (isEnabled) menu.props['functionCall'](index)
						}
					}
				}

				Component
				{
					id: menuGroupTitle

					Item
					{
						id		: menuItem
						width	: initWidth
						height	: Theme.menuGroupTitleHeight

						property double initWidth: menuItemImage.width + menuItemText.implicitWidth + 15 * preferencesModel.uiScale

						Image
						{
							id					: menuItemImage
							height				: parent.height - (menu._iconPad * 2)
							width				: height

							source				: menuImageSource
							smooth				: true
							mipmap				: true
							fillMode			: Image.PreserveAspectFit
							visible				: menuImageSource !== ""

							anchors
							{
								top				: parent.top
								left			: parent.left
								bottom			: parent.bottom
								leftMargin		: visible ? menu._iconPad : 0
							}
						}

						Text
						{
							id					: menuItemText
							text				: displayText
							font				: Theme.fontGroupTitle
							anchors
							{
								left			: menuItemImage.right
								leftMargin		: menu._iconPad
								verticalCenter	: parent.verticalCenter
							}
						}
					}
				}

				Component
				{
					id	: menuSeparator
					ToolSeparator { orientation	: Qt.Horizontal }
				}
			}
		}
	}

	RectangularGlow
	{
		id				: menuShadow
		anchors.fill	: menuRectangle

		color			: Theme.grayDarker
		spread			: 0.2
		cornerRadius	: menuRectangle.radius + glowRadius
		glowRadius		: 5
	}
}
