# coding=utf-8
__author__ = 'Irwan Fathurrahman <irwan@kartoza.com>'
__date__ = '21/02/18'

from rolepermissions.roles import AbstractUserRole


class DataAdmin(AbstractUserRole):
    available_permissions = {
        'can_create_data': True,
        'can_update_data': True,
        'can_delete_data': True,
    }


class BiodiversityManagement(AbstractUserRole):
    available_permissions = {}


class EnvironmentalResearchAndPlanning(AbstractUserRole):
    available_permissions = {}


class EnvironmentalImpactManagement(AbstractUserRole):
    available_permissions = {}


class IntegratedEnvironmentalManagement(AbstractUserRole):
    available_permissions = {}


class IntegratedPollutionWaste(AbstractUserRole):
    available_permissions = {}


class ProtectedAreaManagement(AbstractUserRole):
    available_permissions = {}


class WildlifeTradeRegulation(AbstractUserRole):
    available_permissions = {}


class SouthAfricanNationalBiodiversityInstitute(AbstractUserRole):
    available_permissions = {}


class PolokwaneMunicipality(AbstractUserRole):
    available_permissions = {}


class EnvironmentalAssessmentPractitioners(AbstractUserRole):
    available_permissions = {}
