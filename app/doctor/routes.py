from flask import Blueprint, render_template, request, redirect, url_for, flash, current_app, app, session
import MySQLdb.cursors
from . import doctor
from .. import mysql
from flask import make_response
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas
import io

from app.doctor import doctor


@doctor.route('/doctor/dashboard', methods=['GET'])
def doctor_dashboard():
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    # Compter le nombre de patients
    cur.execute("SELECT COUNT(*) as patient_count FROM patients")
    patient_count = cur.fetchone()

    # Compter le nombre de rendez-vous
    cur.execute("SELECT COUNT(*) as appointment_count FROM appointments")
    appointment_count = cur.fetchone()

    # Compter le nombre de messages non lus
    cur.execute("SELECT COUNT(*) as unread_messages_count FROM messages WHERE recipient_id = %s AND status = 'unread'",
                (session['user_id'],))
    unread_messages_count = cur.fetchone()

    cur.close()

    return render_template('doctor/dashboard.html',
                           patient_count=patient_count,
                           appointment_count=appointment_count,
                           unread_messages_count=unread_messages_count)


@doctor.route('/patients', methods=['GET'], endpoint='list_patients')
def list_patients():
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cur.execute("SELECT id, full_name, dob FROM patients")
    patients = cur.fetchall()
    cur.close()
    return render_template('doctor/list_patients.html', patients=patients)


@doctor.route('/appointments', methods=['GET', 'POST'])
def manage_appointments():
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    if request.method == 'POST':
        patient_id = request.form['patient_id']
        doctor_id = request.form['doctor_id']
        appointment_date = request.form['appointment_date']
        appointment_time = request.form['appointment_time']
        appointment_type = request.form['appointment_type']
        reason = request.form['reason']
        notes = request.form['notes']
        status = request.form['status']

        cur.execute("""
            INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, appointment_type, reason, notes, status)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """, (patient_id, doctor_id, appointment_date, appointment_time, appointment_type, reason, notes, status))
        mysql.connection.commit()
        flash('Rendez-vous créé avec succès.', 'success')

    cur.execute("SELECT id, CONCAT(first_name, ' ', last_name) AS full_name FROM patients")
    patients = cur.fetchall()
    cur.execute("SELECT id, full_name FROM doctors")
    doctors = cur.fetchall()
    cur.execute("SELECT * FROM appointments")
    appointments = cur.fetchall()
    cur.close()
    return render_template('doctor/manage_appointments.html', patients=patients, doctors=doctors,
                           appointments=appointments)


@doctor.route('/appointment/edit/<int:appointment_id>', methods=['GET', 'POST'])
def edit_appointment(appointment_id):
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    if request.method == 'POST':
        appointment_date = request.form['appointment_date']
        appointment_time = request.form['appointment_time']
        appointment_type = request.form['appointment_type']
        reason = request.form['reason']
        notes = request.form['notes']

        cur.execute("""
            UPDATE appointments
            SET appointment_date = %s, appointment_time = %s, appointment_type = %s, reason = %s, notes = %s
            WHERE id = %s
        """, (appointment_date, appointment_time, appointment_type, reason, notes, appointment_id))
        mysql.connection.commit()
        flash('Rendez-vous modifié avec succès.', 'success')
        return redirect(url_for('doctor.manage_appointments'))

    cur.execute("SELECT * FROM appointments WHERE id = %s", (appointment_id,))
    appointment = cur.fetchone()
    cur.close()

    if not appointment:
        flash('Rendez-vous non trouvé.', 'danger')
        return redirect(url_for('doctor.manage_appointments'))

    return render_template('doctor/edit_appointment.html', appointment=appointment)



@doctor.route('/appointment/status/<int:appointment_id>', methods=['GET', 'POST'])
def update_appointment_status(appointment_id):
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    if request.method == 'POST':
        status = request.form['status']

        # Insérer dans l'historique
        cur.execute("""
            INSERT INTO appointment_history (appointment_id, status)
            VALUES (%s, %s)
        """, (appointment_id, status))

        # Mettre à jour le statut du rendez-vous actuel
        cur.execute("""
            UPDATE appointments
            SET status = %s
            WHERE id = %s
        """, (status, appointment_id))

        mysql.connection.commit()
        cur.close()
        flash('Statut du rendez-vous mis à jour avec succès.', 'success')
        return redirect(url_for('doctor.manage_appointments'))

    cur.execute("SELECT * FROM appointments WHERE id = %s", (appointment_id,))
    appointment = cur.fetchone()
    cur.close()

    if not appointment:
        flash('Rendez-vous non trouvé.', 'danger')
        return redirect(url_for('doctor.manage_appointments'))

    return render_template('doctor/update_appointment_status.html', appointment=appointment)


@doctor.route('/appointments/<int:appointment_id>/cancel', methods=['POST'], endpoint='cancel_appointment')
def cancel_appointment(appointment_id):
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cur.execute("DELETE FROM appointments WHERE id=%s", (appointment_id,))
    mysql.connection.commit()
    cur.close()
    flash('Rendez-vous annulé avec succès.', 'success')
    return redirect(url_for('doctor.manage_appointments'))


@doctor.route('/appointments/history', methods=['GET'], endpoint='view_appointment_history')
def view_appointment_history():
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cur.execute("""
        SELECT 
            a.id, 
            CONCAT(p.first_name, ' ', p.last_name) AS patient_name, 
            a.appointment_date, 
            a.appointment_time, 
            a.status
        FROM 
            appointments a
        JOIN 
            patients p ON a.patient_id = p.id
    """)
    appointment_history = cur.fetchall()
    cur.close()
    return render_template('doctor/view_appointment_history.html', appointment_history=appointment_history)
