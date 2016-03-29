from django.shortcuts import render
from django.shortcuts import render_to_response
from django.template import RequestContext
from django.http import HttpResponse,HttpResponseRedirect
from .common_api import error
import matlab.engine
import json
from . import groupCounter
import time

# Create your views here.
eng = matlab.engine.start_matlab()

def index(request):
    request.META["CSRF_COOKIE_USED"] = True
    context = {}
    return render_to_response('index.html',context_instance = RequestContext(request,context))

def output(request):
    request.META["CSRF_COOKIE_USED"] = True
    context = {}
    return render_to_response('output.html',context_instance = RequestContext(request,context))

def uploadFile(request):
    re = dict()
    if request.method == 'POST':
        file_obj = request.FILES
        if file_obj:
            time_now = time.strftime('%Y%m%d%H%M%S',time.localtime(time.time()))
            vectorFileName =  'DBGCVectors'+time_now+'.xlsx'
            for f in file_obj:
                if file_obj[f].size > 10000000:
                    re['error'] = error(5)
                    return HttpResponse(json.dumps(re),content_type='application/json')

                counterA = groupCounter.groupCounter()
                counterA.readGjfFile(gjfFile=file_obj[f], moleculeLabel='test1')
                counterA.readGroupTemplate()
                counterA.writeDBGCVector(fileName=vectorFileName,overwrite=False)
            try:
                request.META["CSRF_COOKIE_USED"] = True
                ret = eng.DBGCUseTrainedANN(vectorFileName)
                re['data'] = ret
                re['error'] = error(1)
            except:
                re['error'] = error(4)
            request.session['vectorFileName'] = vectorFileName
            request.session['ret'] = ret
            return HttpResponseRedirect('/output/')
    else:
        re['error'] = error(3)
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
