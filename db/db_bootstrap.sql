CREATE DATABASE IF NOT EXISTS MealPrepPlus;


GRANT ALL PRIVILEGES ON MealPrepPlus.* TO 'webapp'@'%';
FLUSH PRIVILEGES;


USE MealPrepPlus;


-- DDL
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


# Mockaroo Data
INSERT INTO Users (FirstName, LastName) VALUES
('John', 'Doe'),
('Jane', 'Smith'),
('Alice', 'Johnson'),
('Bob', 'Williams'),
('Eva', 'Brown'),
('Michael', 'Miller'),
('Sophia', 'Davis'),
('Daniel', 'Thomas'),
('Olivia', 'Garcia'),
('William', 'Martinez'),
('Emily', 'Wilson'),
('Benjamin', 'Turner'),
('Ava', 'Clark'),
('Ethan', 'Cooper'),
('Sophie', 'Wright'),
('Liam', 'Robinson'),
('Emma', 'Hall'),
('Jackson', 'Brooks'),
('Olivia', 'Lopez'),
('Noah', 'Morgan'),
('Mia', 'Fisher'),
('Elijah', 'Barnes'),
('Isabella', 'Young'),
('Lucas', 'Reyes'),
('Avery', 'Evans');


INSERT INTO Socials (UserID, Platform, Username) VALUES
(1, 'Twitter', '@john_doe'),
(2, 'Instagram', '@jane_smith'),
(3, 'Facebook', 'alice.johnson.official'),
(4, 'LinkedIn', 'bob.williams'),
(5, 'Snapchat', 'eva_brown'),
(6, 'Twitter', '@michael_miller'),
(7, 'Instagram', '@sophia_davis'),
(8, 'Facebook', 'daniel.thomas.official'),
(9, 'LinkedIn', 'olivia.garcia'),
(10, 'Snapchat', 'william_martinez'),
(11, 'Twitter', '@emily_wilson'),
(12, 'Instagram', '@benjamin_turner'),
(13, 'Facebook', 'ava_clark.official'),
(14, 'LinkedIn', 'ethan.cooper'),
(15, 'Snapchat', 'sophie_wright'),
(16, 'Twitter', '@liam_robinson'),
(17, 'Instagram', '@emma_hall'),
(18, 'Facebook', 'jackson_brooks.official'),
(19, 'LinkedIn', 'olivia.lopez'),
(20, 'Snapchat', 'noah_morgan'),
(21, 'Twitter', '@mia_fisher'),
(22, 'Instagram', '@elijah_barnes'),
(23, 'Facebook', 'isabella_young.official'),
(24, 'LinkedIn', 'lucas_reyes'),
(25, 'Snapchat', 'avery_evans');


INSERT INTO Categories (Type, Name) VALUES
('Cuisine', 'Italian'),
('Cuisine', 'Mexican'),
('Dessert', 'Cakes'),
('Dessert', 'Cookies'),
('Main Dish', 'Chicken'),
('Main Dish', 'Vegetarian'),
('Salad', 'Green Salad'),
('Salad', 'Caesar Salad'),
('Breakfast', 'Pancakes'),
('Breakfast', 'Omelette');


