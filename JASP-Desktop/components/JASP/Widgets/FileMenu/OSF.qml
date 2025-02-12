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

import QtQuick 2.0
import QtQuick.Controls 2.2
import JASP.Theme 1.0
import JASP.Widgets 1.0

//import JASP.Controls    1.0
//import QtQuick.Layouts  1.3

Item
{
	id	: rect

	property bool loggedin			: fileMenuModel.osf.loggedin
	property bool processing		: fileMenuModel.osf.processing
	property bool showfiledialog	: fileMenuModel.osf.showfiledialog

	MouseArea
	{
		z:				-5
		anchors.fill:	parent
		onClicked:		rect.forceActiveFocus()
	}

	MenuHeader
	{
		id				: menuHeader
		headertext		: qsTr("Open Science Framework")
		toolseparator	: !loggedin
	}

	RectangularButton
	{
		id					: logoutButton
		text				: qsTr("Logout")
		visible				: loggedin

		anchors.right		: parent.right
		anchors.top			: parent.top
		anchors.rightMargin	: Theme.generalMenuMargin
		anchors.topMargin	: Theme.generalMenuMargin

		onClicked			: fileMenuModel.osf.logoutClicked()
		KeyNavigation.tab	: newDirectoryButton

	}

	BreadCrumbs
	{
		id		: osfbreadcrumbs
		model	: fileMenuModel.osf.breadCrumbs
		visible	: loggedin

		height	: loggedin ? implicitHeight : 0

		anchors
		{
			top			: menuHeader.bottom
			left		: menuHeader.left
			right		: sortMenuButton.left
			rightMargin	: 4 * preferencesModel.uiScale
		}

		onCrumbButtonClicked: fileMenuModel.osf.breadCrumbs.indexChanged(modelIndex);

		MouseArea
		{
			z:				-5
			anchors.fill:	parent
			onClicked:		osfbreadcrumbs.forceActiveFocus()
		}

	}

	SortMenuButton
	{
		id: sortMenuButton
		anchors
		{
			right:			menuHeader.right
			verticalCenter:	osfbreadcrumbs.verticalCenter
		}
		visible:		loggedin  && !fileExportDialog.visible
		sortMenuModel:	fileMenuModel.osf.sortedMenuModel
	}

	ToolSeparator
	{
		id			: firstSeparator
		visible		: loggedin
		orientation	: Qt.Horizontal

		anchors.top		: osfbreadcrumbs.bottom
		anchors.left	: menuHeader.left
		anchors.right	: menuHeader.right
	}



	/////////////////////////// File dialog to save in OSF ////////////////////////////////////

	RectangularButton
	{
		id		: newDirectoryButton
		text	: qsTr("Create Folder")

		width	: 120 * preferencesModel.uiScale
		height	: 30  * preferencesModel.uiScale
		visible	: fileExportDialog.visible && loggedin

		// Icons made by "https://www.flaticon.com/authors/smashicons"

		anchors.right		: menuHeader.right
		anchors.top			: firstSeparator.bottom
		anchors.topMargin	: Theme.generalAnchorMargin
		onClicked			: { newDirectoryButton.visible = false; foldernameText.focus = true; }
		KeyNavigation.tab	: foldernameText
	}

	Item
	{
		id		: folderExportDialog
		visible	: !newDirectoryButton.visible && showfiledialog && loggedin && !processing
		height	: visible ? newDirectoryButton.height : 0

		anchors.left		: menuHeader.left
		anchors.right		: menuHeader.right
		anchors.top			: firstSeparator.bottom
		anchors.topMargin	: Theme.generalMenuMargin

		Label
		{
			id 		: saveFoldernameLabel
			text	: qsTr("Foldername")

			width	: 80 * preferencesModel.uiScale
			height	: 30 * preferencesModel.uiScale
			color 	: Theme.black
			font	: Theme.font

			anchors.top			: parent.top
			anchors.left		: parent.left
			anchors.rightMargin	: Theme.generalAnchorMargin
			verticalAlignment	: Text.AlignVCenter
		}

		Rectangle
		{
			id		: saveFoldernameInput
			height	: saveFoldernameLabel.height
			clip	: true

			color			: Theme.white
			border.width	: foldernameText.activeFocus ? 5 : 1
			border.color	: foldernameText.activeFocus ? Theme.focusBorderColor : Theme.grayDarker

			anchors
			{
				left		: saveFoldernameLabel.right
				leftMargin	: Theme.generalAnchorMargin
				top			: saveFoldernameLabel.top
				right		: saveFoldernameButton.left
				rightMargin	: Theme.generalAnchorMargin
			}

			TextInput
			{
				id				: foldernameText
				selectByMouse	: true
				text			: fileMenuModel.osf.savefoldername
				font			: Theme.fontRibbon

				anchors.fill		: parent
				anchors.leftMargin	: Theme.itemPadding
				anchors.rightMargin	: Theme.itemPadding
				verticalAlignment	: Text.AlignVCenter

				onAccepted			: saveFoldernameButton.clicked()
				KeyNavigation.tab	: saveFoldernameButton
			}
		}

		RectangularButton
		{
			id		: saveFoldernameButton
			width	: 30 * preferencesModel.uiScale
			height	: 30 * preferencesModel.uiScale
			iconSource	: "qrc:///icons/create-folder.png"

			enabled : foldernameText.text.length > 0

			anchors.top			: parent.top
			anchors.right		: cancelCreateFolderButton.left
			anchors.rightMargin : Theme.generalAnchorMargin
			KeyNavigation.tab	: cancelCreateFolderButton
			onClicked			:
			{
				fileMenuModel.osf.saveFolder(foldernameText.text)
				newDirectoryButton.visible	= true
				filenameText.focus			= true
			}
		}

		RectangularButton
		{
			id					: cancelCreateFolderButton
			width				: 30 * preferencesModel.uiScale
			height				: 30 * preferencesModel.uiScale
			iconSource			: "qrc:/images/close-button.png"
			anchors.top			: parent.top
			anchors.right		: parent.right
			KeyNavigation.tab	: filenameText

			onClicked	:
			{
				foldernameText.clear()
				newDirectoryButton.visible  = true;
				filenameText.focus			= true
			}
		}
	}

	Item
	{
		id		: fileExportDialog
		visible	: showfiledialog && loggedin
		height	: visible ? 30 * preferencesModel.uiScale : 0

		anchors.left			: menuHeader.left
		anchors.right			: menuHeader.right
		anchors.top				: newDirectoryButton.visible ? newDirectoryButton.bottom : folderExportDialog.bottom
		anchors.topMargin		: Theme.generalMenuMargin
		anchors.bottomMargin	: Theme.generalMenuMargin

		Label
		{
			id 		: saveFilenameLabel
			text	: qsTr("Filename")

			width	: 80 * preferencesModel.uiScale
			height	: 30 * preferencesModel.uiScale
			color 	: Theme.black
			font	: Theme.font

			anchors.top			: parent.top
			anchors.left		: parent.left
			verticalAlignment	: Text.AlignVCenter
		}

		Rectangle
		{
			id		: saveFilenameInput
			height	: saveFilenameLabel.height
			clip	: true

			color			: Theme.white
			border.width	: filenameText.activeFocus ? 5 : 1
			border.color	: filenameText.activeFocus ? Theme.focusBorderColor : Theme.grayDarker

			anchors
			{
				left		: saveFilenameLabel.right
				leftMargin	: Theme.generalAnchorMargin
				top			: saveFilenameLabel.top
				right		: saveFilenameButton.left
				rightMargin	: Theme.generalAnchorMargin
			}

			TextInput
			{
				id				: filenameText
				selectByMouse	: true
				text			: fileMenuModel.osf.savefilename
				font			: Theme.fontRibbon

				anchors.fill		: parent
				anchors.leftMargin	: Theme.itemPadding
				verticalAlignment	: Text.AlignVCenter
				KeyNavigation.tab	: saveFilenameButton

				onAccepted	:
				{
					fileMenuModel.osf.saveFile(filenameText.text)
				}
			}
		}

		RectangularButton
		{
			id					: saveFilenameButton
			width				: saveFoldernameButton.width + cancelCreateFolderButton.width + Theme.generalAnchorMargin
			height				: 30 * preferencesModel.uiScale
			text				: qsTr("Save")
			enabled				: filenameText.text.length > 0
			anchors.right		: parent.right
			anchors.top			: parent.top
			KeyNavigation.tab	: osfList

			onClicked	:
			{
				fileMenuModel.osf.saveFile(filenameText.text)
			}
		}
	}


	Item
	{
		visible	: processing
		width	: animation.width;
		height	: animation.height + 8 * preferencesModel.uiScale

		anchors.horizontalCenter	: osfList.horizontalCenter
		anchors.verticalCenter		: osfList.verticalCenter

		AnimatedImage
		{
			id		: animation
			source	: "qrc:/icons/loading.gif"
		}
	}

	FileList
	{
		id					: osfList
		visible				: loggedin && !processing
		focus				: visible
		cppModel			: fileMenuModel.osf.listModel
		breadCrumbs			: osfbreadcrumbs
		KeyNavigation.tab	: logoutButton

		anchors
		{
			top				: fileExportDialog.visible ? fileExportDialog.bottom :  firstSeparator.bottom
			bottom			: parent.bottom
			left			: menuHeader.left
			right			: menuHeader.right
			topMargin		: Theme.generalMenuMargin
			bottomMargin	: Theme.generalMenuMargin
		}
	}


	OSFLogin
	{
		id:			osfLogin
		visible:	!loggedin && !processing
		focus:		visible

		anchors.horizontalCenter	: parent.horizontalCenter
		anchors.top					: firstSeparator.bottom
		anchors.topMargin			: 40 * preferencesModel.uiScale
	}
}
