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
print(student_scores_all_assignments)


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