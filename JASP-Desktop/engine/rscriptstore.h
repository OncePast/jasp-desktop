#ifndef RSCRIPTSTORE_H
#define RSCRIPTSTORE_H

#include "enginedefinitions.h"
#include "column.h"
#include <QString>

struct RScriptStore
{
	RScriptStore(int requestId, QString script, engineState typeScript = engineState::rCode, bool whiteListedVersion = true)
		: typeScript(typeScript), script(script), requestId(requestId), whiteListedVersion(whiteListedVersion) {}

	engineState typeScript; //should be filter/rcode/etc
	QString		script;
	int			requestId;
	bool		whiteListedVersion;

};

struct RFilterStore : public RScriptStore
{
	RFilterStore(QString generatedfilter, QString filter, int requestID) : RScriptStore(requestID, filter, engineState::filter), generatedfilter(generatedfilter) { }

	QString generatedfilter;
};

struct RComputeColumnStore : public RScriptStore
{
	RComputeColumnStore(QString columnName, QString computeCode, Column::ColumnType columnType) : RScriptStore(-1, computeCode, engineState::computeColumn), columnName(columnName), columnType(columnType)
	{ }

	QString				columnName;
	Column::ColumnType	columnType;
};

#endif // RSCRIPTSTORE_H
