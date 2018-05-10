from rest_framework import serializers
from fish.models import FishCollectionRecord


class FishCollectionSerializer(serializers.ModelSerializer):
    """
    Serializer for fish collection model.
    """
    owner = serializers.SerializerMethodField()

    def get_owner(self, obj):
        if obj.owner:
            return '%s,%s' % (obj.owner.pk, obj.owner.username)

    class Meta:
        model = FishCollectionRecord
        fields = '__all__'
