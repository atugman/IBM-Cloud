# Simple usage of Python Dictionaries

Python dictionaries are a powerful data structure that you can use to look up information using key value pairs. They differ from lists and other data structures in various ways, but namely in the sense that they are not indexed numerically, but by keys.

## Learning Objectives
In this lab, we'll take a quick look at Python dictionaries, how to create them, update them, otherwise interact with them, and why they might be useful in various settings.

After completion of this lab, you should be able to:
- Create a dictionary in Python
- Update a dictionary in Python
- Articulate the best use cases for dictionaries

## Prerequisites
- Basic Python knowledge is helpful, but not required
- Local Python 3 Installation
- Local Visual Studio Code (or similar IDE) Installation

## Create our environment

Let's start by creating a simple Python environment that we can work in.

Execute the following commands in your terminal to create our .py file:

```bash
mkdir dictionaries_lab && cd dictionaries_lab
touch dictionaries.py
```
------------
Copy and paste the following code into your dictionaries.py file.

```python
# print hello world to the console!
print('hello world!')
```
------------
Execute the following command in your terminal to ensure your python environment is working. 

```bash
python dictionaries.py
```

If working properly, you should see a simple "hello world!" message printed to the console of your IDE.

## Step 2: Create the data structure

There are a couple of simple ways to do this.

```python
my_dict = {} # or
my_dict = dict()
```

Or you could even prepopulate some data into your dictionary. Let's use this approach for the sake of this example. Ignore the 2 lines above this, and copy and paste the 5 lines below into the dictionaries.py file located in your IDE. You can also delete the "hello world" function used previously.

```python
my_dict = {
	"sample_key":"sample_value"
}

print(my_dict["sample_key"])
```
Save the .py file, and execute the program once again:
```bash
python dictionaries.py
```
The program output should be the string: `sample_value`

## Updating Dictionaries (Existing Entries)

Let's update our dictionary. What if the value of our "sample_key" has changed? What if we need to add more key/value pairs to our dictionary?

Add the following lines below the existing lines in your python program.

```python
my_dict["sample_key"] = "different_value"
print(my_dict["sample_key"])
```
Your full program should look like this:

```python
my_dict = {
	"sample_key":"sample_value"
}

print(my_dict["sample_key"])

my_dict["sample_key"] = "different_value"
print(my_dict["sample_key"])

```
The output of your new and improved program should be:

```
sample_value
different value
```

Notice we printed the value of the `sample key`at two different points in time: first using our initial provided value, `sample_value`, then again using the new value of `sample_key` after our update: `different_value`.

## Updating Dictionaries (New Entries)

Let's add a brand new entry to our Python dictionary and see what it looks like. Add the following lines to your existing Python program. You can comment out previous print statements for a condensed output.

```python
my_dict["new_key"] = "a new value"
print(my_dict)
```
Your full program should now look like this (notice the previous print statements are commented out):

```python
my_dict = {
	"sample_key":"sample_value"
}

#print(my_dict["sample_key"])

my_dict["sample_key"] = "different_value"

#print(my_dict["sample_key"])

my_dict["new_key"] = "a new value"
print(my_dict)
```

Your output, which is a full view of your dictionary after updating one existing entry and adding a second, should like this:

`
my_dict = {
	"sample_key":"different_value",
	"new_key":"a new value"
}
`

## Iterating over Dictionaries"

So, what is the purpose of all of this? Why are we talking about it?

Let's take a look at a simple, real-world example.

Let's say I'm a teacher, and I'm keeping track of all my students' scores on a test. Later on, I decide I want to implement a curve of 3 points to each students' test because I threw out a bad question.

Below is a dictionary containing each of my students' current test score, before the 3 point curve is implemented. Delete all of the existing contents of your dictionaries.py file, and replace them with the code below.

```python
student_scores = {
	"Bob":88,
	"Sally":72,
	"Bill":78,
	"Fred":92,
	"Ted":98,
}
```

How can I easily, quickly, and programmatically add 3 points to each score? Let's iterate over the dictionary and update it during our for loop. Add the following lines below the existing dictionary in .py file:

