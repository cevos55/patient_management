from flask import Blueprint

doctor = Blueprint('doctor', __name__)

from . import routes
