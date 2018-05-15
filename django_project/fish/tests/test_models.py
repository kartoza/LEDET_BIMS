# coding=utf-8
"""Tests for models."""
from django.test import TestCase
from fish.tests.model_factories import (
    FishCollectionRecordF,
)


class TestFishCollectionRecordCRUD(TestCase):
    """
    Tests fish collection record.
    """
    def setUp(self):
        """
        Sets up before each test
        """
        pass

    def test_FishCollectionRecord_create(self):
        """
        Tests fish collection record creation
        """

        model = FishCollectionRecordF.create()

        # check if pk exists
        self.assertTrue(model.pk is not None)

        # check if site exists
        self.assertTrue(model.site is not None)

        # check if original species name exists
        self.assertTrue(model.original_species_name is not None)

    def test_FishCollectionRecord_read(self):
        """
        Tests fish collection record model read
        """
        model = FishCollectionRecordF.create(
            habitat=u'freshwater',
            original_species_name=u'custom original_species_name',
            present=False,
        )

        self.assertTrue(model.habitat == 'freshwater')
        self.assertTrue(
                model.original_species_name == 'custom original_species_name')

    def test_FishCollectionRecord_update(self):
        """
        Tests fish collection record model update
        """
        model = FishCollectionRecordF.create()
        new_data = {
            'habitat': u'freshwater',
            'original_species_name': u'custom original_species_name update',
            'present': False,
        }
        model.__dict__.update(new_data)

        # check if updated
        for key, val in new_data.items():
            self.assertEqual(model.__dict__.get(key), val)

    def test_FishCollectionRecord_delete(self):
        """
        Tests fish collection record model delete
        """
        model = FishCollectionRecordF.create()
        model.delete()

        # check if deleted
        self.assertTrue(model.pk is None)