```python
for key,value in student_scores.items():
    student_scores[key] = value + 3

print(student_scores)
```

Your output should now reflect the students' new scores after the curve!

`{'Bob': 91, 'Sally': 75, 'Bill': 81, 'Fred': 95, 'Ted': 101}`

Let's take note of a couple of *key* items in our code (pun intended!):
- Notice that we iterate over both the keys *and* values of our dictionary.
-	for key,value in student_scores.items():
- This is why we indicate "key" and "value," in the for loop, and is also why we add `.items()` to the name of dictionary. If we only wanted to iterate over the keys or values of a dictionary, we could change `.items()` to `.keys()` or `.values()` respectively.
- Lastly, notice that we are programmatically passing in the *keys* and *values* to be updated:
-	student_scores[key] = value + 3

## A slightly more complex example

Don't worry if everything in this section doesn't click right away. The purpose is to show you another practical use case for dictionaries in the real world.

Let's revisit our teacher/testing example, but a bit more complex. Surely our students have had more than one assignment throughout the semester, thus we'll need a way to track scores for multiple assignments, for multiple students.

But the *value* of a given *key* in our dictionary does not have to be a simple string or integer, as it has been throughout this tutorial. Let's use a list to store each of the scores of 5 different assignments for each of our 5 students:

Replace the contents of your dictionaries.py file with the code block below.

```python
student_scores_all_assignments = {
	"Bob":[88,72,81,95,93],
	"Sally":[72,95,81,95,93],
	"Bill":[78,72,81,95,93],
	"Fred":[92,72,81,95,93],
	"Ted":[98,72,81,95,93],
}

for key,values in student_scores_all_assignments.items():
    average = sum(values) / len(values)
    print(str(key) + "'s final average: " + str(average))
```

In short, the program in the code block above is calculating the final course grades for each student (based on 5 individual assignment scores), and printing each one to the console. The output of program should read:

```html
Bob's final average: 85.8
Sally's final average: 87.2
Bill's final average: 83.8
Fred's final average: 86.6
Ted's final average: 87.8
```

But, this isn't entirely practical. We need a way we can logically store this information. Sure, we could create another dictionary maybe, or another data structure (a simple list could work) that we could update as we iterate over each key and value of our existing dictionary. Dictionaries are great for keeping our data arranged by keys, therefore, when I look up the key for any one of my students, ideally I could find more information about them all in one place. Plus, what if the assignments are weighted differently?

Let's move on to the last section to implement a better approach.

## Dictionaries within Dictionaries

We're actually going to use *another dictionary*, and maybe even *ANOTHER* dictionary to represent the *values* in our first dictionary (and subsequent dictionaries). Like I said, if this all sounds a bit confusing, or like some sort of weird dictionary inception movie for Python nerds, don't worry. Let's take this one step at a time.

First, create a new file called data.py:
```bash
touch data.py
```

