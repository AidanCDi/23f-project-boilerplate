from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


recipes = Blueprint('recipes', __name__)

### GET Routes ###

# Gets a table of all recipes
@recipes.route('/recipes', methods=['GET'])
def get_recipes():
    # get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for a list of recipes
    cursor.execute('SELECT r.RecipeID as RecipeID, Title, Description, Instructions, Price, ROUND(Calories / Servings) as Calories, ROUND(Fiber / Servings) as Fiber, ROUND(Protein / Servings) as Protein, Servings, DATE_FORMAT(DATE(PostDate), "%m/%d/%Y") as PostDate, Rating \
        FROM Recipes r \
            JOIN (SELECT r.RecipeID, sum(ri.Units * i.UnitPrice) as Price, sum(i.UnitCalories) as Calories, sum(i.UnitFiber) as Fiber, sum(i.UnitProtein) as Protein \
                FROM Recipes r \
                    LEFT OUTER JOIN RecipeIngredients ri \
                        ON r.RecipeID = ri.RecipeID \
                    JOIN Ingredients i on ri.IngredientID = i.IngredientID \
                GROUP BY r.RecipeID) recipe_attributes \
                ON r.RecipeID = recipe_attributes.RecipeID \
                    LEFT OUTER JOIN (SELECT RecipeID, round(avg(Rating), 2) as Rating FROM Reviews GROUP BY RecipeID) reviews ON r.RecipeID = reviews.RecipeID')

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






# Gets a list of attributes for a specific recipe/ingredient
@recipes.route('/recipes/<recipe_id>', methods=['GET'])
def get_recipe_details (recipe_id):

    query = 'SELECT Title, Description, Instructions, Servings, PrepTime, CookTime, Price, Calories, Protein, Fiber, CONCAT(FirstName, " ", LastName) as Name, avg(Rating)\
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
                JOIN Users u on r.UserID = u.UserID\
                JOIN Reviews rev on r.RecipeID = rev.RecipeID\
                WHERE r.RecipeID = ' + str(recipe_id) + '\
        GROUP BY r.RecipeID'
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(column_headers, row)))
    return jsonify(json_data)

@recipes.route('/ingredients/<ingredient_id>', methods=['GET'])
def get_ingredient_attrs (ingredient_id):

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






# Gets information about various aspects of a recipe
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

@recipes.route('/recipes/<recipe_id>/categories', methods=['GET'])
def get_recipe_categories (recipe_id):

    query = 'SELECT Type, Name FROM RecipeCategories rc JOIN Categories c on rc.CategoryID = c.CategoryID \
        WHERE rc.RecipeID = ' + str(recipe_id)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(column_headers, row)))
    return jsonify(json_data)






# Gets information about various aspects of an ingredient
@recipes.route('/ingredients/<ingredient_id>/allergens', methods=['GET'])
def get_ingredient_allergens (ingredient_id):

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

@recipes.route('/ingredients/<ingredient_id>/substitutes', methods=['GET'])
def get_ingredient_substitutes (ingredient_id):





# Gets pertinent information about reviews for a recipes
@recipes.route('/recipes/<recipe_id>/reviews', methods=['GET'])
def get_recipe_reviews (recipe_id):





# Populate Dropdowns
@recipes.route('/recipes/list', methods=['GET'])
def get_recipes_list ():

    query = 'SELECT Title as name, RecipeID as code FROM Recipes'
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(column_headers, row)))
    return jsonify(json_data)

@recipes.route('/ingredients', methods=['GET'])
def get_ingredients ():

    query = 'SELECT IngredientID as code, Name as name FROM Ingredients'

    cursor = db.get_db().cursor()
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(column_headers, row)))
    return jsonify(json_data)

@recipes.route('/appliances', methods=['GET'])
def get_appliances ():

    query = 'SELECT ApplianceID as code, Name as name FROM Appliances'

    cursor = db.get_db().cursor()
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(column_headers, row)))
    return jsonify(json_data)

@recipes.route('/categories', methods=['GET'])
def get_category_types ():

    query = 'SELECT Type as label, Type as value FROM Categories GROUP BY Type'

    cursor = db.get_db().cursor()
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_dict = dict(zip(column_headers, row))
        json_dict['children'] = get_categories (row[0])
        json_data.append(json_dict)
    return jsonify(json_data)

