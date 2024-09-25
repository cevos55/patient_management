from flask import Blueprint, render_template, request, redirect, url_for, flash, current_app, app, session

from app.nurse import nurse


@nurse.route('/dashboard')
def nurse_dashboard():
    username = session.get('username')  # Récupérer le nom d'utilisateur depuis la session
    if username:
        return render_template('nurse/dashboard.html', username=username)
    else:
        return redirect(url_for('auth.login'))  # Rediriger si n