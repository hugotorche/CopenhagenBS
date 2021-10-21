from flask import Flask, request, jsonify, render_template
from sklearn.ensemble import RandomForestRegressor
import joblib
import requests

app = Flask(__name__)
rf_model = joblib.load("app/files/rf_model.joblib")

@app.route("/")
def home():
    return 'Hello world'

# User interface
@app.route("/submit-form", methods = ["GET", "POST"])
def submit_form():
    if request.method == 'POST':
        price = request.form['price']
        year = request.form['year']

        # This was used in class
        ## url = f'http://127.0.0.1:5000/calculate?price={price}&year={year}'

        # Although this is better, as it works on any domain
        url = f'{request.root_url}/calculate?price={price}&year={year}'

        r = requests.get(url)

        result = str(r.json()['result'])
        return render_template("pretty_result.html", price=price, year=year, result = result)

    return render_template("pretty_form_page.html")

# API
@app.route("/calculate", methods = ["GET"])
def calculate():
    price = request.args.get("price")
    year = request.args.get("year")

    # Do eventual data processing here

    result = rf_model.predict([[year, price]])

    out = {
        'result' : result[0]
    }
    return jsonify(out)


app.run()