def get_categories (type):

    query = 'SELECT Name as label, CategoryID as value FROM Categories WHERE Type = "' + str(type) + '"'

    cursor = db.get_db().cursor()
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(column_headers, row)))
    return json_data


    query = 'SELECT CONCAT(FirstName, " ", LastName) as User, u.UserID as UserID, ReviewContent, ReviewID, Rating\
        FROM Reviews r JOIN Users u\
        ON r.UserID = u.UserID\
        WHERE RecipeID = ' + str(recipe_id)
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(column_headers, row)))
    return jsonify(json_data)


    query = 'SELECT Name\
        FROM Ingredients i\
            JOIN Substitutes s\
                ON i.IngredientID = s.SubstituteID\
        WHERE s.IngredientID = ' + str(ingredient_id)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(column_headers, row)))
    return jsonify(json_data)







### POST Routes ###







# Adds a recipe to database (inserts not only to Recipes but to RecipeIngredients, RecipeCategories, etc.)
@recipes.route('/recipes', methods=['POST'])
def add_recipe():
    
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    title = the_data['Title']
    description = the_data['Description']
    instructions = the_data['Instructions']
    servings = the_data['Servings']
    preptime = the_data['PrepTime']
    cooktime = the_data['CookTime']
    ingredients = the_data['Ingredients']
    appliances = the_data['Appliances']
    categories = the_data['Categories']
    user_id = the_data['UserID']

    # Constructing the query
    query = 'insert into Recipes (Title, Description, Instructions, Servings, PrepTime, CookTime, UserID) values ("'
    query += str(title) + '", "'
    query += str(description) + '", "'
    query += str(instructions) + '", '
    query += str(servings) + ', '
    query += str(preptime) + ', '
    query += str(cooktime) + ', '
    query += str(user_id) + ')'
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)

    for ingredient in ingredients:
        ingredient_query = 'insert into RecipeIngredients (RecipeID, IngredientID, Units) values ((select max(RecipeID) from Recipes), ' 
        ingredient_query += str(ingredient) + ', 1)'
        ingredient_cursor = db.get_db().cursor()
        ingredient_cursor.execute(ingredient_query)

    for appliance in appliances:
        appliance_query = 'insert into RecipeAppliances (RecipeID, ApplianceID) values ((select max(RecipeID) from Recipes), '
        appliance_query += str(appliance) + ')'
        appliance_cursor = db.get_db().cursor()
        appliance_cursor.execute(appliance_query)

    for category in categories:
        category_query = 'insert into RecipeCategories (RecipeID, CategoryID) values ((select max(RecipeID) from Recipes), '
        category_query += str(category) + ')'
        category_cursor = db.get_db().cursor()
        category_cursor.execute(category_query)

    # executing and committing the insert statement 
    db.get_db().commit()
    
    return 'Success!'


    
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


# Adds a new review for the specified recipe posted by the specified user
@recipes.route('/recipes/<recipe_id>/reviews/<user_id>', methods=['POST'])
def add_review(recipe_id, user_id):
    
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    review_content = the_data['review_content']
    rating = the_data['rating']

    # Constructing the query
    query = 'insert into Reviews (UserID, RecipeID, ReviewContent, Rating) values ("'
    query += str(user_id) + '", "'
    query += str(recipe_id) + '", "'
    query += str(review_content) + '", "'
    query += str(rating) + '")'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'


#### PUT Routes ###

# Updates a review that was made by a certain user
@recipes.route('/recipes/<recipe_id>/reviews/<review_id>', methods=['PUT'])
def edit_review(recipe_id, review_id):
    
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    review_content = the_data['review_content']
    rating = the_data['rating']

    # Constructing the query
    query = 'UPDATE Reviews SET '
    query += 'ReviewContent = "' + str(review_content) + '", '
    query += 'Rating = ' + str(rating) + ' '
    query += 'WHERE ReviewID = ' + str(review_id)
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'


### DELETE Routes ###

# Deletes a review that was made by a certain user
@recipes.route('/recipes/<recipe_id>/reviews/<review_id>', methods=['DELETE'])
def delete_review(recipe_id, review_id):
    
    # Constructing the query
    query = 'DELETE FROM Reviews WHERE ReviewID = ' + str(review_id)
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'

