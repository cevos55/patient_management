from flask import Blueprint

patient = Blueprint('patient', __name__)

from . import routes  # Ceci doit être en bas pour éviter la circularité
