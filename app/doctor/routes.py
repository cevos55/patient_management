from flask import Blueprint, render_template, request, redirect, url_for, flash, session, jsonify, send_file

from app.doctor import doctor


@doctor.route('/dashboard')
def doctor_dashboard():
    return render_template('doctor/dashboard.html')
