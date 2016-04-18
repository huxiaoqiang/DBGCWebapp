from django.shortcuts import render
from django.shortcuts import render_to_response
from django.template import RequestContext
from django.http import HttpResponse,HttpResponseRedirect
from .common_api import error
import matlab.engine
import json
from . import groupCounter
import time
import os

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
        'mol' : request.session.get('mol','')
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
            # I have defined the method readGroupTemplate() as a classmethod
            groupCounter.groupCounter.readGroupTemplate()

            filelist = ''

            for f in file_obj:
                if file_obj[f].size > 10000000:
                    re['error'] = error(5)
                    return HttpResponse(json.dumps(re),content_type='application/json')

                counterA = groupCounter.groupCounter()

                counterA.readGjfFile(gjfFile=file_obj[f], moleculeLabel=time_now+file_obj[f]._name)
                filelist = filelist + time_now+file_obj[f]._name.encode("utf-8") +'|'

                # counterA.readGroupTemplate()
                counterA.writeDBGCVector(fileName=vectorFileName,overwrite=False)
                counterA.mole.generateMOLFile()
            filelist = filelist[:-1]
            try:
                ret = eng.DBGCUseTrainedANN(vectorFileName)
                if isinstance(ret,float):
                    data = [ret]
                else:
                    data = []
                    for item in ret:
                        data.append(item[0])
                re['data'] = data
                re['mol'] = filelist
                re['error'] = error(1)

                # write output data to excel

                groupCounter.writeDataToExcel(data, os.path.join('static/DBGCVectors',vectorFileName))

                request.session['vectorFileName'] = vectorFileName
                request.session['data'] = data
                request.session['mol'] = filelist

            except:
                re['error'] = error(4)
    else:
        re['error'] = error(3)
    return HttpResponse(json.dumps(re),content_type='application/json')


def uploadStr(request):
    re = dict()
    if request.method == "POST":
        str = request.POST.get('data','')
        if str == '':
            re['error'] = error(6)
            return HttpResponse(json.dumps(re),content_type='application/json')
        else:
            time_now = time.strftime('%Y%m%d%H%M%S',time.localtime(time.time()))
            groupCounter.groupCounter.readGroupTemplate()
            counter = groupCounter.groupCounter()
            counter.readGjfGeom(gjfGeom=str,moleculeLabel=time_now)
            vectorFileName =  'DBGCVectors'+time_now+'.xlsx'
            molFileName = 'DBGCVectors'+time_now+'.mol'
            counter.writeDBGCVector(fileName=vectorFileName,overwrite=False)
            counter.mole.generateMOLFile()

            try:
                ret = eng.DBGCUseTrainedANN(vectorFileName)
                if isinstance(ret,float):
                    data = [ret]
                else:
                    data = []
                    for item in ret:
                        data.append(item[0])
                re['data'] = data
                re['mol'] = [time_now]
                re['error'] = error(1)

                # write output data to excel
                groupCounter.writeDataToExcel(data, os.path.join('static/DBGCVectors',vectorFileName))

                request.session['vectorFileName'] = vectorFileName
                request.session['data'] = data
                request.session['mol'] = molFileName

            except:
                re['error'] = error(4)
    else:
        re['error'] = error(2)
    return HttpResponse(json.dumps(re),content_type='application/json')
def getOutput(request):
    re = dict()
    if request.method == 'GET':
        filename = request.GET.get('filename','')
        moleculeLabel = request.GET.get('moleculeLabel','')
        re['error'] = error(1)
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
            re['error'] = error(4)
        #eng.quit()
    else:
        re['error'] = error(2)
    return HttpResponse(json.dumps(re),content_type='application/json')
