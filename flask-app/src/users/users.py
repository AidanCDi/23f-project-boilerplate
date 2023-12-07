from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


users = Blueprint('users', __name__)

### GET Routes ###



# Get relevant information for a specific user (their socials, any recipes they posted, and any meal plans they've created)
@users.route('/users/<user_id>/socials', methods=['GET'])
def get_users_socials (user_id):

    query = 'SELECT Platform, Username\
        FROM Users u\
            JOIN Socials s\
                ON u.UserID = s.UserID\
        WHERE u.UserID = ' + str(user_id)
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(column_headers, row)))
    return jsonify(json_data)

@users.route('/users/<user_id>/recipes', methods=['GET'])
def get_users_recipes (user_id):

    query = 'SELECT r.RecipeID as RecipeID, Title, Description, Instructions, Price, ROUND(Calories / Servings) as Calories, ROUND(Fiber / Servings) as Fiber, ROUND(Protein / Servings) as Protein, Servings, DATE_FORMAT(DATE(PostDate), "%m/%d/%Y") as PostDate, Rating \
        FROM Recipes r \
            JOIN (SELECT r.RecipeID, sum(ri.Units * i.UnitPrice) as Price, sum(i.UnitCalories) as Calories, sum(i.UnitFiber) as Fiber, sum(i.UnitProtein) as Protein \
                FROM Recipes r \
                    LEFT OUTER JOIN RecipeIngredients ri \
                        ON r.RecipeID = ri.RecipeID \
                    JOIN Ingredients i on ri.IngredientID = i.IngredientID \
                GROUP BY r.RecipeID) recipe_attributes \
                ON r.RecipeID = recipe_attributes.RecipeID \
                    LEFT OUTER JOIN (SELECT RecipeID, round(avg(Rating), 2) as Rating FROM Reviews GROUP BY RecipeID) reviews ON r.RecipeID = reviews.RecipeID\
        WHERE r.UserID = ' + str(user_id)
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(column_headers, row)))
    return jsonify(json_data)

@users.route('/users/<user_id>/plans', methods=['GET'])
def get_all_plans (user_id):

    query = 'SELECT p.PlanName, p.PlanID, COUNT(pr.RecipeID) as Recipe, SUM(Price) as Price\
        FROM Plans p\
            LEFT OUTER JOIN PlanRecipes pr\
                ON p.PlanID = pr.PlanID\
            LEFT OUTER JOIN (SELECT r.RecipeID, sum(ri.Units * i.UnitPrice) as Price\
                FROM Recipes r\
                    LEFT OUTER JOIN RecipeIngredients ri on r.RecipeID = ri.RecipeID\
                    JOIN Ingredients i on ri.IngredientID = i.IngredientID\
                GROUP BY r.RecipeID) recipe_attributes\
                ON pr.RecipeID = recipe_attributes.RecipeID\
        WHERE p.UserID = ' + str(user_id) + '\
        GROUP BY p.PlanID' 
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(column_headers, row)))
    return jsonify(json_data)



# Gets information about a specific meal plan
@users.route('/users/<user_id>/plans/<plan_id>', methods=['GET'])
def get_plan_recipes (user_id, plan_id):

    query = "SELECT all_recipes.RecipeID as RecipeID, Title, Description, Price, Calories, Fiber, Protein, Servings, Rating FROM PlanRecipes pr\
         JOIN (SELECT r.RecipeID as RecipeID, Title, Description, Instructions, Price, ROUND(Calories / Servings) as Calories, ROUND(Fiber / Servings) as Fiber, ROUND(Protein / Servings) as Protein, Servings, DATE_FORMAT(DATE(PostDate), '%m/%d/%Y') as PostDate, Rating\
        FROM Recipes r\
            JOIN (SELECT r.RecipeID, sum(ri.Units * i.UnitPrice) as Price, sum(i.UnitCalories) as Calories, sum(i.UnitFiber) as Fiber, sum(i.UnitProtein) as Protein\
                FROM Recipes r\
                    LEFT OUTER JOIN RecipeIngredients ri\
                        ON r.RecipeID = ri.RecipeID\
                    JOIN Ingredients i on ri.IngredientID = i.IngredientID\
                GROUP BY r.RecipeID) recipe_attributes\
                ON r.RecipeID = recipe_attributes.RecipeID\
                    LEFT OUTER JOIN (SELECT RecipeID, round(avg(Rating), 2) as Rating FROM Reviews GROUP BY RecipeID) reviews ON r.RecipeID = reviews.RecipeID) all_recipes ON pr.RecipeID = all_recipes.RecipeID\
         WHERE PlanID = " + str(plan_id) + " AND UserID = " + str(user_id)
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(column_headers, row)))
    return jsonify(json_data)



# Populates dropdowns
@users.route('/users', methods=['GET'])
def get_users ():

    query = 'SELECT CONCAT(FirstName, " ", LastName) as name, UserID as code FROM Users'
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(column_headers, row)))
    return jsonify(json_data)

@users.route('/users/<user_id>/plans/list', methods=['GET'])
def get_all_plans_list (user_id):

    query = 'SELECT PlanName as name, PlanID as code FROM Plans WHERE UserID = ' + str(user_id) 
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(column_headers, row)))
    return jsonify(json_data)



### POST Routes ###



# adds a meal plan to a user's profile
@users.route('/users/<user_id>/plans', methods=['POST'])
def add_meal_plan(user_id):
    
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    plan_name = the_data['plan_name']

    # Constructing the query
    query = 'insert into Plans (UserID, PlanName) values ('
    query += str(user_id) + ', "'
    query += plan_name +  ' ")'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'



# adds a recipe to one of a user's meal plans
@users.route('/users/<user_id>/plans/<plan_id>/<recipe_id>', methods=['POST'])
def add_recipe_meal_plan(user_id, plan_id, recipe_id):
    
    # Constructing the query
    query = 'insert into PlanRecipes (PlanID, UserID, RecipeID) values (' + str(plan_id) + ', ' + str(user_id) + ', ' + str(recipe_id) + ')'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'



### PUT Routes ###



# Changes the name of a user's meal plan
@users.route('/users/<user_id>/plans/<plan_id>', methods=['PUT'])
def modify_meal_plan(user_id, plan_id):
    
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    plan_name = the_data['plan_name']

    # Constructing the query
    query = 'UPDATE Plans SET PlanName = "' + plan_name + '" WHERE PlanID = ' + str(plan_id)
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'



### DELETE Routes ###



# Deletes a certain meal plan created by a certain user
@users.route('/users/<user_id>/plans/<plan_id>', methods=['DELETE'])
def delete_plan(user_id, plan_id):
    
    # Constructing the query
    query = 'DELETE FROM Plans WHERE PlanID = ' + str(plan_id)
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'



# Deletes a certain recipe posted by a certain user
@users.route('/users/<user_id>/recipes/<recipe_id>', methods=['DELETE'])
def delete_recipe(user_id, recipe_id):

    # Constructing the query
    query = 'DELETE FROM Recipes WHERE RecipeID = ' + str(recipe_id)
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'



# Deletes a recipe in a meal plan
@users.route('/users/<user_id>/plans/<plan_id>/<recipe_id>', methods=['DELETE'])
def delete_recipe_meal_plan(user_id, plan_id, recipe_id):

    # Constructing the query
    query = 'DELETE FROM PlanRecipes WHERE RecipeID = ' + str(recipe_id) + ' AND PlanID = ' + str(plan_id)
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'