INSERT INTO Recipes (Title, Description, Instructions, Servings, PrepTime, CookTime, UserID)
VALUES
('Spaghetti Bolognese', 'Classic Italian pasta dish with meat sauce.', '1. Cook pasta according to package instructions. 2. Brown ground beef and onions. 3. Add tomatoes and seasonings. 4. Simmer for 20 minutes. 5. Serve over cooked pasta.', 4, 15, 30, 1),
('Vegetarian Tacos', 'A delicious and healthy meat-free taco recipe.', '1. Sauté vegetables in olive oil. 2. Season with taco spices. 3. Warm tortillas. 4. Assemble tacos with veggies, beans, and toppings.', 6, 20, 15, 2),
('Chocolate Cake', 'Rich and moist chocolate cake for any occasion.', '1. Preheat oven to 350°F. 2. Mix dry ingredients. 3. Beat butter and sugar. 4. Add eggs and vanilla. 5. Combine wet and dry ingredients. 6. Bake for 30-35 minutes.', 12, 20, 35, 3),
('Caprese Salad', 'Refreshing salad with tomatoes, mozzarella, and basil.', '1. Slice tomatoes and mozzarella. 2. Arrange on a plate. 3. Drizzle with balsamic glaze. 4. Garnish with fresh basil. 5. Sprinkle with salt and pepper.', 4, 10, 0, 4),
('Blueberry Pancakes', 'Fluffy pancakes filled with fresh blueberries.', '1. Mix flour, baking powder, and sugar. 2. In a separate bowl, whisk eggs and milk. 3. Combine wet and dry ingredients. 4. Fold in blueberries. 5. Cook on a griddle until golden brown.', 8, 15, 15, 5),
('Chicken Alfredo Pasta', 'Creamy Alfredo sauce with grilled chicken over pasta.', '1. Cook pasta al dente. 2. Grill chicken until cooked. 3. Prepare Alfredo sauce. 4. Combine chicken, pasta, and sauce. 5. Garnish with parsley.', 4, 20, 25, 6),
('Quinoa Salad', 'Healthy salad with quinoa, vegetables, and feta cheese.', '1. Cook quinoa and let it cool. 2. Chop vegetables and mix with quinoa. 3. Crumble feta cheese on top. 4. Dress with olive oil and lemon juice. 5. Toss and serve chilled.', 6, 15, 0, 7),
('Lemon Garlic Shrimp', 'Garlicky shrimp with a zesty lemon twist.', '1. Sauté shrimp in garlic and butter. 2. Add lemon juice and zest. 3. Season with salt and pepper. 4. Cook until shrimp are pink. 5. Serve over rice or pasta.', 4, 10, 15, 8),
('Berry Smoothie Bowl', 'A refreshing and nutritious smoothie bowl with mixed berries.', '1. Blend mixed berries, yogurt, and honey. 2. Pour into a bowl. 3. Top with granola, sliced fruits, and chia seeds. 4. Enjoy immediately.', 2, 10, 0, 9),
('Vegetable Stir-Fry', 'Quick and colorful stir-fry with assorted vegetables.', '1. Stir-fry vegetables in a wok with sesame oil. 2. Add soy sauce and ginger. 3. Cook until veggies are tender-crisp. 4. Serve over rice or noodles.', 4, 15, 12, 10),
('Grilled Salmon with Lemon Dill Sauce', 'Healthy grilled salmon topped with a zesty lemon dill sauce.', '1. Preheat grill. 2. Season salmon fillets. 3. Grill until cooked through. 4. Mix lemon juice, dill, and yogurt for the sauce. 5. Serve salmon with the sauce.', 2, 15, 20, 11),
('Vegetable Lasagna', 'Layered lasagna with a variety of roasted vegetables and cheese.', '1. Roast assorted vegetables. 2. Prepare lasagna noodles. 3. Layer noodles, veggies, and cheese. 4. Bake until bubbly and golden. 5. Let it cool before serving.', 8, 30, 40, 12),
('Mango Avocado Salsa Chicken', 'Grilled chicken topped with a fresh mango avocado salsa.', '1. Grill chicken breasts. 2. Dice mango, avocado, and tomatoes. 3. Mix with red onion and cilantro. 4. Spoon salsa over grilled chicken. 5. Enjoy with rice or salad.', 4, 20, 15, 13),
('Greek Salad with Chicken', 'A classic Greek salad with added grilled chicken for protein.', '1. Grill chicken until fully cooked. 2. Toss together chopped tomatoes, cucumbers, olives, and feta. 3. Add grilled chicken on top. 4. Dress with olive oil and lemon juice.', 4, 15, 25, 14),
('Homemade Pizza', 'Create your own pizza with your favorite toppings.', '1. Preheat oven to 475°F. 2. Roll out pizza dough. 3. Add sauce, cheese, and toppings. 4. Bake until crust is golden and cheese is melted. 5. Slice and enjoy!', 4, 20, 15, 15),
('Beef and Broccoli Stir Fry', 'Tender beef strips and crisp broccoli in a savory stir-fry sauce.', '1. Sear beef in a hot wok. 2. Add broccoli and stir-fry until tender-crisp. 3. Mix in soy sauce and garlic. 4. Serve over rice.', 4, 15, 20, 16),
('Crispy Baked Chicken Thighs', 'Golden and crispy baked chicken thighs with a flavorful seasoning.', '1. Preheat oven to 425°F. 2. Season chicken thighs with spices. 3. Bake until skin is crispy and internal temperature reaches 165°F. 4. Let it rest before serving.', 4, 10, 35, 17),
('Mushroom Risotto', 'Creamy risotto with sautéed mushrooms and Parmesan cheese.', '1. Sauté mushrooms and onions. 2. Toast Arborio rice in butter. 3. Add warm broth gradually while stirring. 4. Stir in Parmesan cheese until creamy. 5. Garnish with parsley.', 4, 20, 25, 18),
('Honey Mustard Glazed Salmon', 'Baked salmon fillets glazed with a sweet and tangy honey mustard sauce.', '1. Preheat oven to 400°F. 2. Mix honey, mustard, and soy sauce. 3. Brush over salmon fillets. 4. Bake until salmon flakes easily with a fork. 5. Serve with lemon wedges.', 2, 10, 15, 19),
('Pesto Pasta with Cherry Tomatoes', 'Pasta tossed in a basil pesto sauce and topped with fresh cherry tomatoes.', '1. Cook pasta al dente. 2. Blend basil, garlic, pine nuts, and Parmesan for pesto. 3. Toss cooked pasta in pesto. 4. Top with halved cherry tomatoes. 5. Enjoy!', 4, 15, 15, 20),
('Teriyaki Chicken Skewers', 'Grilled chicken skewers glazed with teriyaki sauce.', '1. Marinate chicken in teriyaki sauce. 2. Thread onto skewers. 3. Grill until cooked through. 4. Brush with extra teriyaki sauce. 5. Serve with rice or veggies.', 4, 20, 15, 21),
('Spinach and Feta Stuffed Chicken', 'Chicken breasts stuffed with spinach and feta cheese.', '1. Butterfly chicken breasts. 2. Mix spinach, feta, and garlic. 3. Stuff into chicken. 4. Bake until chicken is cooked. 5. Serve with a side salad.', 4, 15, 30, 22),
('Black Bean and Corn Salsa', 'A flavorful salsa with black beans, corn, and fresh herbs.', '1. Mix black beans, corn, tomatoes, and cilantro. 2. Add lime juice and salt. 3. Let it chill in the fridge. 4. Serve with tortilla chips or as a topping.', 6, 10, 0, 23),
('Shrimp Scampi Pasta', 'Lemon garlic shrimp served over a bed of linguine pasta.', '1. Cook linguine al dente. 2. Sauté shrimp in garlic and butter. 3. Add white wine and lemon juice. 4. Toss cooked pasta in the shrimp mixture. 5. Garnish with parsley.', 4, 15, 20, 24),
('BBQ Pulled Pork Sandwiches', 'Slow-cooked pulled pork in barbecue sauce, served on brioche buns.', '1. Rub pork shoulder with BBQ seasoning. 2. Slow cook until tender. 3. Shred pork and mix with BBQ sauce. 4. Serve on toasted brioche buns with coleslaw.', 6, 30, 240, 25);

INSERT INTO Appliances (Name) VALUES
('Blender'),
('Food Processor'),
('Stand Mixer'),
('Toaster'),
('Coffee Maker'),
('Slow Cooker'),
('Instant Pot'),
('Grill'),
('Microwave'),
('Oven'),
('Juicer'),
('Air Fryer'),
('Rice Cooker'),
('Waffle Maker'),
('Hand Mixer'),
('Blender-Food Processor Combo'),
('Electric Kettle'),
('Panini Press'),
('Toaster Oven'),
('Ice Cream Maker');


