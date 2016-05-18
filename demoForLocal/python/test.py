import groupCounter
import os

# groupCounter.groupCounter.readGroupTemplate()

counterA = groupCounter.groupCounter()

# i=34
# counterA.readGjfFile(fileName='apple_' + '%03d'%i + '.gjf', directory='Gjfs', moleculeLabel='test'+'%03d'%i)
# counterA.readGroupTemplate()
# counterA.writeDBGCVector(overwrite=False)
connectivity = ''



counterA.readGjfFile(fileName='c14h30_2.gjf', directory='Gjfs',moleculeLabel='c14h30_2')
connectivity += counterA.mole.getRMGConnectivity()
connectivity += '\n'


print connectivity

# for i in xrange(1,28):
# 	print "%03d" % i
# 	counterA.readGjfFile(fileName='apple_' + '%03d'%i + '.gjf', directory='Gjfs', moleculeLabel='test'+'%03d'%i)
# 	counterA.readGroupTemplate()
# 	counterA.writeDBGCVector(overwrite=False)

# toCalc = range(1,98)
# for i in toCalc:
# 	print "%03d" % i
# 	if os.path.exists(os.path.join('Gjfs', 'banana_' + '%03d'%i + '.gjf')):	
# 		counterA.readGjfFile(fileName='banana_' + '%03d'%i + '.gjf', directory='Gjfs', moleculeLabel='banana_'+'%03d'%i)
# 		counterA.readGroupTemplate()
# 		counterA.writeDBGCVector(overwrite=False)
# 	else:
# 		print 'banana_' + '%03d'%i + '.gjf does not exist'


# for i in xrange(80,81):
# 	print "%03d" % i
# 	counterA.readGjfFile(fileName='banana_' + '%03d'%i + '.gjf', directory='Gjfs', moleculeLabel='banana_'+'%03d'%i)
# 	counterA.readGroupTemplate()
# 	counterA.writeDBGCVector(overwrite=False)

