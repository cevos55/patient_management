from flask import Blueprint, render_template, request, redirect, url_for, flash, session, jsonify, send_file
import MySQLdb.cursors
from .. import mysql
from flask import render_template, make_response
import io

from app.secretary import secretary



@secretary.route('/dashboard')
def secretary_dashboard():
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    cur.execute("SELECT COUNT(*) AS patient_count FROM patients")
    patient_count = cur.fetchone()

    cur.execute("SELECT COUNT(*) AS appointment_count FROM appointments")
    appointment_count = cur.fetchone()

    cur.execute("SELECT COUNT(*) AS unread_messages_count FROM messages WHERE is_read = 0")
    unread_messages_count = cur.fetchone()

    cur.execute("""
           SELECT admissions.id, 
                  patients.full_name AS patient_name, 
                  admissions.admission_date, 
                  services.name AS service_name, 
                  services.price AS service_price, 
                  rooms.room_number, 
                  rooms.price_per_night
           FROM admissions
           JOIN patients ON admissions.patient_id = patients.id
           JOIN services ON admissions.service_id = services.id
           JOIN rooms ON admissions.room_id = rooms.id
           ORDER BY admissions.admission_date DESC
           LIMIT 6
       """)
    admissions = cur.fetchall()

    cur.close()

    return render_template('secretary/dashboard.html',
                           patient_count=patient_count,
                           appointment_count=appointment_count,
                           unread_messages_count=unread_messages_count,
                           admissions=admissions)

    return render_template('secretary/dashboard.html')

# @secretary.route('/appointments')  # Cette route doit correspondre à ce que vous appelez dans redirect
# def secretary_appointments():
#     # Logique pour afficher les rendez-vous
#     return render_template('secretary/appointments.html')



@secretary.route('/appointments/<int:appointment_id>/edit', methods=['GET', 'POST'])
def edit_appointment(appointment_id):
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    if request.method == 'POST':
        patient_id = request.form['patient_id']
        doctor_id = request.form['doctor_id']
        appointment_date = request.form['appointment_date']
        appointment_time = request.form['appointment_time']
        appointment_type = request.form['appointment_type']
        reason = request.form['reason']
        notes = request.form['notes']
        confirmation = request.form['confirmation']

        cur.execute("""
            UPDATE appointments
            SET patient_id=%s, doctor_id=%s, appointment_date=%s, appointment_time=%s, appointment_type=%s, reason=%s, notes=%s, confirmation=%s
            WHERE id=%s
        """, (patient_id, doctor_id, appointment_date, appointment_time, appointment_type, reason, notes, confirmation,
              appointment_id))
        mysql.connection.commit()
        flash('Rendez-vous modifié avec succès.', 'success')
        return redirect(url_for('secretary.liste_appointments'))

    cur.execute("SELECT * FROM appointments WHERE id=%s", (appointment_id,))
    appointment = cur.fetchone()
    cur.execute("SELECT id, full_name FROM patients")
    patients = cur.fetchall()
    cur.execute("SELECT id, full_name FROM doctors")
    doctors = cur.fetchall()
    cur.close()
    return render_template('secretary/edit_appointment.html', appointment=appointment, patients=patients,
                           doctors=doctors)

@secretary.route('/appointments/<int:appointment_id>/cancel', methods=['POST'])
def cancel_appointment(appointment_id):
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cur.execute("DELETE FROM appointments WHERE id=%s", (appointment_id,))
    mysql.connection.commit()
    cur.close()
    flash('Rendez-vous annulé avec succès.', 'success')
    return redirect(url_for('secretary.liste_appointments'))


@secretary.route('/patients', methods=['GET'])
def list_patients():
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cur.execute("""
        SELECT 
            patients.id, 
            patients.full_name, 
            patients.dob, 
            admissions.id AS admission_id 
        FROM patients
        LEFT JOIN admissions ON patients.id = admissions.patient_id
    """)
    patients = cur.fetchall()
    cur.close()
    return render_template('secretary/list_patients.html', patients=patients)

@secretary.route('/liste-rendez-vous', methods=['GET'], endpoint='liste_appointments')
def liste_appointments():
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    # Requête pour récupérer les noms des patients et des docteurs associés aux rendez-vous
    cur.execute("""
        SELECT 
            appointments.id, 
            patients.full_name AS patient_name, 
            doctors.full_name AS doctor_name, 
            appointments.appointment_date, 
            appointments.appointment_time, 
            appointments.appointment_type, 
            appointments.reason, 
            appointments.notes, 
            appointments.confirmation,
            appointments.status
        FROM appointments
        JOIN patients ON appointments.patient_id = patients.id
        JOIN doctors ON appointments.doctor_id = doctors.id
    """)
    appointments = cur.fetchall()
    cur.close()

    # Rendu du template avec les données récupérées
    return render_template('secretary/secretaireListeRdv.html', appointments=appointments)



