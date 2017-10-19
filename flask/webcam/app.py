from flask import Flask, render_template, Response
import socket
import time
import io
from camera import Camera

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('vf.html', switche=switche)

def gen(camera):
    """Video streaming generator function."""
    while True:
        frame = camera.get_frame()
        yield (b'--frame\r\n'
               b'Content-Type: image/jpeg\r\n\r\n' + frame + b'\r\n')


def stop(camera):
    switche = False
    camera.stop()

switche = True

@app.route('/video_feed')
def video_feed():
    """Video streaming route. Put this in the src attribute of an img tag."""
    if Camera.cameraRunning:
        return Response(gen(Camera()), mimetype='multipart/x-mixed-replace; boundary=frame')
    else:
        return '<p>Sth because response must be</p>'


@app.route('/startStop/start')
def stop_vid():
    return Camera().pause()


if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True, threaded=True)