INSERT INTO Ingredients (Name, UnitPrice, UnitCalories, UnitProtein, UnitFiber) VALUES
('Pork Shoulder', 10.99, 300, 35, 0),
('BBQ Seasoning', 2.50, 10, 0, 0),
('BBQ Sauce', 3.99, 50, 0, 0),
('Brioche Buns', 2.00, 180, 4, 1),
('Coleslaw', 4.50, 120, 1, 3),

('Shrimp', 9.99, 200, 20, 0),
('Linguine Pasta', 2.50, 350, 8, 2),
('Garlic', 0.50, 5, 1, 0),
('Butter', 2.99, 100, 1, 0),
('White Wine', 5.00, 120, 0, 0),
('Lemon Juice', 1.50, 10, 0, 0),
('Parsley', 1.00, 5, 0, 1),

('Black Beans', 1.29, 200, 10, 8),
('Corn', 1.99, 90, 3, 2),
('Tomatoes', 3.99, 30, 1, 2),
('Cilantro', 1.50, 5, 0, 1),
('Lime Juice', 2.00, 15, 0, 0),
('Salt', 0.50, 0, 0, 0),

('Chicken Breasts', 6.99, 200, 25, 0),
('Spinach', 2.50, 20, 3, 2),
('Feta Cheese', 3.99, 100, 5, 0),
('Garlic', 0.50, 5, 1, 0),
('Olive Oil', 3.00, 120, 0, 0),
('Salt', 0.50, 0, 0, 0),
('Pepper', 0.75, 0, 0, 0),

('Chicken', 7.99, 200, 25, 0),
('Teriyaki Sauce', 4.00, 80, 2, 0),
('Skewers', 2.50, 0, 0, 0),
('Rice', 1.50, 150, 3, 1),
('Vegetables', 3.50, 50, 2, 3),

('Pasta', 2.50, 200, 8, 2),
('Basil', 1.99, 10, 1, 1),
('Garlic', 0.50, 5, 1, 0),
('Pine Nuts', 3.50, 100, 3, 2),
('Parmesan Cheese', 3.99, 150, 10, 0),
('Cherry Tomatoes', 2.99, 30, 1, 1),
('Olive Oil', 3.00, 120, 0, 0),
('Salt', 0.50, 0, 0, 0),
('Pepper', 0.75, 0, 0, 0),

('Mushrooms', 2.99, 20, 2, 1),
('Onions', 0.99, 40, 1, 2),
('Arborio Rice', 3.50, 200, 4, 1),
('Butter', 2.99, 100, 1, 0),
('Chicken Broth', 2.00, 10, 1, 0),
('Parmesan Cheese', 3.99, 150, 10, 0),
('Parsley', 1.00, 5, 0, 1),
('Salt', 0.50, 0, 0, 0),
('Pepper', 0.75, 0, 0, 0),

('Salmon Fillets', 8.99, 350, 40, 0),
('Honey', 3.50, 60, 0, 0),
('Mustard', 1.99, 10, 1, 0),
('Soy Sauce', 2.00, 10, 1, 0),
('Lemon Wedges', 1.50, 5, 0, 1),

('Pizza Dough', 3.99, 150, 5, 1),
('Pizza Sauce', 2.50, 50, 1, 2),
('Cheese', 4.50, 200, 10, 0),
('Toppings (e.g., Pepperoni, Mushrooms, Bell Peppers)', 2.00, 30, 2, 2),

('Beef Strips', 7.99, 250, 20, 0),
('Broccoli', 2.50, 30, 2, 3),
('Soy Sauce', 2.00, 10, 1, 0),
('Garlic', 0.50, 5, 1, 0),
('Rice', 1.50, 150, 3, 1),

('Spices (e.g., Paprika, Garlic Powder, Salt, Pepper)', 2.50, 5, 0, 1),
('Chicken Thighs', 7.99, 250, 20, 0),

('Salmon Fillets', 8.99, 350, 40, 0),
('Lemon Juice', 0.75, 10, 0, 1),
('Dill', 1.50, 10, 1, 1),
('Yogurt', 3.00, 150, 8, 0),

('Lasagna Noodles', 2.50, 200, 8, 2),
('Assorted Vegetables', 3.50, 50, 2, 3),
('Cheese (e.g., Mozzarella, Parmesan)', 4.50, 200, 10, 0),
('Tomato Sauce', 2.00, 30, 1, 2),

('Chicken Breasts', 6.99, 200, 25, 0),
('Mango', 2.99, 60, 1, 3),
('Avocado', 1.50, 120, 2, 6),
('Tomatoes', 3.99, 30, 1, 2),
('Red Onion', 1.50, 45, 1, 2),
('Cilantro', 1.50, 5, 0, 1),

('Chicken', 7.99, 250, 20, 0),
('Tomatoes', 3.99, 30, 1, 2),
('Cucumbers', 2.50, 20, 1, 2),
('Olives', 2.00, 50, 1, 3),
('Feta Cheese', 3.99, 100, 5, 0),
('Olive Oil', 3.00, 120, 0, 0),
('Lemon Juice', 1.50, 10, 0, 0),

('Pasta', 2.50, 200, 8, 2),
('Ground Beef', 5.99, 250, 20, 0),
('Onions', 0.99, 40, 1, 2),
('Tomatoes', 3.99, 30, 1, 2),
('Italian Seasonings', 1.50, 5, 0, 1),

('Assorted Vegetables', 3.50, 50, 2, 3),
('Olive Oil', 3.00, 120, 0, 0),
('Taco Spices', 2.00, 10, 1, 0),
('Tortillas', 2.50, 150, 3, 1),
('Beans', 1.50, 100, 5, 5),
('Toppings (e.g., lettuce, tomatoes, cheese)', 2.50, 30, 1, 2),

