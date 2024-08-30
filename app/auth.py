from flask import Blueprint, render_template, request, redirect, url_for, flash, session
from werkzeug.security import generate_password_hash, check_password_hash
from . import mysql

auth = Blueprint('auth', __name__)


@auth.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM users WHERE username = %s", [username])
        user = cur.fetchone()
        if user and check_password_hash(user[2], password):
            session['user_id'] = user[0]
            session['role'] = user[3]
            if user[3] == 'admin':
                return redirect(url_for('admin.admin_dashboard'))
            elif user[3] == 'doctor':
                return redirect(url_for('doctor.doctor_dashboard'))
            elif user[3] == 'nurse':
                return redirect(url_for('nurse.nurse_dashboard'))
            elif user[3] == 'secretary':
                return redirect(url_for('secretary.secretary_dashboard'))
            elif user[3] == 'patient':
                return redirect(url_for('patient.patient_dashboard'))
        else:
            flash('Login failed. Check your username and/or password.')
    return render_template('auth/login.html')


@auth.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        role = request.form['role']
        hashed_password = generate_password_hash(password, method='pbkdf2:sha256')
        cur = mysql.connection.cursor()
        cur.execute("INSERT INTO users (username, password, role) VALUES (%s, %s, %s)",
                    (username, hashed_password, role))
        mysql.connection.commit()
        flash('You have successfully registered! Please log in.')
        return redirect(url_for('auth.login'))
    return render_template('auth/register.html')


@auth.route('/logout')
def logout():
    session.pop('user_id', None)
    session.pop('role', None)
    return redirect(url_for('auth.login'))
