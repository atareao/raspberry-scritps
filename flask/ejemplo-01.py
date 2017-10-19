#!/usr/bin/env python3

from flask import Flask, render_template
import platform
import psutil

app = Flask(__name__)

@app.route('/')
def hola():
    return '<html><body><h1>¡Hola Mundo!</h1></body></html>'

@app.route('/sorpresa')
def sorpresa():
	return '<html><body><h1>¡Sorpresa!</h1></body></html>'

@app.route('/conestilo')
def conestilo():
    return '<html><head><link rel="stylesheet" href="/static/style.css"/></head><body><h1>Una página con estilo. Que se recarga.</h1></body></html>'

@app.route('/info')
def info():
    afile = open('/sys/class/thermal/thermal_zone0/temp', 'r')
    temp = afile.read()
    afile.close()
    temp = temp[:-1]
    temp = str(float(temp) / 1000.0) + ' ºC'
    mem = psutil.virtual_memory()[2]
    data = [platform.machine(), platform.system(), temp, mem]
    return render_template('index.html', data=data)

@app.route('/hola/<nombre>')
def hola_nombre(nombre):
    return render_template('page.html', nombre=nombre)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
