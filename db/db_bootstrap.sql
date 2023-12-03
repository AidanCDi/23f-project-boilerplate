-- This file is to bootstrap a database for the CS3200 project. 

-- Create a new database.  You can change the name later.  You'll
-- need this name in the FLASK API file(s),  the AppSmith 
-- data source creation.
CREATE DATABASE MealPrepPlus;

-- Via the Docker Compose file, a special user called webapp will 
-- be created in MySQL. We are going to grant that user 
-- all privilages to the new database we just created. 
-- TODO: If you changed the name of the database above, you need 
-- to change it here too.
GRANT ALL PRIVILEGES ON MealPrepPlus.* TO 'webapp'@'%';
FLUSH PRIVILEGES;

-- Move into the database we just created.
-- TODO: If you changed the name of the database above, you need to
-- change it here too. 
USE MealPrepPlus;

-- Put your DDL 
CREATE TABLE Users (
    UserID INTEGER AUTO_INCREMENT NOT NULL UNIQUE,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    PRIMARY KEY (UserID)
);

CREATE TABLE Categories (
    CategoryID INTEGER AUTO_INCREMENT NOT NULL UNIQUE,
    Type VARCHAR(255),
    Name VARCHAR(255) NOT NULL,
    PRIMARY KEY (CategoryID),
    INDEX CategoryIndex (Name)
);

CREATE TABLE Recipes (
    RecipeID INTEGER AUTO_INCREMENT NOT NULL UNIQUE,
    Title VARCHAR(255) NOT NULL,
    Description TEXT,
    Instructions TEXT NOT NULL,
    Servings INTEGER NOT NULL,
    PrepTime INTEGER,
    CookTime INTEGER,
    PostDate DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    LastModified DATETIME DEFAULT CURRENT_TIMESTAMP
                     ON UPDATE CURRENT_TIMESTAMP NOT NULL,
    UserID INTEGER NOT NULL,
    PRIMARY KEY(RecipeID),
    FOREIGN KEY (UserID)
        REFERENCES Users(UserID),
    INDEX RecipeTitleIndex (Title),
    INDEX RecipeServingsIndex (Servings),
    INDEX RecipePrepTimeIndex (PrepTime),
    INDEX RecipeCookTimeIndex (CookTime),
    INDEX UserIDIndex (UserID)
);

CREATE TABLE Appliances (
    ApplianceID INTEGER AUTO_INCREMENT NOT NULL UNIQUE,
    Name VARCHAR(255) NOT NULL,
    PRIMARY KEY(ApplianceID),
    INDEX ApplianceNameIndex (Name)
);

CREATE TABLE Ingredients (
    IngredientID INTEGER AUTO_INCREMENT NOT NULL UNIQUE,
    Name VARCHAR(255) NOT NULL,
    UnitPrice DECIMAL NOT NULL,
    UnitCalories INTEGER NOT NULL,
    UnitProtein INTEGER NOT NULL,
    UnitFiber INTEGER NOT NULL,
    PRIMARY KEY (IngredientID),
    INDEX IngredientPriceIndex (UnitPrice),
    INDEX IngredientCaloriesIndex (UnitCalories),
    INDEX IngredientProteinIndex (UnitProtein),
    INDEX IngredientFiberIndex (UnitFiber)
);

CREATE TABLE Allergens (
    AllergenID INTEGER AUTO_INCREMENT NOT NULL UNIQUE,
    Name VARCHAR(255) NOT NULL UNIQUE,
    PRIMARY KEY(AllergenID),
    INDEX AllergenNameIndex (Name)
);

CREATE TABLE Plans (
    UserID INTEGER NOT NULL,
    PlanName VARCHAR(255) NOT NULL,
    PRIMARY KEY (UserID, PlanName),
    FOREIGN KEY (UserID)
        REFERENCES Users(UserID)
);

