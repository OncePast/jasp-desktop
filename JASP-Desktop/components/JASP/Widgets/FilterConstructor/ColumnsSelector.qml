import QtQuick 2.0

Rectangle
{
	color: Theme.white

	z: 2

	ListView
	{
		id:				listOfColumns
		orientation:	ListView.Horizontal
		anchors.fill:	parent
		boundsBehavior:	Flickable.StopAtBounds


		model: ListModel
		{
			ListElement { name: "dummyNominalText";	type: "qrc:/icons/variable-nominal-text.svg";	}
			ListElement { name: "dummyNominal";		type: "qrc:/icons/variable-nominal.svg";		}
			ListElement { name: "dummyOrdinal";		type: "qrc:/icons/variable-ordinal.svg";		}
			ListElement { name: "dummyScale";		type: "qrc:/icons/variable-scale.svg";			}
		}

		delegate: MouseArea
		{
			width: col.width
			height: col.height

			ColumnDrag {  id: col; columnName: name; columnIcon: type; alternativeDropFunction: createFunc }

			onDoubleClicked: createFunc()

			property var createFunc: function () { return columnComp.createObject(scriptColumn, { "columnName": name, "columnIcon": type, "alternativeDropFunction": null } ) }

			Component {	id: columnComp;	ColumnDrag { }	}
		}
	}
}
