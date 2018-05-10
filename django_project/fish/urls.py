# coding=utf-8

from django.conf.urls import url
from fish.api_views.fish_collection_record import (
    FishCollectionList,
    FishCollectionDetail,
)
from fish.views.csv_upload import CsvUploadView


api_urls = [
    url(r'^api/fish-collections/$', FishCollectionList.as_view()),
    url(r'^api/fish-collections/(?P<pk>[0-9]+)/$',
        FishCollectionDetail.as_view()),
]

urlpatterns = [
    url(regex=r'^upload/$',
        view=CsvUploadView.as_view(),
        name='csv-upload'),
] + api_urls
