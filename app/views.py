from django.shortcuts import render
from django.shortcuts import render_to_response
from django.template import RequestContext
from django.http import HttpResponse,HttpResponseRedirect
import common_api
import matlab.engine
import json
import time
import os
import collections

import groupCounter

import json


# Create your views here.
eng = matlab.engine.start_matlab()

def index(request):
    request.META["CSRF_COOKIE_USED"] = True
    context = {}
    return render_to_response('index.html',context_instance = RequestContext(request,context))

def output(request):
    request.META["CSRF_COOKIE_USED"] = True

    context = {
        'vectorFileName' : request.session.get('vectorFileName',''),
        'data':  request.session.get('data',''),
        'formulalist' : request.session.get('formulalist',''),
        'mol' : request.session.get('mol',''),
        'groupvector' : request.session['groupVector']
    }
    return render_to_response('output.html',context_instance = RequestContext(request,context))

def help(request):
    request.META["CSRF_COOKIE_USED"] = True
    context = {}
    return render_to_response('help.html',context_instance = RequestContext(request,context))

def aboutus(request):
    request.META["CSRF_COOKIE_USED"] = True
    context = {}
    return render_to_response('aboutus.html',context_instance = RequestContext(request,context))

def uploadFile(request):
    re = dict()
    if request.method == 'POST':
        file_obj = request.FILES
        if file_obj:
            time_now = time.strftime('%Y%m%d%H%M%S',time.localtime(time.time()))
            vectorFileName =  'DBGCVectors'+time_now+'.xlsx'
            # I suggest to read template firstly. Then we just need to read the Template file only once.
            # I have defined the method readGroupTemplate() as a classmethod\
            try:
                groupCounter.groupCounter.readGroupTemplate()
            except common_api.groupTemplateReadError:
                re['error'] = common_api.error(101)
                return HttpResponse(json.dumps(re),content_type='application/json')
            except:
                print 'Unexpected error in groupCounter.groupCounter.readGroupTemplate()!'
                re['error'] = common_api.error(1000)
                return HttpResponse(json.dumps(re),content_type='application/json')

            groupOrder = {}
            for (index_group, tmp_group) in enumerate(groupCounter.groupCounter.groupLib):
                groupOrder[tmp_group] = index_group

            filelist = ''
            formulalist = ''
            groupVector = []
            for f in file_obj:
                if file_obj[f].size > 10000000:
                    re['error'] = common_api.error(5)
                    return HttpResponse(json.dumps(re),content_type='application/json')
                counterA = groupCounter.groupCounter()

                try:
                    counterA.readGjfFile(gjfFile=file_obj[f], moleculeLabel=time_now+'.'+file_obj[f]._name)
                except common_api.readGjfFileError:
                    re['error'] = common_api.error(102)
                    print 'Error .gjf: ' + time_now+'.'+file_obj[f]._name
                    return HttpResponse(json.dumps(re),content_type='application/json')
                except common_api.carbonLessThan3Error:
                    re['error'] = common_api.error(107)
                    print 'Error .gjf: ' + time_now+'.'+file_obj[f]._name
                    return HttpResponse(json.dumps(re),content_type='application/json')                    
                except common_api.beyondSpeciesRangeError:
                    re['error'] = common_api.error(108)
                    print 'Error .gjf: ' + time_now+'.'+file_obj[f]._name
                    return HttpResponse(json.dumps(re),content_type='application/json')                    
                except common_api.ringExistingError:
                    re['error'] = common_api.error(109)
                    print 'Error .gjf: ' + time_now+'.'+file_obj[f]._name
                    return HttpResponse(json.dumps(re),content_type='application/json')                    
                except:
                    print 'Unexpected error in counterA.readGjfFile()!'
                    re['error'] = common_api.error(1000)
                    return HttpResponse(json.dumps(re),content_type='application/json')                    

                filelist = filelist + time_now+'.'+file_obj[f]._name.encode("utf-8").replace(" ","") +'|'

                try: 
                    tmp_groupVector = counterA.writeDBGCVector(fileName=vectorFileName,overwrite=False)
                except common_api.writeDBGCVectorError:
                    re['error'] = common_api.error(103)
                    print 'Error .gjf: ' + time_now+'.'+file_obj[f]._name
                    return HttpResponse(json.dumps(re),content_type='application/json')
                except:
                    print 'Unexpected error in tmp_groupVector = counterA.writeDBGCVector()!'
                    re['error'] = common_api.error(1000)
                    return HttpResponse(json.dumps(re),content_type='application/json')

                tmp_orderedGroupVector = collections.OrderedDict(sorted(tmp_groupVector.items(), key=lambda group: groupOrder[group[0]]))
                tmp_orderedGroupVectorList = []
                for tmp_group in tmp_orderedGroupVector.keys():
                    if not(tmp_orderedGroupVector[tmp_group] <= 1e-15 or tmp_orderedGroupVector[tmp_group] == 0):
                        tmp_orderedGroupVectorList.append([tmp_group, tmp_orderedGroupVector[tmp_group]])

                groupVector.append(tmp_orderedGroupVectorList)

                try:
                    counterA.mole.generateMOLFile()
                except common_api.molFileGeneratingError:
                    re['error'] = common_api.error(104)
                    print 'Error .gjf: ' + time_now+'.'+file_obj[f]._name
                    return HttpResponse(json.dumps(re),content_type='application/json')
                except:
                    print 'Unexpected error in counterA.mole.generateMOLFile()!'
                    re['error'] = common_api.error(1000)
                    return HttpResponse(json.dumps(re),content_type='application/json')

                formulalist = formulalist + counterA.mole.formula.encode("utf-8") + '|'
            filelist = filelist[:-1]
            formulalist = formulalist[:-1]
            model = request.POST.get('model','')
            if model == '':
                re['error'] = common_api.error(110)
                return HttpResponse(json.dumps(re),content_type='application/json')
            try:
                if model == 'DBGCUseTrainedANN':
                    ret = eng.DBGCUseTrainedANN(vectorFileName)
                else:
                    ret = eng.DBGCUseTrainedANN(vectorFileName)
                if isinstance(ret,float):
                    data = [ret]
                else:
                    data = []
                    for item in ret:
                        data.append(item[0])
                re['data'] = data
                re['mol'] = filelist
                re['error'] = common_api.error(1)

                # write output data to excel

                groupCounter.writeDataToExcel(data, os.path.join('static/DBGCVectors',vectorFileName))

                request.session['vectorFileName'] = vectorFileName
                request.session['data'] = data
                request.session['mol'] = filelist
                request.session['formulalist'] = formulalist
                request.session['groupVector'] = groupVector
            except common_api.writeDataToExcelError:
                re['error'] = common_api.error(105)
            except:
                re['error'] = common_api.error(4)
    else:
        re['error'] = common_api.error(3)
    return HttpResponse(json.dumps(re),content_type='application/json')