('Flour', 2.99, 100, 2, 1),
('Baking Powder', 1.50, 5, 0, 0),
('Sugar', 2.00, 50, 0, 0),
('Butter', 3.99, 100, 1, 0),
('Eggs', 1.99, 70, 6, 0),
('Vanilla Extract', 2.50, 10, 0, 0),
('Cocoa Powder', 3.50, 20, 1, 1),

('Tomatoes', 3.99, 30, 1, 2),
('Mozzarella', 4.50, 200, 10, 0),
('Basil', 1.50, 5, 0, 1),
('Balsamic Glaze', 2.50, 15, 0, 0),

('Flour', 2.99, 100, 2, 1),
('Baking Powder', 1.50, 5, 0, 0),
('Sugar', 2.00, 50, 0, 0),
('Eggs', 1.99, 70, 6, 0),
('Milk', 3.00, 80, 4, 0),
('Blueberries', 4.50, 30, 1, 2),

('Pasta', 2.50, 200, 8, 2),
('Chicken', 7.99, 250, 20, 0),
('Heavy Cream', 3.50, 120, 1, 0),
('Parmesan Cheese', 3.99, 150, 10, 0),
('Garlic', 0.50, 5, 1, 0),

('Quinoa', 4.50, 150, 5, 2),
('Assorted Vegetables', 3.50, 50, 2, 3),
('Feta Cheese', 3.99, 100, 5, 0),
('Olive Oil', 3.00, 120, 0, 0),
('Lemon Juice', 1.50, 10, 0, 0),

('Shrimp', 9.99, 200, 20, 0),
('Garlic', 0.50, 5, 1, 0),
('Butter', 2.99, 100, 1, 0),
('Lemon Juice', 1.50, 10, 0, 0),
('Lemon Zest', 1.00, 5, 0, 0),

('Mixed Berries', 4.99, 50, 1, 8),
('Yogurt', 3.00, 120, 8, 0),
('Honey', 2.50, 60, 0, 1),
('Granola', 3.50, 100, 3, 2),
('Sliced Fruits', 2.00, 30, 1, 2),
('Chia Seeds', 2.99, 20, 1, 5),

('Assorted Vegetables', 3.50, 50, 2, 3),
('Sesame Oil', 3.00, 120, 0, 0),
('Soy Sauce', 2.00, 10, 1, 0),
('Ginger', 1.50, 5, 0, 1),
('Rice or Noodles', 1.50, 150, 3, 1);

-- RecipeIngredients for 'Spaghetti Bolognese'
INSERT INTO RecipeIngredients (RecipeID, IngredientID, Units) VALUES
(1, 1, 4),
(1, 2, 1),
(1, 3, 1),
(1, 4, 2),
(1, 5, 1);

-- RecipeIngredients for 'Vegetarian Tacos'
INSERT INTO RecipeIngredients (RecipeID, IngredientID, Units) VALUES
(2, 20, 1),
(2, 21, 2),
(2, 22, 1),
(2, 23, 1),
(2, 24, 1),
(2, 25, 1);

-- RecipeIngredients for 'Chocolate Cake'
INSERT INTO RecipeIngredients (RecipeID, IngredientID, Units) VALUES
(3, 26, 2),
(3, 27, 1),
(3, 28, 2),
(3, 29, 1),
(3, 30, 4),
(3, 31, 1),
(3, 32, 1);

-- RecipeIngredients for 'Caprese Salad'
INSERT INTO RecipeIngredients (RecipeID, IngredientID, Units) VALUES
(4, 4, 4),
(4, 33, 1),
(4, 34, 1),
(4, 35, 1);

-- RecipeIngredients for 'Blueberry Pancakes'
INSERT INTO RecipeIngredients (RecipeID, IngredientID, Units) VALUES
(5, 26, 2),
(5, 27, 1),
(5, 28, 2),
(5, 29, 1),
(5, 36, 1),
(5, 37, 1);

-- RecipeIngredients for 'Chicken Alfredo Pasta'
INSERT INTO RecipeIngredients (RecipeID, IngredientID, Units) VALUES
(6, 1, 4),
(6, 38, 1),
(6, 39, 1),
(6, 40, 1),
(6, 41, 1);

-- RecipeIngredients for 'Quinoa Salad'
INSERT INTO RecipeIngredients (RecipeID, IngredientID, Units) VALUES
(7, 42, 1),
(7, 20, 1),
(7, 43, 1),
(7, 44, 1),
(7, 45, 1);

-- RecipeIngredients for 'Lemon Garlic Shrimp'
INSERT INTO RecipeIngredients (RecipeID, IngredientID, Units) VALUES
(8, 8, 4),
(8, 46, 1),
(8, 47, 1),
(8, 48, 1),
(8, 49, 1);

-- RecipeIngredients for 'Berry Smoothie Bowl'
INSERT INTO RecipeIngredients (RecipeID, IngredientID, Units) VALUES
(9, 50, 2),
(9, 51, 1),
(9, 52, 1),
(9, 53, 1),
(9, 54, 1),
(9, 55, 1);

-- RecipeIngredients for 'Vegetable Stir-Fry'
INSERT INTO RecipeIngredients (RecipeID, IngredientID, Units) VALUES
(10, 20, 1),
(10, 56, 1),
(10, 57, 1),
(10, 58, 1),
(10, 59, 1);

-- RecipeIngredients for 'Grilled Salmon with Lemon Dill Sauce'
INSERT INTO RecipeIngredients (RecipeID, IngredientID, Units) VALUES
(11, 55, 2),
(11, 60, 1),
(11, 61, 1),
(11, 62, 1);

-- RecipeIngredients for 'Vegetable Lasagna'
INSERT INTO RecipeIngredients (RecipeID, IngredientID, Units) VALUES
(12, 20, 1),
(12, 63, 1),
(12, 64, 1),
(12, 65, 1),
(12, 66, 1);

