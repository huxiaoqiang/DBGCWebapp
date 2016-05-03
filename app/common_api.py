errMsg = {
    1 : 'Succeed',
    2 : 'Need POST',
    3 : 'Need GET',
    4 : 'Run matlab error',
    5 : 'File is too big!',
    6 : 'geometry is empty!',
    
    101 : 'Error when reading group template in groupCounter.readGroupTemplate()!',
    102 : 'Error when reading .gjf file in groupCounter.readGjfFile()!' ,
    103 : 'Error when writing DBGC vector in groupCounter.writeDBGCVector()!',
    104 : 'Error when generating .mol file in chem.generateMOLFile()!',
    105 : 'Error when writing data to excel in groupCounter.writeDataToExcel()!',
    106 : 'Error when reading geometry from String in groupCounter.readGjfGeom()!',
    107 : 'Please submit a species with carbon atoms >= 3!',
    108 : 'Sorry! Not an alkane or alkene or their radical! Not supported temporarily!',
    109 : 'Sorry! Structure with rings is not supported temporarily!',

    1000 : 'Unknown Error!',
}

def error(code):
    return {"code":code,"errMsg":errMsg[code]}

class groupTemplateReadError(Exception):
	pass

class readGjfFileError(Exception):
	pass

class writeDBGCVectorError(Exception):
	pass

class molFileGeneratingError(Exception):
	pass

class writeDataToExcelError(Exception):
	pass

class readGjfGeomError(Exception):
	pass

class carbonLessThan3Error(Exception):
	pass

class beyondSpeciesRangeError(Exception):
	pass

class ringExistingError(Exception):
	pass



	