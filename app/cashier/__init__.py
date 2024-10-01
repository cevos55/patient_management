from flask import Blueprint

cashier = Blueprint('cashier', __name__)

from . import routes  # Ceci doit être en bas pour éviter la circularité
