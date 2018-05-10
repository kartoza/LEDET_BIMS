from django.test import TestCase
from rest_framework.test import APIRequestFactory
from fish.tests.model_factories import (
    FishCollectionRecordF,
)
from fish.api_views.fish_collection_record import (
    FishCollectionList,
    FishCollectionDetail
)


class TestApiView(TestCase):
    """Test Fish API """

    def setUp(self):
        self.factory = APIRequestFactory()
        self.fish_collection_1 = FishCollectionRecordF.create(
            pk=1,
            original_species_name=u'Test fish species name 1',
        )
        self.fish_collection_2 = FishCollectionRecordF.create(
            pk=2,
            original_species_name=u'Test fish species name 2',
        )

    def test_get_all_fish(self):
        view = FishCollectionList.as_view()
        request = self.factory.get('/api/fish-collections/')
        response = view(request)
        self.assertTrue(len(response.data) > 1)

    def test_get_fish_by_id(self):
        view = FishCollectionDetail.as_view()
        pk = 1
        request = self.factory.get('/api/fish-collections/' + str(pk))
        response = view(request, str(pk))
        self.assertEqual(
            self.fish_collection_1.original_species_name,
            response.data['original_species_name']
        )
