from flask import Blueprint, render_template, request, redirect, url_for, flash, current_app

from app.admin import admin


@admin.route('/dashboard')
def admin_dashboard():
    return render_template('admin/dashboard.html')
