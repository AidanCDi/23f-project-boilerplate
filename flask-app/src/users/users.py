from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


users = Blueprint('users', __name__)

@users.route('/users/<user_id>', methods=['GET'])
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


@users.route('/users/<user_id>', methods=['GET'])
def get_users_recipes (user_id):

    query = 'SELECT Title, Price, ROUND(Calories / Servings) as "Calories per Serving", Servings, Name as Category, DATE_FORMAT(DATE(PostDate), "%m/%d/%Y") as PostDate\
        FROM Recipes r\
            JOIN RecipeCategories rc\
                ON r.recipeID = rc.RecipeID\
            JOIN Categories c\
                ON rc.CategoryID = c.CategoryID\
            JOIN (SELECT r.RecipeID, sum(ri.Units * i.UnitPrice) as Price, sum(i.UnitCalories) as Calories\
                FROM Recipes r\
                    LEFT OUTER JOIN RecipeIngredients ri on r.RecipeID = ri.RecipeID\
                    JOIN Ingredients i on ri.IngredientID = i.IngredientID\
                GROUP BY r.RecipeID) recipe_attributes\
                ON r.RecipeID = recipe_attributes.RecipeID\
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


@users.route('/users/<user_id>', methods=['GET'])
def get_all_plans (user_id):

    query = 'SELECT p.PlanName, COUNT(pr.RecipeID) as Recipe, SUM(Price) as Price\
        FROM Plans p\
            JOIN PlanRecipes pr\
                ON p.PlanName = pr.PlanName AND p.UserID = pr.UserID\
            JOIN (SELECT r.RecipeID, sum(ri.Units * i.UnitPrice) as Price\
                FROM Recipes r\
                    LEFT OUTER JOIN RecipeIngredients ri on r.RecipeID = ri.RecipeID\
                    JOIN Ingredients i on ri.IngredientID = i.IngredientID\
                GROUP BY r.RecipeID) recipe_attributes\
                ON pr.RecipeID = recipe_attributes.RecipeID\
        WHERE p.UserID = ' + str(user_id) + '\
        GROUP BY p.PlanName ' 
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(column_headers, row)))
    return jsonify(json_data)


@users.route('/users/<user_id>/plans/<plan_name>', methods=['GET'])
def get_all_plans (user_id, plan_name):

    query = 'SELECT Title, Price, "Calories per Serving", Servings, Category, PostDate\
        FROM PlanRecipes pr\
            JOIN (SELECT r.RecipeID, Title, Price, ROUND(Calories / Servings) as "Calories per Serving", Servings, Name as Category, DATE_FORMAT(DATE(PostDate), "%m/%d/%Y") as PostDate\
                FROM Recipes r\
                    JOIN RecipeCategories rc\
                        ON r.recipeID = rc.RecipeID\
                    JOIN Categories c\
                        ON rc.CategoryID = c.CategoryID\
                    JOIN (SELECT r.RecipeID, sum(ri.Units * i.UnitPrice) as Price, sum(i.UnitCalories) as Calories\
                            FROM Recipes r\
                                LEFT OUTER JOIN RecipeIngredients ri on r.RecipeID = ri.RecipeID\
                                JOIN Ingredients i on ri.IngredientID = i.IngredientID\
                            GROUP BY r.RecipeID) recipe_attributes\
                        ON r.RecipeID = recipe_attributes.RecipeID) r2\
                ON pr.RecipeID = r2.RecipeID\
        WHERE pr.UserID = ' + str(user_id) + ' AND pr.PlanName = ' + str(plan_name)
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