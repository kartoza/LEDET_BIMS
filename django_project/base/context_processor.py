# coding=utf-8
from bims.models.links import Link


def add_links(request):
    """Add links to the context."""
    links = Link.objects.all()
    return {'links': links}
