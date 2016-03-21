from django.shortcuts import render
from django.shortcuts import render_to_response
from django.template import RequestContext
from django.http import HttpResponse
from .common_api import error
import matlab.engine
import json
from . import groupCounter

# Create your views here.

def index(request):
    request.META["CSRF_COOKIE_USED"] = True
    context = {}
    return render_to_response('index.html',context_instance = RequestContext(request,context))

def uploadFile(request):
    re = dict()
    if request.method == 'POST':
        pass
    else:
        re['error'] = error(3)
    return HttpResponse(json.dumps(re),content_type='application/json')

def getOutput(request):
    re = dict()
    if request.method == 'GET':
        eng = matlab.engine.start_matlab()
        counterA = groupCounter.groupCounter()
        counterA.readGjfFile(fileName='C5H10_5.gjf', directory='Gjfs', moleculeLabel='test1')
        counterA.readGroupTemplate()
        counterA.writeDBGCVector(overwrite=True)
        eng.quit()
    else:
        re['error'] = error(2)
    return HttpResponse(json.dumps(re),content_type='application/json')

def handle_matlab_command(command):
    eng = matlab.engine.start_matlab()
    tf = eng.isprime(37)
    print (tf)


