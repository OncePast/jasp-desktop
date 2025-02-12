#ifndef IMPORTER_H
#define IMPORTER_H

#include "dataset.h"
#include <boost/function.hpp>
#include "../datasetpackage.h"
#include "importdataset.h"

class ImportDataSet;
class ImportColumn;

class Importer
{
public:
	Importer(DataSetPackage *packageData);
	virtual ~Importer();
	void loadDataSet(const std::string &locator, boost::function<void (const std::string &, int)> progressCallback);
	void syncDataSet(const std::string &locator, boost::function<void (const std::string &, int)> progressCallback);

protected:
	virtual ImportDataSet* loadFile(const std::string &locator, boost::function<void(const std::string &, int)> progressCallback) = 0;
	virtual void fillSharedMemoryColumn(ImportColumn *importColumn, Column &column) = 0;

	void fillSharedMemoryColumnWithStrings(const std::vector<std::string> &values, Column &column);

	DataSetPackage *_packageData;

private:
	DataSet* setDataSetSize(int columnCount, int rowCount);
	DataSet* setDataSetRowCount(int rowCount)				{ return setDataSetSize(_packageData->dataSet()->columnCount(),		rowCount); }
	DataSet* increaseDataSetColCount(int rowCount)			{ return setDataSetSize(_packageData->dataSet()->columnCount() + 1, rowCount); }

	void _syncPackage(
			ImportDataSet *syncDataSet,
			std::vector<std::pair<std::string, int> >	& newColumns,
			std::vector<std::pair<int, Column *> >		& changedColumns,
			std::map<std::string, Column *>				& missingColumns,
			std::map<std::string, Column *>				& changeNameColumns,
			bool rowCountChanged);

	void initColumn(int colNo,				ImportColumn * importColumn);
	void initColumn(std::string colName,	ImportColumn * importColumn);
};

#endif // IMPORTER_H
