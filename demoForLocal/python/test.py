import groupCounter

counterA = groupCounter.groupCounter()

# i=34
# counterA.readGjfFile(fileName='apple_' + '%03d'%i + '.gjf', directory='Gjfs', moleculeLabel='test'+'%03d'%i)
# counterA.readGroupTemplate()
# counterA.writeDBGCVector(overwrite=False)

# counterA.readGjfFile(fileName='C5H10_5.gjf', directory='Gjfs', moleculeLabel='test1')
# counterA.readGroupTemplate()
# counterA.writeDBGCVector(overwrite=True)

for i in xrange(1,28):
	print "%03d" % i
	counterA.readGjfFile(fileName='apple_' + '%03d'%i + '.gjf', directory='Gjfs', moleculeLabel='test'+'%03d'%i)
	counterA.readGroupTemplate()
	counterA.writeDBGCVector(overwrite=False)