from django.shortcuts import render
from django.shortcuts import render_to_response
from django.template import RequestContext
from django.http import HttpResponse
from .common_api import error
import json
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
    pass
