import picamera
from flask import Flask

app = Flask(__name__)
app._static_folder = "/home/pi/raspberry-scritps/flask/webcam"

@app.route("/")
def hello():
    with picamera.PiCamera() as camera:
        camera.capture('image.jpg', use_video_port=True)
    return app.send_static_file('image.jpg')

if __name__ == '__main__':
    app.run(host='0.0.0.0',debug=True)