-- RecipeIngredients for 'Mango Avocado Salsa Chicken'
INSERT INTO RecipeIngredients (RecipeID, IngredientID, Units) VALUES
(13, 38, 1),
(13, 67, 1),
(13, 68, 1),
(13, 69, 1),
(13, 70, 1),
(13, 71, 1);

-- RecipeIngredients for 'Greek Salad with Chicken'
INSERT INTO RecipeIngredients (RecipeID, IngredientID, Units) VALUES
(14, 38, 1),
(14, 4, 4),
(14, 57, 1),
(14, 72, 1),
(14, 73, 1);

-- RecipeIngredients for 'Homemade Pizza'
INSERT INTO RecipeIngredients (RecipeID, IngredientID, Units) VALUES
(15, 74, 1),
(15, 75, 1),
(15, 76, 1),
(15, 77, 1),
(15, 78, 1);

-- RecipeIngredients for 'Beef and Broccoli Stir Fry'
INSERT INTO RecipeIngredients (RecipeID, IngredientID, Units) VALUES
(16, 79, 1),
(16, 80, 1),
(16, 57, 1),
(16, 81, 1),
(16, 59, 1);

-- RecipeIngredients for 'Crispy Baked Chicken Thighs'
INSERT INTO RecipeIngredients (RecipeID, IngredientID, Units) VALUES
(17, 82, 1),
(17, 83, 1),
(17, 84, 1);

-- RecipeIngredients for 'Mushroom Risotto'
INSERT INTO RecipeIngredients (RecipeID, IngredientID, Units) VALUES
(18, 85, 1),
(18, 86, 1),
(18, 87, 1),
(18, 63, 1),
(18, 88, 1);

-- RecipeIngredients for 'Honey Mustard Glazed Salmon'
INSERT INTO RecipeIngredients (RecipeID, IngredientID, Units) VALUES
(19, 11, 2),
(19, 89, 1),
(19, 90, 1),
(19, 91, 1),
(19, 92, 1);

-- RecipeIngredients for 'Pesto Pasta with Cherry Tomatoes'
INSERT INTO RecipeIngredients (RecipeID, IngredientID, Units) VALUES
(20, 26, 2),
(20, 93, 1),
(20, 94, 1),
(20, 95, 1),
(20, 96, 1),
(20, 97, 1);

-- RecipeIngredients for 'Teriyaki Chicken Skewers'
INSERT INTO RecipeIngredients (RecipeID, IngredientID, Units) VALUES
(21, 38, 1),
(21, 98, 1),
(21, 99, 1),
(21, 100, 1),
(21, 59, 1);

-- RecipeIngredients for 'Spinach and Feta Stuffed Chicken'
INSERT INTO RecipeIngredients (RecipeID, IngredientID, Units) VALUES
(22, 38, 1),
(22, 101, 1),
(22, 102, 1),
(22, 103, 1);

-- RecipeIngredients for 'Black Bean and Corn Salsa'
INSERT INTO RecipeIngredients (RecipeID, IngredientID, Units) VALUES
(23, 41, 2),
(23, 104, 1),
(23, 105, 1),
(23, 106, 1),
(23, 34, 1),
(23, 107, 1);

-- RecipeIngredients for 'Shrimp Scampi Pasta'
INSERT INTO RecipeIngredients (RecipeID, IngredientID, Units) VALUES
(24, 20, 1),
(24, 8, 4),
(24, 92, 1),
(24, 108, 1),
(24, 49, 1);

-- RecipeIngredients for 'BBQ Pulled Pork Sandwiches'
INSERT INTO RecipeIngredients (RecipeID, IngredientID, Units) VALUES
(25, 1, 4),
(25, 75, 1),
(25, 109, 1),
(25, 110, 1),
(25, 111, 1),
(25, 112, 1);

-- RecipeCategories for 'Spaghetti Bolognese'
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES
(1, 1), -- Italian
(1, 5); -- Main Dish

-- RecipeCategories for 'Vegetarian Tacos'
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES
(2, 2), -- Mexican
(2, 6); -- Vegetarian

-- RecipeCategories for 'Chocolate Cake'
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES
(3, 3); -- Dessert

-- RecipeCategories for 'Caprese Salad'
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES
(4, 1), -- Italian
(4, 7); -- Salad

-- RecipeCategories for 'Blueberry Pancakes'
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES
(5, 8); -- Breakfast

-- RecipeCategories for 'Chicken Alfredo Pasta'
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES
(6, 5); -- Main Dish

-- RecipeCategories for 'Quinoa Salad'
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES
(7, 9); -- Salad

-- RecipeCategories for 'Lemon Garlic Shrimp'
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES
(8, 5); -- Main Dish

-- RecipeCategories for 'Berry Smoothie Bowl'
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES
(9, 8); -- Breakfast

-- RecipeCategories for 'Vegetable Stir-Fry'
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES
(10, 5), -- Main Dish
(10, 9); -- Salad

-- RecipeCategories for 'Grilled Salmon with Lemon Dill Sauce'
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES
(11, 5); -- Main Dish

-- RecipeCategories for 'Vegetable Lasagna'
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES
(12, 6), -- Vegetarian
(12, 5); -- Main Dish

-- RecipeCategories for 'Mango Avocado Salsa Chicken'
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES
(13, 5), -- Main Dish
(13, 9); -- Salad

-- RecipeCategories for 'Greek Salad with Chicken'
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES
(14, 5), -- Main Dish
(14, 7); -- Salad

-- RecipeCategories for 'Homemade Pizza'
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES
(15, 5); -- Main Dish

-- RecipeCategories for 'Beef and Broccoli Stir Fry'
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES
(16, 5); -- Main Dish

-- RecipeCategories for 'Crispy Baked Chicken Thighs'
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES
(17, 5); -- Main Dish

-- RecipeCategories for 'Mushroom Risotto'
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES
(18, 5); -- Main Dish

