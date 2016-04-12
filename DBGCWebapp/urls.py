from django.conf.urls import patterns, include, url

from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'DBGCWebapp.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),
    url(r'^api/',include('app.urls')),
    url(r'^output/$','app.views.output'),
    url(r'aboutus$',"app.views.aboutus"),
    url(r'help$',"app.views.help"),
    url(r'^.*','app.views.index'),
)
