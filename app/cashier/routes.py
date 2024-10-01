from flask import Blueprint, render_template, request, redirect, url_for, flash, session, jsonify, send_file

from app.cashier import cashier

#components

def render_sidebar(): return render_template('cashier/component/sidebar.html')

@cashier.route('/dashboard')
def dashboard():
    return render_template('cashier/dashboard.html',render_sidebar=render_sidebar)


# bill routes

@cashier.route('/bill', methods=['GET'])
def bill(): return render_template('cashier/bill/bill.html',render_sidebar=render_sidebar)

@cashier.route('/bill/list', methods=['GET'])
def bill_list(): return render_template('cashier/bill/list.html',render_sidebar=render_sidebar)

@cashier.route('/bill/add', methods=['GET'])
def bill_add(): return render_template('cashier/bill/add.html',render_sidebar=render_sidebar)



# messages routes

@cashier.route('/messages', methods=['GET'])
def messages(): return render_template('globalPage/messages/message.html',render_sidebar=render_sidebar) 

