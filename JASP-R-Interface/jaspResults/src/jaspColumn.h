#ifndef _JASPCOLUMN_HEADER
#define _JASPCOLUMN_HEADER

#include "jaspObject.h"

class jaspColumn : public jaspObject
{
public:
	jaspColumn(std::string columnName="") : jaspObject(jaspObjectType::column, "jaspColumn for " + columnName), _columnName(columnName) {  }


	Json::Value		convertToJSON()								override;
	void			convertFromJSON_SetFields(Json::Value in)	override;
	std::string		dataToString(std::string prefix)			override;

	Json::Value	metaEntry() override { return constructMetaEntry("column"); }
	Json::Value	dataEntry() override;


	void setScale(		Rcpp::RObject scalarData);
	void setOrdinal(	Rcpp::RObject ordinalData);
	void setNominal(	Rcpp::RObject nominalData);
	void setNominalText(Rcpp::RObject nominalData);

private:
	std::string		_columnName = "";
	bool			_changed	= false;
	jaspColumnType	_columnType	= jaspColumnType::unknown;
};



class jaspColumn_Interface : public jaspObject_Interface
{
public:
	jaspColumn_Interface(jaspObject * dataObj) : jaspObject_Interface(dataObj) {}

	void setScale(		Rcpp::RObject scalarData)	{ static_cast<jaspColumn*>(myJaspObject)->setScale(scalarData);			}
	void setOrdinal(	Rcpp::RObject ordinalData)	{ static_cast<jaspColumn*>(myJaspObject)->setOrdinal(ordinalData);		}
	void setNominal(	Rcpp::RObject nominalData)	{ static_cast<jaspColumn*>(myJaspObject)->setNominal(nominalData);		}
	void setNominalText(Rcpp::RObject nominalData)	{ static_cast<jaspColumn*>(myJaspObject)->setNominalText(nominalData);	}
};

RCPP_EXPOSED_CLASS_NODECL(jaspColumn_Interface)
#endif
