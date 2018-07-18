from django.core.management.base import BaseCommand
from bims.models import BiologicalCollectionRecord
from django.db.models import Count, Max


class Command(BaseCommand):
    """Update Fish Collection Record.
    """

    def handle(self, *args, **options):

        unique_fields = [
            'site',
            'original_species_name',
            'category',
            'taxon_gbif_id',
            'collection_date',
            'collector',
        ]

        duplicates = BiologicalCollectionRecord.objects.\
            values(*unique_fields).order_by().\
            annotate(max_id=Max('id'), count_id=Count('id')).\
            filter(count_id__gt=1)

        for duplicate in duplicates:
            BiologicalCollectionRecord.\
                objects.\
                filter(**{x: duplicate[x] for x in unique_fields}).\
                exclude(id=duplicate['max_id']).delete()
