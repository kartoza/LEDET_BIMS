# coding=utf-8
from django.conf.urls import url
from .views.upload_options import UploadOptionsView

urlpatterns = [
    url(r'^upload-options/$', UploadOptionsView.as_view()),
]
