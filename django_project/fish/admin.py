# coding=utf-8

from django.contrib import admin
from fish.models import (
    FishCollectionRecord,
    CSVDocument,
)


class FishCollectionAdmin(admin.ModelAdmin):
    list_display = (
        'original_species_name',
        'habitat',
        'category',
        'collection_date',
        'owner',
    )


admin.site.register(FishCollectionRecord, FishCollectionAdmin)
admin.site.register(CSVDocument)