def uploadStr(request):
    re = dict()
    if request.method == "POST":
        str = request.POST.get('data','')
        if str == '':
            re['error'] = common_api.error(6)
            return HttpResponse(json.dumps(re),content_type='application/json')
        else:
            groupVector = []
            groupOrder = {}
            for (index_group, tmp_group) in enumerate(groupCounter.groupCounter.groupLib):
                groupOrder[tmp_group] = index_group
            time_now = time.strftime('%Y%m%d%H%M%S',time.localtime(time.time()))

            try:
                groupCounter.groupCounter.readGroupTemplate()
            except common_api.groupTemplateReadError:
                re['error'] = common_api.error(101)
                return HttpResponse(json.dumps(re),content_type='application/json')
            except:
                print 'Unexpected error in groupCounter.groupCounter.readGroupTemplate()!'
                re['error'] = common_api.error(1000)
                return HttpResponse(json.dumps(re),content_type='application/json')

            counter = groupCounter.groupCounter()

            try:
                counter.readGjfGeom(gjfGeom=str,moleculeLabel=time_now)
            except common_api.readGjfGeomError:
                re['error'] = common_api.error(106)
                print 'moleculeLabel ' + time_now
                return HttpResponse(json.dumps(re),content_type='application/json')
            except common_api.carbonLessThan3Error:
                re['error'] = common_api.error(107)
                print 'moleculeLabel ' + time_now
                return HttpResponse(json.dumps(re),content_type='application/json')                    
            except common_api.beyondSpeciesRangeError:
                re['error'] = common_api.error(108)
                print 'moleculeLabel ' + time_now
                return HttpResponse(json.dumps(re),content_type='application/json')                    
            except common_api.ringExistingError:
                re['error'] = common_api.error(109)
                print 'moleculeLabel ' + time_now
                return HttpResponse(json.dumps(re),content_type='application/json')        
            except:
                print 'Unexpected error in counter.readGjfGeom()!'
                re['error'] = common_api.error(1000)
                return HttpResponse(json.dumps(re),content_type='application/json')                        

            vectorFileName =  'DBGCVectors'+time_now+'.xlsx'
            molFileName = time_now

            try: 
                tmp_groupVector = counter.writeDBGCVector(fileName=vectorFileName,overwrite=False)
            except common_api.writeDBGCVectorError:
                re['error'] = common_api.error(103)
                print 'moleculeLabel ' + time_now
                return HttpResponse(json.dumps(re),content_type='application/json')
            except:
                print 'Unexpected error in tmp_groupVector = counter.writeDBGCVector()!'
                re['error'] = common_api.error(1000)
                return HttpResponse(json.dumps(re),content_type='application/json')

            try:
                counter.mole.generateMOLFile()
                print counter.mole.formula
            except common_api.molFileGeneratingError:
                re['error'] = common_api.error(104)
                print 'moleculeLabel ' + time_now
                return HttpResponse(json.dumps(re),content_type='application/json')
            except:
                print 'Unexpected error in counter.mole.generateMOLFile()!'
                re['error'] = common_api.error(1000)
                return HttpResponse(json.dumps(re),content_type='application/json')            
            model = request.POST.get('model','')
            if model == '':
                re['error'] = common_api.error(110)
                return HttpResponse(json.dumps(re),content_type='application/json')
            try:
                if model == 'DBGCUseTrainedANN':
                    ret = eng.DBGCUseTrainedANN(vectorFileName)
                else:
                    ret = eng.DBGCUseTrainedANN(vectorFileName)
                if isinstance(ret,float):
                    data = [ret]
                else:
                    data = []
                    for item in ret:
                        data.append(item[0])
                re['data'] = data
                re['mol'] = [time_now]
                re['error'] = common_api.error(1)

                # write output data to excel
                groupCounter.writeDataToExcel(data, os.path.join('static/DBGCVectors',vectorFileName))
                for key in tmp_groupVector.keys():
                    tmp_groupVector[key.encode("utf-8")] = tmp_groupVector.pop(key)

                tmp_orderedGroupVector = collections.OrderedDict(sorted(tmp_groupVector.items(), key=lambda group: groupOrder[group[0]]))
                tmp_orderedGroupVectorList = []
                for tmp_group in tmp_orderedGroupVector.keys():
                    if not(tmp_orderedGroupVector[tmp_group] <= 1e-15 or tmp_orderedGroupVector[tmp_group] == 0):
                        tmp_orderedGroupVectorList.append([tmp_group, tmp_orderedGroupVector[tmp_group]])

                groupVector.append(tmp_orderedGroupVectorList)
                request.session['vectorFileName'] = vectorFileName
                request.session['formulalist'] = counter.mole.formula.encode("utf-8")
                request.session['data'] = data
                request.session['mol'] = molFileName
                request.session['groupVector'] = groupVector
            except common_api.writeDataToExcelError:
                re['error'] = common_api.error(105)
            except:
                re['error'] = common_api.error(4)
    else:
        re['error'] = common_api.error(2)
    return HttpResponse(json.dumps(re),content_type='application/json')

def getOutput(request):
    re = dict()
    if request.method == 'GET':
        filename = request.GET.get('filename','')
        moleculeLabel = request.GET.get('moleculeLabel','')
        re['error'] = common_api.error(1)
        fullFileName = filename + '.gjf'
        eng = matlab.engine.start_matlab()
        counterA = groupCounter.groupCounter()
        counterA.readGjfFile(fileName=fullFileName, directory='Gjfs', moleculeLabel=moleculeLabel)
        counterA.readGroupTemplate()
        counterA.writeDBGCVector(overwrite=True)
        try:
            ret = eng.DBGCUseTrainedANN()
            re['data'] = ret
        except:
            re['error'] = common_api.error(4)
        #eng.quit()
    else:
        re['error'] = common_api.error(2)
    return HttpResponse(json.dumps(re),content_type='application/json')