CREATE TABLE Socials (
    UserID INTEGER NOT NULL,
    Platform VARCHAR(255) NOT NULL,
    Username VARCHAR(255) NOT NULL,
    PRIMARY KEY (UserID, Platform),
    FOREIGN KEY (UserID)
        REFERENCES Users(UserID)
);

CREATE TABLE Reviews (
    UserID INTEGER NOT NULL,
    RecipeID INTEGER NOT NULL,
    ReviewID INTEGER AUTO_INCREMENT NOT NULL UNIQUE,
    ReviewContent TEXT,
    Rating INTEGER,
    PRIMARY KEY (ReviewID),
    FOREIGN KEY (UserID)
        REFERENCES Users(UserID),
    FOREIGN KEY (RecipeID)
        REFERENCES Recipes(RecipeID),
    INDEX ReviewRating (Rating)
);

CREATE TABLE RecipeCategories (
    RecipeID INTEGER NOT NULL,
    CategoryID INTEGER NOT NULL,
    PRIMARY KEY (RecipeID, CategoryID),
    FOREIGN KEY (RecipeID)
        REFERENCES Recipes(RecipeID),
    FOREIGN KEY (CategoryID)
        REFERENCES Categories(CategoryID)
);

CREATE TABLE RecipeAppliances (
    RecipeID INTEGER NOT NULL,
    ApplianceID INTEGER NOT NULL,
    PRIMARY KEY (RecipeID, ApplianceID),
    FOREIGN KEY (RecipeID)
        REFERENCES Recipes(RecipeID),
    FOREIGN KEY (ApplianceID)
        REFERENCES Appliances(ApplianceID)
);

CREATE TABLE RecipeIngredients (
    RecipeID INTEGER NOT NULL,
    IngredientID INTEGER NOT NULL,
    Units INTEGER NOT NULL,
    PRIMARY KEY (RecipeID, IngredientID),
    FOREIGN KEY (RecipeID)
        REFERENCES Recipes(RecipeID),
    FOREIGN KEY (IngredientID)
        REFERENCES Ingredients(IngredientID)
);

CREATE TABLE Substitutes (
    IngredientID INTEGER NOT NULL,
    SubstituteID INTEGER NOT NULL,
    PRIMARY KEY (IngredientID, SubstituteID),
    FOREIGN KEY (IngredientID)
        REFERENCES Ingredients(IngredientID),
    FOREIGN KEY (SubstituteID)
        REFERENCES Ingredients(IngredientID)
);

CREATE TABLE UserAllergies (
    UserID INTEGER NOT NULL,
    AllergenID INTEGER NOT NULL,
    Severity VARCHAR(255) NOT NULL,
    PRIMARY KEY(UserID, AllergenID),
    FOREIGN KEY (UserID)
        REFERENCES Users(UserID),
    FOREIGN KEY (AllergenID)
        REFERENCES Allergens(AllergenID)
);

CREATE TABLE IngredientAllergens (
    IngredientID INTEGER NOT NULL,
    AllergenID INTEGER NOT NULL,
    PRIMARY KEY (IngredientID, AllergenID),
    FOREIGN KEY (IngredientID)
        REFERENCES Ingredients(IngredientID),
    FOREIGN KEY (AllergenID)
        REFERENCES Allergens(AllergenID)
);

CREATE TABLE PlanRecipes (
    UserID INTEGER NOT NULL,
    PlanName VARCHAR(255) NOT NULL,
    RecipeID INTEGER NOT NULL,
    PRIMARY KEY (PlanName, UserID, RecipeID),
    FOREIGN KEY (UserID, PlanName)
        REFERENCES Plans(UserID, PlanName),
    FOREIGN KEY (RecipeID)
        REFERENCES Recipes(RecipeID)
);

-- Add sample data. 
# Sample Users
INSERT INTO Users (FirstName, LastName)
VALUES ('Ashley', 'Davis');

INSERT INTO Users (FirstName, LastName)
VALUES ('Aidan', 'DiSalvo');

INSERT INTO Users (FirstName, LastName)
VALUES ('Dylan', 'McConnell');

