from flask import Blueprint

secretary = Blueprint('secretary', __name__)

from . import routes
