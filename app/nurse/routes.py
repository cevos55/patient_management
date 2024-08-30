from flask import Blueprint, render_template, request, redirect, url_for, flash, session, jsonify, send_file

from app.nurse import nurse


@nurse.route('/dashboard')
def nurse_dashboard():
    return render_template('nurse/dashboard.html')