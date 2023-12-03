from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


recipes = Blueprint('recipes', __name__)

# Get all the recipes from the database
@recipes.route('/recipes', methods=['GET'])
def get_recipes():
    # get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for a list of recipes
    cursor.execute('SELECT Title, Price, ROUND(Calories / Servings) as "Calories per Serving", Servings, Name as Category, DATE_FORMAT(DATE(PostDate), "%m/%d/%Y") as PostDate FROM Recipes r JOIN RecipeCategories rc ON r.recipeID = rc.RecipeID JOIN Categories c ON rc.CategoryID = c.CategoryID JOIN (SELECT r.RecipeID, sum(ri.Units * i.UnitPrice) as Price, sum(i.UnitCalories) as CaloriesFROM Recipes r LEFT OUTER JOIN RecipeIngredients ri on r.RecipeID = ri.RecipeID JOIN Ingredients i on ri.IngredientID = i.IngredientID GROUP BY r.RecipeID) recipe_attributes ON r.RecipeID = recipe_attributes.RecipeID')

    # grab the column headers from the returned data
    column_headers = [x[0] for x in cursor.description]

    # create an empty dictionary object to use in 
    # putting column headers together with data
    json_data = []

    # fetch all the data from the cursor
    theData = cursor.fetchall()

    # for each of the rows, zip the data elements together with
    # the column headers. 
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    return jsonify(json_data)

@recipes.route('/recipes/<recipe_id>', methods=['GET'])
def get_recipe_details (recipe_id):

    query = 'SELECT Title, Description, Instructions, Servings, PrepTime, CookTime, Price, Calories, Protein, Fiber\
        FROM Recipes r JOIN (SELECT ri.RecipeID,\
                                SUM(Units * UnitPrice) as Price,\
                                ROUND(SUM(Units * UnitCalories) / Servings) as Calories,\
                                ROUND(SUM(Units * UnitProtein) / Servings) as Protein,\
                                ROUND(SUM(Units * UnitFiber) / Servings) as Fiber\
                            FROM Ingredients i\
                                JOIN RecipeIngredients ri\
                                    ON i.IngredientID = ri.IngredientID\
                                JOIN Recipes r\
                                    ON ri.RecipeID = r.RecipeID\
                            WHERE ri.RecipeID = ' + str(recipe_id) + ') ingredient_details\
            ON r.RecipeID = ingredient_details.RecipeID\
        WHERE r.RecipeID = ' + str(recipe_id)
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(column_headers, row)))
    return jsonify(json_data)


@recipes.route('/recipes/<recipe_id>/ingredients', methods=['GET'])
def get_recipe_ingredients (recipe_id):

    query = 'SELECT Name, Units\
        FROM Ingredients i\
            JOIN RecipeIngredients ri\
                ON i.IngredientID = ri.IngredientID\
        WHERE ri.RecipeID = ' + str(recipe_id)
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(column_headers, row)))
    return jsonify(json_data)


@recipes.route('/recipes/<recipe_id>/appliances', methods=['GET'])
def get_recipe_appliances (recipe_id):

    query = 'SELECT Name\
        FROM Appliances ap\
            JOIN RecipeAppliances rap\
                ON ap.ApplianceID = rap.ApplianceID\
        WHERE rap.RecipeID =' + str(recipe_id)
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(column_headers, row)))
    return jsonify(json_data)


@recipes.route('/recipes/<recipe_id>/allergens', methods=['GET'])
def get_recipe_allergens (recipe_id):

    query = 'SELECT a.Name as Name\
        FROM Ingredients i\
            JOIN RecipeIngredients ri\
                ON i.IngredientID = ri.IngredientID\
            JOIN IngredientAllergens ia\
                ON i.IngredientID = ia.IngredientID\
            JOIN Allergens a\
                ON ia.AllergenID = a.AllergenID\
        WHERE ri.RecipeID =' + str(recipe_id)
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(column_headers, row)))
    return jsonify(json_data)


@recipes.route('/recipes/<recipe_id>/reviews', methods=['GET'])
def get_recipe_reviews (recipe_id):

    query = 'SELECT UserID, ReviewContent, Rating\
        FROM Reviews\
        WHERE RecipeID =' + str(recipe_id)
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(column_headers, row)))
    return jsonify(json_data)


@recipes.route('/recipes/<recipe_id>/reviews/<user_id>', methods=['GET'])
def get_recipe_reviews_user (recipe_id, user_id):

    query = 'SELECT UserID, ReviewContent, Rating\
        FROM Reviews\
        WHERE RecipeID =' + str(recipe_id) + 'AND UserID =' + str(user_id)
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(column_headers, row)))
    return jsonify(json_data)


@recipes.route('/recipes/<recipe_id>/ingredients/<ingredient_id>', methods=['GET'])
def get_ingredient_attrs (recipe_id, ingredient_id):

    query = 'SELECT Name, UnitPrice, UnitCalories, UnitProtein, UnitFiber\
        FROM Ingredients\
        WHERE IngredientID =' + str(ingredient_id)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(column_headers, row)))
    return jsonify(json_data)


@recipes.route('/recipes/<recipe_id>/ingredients/<ingredient_id>', methods=['GET'])
def get_ingredient_allergens (recipe_id, ingredient_id):

    query = 'SELECT i.Name as Name, a.Name as Allergens\
        FROM IngredientAllergens ia\
            JOIN Allergens a\
                ON ia.AllergenID = a.AllergenID\
            JOIN Ingredients i\
                ON ia.IngredientID = i.IngredientID\
        WHERE ia.IngredientID = ' + str(ingredient_id)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(column_headers, row)))
    return jsonify(json_data)


