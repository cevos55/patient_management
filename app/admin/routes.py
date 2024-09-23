from flask import Blueprint, render_template, request, redirect, url_for, flash, current_app, app, session

from app.admin import admin


@admin.route('/dashboard')
def admin_dashboard():
    username = session.get('username')  # Récupérer le nom d'utilisateur depuis la session
    if username:
        return render_template('admin/dashboard.html', username=username)
    else:
        return redirect(url_for('auth.login'))  # Rediriger si l'utilisateur n'est pas connecté