INSERT INTO Users (FirstName, LastName)
VALUES ('Tim', 'Clay');

INSERT INTO Users (FirstName, LastName)
VALUES ('Armand', 'Meskin');

# Sample Socials
INSERT INTO Socials (Username, UserID, Platform)
VALUES ('ashleyydaviis', 1, 'Instagram');

INSERT INTO Socials (Username, UserID, Platform)
VALUES ('ashleydavis921', 1, 'Twitter');

INSERT INTO Socials(Username, UserID, Platform)
VALUES ('adiandisalvo', 2, 'Instagram');

INSERT INTO Socials(Username, UserID, Platform)
VALUES ('adiandisalvo', 2, 'Twitter');

# Sample Appliances
INSERT INTO Appliances (Name)
VALUES ('Oven');

INSERT INTO Appliances (Name)
VALUES ('Microwave');

INSERT INTO Appliances (Name)
VALUES ('Air Fryer');

INSERT INTO Appliances (Name)
VALUES ('Mixer');

INSERT INTO Appliances (Name)
VALUES ('Skillet');

INSERT INTO Appliances (Name)
VALUES ('Kitchen Utensils');

INSERT INTO Appliances (Name)
VALUES ('Pot');

# Sample Allergens
INSERT INTO Allergens (Name)
VALUES ('Gluten');

INSERT INTO Allergens (Name)
VALUES ('Lactose');

INSERT INTO Allergens (Name)
VALUES ('Shellfish');

INSERT INTO Allergens (Name)
VALUES ('Nuts');

# Sample Categories
INSERT INTO Categories (Type, Name)
VALUES ('Meal', 'Breakfast');

INSERT INTO Categories (Type, Name)
VALUES ('Meal', 'Dinner');

INSERT INTO Categories (Type, Name)
VALUES ('Taste', 'Savory');

INSERT INTO Categories (Type, Name)
VALUES ('Taste', 'Sweet');


