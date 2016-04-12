from django.conf.urls import patterns, include, url
from . import views
urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'DBGCWebapp.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),
    url(r'file/upload$',views.uploadFile,name='uploadFile'),
    url(r'output/get$',views.getOutput,name='getOutput'),

)