-- RecipeCategories for 'Honey Mustard Glazed Salmon'
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES
(19, 5); -- Main Dish

-- RecipeCategories for 'Pesto Pasta with Cherry Tomatoes'
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES
(20, 5); -- Main Dish

-- RecipeCategories for 'Teriyaki Chicken Skewers'
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES
(21, 5); -- Main Dish

-- RecipeCategories for 'Spinach and Feta Stuffed Chicken'
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES
(22, 5); -- Main Dish

-- RecipeCategories for 'Black Bean and Corn Salsa'
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES
(23, 9); -- Salad

-- RecipeCategories for 'Shrimp Scampi Pasta'
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES
(24, 5); -- Main Dish

-- RecipeCategories for 'BBQ Pulled Pork Sandwiches'
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES
(25, 5), -- Main Dish
(25, 10); -- Cuisine


-- RecipeAppliances for 'Spaghetti Bolognese'
INSERT INTO RecipeAppliances (RecipeID, ApplianceID) VALUES
(1, 10); -- Oven

-- RecipeAppliances for 'Vegetarian Tacos'
INSERT INTO RecipeAppliances (RecipeID, ApplianceID) VALUES
(2, 8); -- Grill

-- RecipeAppliances for 'Chocolate Cake'
INSERT INTO RecipeAppliances (RecipeID, ApplianceID) VALUES
(3, 10), -- Oven
(3, 2);  -- Food Processor

-- RecipeAppliances for 'Caprese Salad'
INSERT INTO RecipeAppliances (RecipeID, ApplianceID) VALUES
(4, 15); -- Hand Mixer

-- RecipeAppliances for 'Blueberry Pancakes'
INSERT INTO RecipeAppliances (RecipeID, ApplianceID) VALUES
(5, 13); -- Waffle Maker

-- RecipeAppliances for 'Chicken Alfredo Pasta'
INSERT INTO RecipeAppliances (RecipeID, ApplianceID) VALUES
(6, 10); -- Oven

-- RecipeAppliances for 'Quinoa Salad'
INSERT INTO RecipeAppliances (RecipeID, ApplianceID) VALUES
(7, 12); -- Rice Cooker

-- RecipeAppliances for 'Lemon Garlic Shrimp'
INSERT INTO RecipeAppliances (RecipeID, ApplianceID) VALUES
(8, 10); -- Oven

-- RecipeAppliances for 'Berry Smoothie Bowl'
INSERT INTO RecipeAppliances (RecipeID, ApplianceID) VALUES
(9, 1);  -- Blender

-- RecipeAppliances for 'Vegetable Stir-Fry'
INSERT INTO RecipeAppliances (RecipeID, ApplianceID) VALUES
(10, 7); -- Instant Pot

-- RecipeAppliances for 'Grilled Salmon with Lemon Dill Sauce'
INSERT INTO RecipeAppliances (RecipeID, ApplianceID) VALUES
(11, 8); -- Grill

-- RecipeAppliances for 'Vegetable Lasagna'
INSERT INTO RecipeAppliances (RecipeID, ApplianceID) VALUES
(12, 10); -- Oven

-- RecipeAppliances for 'Mango Avocado Salsa Chicken'
INSERT INTO RecipeAppliances (RecipeID, ApplianceID) VALUES
(13, 8); -- Grill

-- RecipeAppliances for 'Greek Salad with Chicken'
INSERT INTO RecipeAppliances (RecipeID, ApplianceID) VALUES
(14, 8); -- Grill

-- RecipeAppliances for 'Homemade Pizza'
INSERT INTO RecipeAppliances (RecipeID, ApplianceID) VALUES
(15, 10); -- Oven

-- RecipeAppliances for 'Beef and Broccoli Stir Fry'
INSERT INTO RecipeAppliances (RecipeID, ApplianceID) VALUES
(16, 7); -- Slow Cooker

-- RecipeAppliances for 'Crispy Baked Chicken Thighs'
INSERT INTO RecipeAppliances (RecipeID, ApplianceID) VALUES
(17, 10); -- Oven

-- RecipeAppliances for 'Mushroom Risotto'
INSERT INTO RecipeAppliances (RecipeID, ApplianceID) VALUES
(18, 7); -- Slow Cooker

-- RecipeAppliances for 'Honey Mustard Glazed Salmon'
INSERT INTO RecipeAppliances (RecipeID, ApplianceID) VALUES
(19, 10); -- Oven

-- RecipeAppliances for 'Pesto Pasta with Cherry Tomatoes'
INSERT INTO RecipeAppliances (RecipeID, ApplianceID) VALUES
(20, 10), -- Oven
(20, 2);  -- Food Processor

-- RecipeAppliances for 'Teriyaki Chicken Skewers'
INSERT INTO RecipeAppliances (RecipeID, ApplianceID) VALUES
(21, 8); -- Grill

-- RecipeAppliances for 'Spinach and Feta Stuffed Chicken'
INSERT INTO RecipeAppliances (RecipeID, ApplianceID) VALUES
(22, 10); -- Oven

-- RecipeAppliances for 'Black Bean and Corn Salsa'
INSERT INTO RecipeAppliances (RecipeID, ApplianceID) VALUES
(23, 1),  -- Blender
(23, 2);  -- Food Processor

-- RecipeAppliances for 'Shrimp Scampi Pasta'
INSERT INTO RecipeAppliances (RecipeID, ApplianceID) VALUES
(24, 10); -- Oven

-- RecipeAppliances for 'BBQ Pulled Pork Sandwiches'
INSERT INTO RecipeAppliances (RecipeID, ApplianceID) VALUES
(25, 6),  -- Slow Cooker
(25, 10); -- Oven

INSERT INTO Allergens (Name) VALUES
('Dairy'),
('Eggs'),
('Soy'),
('Wheat'),
('Peanuts'),
('Tree Nuts');




