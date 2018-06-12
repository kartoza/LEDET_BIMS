from .models import Category
from django.shortcuts import render
from django.views.generic import ListView


class LinksCategoryView(ListView):
    template_name = 'links/links.html'
    context_object_name = 'categories'
    paginate_by = 2
    queryset = Category.objects.all()

    def get_context_data(self, **kwargs):
        context = super(LinksCategoryView, self).get_context_data()
        context['categories'] = Category.objects.all()
        return context
