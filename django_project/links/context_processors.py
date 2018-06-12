from .models import Category
from django.shortcuts import render
def categories(request):
    template = 'links/links.html'
    return render(request, template,{'categories': Category.objects.all()})


