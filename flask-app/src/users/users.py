from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


users = Blueprint('users', __name__)

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

    query = 'SELECT r.RecipeID as RecipeID, Title, Description, Instructions, Price, ROUND(Calories / Servings) as Calories, ROUND(Fiber / Servings) as Fiber, ROUND(Protein / Servings) as Protein, Servings, Category, DATE_FORMAT(DATE(PostDate), "%m/%d/%Y") as PostDate, Rating \
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

    query = 'SELECT p.PlanName, COUNT(pr.RecipeID) as Recipe, SUM(Price) as Price\
        FROM Plans p\
            JOIN PlanRecipes pr\
                ON p.PlanID = pr.PlanID\
            JOIN (SELECT r.RecipeID, sum(ri.Units * i.UnitPrice) as Price\
                FROM Recipes r\
                    LEFT OUTER JOIN RecipeIngredients ri on r.RecipeID = ri.RecipeID\
                    JOIN Ingredients i on ri.IngredientID = i.IngredientID\
                GROUP BY r.RecipeID) recipe_attributes\
                ON pr.RecipeID = recipe_attributes.RecipeID\
        WHERE p.UserID = ' + str(user_id) + '\
        GROUP BY p.PlanID ' 
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(column_headers, row)))
    return jsonify(json_data)


@users.route('/users/<user_id>/plans/<plan_id>', methods=['GET'])
def get_plan_recipes (user_id, plan_id):

    query = "SELECT all_recipes.RecipeID as RecipeID, Title, Description, Price, Calories, Fiber, Protein, Servings, Category, Rating FROM PlanRecipes pr\
         JOIN (SELECT r.RecipeID as RecipeID, Title, Description, Instructions, Price, ROUND(Calories / Servings) as Calories, ROUND(Fiber / Servings) as Fiber, ROUND(Protein / Servings) as Protein, Servings, Category, DATE_FORMAT(DATE(PostDate), '%m/%d/%Y') as PostDate, Rating\
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


@users.route('/users/<user_id>/plans', methods=['POST'])
def add_review(user_id):
    
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    plan_name = the_data['plan_name']

    # Constructing the query
    query = 'insert into RecipeAppliances (UserID, PlanName) values ("'
    query += str(user_id) + '", "'
    query += plan_name +  ')'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'