@recipes.route('/recipes/<recipe_id>/ingredients/<ingredient_id>', methods=['GET'])
def get_ingredient_substitutes (recipe_id, ingredient_id):

    query = 'SELECT Name\
        FROM Ingredients i\
            JOIN Substitutes s\
                ON i.IngredientID = s.IngredientID\
        WHERE i.IngredientID = ' + str(ingredient_id)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(column_headers, row)))
    return jsonify(json_data)


@recipes.route('/recipes', methods=['POST'])
def add_recipe():
    
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    title = the_data['recipe_title']
    description = the_data['recipe_description']
    instructions = the_data['recipe_instructions']
    preptime = the_data['recipe_preptime']
    cooktime = the_data['recipe_cooktime']
    user_id = the_data['user_id']

    # Constructing the query
    query = 'insert into Recipes (Title, Instructions, Servings, PrepTime, CookTime, UserTime) values ("'
    query += title + '", "'
    query += description + '", "'
    query += instructions + '", '
    query += str(preptime) + '", '
    query += str(cooktime) + '", '
    query += str(user_id) + ')'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'


@recipes.route('/recipes', methods=['POST'])
def add_recipe_ingredients():
    
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    recipe_id = the_data['recipe_id']
    ingredient_id = the_data['ingredient_id']
    units = the_data['units']

    # Constructing the query
    query = 'insert into RecipeIngredients (RecipeID, IngredientID, Units) values ("'
    query += str(recipe_id) + '", "'
    query += str(ingredient_id) + '", "'
    query += str(units) + ')'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'


@recipes.route('/recipes', methods=['POST'])
def add_recipe_appliances():
    
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    recipe_id = the_data['product_name']
    appliance_id = the_data['product_description']

    # Constructing the query
    query = 'insert into RecipeAppliances (RecipeID, ApplianceID) values ("'
    query += str(recipe_id) + '", "'
    query += str(appliance_id) + ')'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'


@recipes.route('/recipes/<recipe_id>/reviews', methods=['POST'])
def add_review(recipe_id):
    
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    user_id = the_data['user_id']
    review_content = the_data['review_content']
    rating = the_data['rating']

    # Constructing the query
    query = 'insert into Reviews (UserID, RecipeID, ReviewContent, Rating) values ("'
    query += str(user_id) + '", "'
    query += str(recipe_id) + '", "'
    query += str(review_content) + '", "'
    query += str(rating) + ')'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'

    

# # get the top 5 products from the database
# @products.route('/mostExpensive')
# def get_most_pop_products():
#     cursor = db.get_db().cursor()
#     query = '''
#         SELECT product_code, product_name, list_price, reorder_level
#         FROM products
#         ORDER BY list_price DESC
#         LIMIT 5
#     '''
#     cursor.execute(query)
#     # grab the column headers from the returned data
#     column_headers = [x[0] for x in cursor.description]

#     # create an empty dictionary object to use in 
#     # putting column headers together with data
#     json_data = []

#     # fetch all the data from the cursor
#     theData = cursor.fetchall()

#     # for each of the rows, zip the data elements together with
#     # the column headers. 
#     for row in theData:
#         json_data.append(dict(zip(column_headers, row)))

#     return jsonify(json_data)


# @products.route('/tenMostExpensive', methods=['GET'])
# def get_10_most_expensive_products():
    
#     query = '''
#         SELECT product_code, product_name, list_price, reorder_level
#         FROM products
#         ORDER BY list_price DESC
#         LIMIT 10
#     '''

#     cursor = db.get_db().cursor()
#     cursor.execute(query)

#     column_headers = [x[0] for x in cursor.description]

#     # create an empty dictionary object to use in 
#     # putting column headers together with data
#     json_data = []

#     # fetch all the data from the cursor
#     theData = cursor.fetchall()

#     # for each of the rows, zip the data elements together with
#     # the column headers. 
#     for row in theData:
#         json_data.append(dict(zip(column_headers, row)))
    
#     return jsonify(json_data)

# @products.route('/product', methods=['POST'])
# def add_new_product():
    
#     # collecting data from the request object 
#     the_data = request.json
#     current_app.logger.info(the_data)

#     #extracting the variable
#     name = the_data['product_name']
#     description = the_data['product_description']
#     price = the_data['product_price']
#     category = the_data['product_category']

#     # Constructing the query
#     query = 'insert into products (product_name, description, category, list_price) values ("'
#     query += name + '", "'
#     query += description + '", "'
#     query += category + '", '
#     query += str(price) + ')'
#     current_app.logger.info(query)

#     # executing and committing the insert statement 
#     cursor = db.get_db().cursor()
#     cursor.execute(query)
#     db.get_db().commit()
    
#     return 'Success!'

# ### Get all product categories
# @products.route('/categories', methods = ['GET'])
# def get_all_categories():
#     query = '''
#         SELECT DISTINCT category AS label, category as value
#         FROM products
#         WHERE category IS NOT NULL
#         ORDER BY category
#     '''

#     cursor = db.get_db().cursor()
#     cursor.execute(query)

#     json_data = []
#     # fetch all the column headers and then all the data from the cursor
#     column_headers = [x[0] for x in cursor.description]
#     theData = cursor.fetchall()
#     # zip headers and data together into dictionary and then append to json data dict.
#     for row in theData:
#         json_data.append(dict(zip(column_headers, row)))
    
#     return jsonify(json_data)