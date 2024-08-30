from flask import Flask
from flask_mysqldb import MySQL

mysql = MySQL()


def create_app():
    app = Flask(__name__)
    app.config.from_object('config.Config')
    mysql.init_app(app)

    from .auth import auth as auth_blueprint
    app.register_blueprint(auth_blueprint, url_prefix='/auth')

    from .admin import admin as admin_blueprint
    app.register_blueprint(admin_blueprint, url_prefix='/admin')

    from .doctor import doctor as doctor_blueprint
    app.register_blueprint(doctor_blueprint, url_prefix='/doctor')

    from .nurse import nurse as nurse_blueprint
    app.register_blueprint(nurse_blueprint, url_prefix='/nurse')

    from .secretary import secretary as secretary_blueprint
    app.register_blueprint(secretary_blueprint, url_prefix='/secretary')

    from .patient import patient as patient_blueprint
    app.register_blueprint(patient_blueprint, url_prefix='/patient')

    return app
