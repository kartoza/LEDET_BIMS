# noinspection PyUnresolvedReferences,PyPackageRequirements
import factory
from django.utils import timezone
from django.db.models import signals

from fish.models import (
    FishCollectionRecord,
)
from bims.tests.model_factories import LocationSiteF, TaxonF
from core.tests.model_factories import UserF


@factory.django.mute_signals(signals.post_save)
class FishCollectionRecordF(factory.django.DjangoModelFactory):
    """
    Fish collection record factory
    """
    class Meta:
        model = FishCollectionRecord

    site = factory.SubFactory(LocationSiteF)
    original_species_name = factory.Sequence(
            lambda n: u'Test original species name %s' % n)
    habitat = 'euryhaline'
    category = 'alien'
    present = True
    collection_date = timezone.now()
    collector = factory.Sequence(
            lambda n: u'Test collector %s' % n)
    owner = factory.SubFactory(UserF)
    notes = factory.Sequence(
            lambda n: u'Test notes %s' % n)
    taxon_gbif_id = factory.SubFactory(TaxonF)
