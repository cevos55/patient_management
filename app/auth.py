from flask import Blueprint, render_template, request, redirect, url_for, session, flash
from werkzeug.security import generate_password_hash, check_password_hash
from flask_mysqldb import MySQL
from datetime import datetime
import os

auth = Blueprint('auth', __name__)

# Configurez MySQL ici si nécessaire
mysql = MySQL()

# Créez le répertoire pour stocker les fichiers de session si ce n'est pas déjà fait
session_folder = os.path.join(os.getcwd(), 'session_files')
os.makedirs(session_folder, exist_ok=True)

# Fonction pour écrire les informations de session dans un fichier spécifique à chaque utilisateur
def write_session_to_file(username, action_time, action_type):
    # Générer un nom de fichier unique pour chaque utilisateur
    file_name = f"session_de_{username}.txt"
    file_path = os.path.join(session_folder, file_name)

    # Format du log
    if action_type == "connexion":
        log_entry = f"Heure de connexion: {action_time}\n"
    elif action_type == "déconnexion":
        log_entry = f"Heure de déconnexion: {action_time}\n---------------------------\n"

    # Écriture dans un fichier de session spécifique à l'utilisateur
    with open(file_path, 'a') as f:
        f.write(log_entry)


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
            session['username'] = user[1]
            session['role'] = user[3]
            session['login_time'] = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

            # Enregistrer l'heure de connexion dans le fichier
            write_session_to_file(username, session['login_time'], 'connexion')

            # Redirection selon le rôle
            if user[3] == 'admin':
                return redirect(url_for('admin.admin_dashboard'))
            elif user[3] == 'doctor':
                return redirect(url_for('doctor.doctor_dashboard'))
            elif user[3] == 'nurse':
                return redirect(url_for('nurse.nurse_dashboard'))
            elif user[3] == 'secretary':
                return redirect(url_for('secretary.secretary_dashboard'))
            # elif user[3] == 'cashier':
            #     return redirect(url_for('cashier.cashier_dashboard'))
            # elif user[3] == 'patient':
            #     return redirect(url_for('patient.patient_dashboard'))
            elif user[3] == 'patient':
                return redirect(url_for('cashier.cashier_dashboard'))
        else:
            flash('Échec de la connexion. Vérifiez votre nom d’utilisateur et/ou mot de passe.')
    return render_template('auth/login.html')


@auth.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        role = request.form['role']
        hashed_password = generate_password_hash(password, method='pbkdf2:sha256')
        cur = mysql.connection.cursor()
        cur.execute("INSERT INTO users (username, password, role) VALUES (%s, %s, %s)", (username, hashed_password, role))
        mysql.connection.commit()
        flash('Inscription réussie! Veuillez vous connecter.')
        return redirect(url_for('auth.login'))
    return render_template('auth/register.html')


@auth.route('/logout')
def logout():
    logout_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    username = session.get('username', 'Unknown User')

    # Enregistrer l'heure de déconnexion dans le fichier
    write_session_to_file(username, logout_time, 'déconnexion')

    session.clear()
    flash('Vous avez été déconnecté.')
    return redirect(url_for('auth.login'))