And copy the code from [this file](https://github.com/atugman/IBM-Cloud/blob/main/Labs/Python/Dictionaries/data.py) into your local data.py file.

Let's start from scratch in our dictionaries.py file. Go ahead and remove any existing lines of code, and let's start small to understand how to access all of this data stored in our dictionary (in our data.py file), and eventually we will store the final student grades in a logical place.

Copy and paste the block of code below into dictionaries.py. Your full dictionaries.py file should look like this at the moment:

```python
from data import student_scores_all_assignments

for keys,values in student_scores_all_assignments.items():
    # in this loop, the keys are student names, and the values are dictionaries
    print(keys,values)
```
Execute the program:
```bash
python dictionaries.py
```

You'll notice your output looks a lot like our full data structure in data.py. The keys of our student_scores_all_assignments dictionary located in data.py are the names of our students, and the values are dictionaries.

Let's iterate through the dictionaries that we are using for the values of the keys in our student_scores_all_assignments dictionary.

Update your dictionaries.py file to look like this - you can replace all of the contents of the current file with the code block below (notice that I added two lines, and commented out line 5).

```python
from data import student_scores_all_assignments

for student_names,another_dictionary in student_scores_all_assignments.items():
    # in this loop, the keys are student names, and the values are dictionaries
    #print(student_names,another_dictionary)
    for assignment_name,values in another_dictionary.items():
        print(student_names,assignment_name,values)
```
Execute the program again, and take note of the differences in the output.
```bash
python dictionaries.py
```
Your output will look something like this block below - notice how each iteration (represented by a single line in the output) is a particular assignment, rather than a student, as was the case in the previous output. The student names are only present in the console because I chose to print them here - they are actually from the *original* dictionary.

```html
Bob: Test 1 {'Score': 72, 'Weight': 20}
Bob: Test 2 {'Score': 95, 'Weight': 30}
Bob: Test 3 {'Score': 81, 'Weight': 10}
Bob: Project 1 {'Score': 95, 'Weight': 30}
Bob: Project 2 {'Score': 93, 'Weight': 10}
Sally: Test 1 {'Score': 72, 'Weight': 20}
Sally: Test 2 {'Score': 95, 'Weight': 30}
Sally: Test 3 {'Score': 81, 'Weight': 10}
...
```

Now we are in a position where we can programmatically access the score and weight for each assignment, for each student. Let's put this into practice with a simple example. Add the following two lines to dictionaries.py:

```python
        points_for_assignment = values['Score'] * (values['Weight'] / 100)
        print("Equivalent to",points_for_assignment,"points out of",values['Weight'])
```
Note that these should be lines 8 and 9 (and should be placed within the second for loop). Then execute the program.

```bash
python dictionaries.py
```

The program output will be longer than the sample below, but now we can see how much each assignment was worth out of the student's total score.

```
Ted: Project 2 {'Score': 93, 'Weight': 10}
Equivalent to 9.3 points out of 10
```

> Take note of how we accessed the data in our dictionary in line 8. The syntax is as follows: `dictionary_name[key_name]`. So why is our dictionary name `values` on line 8?
```python
        points_for_assignment = values['Score'] * (values['Weight'] / 100)
```

> In our nested for loop, we're accessing a dictionary within a dictionary. Taking a look at data.py, we're accessing the `Score` and `Weight` properties for each assignment for each student. Below is an abbreviated version of data.py with comments to illustrate this.

```python
# from data.py
student_scores_all_assignments = {
    "Bob":{ # <--- Data being accessed in the first for loop (each student)
        "Test 1":{ # <--- Data being accessed in the inner for loop (each assignment)
            "Score":72, # <---- Property available (inner for loop)
            "Weight":20 # <---- Property available (inner for loop)
        },
        "Test 2":{
            "Score":95,
            "Weight":30
        },
# ......
    "Sally":{ # <--- Data being accessed in the first for loop (each student)
        "Test 1":{ # <--- Data being accessed in the inner for loop (each assignment)
            "Score":72, # <---- Property available (inner for loop)
            "Weight":20 # <---- Property available (inner for loop)
        },
        "Test 2":{ # <--- Data being accessed in the inner for loop (each assignment)
            "Score":95, # <---- Property available (inner for loop)
            "Weight":30 # <---- Property available (inner for loop)
        },
# ......
```

Let's jump to the next section for our final implementation.

## Dictionaries within Dictionaries - Final Implementation (with comments)

Thanks for hanging in there this long! Here is our final implementation. There are various comments throughout the file that explain the approaches that the code is using line by line. 

Replace the contents of your dictionaries.py file with the code block below and execute the program. Take note of the output, and read through the comments to make sure you understand the code!

```python
from data import student_scores_all_assignments

for student_names,another_dictionary in student_scores_all_assignments.items():
    # as we loop over this dictionary, the keys are student names,
    # and the values are dictionaries representing all assignments

    # create a temporary integer to store the total score for each student
    # we create it here so that it resets to 0 for each student in the loop
    # meaning that we are calculating final scores for every student,
    # and storing it in this variable for each iteration of the loop
    student_total_course_score = int()

    for assignment_name,values in another_dictionary.items():
        # as we loop over this dictionary, the keys are assignment names,
        # and the values are dictionaries representing the score and weight of the assignment

        # create a variable to store the points earned toward their final grade
        # for each assignment. notice how we access the 'Score' and 'Weight' 
        # values of our dictionary - with the syntax: dictionary_name[key_name]
        # e.g. values['Score'] and values['Weight']
        points_for_assignment = values['Score'] * (values['Weight'] / 100)

        # add the points for each assignment to our temporary integer we created
        # to store the total points for each student
        student_total_course_score += points_for_assignment

    # once we've calculated the final grade for each student, back in our first for loop
    # we will update the dictionary allocated to each student, each of which are
    # located in our original dictionary (that we added to data.py). 
    # the updated dictionary will now have a "Final Grade" key for each student,
    # where we've assigned the score that we calculated for them above.
    student_scores_all_assignments[student_names]['Final Grade'] = student_total_course_score

# Lastly, let's print our updated final dictionary (that we pulled in from data.py)
# You should see each student's final score listed.
# Take note: the actual data structure in data.py was NOT updated. 
# We are merely printing an instance of this object that we updated during the execution
# of our program. In the next module, we will work on updating files with Python
# so that our data will persist across multiple program executions!
print(student_scores_all_assignments)
```
> Command to execute the program (for your reference!)
```bash
python dictionaries.py
```
> Sample output - your new data structure should have a "Final Grade" present for each student!
```html
{'Bob': {'Test 1': {'Score': 72, 'Weight': 20}, 'Test 2': {'Score': 95, 'Weight': 30}, 'Test 3': {'Score': 81, 'Weight': 10}, 'Project 1': {'Score': 95, 'Weight': 30}, 'Project 2': {'Score': 93, 'Weight': 10}, 'Final Grade': 88.8}, 'Sally': {'Test 1': {'Score': 72, 'Weight': 20}, 'Test 2': {'Score': 95, 'Weight': 30}, 'Test 3': {'Score': 81, 'Weight': 10}, 'Project 1': {'Score': 95, 'Weight': 30}, 'Project 2': {'Score': 93, 'Weight': 10}, 'Final Grade': 88.8}, 'Bill': {'Test 1': {'Score': 78, 'Weight': 20}, 'Test 2': {'Score': 72, 'Weight': 30}, 'Test 3': {'Score': 81, 'Weight': 10}, 'Project 1': {'Score': 95, 'Weight': 30}, 'Project 2': {'Score': 93, 'Weight': 10}, 'Final Grade': 83.10000000000001}, 'Fred': {'Test 1': {'Score': 92, 'Weight': 20}, 'Test 2': {'Score': 72, 'Weight': 30}, 'Test 3': {'Score': 81, 'Weight': 10}, 'Project 1': {'Score': 95, 'Weight': 30}, 'Project 2': {'Score': 93, 'Weight': 10}, 'Final Grade': 85.89999999999999}, 'Ted': {'Test 1': {'Score': 98, 'Weight': 20}, 'Test 2': {'Score': 72, 'Weight': 30}, 'Test 3': {'Score': 81, 'Weight': 10}, 'Project 1': {'Score': 95, 'Weight': 30}, 'Project 2': {'Score': 93, 'Weight': 10}, 'Final Grade': 87.10000000000001}}
```

## (Optional) Write our Updated Dictionary to a File

This section will not explicitly focus on the fundamentals of Python dictionaries, but rather how to optimally create and update files using Python so that we can store our dictionaries (particularly after they have been updated).

Let's jump in and write our dictionary to a new .py file! Add this code block to the bottom of your dictionaries.py file. This code block should not be indented at all! You are also welcome to comment out or remove the previous `print(student_scores_all_assignments)` statement.

```python
# (Optional) 
# Instead of simply printing our new dictionary to the console,
# Let's write it to a file using a few more lines of Python.

# The first example writes to a new Python file.

# Open/create a file with write ("w") permissions
new_python_file = open("updated_data.py","w")
# Pass our new dict to the write() method
# Notice we convert our dictionary to a string to be written
new_python_file.write(str(student_scores_all_assignments))
# Close the file
new_python_file.close()
# Review the updated_data.py file to see the results!
```

Execute the program once again!

```bash
python dictionaries.py
```
Now, you should be able to see an additional file - `updated_data.py` - in your IDE. Click into the file and take note of the results! Is this file as organized as you'd like for it to be? Let's jump forward and look at one more example of how to write a dictionary to a file in Python.

::page{title="(Optional) Write our Updated Dictionary to a JSON File using Python Libraries"}

For our last lesson, your dictionaries.py file should look exactly like the code block below. You can simply replace the full contents of your current dictionaries.py file with this code block. If you're interesting in reviewing a few of the differences or updating your file manually:
- Lines 64 to the end of the block below is the code we will use to write our dictionary to a .json file.
- Line 2 in the block below is now `import json` so that we can use Python's json library.
- The previous print() statement (line 41 below), and the previous exercise (writing to a .py file, lines 43-58 below) are commented out. This isn't explicitly required for this exercise to work properly, it's merely designed to clean things up a bit and comment out any code we aren't using at the moment.

*After* making sure your dictionaries.py file looks exactly like the code block below, execute the program one last time with our favorite `python dictionaries.py` command. You should see a new file named `updated_data.json` containing our updated dictionary (which stores each students' final grade)! And this file should look a lot more organized than our `updated_data.py` file from the previous exercise.

```python
from data import student_scores_all_assignments
import json

for student_names,another_dictionary in student_scores_all_assignments.items():
    # as we loop over this dictionary, the keys are student names, 
    # and the values are dictionaries representing all assignments

    # create a temporary integer to store the total score for each student
    # we create it here so that it resets to 0 for each student in the loop
    # meaning that we are calculating final scores for every student,
    # and storing it in this variable for each iteration of the loop
    student_total_course_score = int()

    for assignment_name,values in another_dictionary.items():
        # as we loop over this dictionary, the keys are assignment names, 
        # and the values are dictionaries representing the score and weight of the assignment

        # create a variable to store the points earned toward their final grade
        # for each assignment. notice how we access the 'Score' and 'Weight' 
        # values of our dictionary - with the syntax: dictionary_name[key_name]
        # e.g. values['Score'] and values['Weight']
        points_for_assignment = values['Score'] * (values['Weight'] / 100)

        # add the points for each assignment to our temporary integer we created
        # to store the total points for each student
        student_total_course_score += points_for_assignment

    # once we've calculated the final grade for each student, back in our first for loop
    # we will update the dictionary allocated to each student, each of which are
    # located in our original dictionary (that we added to data.py). 
    # the updated dictionary will now have a "Final Grade" key for each student,
    # where we've assigned the score that we calculated for them above.
    student_scores_all_assignments[student_names]['Final Grade'] = student_total_course_score

# Lastly, let's print our updated final dictionary (that we pulled in from data.py)
# You should see each student's final score listed.
# Take note: the actual data structure in data.py was NOT updated. 
# We are merely printing an instance of this object that we updated during the execution
# of our program. In the next module, we will work on updating files with Python
# so that our data will persist across multiple program executions!
#print(student_scores_all_assignments)

'''
# (Optional) 
# Instead of simply printing our new dictionary to the console,
# Let's write it to a file using a few more lines of Python.

# The first example writes to a new Python file.

# Open/create a file with write ("w") permissions
new_python_file = open("updated_data.py","w")
# Pass our new dict to the write() method
# Notice we convert our dictionary to a string to be written
new_python_file.write(str(student_scores_all_assignments))
# Close the file
new_python_file.close()
# Review the updated_data.py file to see the results!
'''

# In the second example below, we will use the JSON library
# to write our new dictionary to a .json file. 
# Notice the new import statement at the top of this file - "import json"

updated_dict_json = json.dumps(
    # pass our new dictionary once again
    student_scores_all_assignments,
    # extra parameters that make the file look pretty!
    # These parameters were taken directly from Python docs for the json library:
    # https://docs.python.org/3/library/json.html
    sort_keys=True,
    indent=4,
    separators=(',', ': ')
    )

# Just like the first example, we open/create a file
json_file = open("updated_data.json","w")
# Write to the file by passing our new json object to the write() method
json_file.write(updated_dict_json)
# Close the file
json_file.close()
# Review the updated_data.json file to see the results!
# How does it compare to updated_data.py?
```

## Summary

## Next Steps