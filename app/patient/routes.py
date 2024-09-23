from flask import Blueprint, render_template, request, redirect, url_for, flash, session, jsonify, send_file

from app.patient import patient


@patient.route('/dashboard')
def patient_dashboard():
    return render_template('patient/dashboard.html')