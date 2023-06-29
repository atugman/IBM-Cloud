from flask import Flask, render_template
app = Flask(__name__)

@app.route('/')
def index():
  return render_template('index.html')

@app.route('/my-link/')
def my_link():
  print ('I got clicked!')

  return 'Click.'

@app.route('/test/')
def test():
  
  return render_template('app.html')

@app.route('/my-test/')
def my_test():
  print('hi')
  return render_template('app.html')

if __name__ == '__main__':
  app.run(debug=True)