-- UserAllergies records
INSERT INTO UserAllergies (UserID, AllergenID, Severity) VALUES
(1, 1, 'Moderate'), -- User 1 is allergic to Dairy with moderate severity
(1, 5, 'Severe'),   -- User 1 is allergic to Peanuts with severe severity
(2, 3, 'Mild'),     -- User 2 is allergic to Soy with mild severity
(3, 2, 'Moderate'), -- User 3 is allergic to Eggs with moderate severity
(4, 4, 'Severe'),   -- User 4 is allergic to Wheat with severe severity
(5, 1, 'Mild'),     -- User 5 is allergic to Dairy with mild severity
(5, 6, 'Severe');   -- User 5 is allergic to Tree Nuts with severe severity


-- IngredientAllergens records
INSERT INTO IngredientAllergens (IngredientID, AllergenID) VALUES
(25, 2), -- Chicken contains Eggs
(30, 6), -- Teriyaki Sauce contains Tree Nuts
(32, 2), -- Rice contains Eggs
(33, 3), -- Vegetables contain Soy
(46, 2), -- Lasagna Noodles contain Eggs
(46, 4), -- Lasagna Noodles contain Wheat
(47, 2), -- Assorted Vegetables contain Eggs
(47, 4), -- Assorted Vegetables contain Wheat
(49, 4), -- Arborio Rice contains Wheat
(57, 3), -- Honey contains Soy
(58, 4); -- Mustard contains Wheat

INSERT INTO Substitutes (IngredientID, SubstituteID) VALUES
-- Substitutes for Pork Shoulder
(1, 26), -- Chicken as a substitute

-- Substitutes for BBQ Seasoning
(2, 46), -- Spices (e.g., Paprika, Garlic Powder, Salt, Pepper)
(2, 47), -- Chicken Thighs seasoning

-- Substitutes for BBQ Sauce
(3, 35), -- Teriyaki Sauce
(3, 37), -- Pizza Sauce

-- Substitutes for Brioche Buns
(4, 41), -- Pizza Dough
(4, 48), -- Bread

-- Substitutes for Coleslaw
(5, 15), -- Shredded Cabbage Mix
(5, 16), -- Carrot Strips

-- Substitutes for Shrimp
(6, 18), -- Chicken
(6, 39), -- Tofu

-- Substitutes for Linguine Pasta
(7, 21), -- Rice Noodles
(7, 25), -- Quinoa

-- Substitutes for Garlic
(8, 43), -- Garlic Powder
(8, 44), -- Minced Garlic

-- Substitutes for Butter
(9, 40), -- Olive Oil
(9, 42), -- Avocado

-- Substitutes for White Wine
(10, 45), -- Chicken Broth
(10, 47), -- Water with Lemon Juice

-- Substitutes for Lemon Juice
(11, 45), -- Chicken Broth
(11, 47), -- Water with White Vinegar

-- Substitutes for Parsley
(12, 43), -- Dried Parsley
(12, 44); -- Fresh Cilantro

INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES
-- Reviews for Spaghetti Bolognese (RecipeID: 1)
(1, 1, 'Delicious and easy to make. My family loved it!', 5),
(2, 1, 'Classic and comforting. Perfect for a weeknight dinner.', 4),
(3, 1, 'I added extra garlic for more flavor. Turned out great!', 4),

-- Reviews for Vegetarian Tacos (RecipeID: 2)
(4, 2, 'Healthy and tasty! A great meat-free option.', 5),
(5, 2, 'Satisfying and quick to make. Loved the taco spices.', 4),
(6, 2, 'I added guacamole as a topping. Yum!', 4),

-- Reviews for Chocolate Cake (RecipeID: 3)
(7, 3, 'Moist and chocolaty. A hit at the party!', 5),
(8, 3, 'Easy to follow recipe. Perfect for any chocolate lover.', 5),
(9, 3, 'I used dark chocolate for a rich flavor. Loved it!', 5),

(10, 4, 'Simple and refreshing. Perfect for a light lunch.', 5),
(11, 4, 'I drizzled some balsamic reduction. A lovely combination!', 4),
(12, 4, 'Fresh ingredients make this salad delightful.', 5),

-- Reviews for Blueberry Pancakes (RecipeID: 5)
(13, 5, 'Fluffy and delicious! The blueberries add a nice touch.', 5),
(14, 5, 'My go-to pancake recipe. Always a crowd-pleaser.', 4),
(15, 5, 'I added a dollop of whipped cream. Amazing!', 5),

-- Reviews for Chicken Alfredo Pasta (RecipeID: 6)
(16, 6, 'Creamy and flavorful. A comfort food favorite.', 5),
(17, 6, 'Grilled chicken adds a nice smoky flavor. Loved it!', 4),
(18, 6, 'Rich and satisfying. Definitely making it again.', 5),

-- Reviews for Quinoa Salad (RecipeID: 7)
(19, 7, 'Healthy and tasty salad. Great for a light dinner.', 4),
(20, 7, 'The feta cheese adds a nice tang. A new favorite!', 4),
(21, 7, 'Easy to prepare and perfect for meal prep.', 5),

-- Reviews for Lemon Garlic Shrimp (RecipeID: 8)
(22, 8, 'Garlicky and zesty. A quick and flavorful dish.', 5),
(23, 8, 'Served it over rice. The family loved the flavors!', 4),
(24, 8, 'Simple and delicious. A regular in our dinner rotation.', 5);

INSERT INTO Plans (UserID, PlanName) VALUES
(1, 'Weekly Meal Prep'),
(2, 'Vegetarian Delight'),
(3, 'Quick and Easy Dinners'),
(4, 'Family Favorites'),
(5, 'Healthy Choices'),
(6, 'Italian Feast'),
(7, 'Mexican Fiesta'),
(8, 'Low-Carb Lifestyle'),
(9, 'Breakfast Bonanza'),
(10, 'Asian Flavors'),
(11, 'Mediterranean Delicacies'),
(12, 'Comfort Food Cravings'),
(13, 'Protein-Packed Power'),
(14, 'Balanced Nutrition'),
(15, 'Date Night Specials'),
(16, 'Vegan Bliss'),
(17, 'Gluten-Free Goodness'),
(18, 'Tropical Treats'),
(19, 'Grill Master\'s Plan'),
(20, 'Student Survival Kit');

