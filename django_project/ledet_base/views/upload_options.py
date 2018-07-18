# coding=utf-8
from django.views.generic import TemplateView


class UploadOptionsView(TemplateView):
    """Upload options view."""

    template_name = 'upload_options.html'