# Sample Recipes
INSERT INTO Recipes (Title, Description, Instructions, Servings, PrepTime, CookTime, UserID)
VALUES ('Mac and Cheese', 'Baked Mac and Cheese for the entire family!',
       '1. Bring water to boil in medium pot. Add Macaroni; cook 7 to 8 min. or until tender, stirring occasionally.
        2. Drain Pasta
        3. Add cheese, milk, butter. Mix well on low heat
        4. Sprinkle bed crumbs on top
        5. Place in oven for 10 minutes and serve', 4, 5, 20, 1);


INSERT INTO Recipes (Title, Description, Instructions, Servings, PrepTime, CookTime, UserID)
VALUES ('Peanut Butter and Jelly Sandwich',
       'A simple sandwich on white bread with peanut butter and jelly lathered between the two slices',
       '1. Acquire all materials
        2. (Optional) Toast white bread
        3. Spread peanut butter and jelly between slices and close sandwich',
        1, 3, 3, 2);

# Sample RecipeCategories
INSERT INTO RecipeCategories (RecipeID, CategoryID)
VALUES (1, 2);

INSERT INTO RecipeCategories (RecipeID, CategoryID)
VALUES (2, 3);

# Sample RecipeAppliances
INSERT INTO RecipeAppliances (RecipeID, ApplianceID)
VALUES (1, 7);

INSERT INTO RecipeAppliances (RecipeID, ApplianceID)
VALUES (1, 1);

INSERT INTO RecipeAppliances (RecipeID, ApplianceID)
VALUES (2, 6);

# Sample Ingredients
INSERT INTO Ingredients (Name, UnitPrice, UnitCalories, UnitProtein, UnitFiber)
VALUES ('Cheddar Cheese', 3.99, 120, 10, 2);


INSERT INTO Ingredients (Name, UnitPrice, UnitCalories, UnitProtein, UnitFiber)
VALUES ('Bread Crumbs', 5.99, 150, 5, 4);


INSERT INTO Ingredients (Name, UnitPrice, UnitCalories, UnitProtein, UnitFiber)
VALUES ('Whole Milk', 4.99, 110, 8, 3);


INSERT INTO Ingredients (Name, UnitPrice, UnitCalories, UnitProtein, UnitFiber)
VALUES ('Butter', 1.99, 810, 1, 0);


INSERT INTO Ingredients (Name, UnitPrice, UnitCalories, UnitProtein, UnitFiber)
VALUES ('Macaroni', 3.99, 500, 10, 2);


INSERT INTO Ingredients (Name, UnitPrice, UnitCalories, UnitProtein, UnitFiber)
VALUES ('White Bread', 5.99, 400, 10, 4);


INSERT INTO Ingredients (Name, UnitPrice, UnitCalories, UnitProtein, UnitFiber)
VALUES ('Peanut Butter', 3.99, 600, 20, 6);


INSERT INTO Ingredients (Name, UnitPrice, UnitCalories, UnitProtein, UnitFiber)
VALUES ('Jelly', 3.99, 500, 5, 3);


INSERT INTO Ingredients (Name, UnitPrice, UnitCalories, UnitProtein, UnitFiber)
VALUES ('Gluten Free Bread Crumbs', 6.99, 150, 5, 4);


INSERT INTO Ingredients (Name, UnitPrice, UnitCalories, UnitProtein, UnitFiber)
VALUES ('Gluten Free Bread', 5.99, 400, 10, 4);

# Sample RecipeIngredients
INSERT INTO RecipeIngredients (Units, RecipeID, IngredientID)
VALUES (3, 1, 1);

INSERT INTO RecipeIngredients (Units, RecipeID, IngredientID)
VALUES (3, 1, 2);

INSERT INTO RecipeIngredients (Units, RecipeID, IngredientID)
VALUES (1, 1, 3);

INSERT INTO RecipeIngredients (Units, RecipeID, IngredientID)
VALUES (1, 1, 4);

INSERT INTO RecipeIngredients (Units, RecipeID, IngredientID)
VALUES (1, 1, 5);

INSERT INTO RecipeIngredients (Units, RecipeID, IngredientID)
VALUES (1, 2, 6);

INSERT INTO RecipeIngredients (Units, RecipeID, IngredientID)
VALUES (1, 2, 7);

INSERT INTO RecipeIngredients (Units, RecipeID, IngredientID)
VALUES (1, 2, 8);

# Sample Substitutes
INSERT INTO Substitutes (IngredientID, SubstituteID)
VALUES (9, 1);

INSERT INTO Substitutes (IngredientID, SubstituteID)
VALUES (10, 2);

# Sample IngredientAllergens
INSERT INTO IngredientAllergens (IngredientID, AllergenID)
VALUES (7,4);


INSERT INTO IngredientAllergens (IngredientID, AllergenID)
VALUES (6,1);


INSERT INTO IngredientAllergens (IngredientID, AllergenID)
VALUES (2,1);


INSERT INTO IngredientAllergens (IngredientID, AllergenID)
VALUES (1,2);

# Sample UserAllergies
INSERT INTO UserAllergies (Severity, UserID, AllergenID)
VALUES ('high', 2, 1);

INSERT INTO UserAllergies (Severity, UserID, AllergenID)
VALUES ('low', 3, 2);

# Sample Reviews
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating)
VALUES (5, 1, 'Awesome recipe!', 5);

INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating)
VALUES (4, 2, 'A classic!!', 5);

# Sample Plans
INSERT INTO Plans (UserID, PlanName)
VALUES (1, 'Dinner Ideas');

INSERT INTO Plans (UserID, PlanName)
VALUES (2, 'Lunch Ideas');

# Sample PlanRecipes
INSERT INTO PlanRecipes (UserID, PlanName, RecipeID)
VALUES (1, 'Dinner Ideas', 1);

INSERT INTO PlanRecipes (UserID, PlanName, RecipeID)
VALUES (2, 'Lunch Ideas', 2);