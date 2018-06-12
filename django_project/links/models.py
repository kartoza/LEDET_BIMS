from django.db import models

class Category(models.Model):
    name = models.CharField(max_length=50, unique=True)
    description = models.TextField(default='', blank=True)
    ordering = models.IntegerField(default=0)

    def __str__(self):
        return self.name

    class Meta:
        ordering = ('ordering',)
        verbose_name_plural = 'categories'

class Link(models.Model):
    category = models.ForeignKey(Category, on_delete=models.CASCADE)
    name = models.CharField(max_length=50, unique=True)
    url = models.URLField(null=True, blank=True)
    description = models.TextField(default='', blank=True)
    ordering = models.IntegerField(default=0)

    def __str__(self):
        return self.name

    class Meta:
        ordering = ('category__ordering', 'ordering',)