@secretary.route('/planification-rendez-vous', methods=['GET', 'POST'], endpoint='planification_appointments')
def planification_appointments():
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    if request.method == 'POST':
        # Récupération des données du formulaire
        patient_id = request.form.get('patient_id')
        doctor_id = request.form.get('doctor_id')
        appointment_date = request.form.get('appointment_date')
        appointment_time = request.form.get('appointment_time')
        appointment_type = request.form.get('appointment_type')
        reason = request.form.get('reason')
        notes = request.form.get('notes')
        status = request.form.get('status')

        try:
            # Insertion des données dans la table appointments
            cur.execute("""
                INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, appointment_type, reason, notes, status)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
            """, (patient_id, doctor_id, appointment_date, appointment_time, appointment_type, reason, notes, status))
            mysql.connection.commit()
            flash('Rendez-vous créé avec succès.', 'success')
        except MySQLdb.Error as e:
            flash(f"Erreur lors de la création du rendez-vous : {str(e)}", 'danger')
        finally:
            cur.close()
            return redirect(url_for('secretary.planification_appointments'))

    else:
        try:
            # Requête pour récupérer la liste des rendez-vous
            cur.execute("""
                SELECT 
                    appointments.id, 
                    patients.full_name AS patient_name, 
                    doctors.full_name AS doctor_name, 
                    appointments.appointment_date, 
                    appointments.appointment_time, 
                    appointments.appointment_type, 
                    appointments.reason, 
                    appointments.notes, 
                    appointments.confirmation, 
                    appointments.status
                FROM appointments
                JOIN patients ON appointments.patient_id = patients.id
                JOIN doctors ON appointments.doctor_id = doctors.id
            """)
            appointments = cur.fetchall()  # Assure-toi que 'execute()' a été appelé avant 'fetchall()'

            # Requêtes pour récupérer la liste des patients et des docteurs
            cur.execute("SELECT id, full_name FROM patients")
            patients = cur.fetchall()

            cur.execute("SELECT id, full_name FROM doctors")
            doctors = cur.fetchall()

        except MySQLdb.Error as e:
            flash(f"Erreur lors de la récupération des données : {str(e)}", 'danger')
            appointments, patients, doctors = [], [], []

        finally:
            cur.close()

    return render_template('secretary/secretairPlanificationRdv.html', patients=patients, doctors=doctors)


@secretary.route('/planification', methods=['GET'], endpoint='plan_appointment')
def plan_appointment():
    return render_template('secretary/secretairPlanificationRdv.html')

@secretary.route('/acceuil', methods=['GET'], endpoint='acceuil')
def acceuil():
    return render_template('secretary/dashboard.html')


@secretary.route('/messages')
def view_messages():
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cur.execute("""
        SELECT messages.id, messages.message AS content, messages.date_sent, messages.is_read, 
               patients.full_name AS patient_name, doctors.full_name AS doctor_name
        FROM messages
        JOIN patients ON messages.patient_id = patients.id
        JOIN doctors ON messages.doctor_id = doctors.id
        ORDER BY messages.date_sent DESC
    """)
    messages = cur.fetchall()
    cur.close()
    return render_template('secretary/messages.html', messages=messages)


@secretary.route('/add_patient', methods=['GET', 'POST'])
def add_patient():
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    if request.method == 'POST':
        full_name = request.form['full_name']
        dob = request.form['dob']
        address = request.form['address']
        phone = request.form['phone']
        email = request.form['email']
        service_name = request.form['service_name']
        service_description = request.form['service_description']
        service_price = request.form['service_price']

        cur.execute("""
            INSERT INTO patients (full_name, dob, address, phone, email) 
            VALUES (%s, %s, %s, %s, %s)
        """, (full_name, dob, address, phone, email))

        patient_id = cur.lastrowid

        cur.execute("""
            INSERT INTO admissions (patient_id, service_name, service_description, service_price, admission_date, status)
            VALUES (%s, %s, %s, %s, NOW(), 'pending')
        """, (patient_id, service_name, service_description, service_price))

        mysql.connection.commit()
        cur.close()

        flash('Patient ajouté et admission créée avec succès!', 'success')
        return redirect(url_for('secretary.list_patients'))

    # Services disponibles - définis directement dans le code
    services = [
        {"name": "Consultation", "price": 50.0},
        {"name": "Check-up", "price": 150.0},
        {"name": "Hospitalisation", "price": 500.0}
    ]

    cur.close()
    return render_template('secretary/add_patient.html', services=services)