-- Assign recipes to Weekly Meal Prep
INSERT INTO PlanRecipes (UserID, PlanName, RecipeID) VALUES
(1, 'Weekly Meal Prep', 1),
(1, 'Weekly Meal Prep', 6),
(1, 'Weekly Meal Prep', 9),
(1, 'Weekly Meal Prep', 12),
(1, 'Weekly Meal Prep', 17);

-- Assign recipes to Vegetarian Delight
INSERT INTO PlanRecipes (UserID, PlanName, RecipeID) VALUES
(2, 'Vegetarian Delight', 2),
(2, 'Vegetarian Delight', 7),
(2, 'Vegetarian Delight', 14),
(2, 'Vegetarian Delight', 20);

-- Assign recipes to Quick and Easy Dinners
INSERT INTO PlanRecipes (UserID, PlanName, RecipeID) VALUES
(3, 'Quick and Easy Dinners', 3),
(3, 'Quick and Easy Dinners', 8),
(3, 'Quick and Easy Dinners', 15),
(3, 'Quick and Easy Dinners', 21);

-- Assign recipes to Family Favorites
INSERT INTO PlanRecipes (UserID, PlanName, RecipeID) VALUES
(4, 'Family Favorites', 4),
(4, 'Family Favorites', 11),
(4, 'Family Favorites', 16),
(4, 'Family Favorites', 23);

-- Assign recipes to Healthy Choices
INSERT INTO PlanRecipes (UserID, PlanName, RecipeID) VALUES
(5, 'Healthy Choices', 5),
(5, 'Healthy Choices', 10),
(5, 'Healthy Choices', 18),
(5, 'Healthy Choices', 24);

-- Assign recipes to Italian Feast
INSERT INTO PlanRecipes (UserID, PlanName, RecipeID) VALUES
(6, 'Italian Feast', 6),
(6, 'Italian Feast', 12),
(6, 'Italian Feast', 17),
(6, 'Italian Feast', 25);

-- Assign recipes to Mexican Fiesta
INSERT INTO PlanRecipes (UserID, PlanName, RecipeID) VALUES
(7, 'Mexican Fiesta', 7),
(7, 'Mexican Fiesta', 14),
(7, 'Mexican Fiesta', 20);

-- Assign recipes to Low-Carb Lifestyle
INSERT INTO PlanRecipes (UserID, PlanName, RecipeID) VALUES
(8, 'Low-Carb Lifestyle', 8),
(8, 'Low-Carb Lifestyle', 15),
(8, 'Low-Carb Lifestyle', 21);

-- Assign recipes to Breakfast Bonanza
INSERT INTO PlanRecipes (UserID, PlanName, RecipeID) VALUES
(9, 'Breakfast Bonanza', 9),
(9, 'Breakfast Bonanza', 13),
(9, 'Breakfast Bonanza', 19);

-- Assign recipes to Asian Flavors
INSERT INTO PlanRecipes (UserID, PlanName, RecipeID) VALUES
(10, 'Asian Flavors', 10),
(10, 'Asian Flavors', 16),
(10, 'Asian Flavors', 22);

-- Assign recipes to Mediterranean Delicacies
INSERT INTO PlanRecipes (UserID, PlanName, RecipeID) VALUES
(11, 'Mediterranean Delicacies', 11),
(11, 'Mediterranean Delicacies', 14),
(11, 'Mediterranean Delicacies', 20);

-- Assign recipes to Comfort Food Cravings
INSERT INTO PlanRecipes (UserID, PlanName, RecipeID) VALUES
(12, 'Comfort Food Cravings', 12),
(12, 'Comfort Food Cravings', 17),
(12, 'Comfort Food Cravings', 25);

-- Assign recipes to Protein-Packed Power
INSERT INTO PlanRecipes (UserID, PlanName, RecipeID) VALUES
(13, 'Protein-Packed Power', 17),
(13, 'Protein-Packed Power', 22);

-- Assign recipes to Balanced Nutrition
INSERT INTO PlanRecipes (UserID, PlanName, RecipeID) VALUES
(14, 'Balanced Nutrition', 14),
(14, 'Balanced Nutrition', 20);

-- Assign recipes to Date Night Specials
INSERT INTO PlanRecipes (UserID, PlanName, RecipeID) VALUES
(15, 'Date Night Specials', 15),
(15, 'Date Night Specials', 21);

-- Assign recipes to Vegan Bliss
INSERT INTO PlanRecipes (UserID, PlanName, RecipeID) VALUES
(16, 'Vegan Bliss', 2),
(16, 'Vegan Bliss', 7),
(16, 'Vegan Bliss', 14),
(16, 'Vegan Bliss', 20);

-- Assign recipes to Gluten-Free Goodness
INSERT INTO PlanRecipes (UserID, PlanName, RecipeID) VALUES
(17, 'Gluten-Free Goodness', 18),
(17, 'Gluten-Free Goodness', 24);

-- Assign recipes to Tropical Treats
INSERT INTO PlanRecipes (UserID, PlanName, RecipeID) VALUES
(18, 'Tropical Treats', 19);

-- Assign recipes to Grill Master's Plan
INSERT INTO PlanRecipes (UserID, PlanName, RecipeID) VALUES
(19, 'Grill Master\'s Plan', 21),
(19, 'Grill Master\'s Plan', 23);

-- Assign recipes to Student Survival Kit
INSERT INTO PlanRecipes (UserID, PlanName, RecipeID) VALUES
(20, 'Student Survival Kit', 10),
(20, 'Student Survival Kit', 15),
(20, 'Student Survival Kit', 20);

