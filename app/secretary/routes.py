from flask import Blueprint, render_template, request, redirect, url_for, flash, session, jsonify, send_file

from app.secretary import secretary


@secretary.route('/dashboard')
def secretary_dashboard():
    return render_template('secretary/dashboard.html')