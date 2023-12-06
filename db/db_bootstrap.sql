CREATE DATABASE IF NOT EXISTS MealPrepPlus;


#GRANT ALL PRIVILEGES ON MealPrepPlus.* TO 'webapp'@'%';
#FLUSH PRIVILEGES;


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
REFERENCES Recipes(RecipeID) 
ON DELETE cascade,
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
REFERENCES Recipes(RecipeID)
ON DELETE cascade,
FOREIGN KEY (ApplianceID)
REFERENCES Appliances(ApplianceID)
);


CREATE TABLE RecipeIngredients (
RecipeID INTEGER NOT NULL,
IngredientID INTEGER NOT NULL,
Units INTEGER NOT NULL,
PRIMARY KEY (RecipeID, IngredientID),
FOREIGN KEY (RecipeID)
REFERENCES Recipes(RecipeID)
ON DELETE cascade,
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
<<<<<<< HEAD
PRIMARY KEY (PlanName, UserID, RecipeID),
FOREIGN KEY (UserID, PlanName)
REFERENCES Plans(UserID, PlanName),
=======
PRIMARY KEY (PlanID, UserID, RecipeID),
FOREIGN KEY (PlanID)
REFERENCES Plans(PlanID)
ON DELETE cascade,
>>>>>>> a08652ea4790e419e101b3daa3325f9985d6cea0
FOREIGN KEY (RecipeID)
REFERENCES Recipes(RecipeID)
ON DELETE cascade
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
('Avery', 'Evans'),
('Hannah', 'Mitchell'),
('Alexander', 'Lee'),
('Grace', 'Baker'),
('Carter', 'Gomez'),
('Avery', 'Taylor'),
('Logan', 'Hall'),
('Chloe', 'Stewart'),
('Mason', 'Lopez'),
('Aubrey', 'Ward'),
('Elijah', 'Fisher'),
('Zoe', 'Hernandez'),
('James', 'Turner'),
('Natalie', 'Ramirez'),
('David', 'Evans'),
('Lillian', 'Perez'),
('Michael', 'Carter'),
('Sophia', 'Morales'),
('Landon', 'Hill'),
('Isabella', 'Barnes'),
('Luke', 'Kelly'),
('Layla', 'Bailey'),
('Henry', 'Foster'),
('Peyton', 'Powell'),
('Brooklyn', 'Cook'),
('Andrew', 'Stevens'),
('Penelope', 'Gordon'),
('Gabriel', 'Cooper'),
('Madison', 'Rogers'),
('Christopher', 'Ferguson');


-- Inserting socials for users
INSERT INTO Socials (UserID, Platform, Username) VALUES
(1, 'Twitter', '@john_doe'), (1, 'Instagram', '@john.doe.123'), (1, 'LinkedIn', 'john.doe.linked'),
(2, 'Instagram', '@jane_smith.456'), (2, 'LinkedIn', 'jane.smith.linked'), (2, 'Facebook', 'jane.smith.facebook'),
(3, 'Facebook', 'alice.johnson.official'), (3, 'Instagram', '@alice.johnson.789'), (3, 'Twitter', '@alice_johnson_tweet'),
(4, 'LinkedIn', 'bob.williams'), (4, 'Snapchat', 'bob_williams_snap'), (4, 'Twitter', '@bob.williams_tweet'),
(5, 'Snapchat', 'eva_brown_snap'), (5, 'Facebook', 'eva.brown.official'), (5, 'Instagram', '@eva_brown.123'),
(6, 'Twitter', '@michael_miller'), (6, 'LinkedIn', 'michaelmiller'), (6, 'Instagram', '@michael_miller.official'),
(7, 'Facebook', 'sophia.davis.789'), (7, 'Instagram', '@sophia.davis.789'), (7, 'Twitter', '@sophia_davis_tweet'),
(8, 'Facebook', 'daniel.thomas.official'), (8, 'LinkedIn', 'daniel.thomas.linked'), (8, 'Instagram', '@daniel.thomas.567'),
(9, 'LinkedIn', 'olivia.garcia'), (9, 'Instagram', '@olivia.garcia.101'), (9, 'Facebook', 'olivia.garcia.official'),
(10, 'Snapchat', 'william_martinez_snap'), (10, 'LinkedIn', 'william.martinez'), (10, 'Twitter', '@william_martinez_tweet'),
(11, 'Twitter', '@emily_wilson'), (11, 'Instagram', '@emily.wilson.111'), (11, 'LinkedIn', 'emily.wilson.linked'),
(12, 'LinkedIn', 'benjamin.turner'), (12, 'Instagram', '@benjamin_turner.official'), (12, 'Facebook', 'benjamin.turner.official'),
(13, 'Facebook', 'ava_clark.official'), (13, 'Instagram', '@ava.clark.222'), (13, 'Snapchat', 'ava_clark_snap'),
(14, 'LinkedIn', 'ethan.cooper'), (14, 'Twitter', '@ethan_cooper_tweet'), (14, 'Instagram', '@ethan.cooper.333'),
(15, 'Snapchat', 'sophie_wright_snap'), (15, 'Twitter', '@sophie_wright_tweet'), (15, 'Instagram', '@sophie_wright.official'),
(16, 'Instagram', '@liam_robinson.official'), (16, 'Snapchat', 'liam_robinson_snap'), (16, 'Twitter', '@liam_robinson_tweet'),
(17, 'Twitter', '@emma_hall_tweet'), (17, 'Instagram', '@emma_hall.official'), (17, 'Snapchat', 'emma_hall_snap'),
(18, 'Facebook', 'jackson_brooks.official'), (18, 'LinkedIn', 'jackson.brooks.linked'), (18, 'Instagram', '@jackson_brooks_snap'),
(19, 'Instagram', '@olivia_lopez.official'), (19, 'Snapchat', 'olivia_lopez_snap'), (19, 'Twitter', '@olivia_lopez_tweet'),
(20, 'Facebook', 'noah.morgan.official'), (20, 'LinkedIn', 'noah.morgan.linked'), (20, 'Instagram', '@noah_morgan_snap'),
(21, 'Twitter', '@mia_fisher_tweet'), (21, 'LinkedIn', 'mia.fisher.linked'), (21, 'Instagram', '@mia_fisher.official'),
(22, 'Instagram', '@elijah_barnes.official'), (22, 'Facebook', 'elijah.barnes.official'), (22, 'Snapchat', 'elijah_barnes_snap'),
(23, 'Facebook', 'isabella_young.official'), (23, 'LinkedIn', 'isabella.young.linked'), (23, 'Twitter', '@isabella_young_tweet'),
(24, 'LinkedIn', 'lucas_reyes'), (24, 'Snapchat', 'lucas_reyes_snap'), (24, 'Instagram', '@lucas_reyes.official'),
(25, 'Snapchat', 'avery_evans_snap'), (25, 'Facebook', 'avery.evans.official'), (25, 'Instagram', '@avery_evans.567'),
(26, 'Facebook', 'hannah.mitchell.official'), (26, 'LinkedIn', 'hannah.mitchell.linked'), (26, 'Instagram', '@hannah_mitchell.official'),
(27, 'Instagram', '@alexander.lee.official'), (27, 'Twitter', '@alexander_lee_tweet'), (27, 'Snapchat', 'alexander_lee_snap'),
(28, 'Facebook', 'grace.baker.official'), (28, 'LinkedIn', 'grace.baker.linked'), (28, 'Instagram', '@grace.baker.567'),
(29, 'LinkedIn', 'carter.gomez'), (29, 'Twitter', '@carter_gomez_tweet'), (29, 'Instagram', '@carter_gomez.official'),
(30, 'Instagram', '@avery_taylor.official'), (30, 'Snapchat', 'avery_taylor_snap'), (30, 'Twitter', '@avery_taylor_tweet'),
(31, 'Snapchat', 'logan_hall_snap'),(31, 'Twitter', '@logan_hall_tweet'),(31, 'Instagram', '@logan.hall.official'),
(32, 'Instagram', '@chloe_stewart.official'),(32, 'Snapchat', 'chloe_stewart_snap'),(32, 'Twitter', '@chloe_stewart_tweet'),
(33, 'LinkedIn', 'mason.lopez'),(33, 'Twitter', '@mason_lopez_tweet'),(33, 'Instagram', '@mason.lopez.official'),
(34, 'Facebook', 'aubrey.ward.official'),(34, 'Snapchat', 'aubrey_ward_snap'),(34, 'Instagram', '@aubrey.ward.567'),
(35, 'Instagram', '@elijah_fisher.official'),(35, 'Snapchat', 'elijah_fisher_snap'),(35, 'Twitter', '@elijah_fisher_tweet'),
(36, 'Snapchat', 'zoe_hernandez_snap'),(36, 'Instagram', '@zoe.hernandez.official'),(36, 'Twitter', '@zoe_hernandez_tweet'),
(37, 'Facebook', 'james.turner.official'),(37, 'LinkedIn', 'james.turner.linked'),(37, 'Twitter', '@james_turner_tweet'),
(38, 'Instagram', '@natalie.ramirez.official'),(38, 'Snapchat', 'natalie_ramirez_snap'),(38, 'Twitter', '@natalie_ramirez_tweet'),
(39, 'Snapchat', 'david_evans_snap'),(39, 'LinkedIn', 'david.evans.linked'),(39, 'Twitter', '@david_evans_tweet'),
(40, 'Facebook', 'lillian.perez.official'),(40, 'Instagram', '@lillian.perez.official'),(40, 'Snapchat', 'lillian_perez_snap'),
(41, 'Instagram', '@michael_carter.official'),(41, 'LinkedIn', 'michael.carter.linked'),(41, 'Snapchat', 'michael_carter_snap'),
(42, 'Twitter', '@sophia_morales_tweet'),(42, 'Instagram', '@sophia_morales.official'),(42, 'Snapchat', 'sophia_morales_snap'),
(43, 'LinkedIn', 'landon.hill'),(43, 'Twitter', '@landon_hill_tweet'),(43, 'Instagram', '@landon.hill.official'),
(44, 'Instagram', '@isabella_barnes.official'),(44, 'Snapchat', 'isabella_barnes_snap'),(44, 'Twitter', '@isabella_barnes_tweet'),
(45, 'Twitter', '@luke_kelly_tweet'),(45, 'Snapchat', 'luke_kelly_snap'),(45, 'Instagram', '@luke.kelly.official'),
(46, 'Facebook', 'layla.bailey.official'),(46, 'LinkedIn', 'layla.bailey.linked'),(46, 'Twitter', '@layla_bailey_tweet'),
(47, 'Instagram', '@henry_foster.official'),(47, 'Snapchat', 'henry_foster_snap'),(47, 'Twitter', '@henry_foster_tweet'),
(48, 'Facebook', 'peyton.powell.official'),(48, 'LinkedIn', 'peyton.powell.linked'),(48, 'Instagram', '@peyton.powell.567'),
(49, 'Snapchat', 'brooklyn_cook_snap'),(49, 'Instagram', '@brooklyn.cook.official'),(49, 'Twitter', '@brooklyn_cook_tweet'),
(50, 'LinkedIn', 'andrew.stevens'),(50, 'Snapchat', 'andrew_stevens_snap'),(50, 'Twitter', '@andrew_stevens_tweet'),
(51, 'Instagram', '@penelope.gordon.official'),(51, 'Facebook', 'penelope.gordon.official'),(51, 'Snapchat', 'penelope_gordon_snap'),
(52, 'Facebook', 'gabriel.cooper.official'),(52, 'Twitter', '@gabriel_cooper_tweet'),(52, 'Instagram', '@gabriel.cooper.567'),
(53, 'Twitter', '@madison_rogers_tweet'),(53, 'Instagram', '@madison.rogers.official'),(53, 'Snapchat', 'madison_rogers_snap'),
(54, 'Instagram', '@christopher_ferguson.official'),(54, 'Snapchat', 'christopher_ferguson_snap'),(54, 'Twitter', '@christopher_ferguson_tweet');


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
('Vegetarian Tacos', 'A delicious and healthy meat-free taco recipe.', '1. Sauté vegetables in olive oil. 2. Season with taco spices. 3. Warm tortillas. 4. Assemble tacos with veggies, beans, and toppings.', 6, 20, 15, 1),
('Chocolate Cake', 'Rich and moist chocolate cake for any occasion.', '1. Preheat oven to 350°F. 2. Mix dry ingredients. 3. Beat butter and sugar. 4. Add eggs and vanilla. 5. Combine wet and dry ingredients. 6. Bake for 30-35 minutes.', 12, 20, 35, 1),
('Caprese Salad', 'Refreshing salad with tomatoes, mozzarella, and basil.', '1. Slice tomatoes and mozzarella. 2. Arrange on a plate. 3. Drizzle with balsamic glaze. 4. Garnish with fresh basil. 5. Sprinkle with salt and pepper.', 4, 10, 0, 4),
('Blueberry Pancakes', 'Fluffy pancakes filled with fresh blueberries.', '1. Mix flour, baking powder, and sugar. 2. In a separate bowl, whisk eggs and milk. 3. Combine wet and dry ingredients. 4. Fold in blueberries. 5. Cook on a griddle until golden brown.', 8, 15, 15, 5),
('Chicken Alfredo Pasta', 'Creamy Alfredo sauce with grilled chicken over pasta.', '1. Cook pasta al dente. 2. Grill chicken until cooked. 3. Prepare Alfredo sauce. 4. Combine chicken, pasta, and sauce. 5. Garnish with parsley.', 4, 20, 25, 6),
('Quinoa Salad', 'Healthy salad with quinoa, vegetables, and feta cheese.', '1. Cook quinoa and let it cool. 2. Chop vegetables and mix with quinoa. 3. Crumble feta cheese on top. 4. Dress with olive oil and lemon juice. 5. Toss and serve chilled.', 6, 15, 0, 5),
('Lemon Garlic Shrimp', 'Garlicky shrimp with a zesty lemon twist.', '1. Sauté shrimp in garlic and butter. 2. Add lemon juice and zest. 3. Season with salt and pepper. 4. Cook until shrimp are pink. 5. Serve over rice or pasta.', 4, 10, 15, 5),
('Berry Smoothie Bowl', 'A refreshing and nutritious smoothie bowl with mixed berries.', '1. Blend mixed berries, yogurt, and honey. 2. Pour into a bowl. 3. Top with granola, sliced fruits, and chia seeds. 4. Enjoy immediately.', 2, 10, 0, 5),
('Vegetable Stir-Fry', 'Quick and colorful stir-fry with assorted vegetables.', '1. Stir-fry vegetables in a wok with sesame oil. 2. Add soy sauce and ginger. 3. Cook until veggies are tender-crisp. 4. Serve over rice or noodles.', 4, 15, 12, 5),
('Grilled Salmon with Lemon Dill Sauce', 'Healthy grilled salmon topped with a zesty lemon dill sauce.', '1. Preheat grill. 2. Season salmon fillets. 3. Grill until cooked through. 4. Mix lemon juice, dill, and yogurt for the sauce. 5. Serve salmon with the sauce.', 2, 15, 20, 11),
('Vegetable Lasagna', 'Layered lasagna with a variety of roasted vegetables and cheese.', '1. Roast assorted vegetables. 2. Prepare lasagna noodles. 3. Layer noodles, veggies, and cheese. 4. Bake until bubbly and golden. 5. Let it cool before serving.', 8, 30, 40, 12),
('Mango Avocado Salsa Chicken', 'Grilled chicken topped with a fresh mango avocado salsa.', '1. Grill chicken breasts. 2. Dice mango, avocado, and tomatoes. 3. Mix with red onion and cilantro. 4. Spoon salsa over grilled chicken. 5. Enjoy with rice or salad.', 4, 20, 15, 13),
('Greek Salad with Chicken', 'A classic Greek salad with added grilled chicken for protein.', '1. Grill chicken until fully cooked. 2. Toss together chopped tomatoes, cucumbers, olives, and feta. 3. Add grilled chicken on top. 4. Dress with olive oil and lemon juice.', 4, 15, 25, 14),
('Homemade Pizza', 'Create your own pizza with your favorite toppings.', '1. Preheat oven to 475°F. 2. Roll out pizza dough. 3. Add sauce, cheese, and toppings. 4. Bake until crust is golden and cheese is melted. 5. Slice and enjoy!', 4, 20, 15, 14),
('Beef and Broccoli Stir Fry', 'Tender beef strips and crisp broccoli in a savory stir-fry sauce.', '1. Sear beef in a hot wok. 2. Add broccoli and stir-fry until tender-crisp. 3. Mix in soy sauce and garlic. 4. Serve over rice.', 4, 15, 20, 16),
('Crispy Baked Chicken Thighs', 'Golden and crispy baked chicken thighs with a flavorful seasoning.', '1. Preheat oven to 425°F. 2. Season chicken thighs with spices. 3. Bake until skin is crispy and internal temperature reaches 165°F. 4. Let it rest before serving.', 4, 10, 35, 17),
('Mushroom Risotto', 'Creamy risotto with sautéed mushrooms and Parmesan cheese.', '1. Sauté mushrooms and onions. 2. Toast Arborio rice in butter. 3. Add warm broth gradually while stirring. 4. Stir in Parmesan cheese until creamy. 5. Garnish with parsley.', 4, 20, 25, 18),
('Honey Mustard Glazed Salmon', 'Baked salmon fillets glazed with a sweet and tangy honey mustard sauce.', '1. Preheat oven to 400°F. 2. Mix honey, mustard, and soy sauce. 3. Brush over salmon fillets. 4. Bake until salmon flakes easily with a fork. 5. Serve with lemon wedges.', 2, 10, 15, 19),
('Pesto Pasta with Cherry Tomatoes', 'Pasta tossed in a basil pesto sauce and topped with fresh cherry tomatoes.', '1. Cook pasta al dente. 2. Blend basil, garlic, pine nuts, and Parmesan for pesto. 3. Toss cooked pasta in pesto. 4. Top with halved cherry tomatoes. 5. Enjoy!', 4, 15, 15, 19),
('Teriyaki Chicken Skewers', 'Grilled chicken skewers glazed with teriyaki sauce.', '1. Marinate chicken in teriyaki sauce. 2. Thread onto skewers. 3. Grill until cooked through. 4. Brush with extra teriyaki sauce. 5. Serve with rice or veggies.', 4, 20, 15, 22),
('Spinach and Feta Stuffed Chicken', 'Chicken breasts stuffed with spinach and feta cheese.', '1. Butterfly chicken breasts. 2. Mix spinach, feta, and garlic. 3. Stuff into chicken. 4. Bake until chicken is cooked. 5. Serve with a side salad.', 4, 15, 30, 22),
('Black Bean and Corn Salsa', 'A flavorful salsa with black beans, corn, and fresh herbs.', '1. Mix black beans, corn, tomatoes, and cilantro. 2. Add lime juice and salt. 3. Let it chill in the fridge. 4. Serve with tortilla chips or as a topping.', 6, 10, 0, 23),
('Shrimp Scampi Pasta', 'Lemon garlic shrimp served over a bed of linguine pasta.', '1. Cook linguine al dente. 2. Sauté shrimp in garlic and butter. 3. Add white wine and lemon juice. 4. Toss cooked pasta in the shrimp mixture. 5. Garnish with parsley.', 4, 15, 20, 24),
('BBQ Pulled Pork Sandwiches', 'Slow-cooked pulled pork in barbecue sauce, served on brioche buns.', '1. Rub pork shoulder with BBQ seasoning. 2. Slow cook until tender. 3. Shred pork and mix with BBQ sauce. 4. Serve on toasted brioche buns with coleslaw.', 6, 30, 240, 25),
('Lemon Herb Grilled Chicken', 'Juicy grilled chicken marinated in lemon and herbs.', '1. Marinate chicken in lemon, garlic, and herbs. 2. Grill until fully cooked. 3. Serve with a side of roasted vegetables or salad.', 4, 15, 20, 26),
('Butternut Squash Risotto', 'Creamy risotto with roasted butternut squash and sage.', '1. Roast butternut squash with olive oil and sage. 2. Sauté onions and Arborio rice. 3. Add warm broth gradually while stirring. 4. Stir in roasted squash and Parmesan cheese.', 4, 20, 25, 27),
('Cajun Shrimp and Sausage Skillet', 'Spicy Cajun shrimp and sausage cooked in a flavorful skillet.', '1. Sauté sliced sausage until browned. 2. Add shrimp and Cajun seasoning. 3. Cook until shrimp are pink and cooked through. 4. Serve over rice or pasta.', 4, 15, 15, 27),
('Mediterranean Quinoa Bowl', 'A nutritious bowl with quinoa, roasted vegetables, olives, and feta.', '1. Cook quinoa and let it cool. 2. Roast vegetables with olive oil and Mediterranean herbs. 3. Assemble bowls with quinoa, veggies, olives, and crumbled feta.', 4, 15, 0, 27),
('Tomato Basil Bruschetta', 'Classic bruschetta with diced tomatoes, fresh basil, and balsamic glaze.', '1. Dice tomatoes and mix with chopped basil. 2. Add minced garlic, olive oil, and salt. 3. Spoon over toasted baguette slices. 4. Drizzle with balsamic glaze.', 4, 10, 0, 30),
('Sesame Ginger Glazed Salmon', 'Baked salmon fillets glazed with a flavorful sesame ginger sauce.', '1. Preheat oven to 400°F. 2. Mix sesame oil, soy sauce, ginger, and garlic. 3. Brush over salmon fillets. 4. Bake until salmon flakes easily with a fork. 5. Garnish with sesame seeds and green onions.', 2, 10, 15, 31),
('Sweet Potato Black Bean Chili', 'Hearty and flavorful chili with sweet potatoes, black beans, and spices.', '1. Sauté onions, garlic, and spices. 2. Add diced sweet potatoes, black beans, and tomatoes. 3. Simmer until sweet potatoes are tender. 4. Serve with toppings like avocado and cilantro.', 6, 15, 30, 32),
('Lemon Poppy Seed Muffins', 'Moist and tangy lemon poppy seed muffins with a sweet glaze.', '1. Mix flour, baking powder, and poppy seeds. 2. Beat butter, sugar, and eggs. 3. Add lemon zest and juice. 4. Combine wet and dry ingredients. 5. Bake until golden. 6. Drizzle with lemon glaze.', 12, 15, 20, 33),
('Chickpea and Spinach Curry', 'A vegetarian curry with chickpeas, spinach, and aromatic spices.', '1. Sauté onions, garlic, and spices. 2. Add chickpeas, tomatoes, and coconut milk. 3. Simmer until flavors meld. 4. Stir in fresh spinach. 5. Serve over rice.', 4, 15, 25, 34),
('Peach and Raspberry Crisp', 'Delicious peach and raspberry crisp with a buttery oat topping.', '1. Mix sliced peaches and raspberries with sugar and lemon juice. 2. Prepare a crumbly topping with oats, flour, butter, and sugar. 3. Bake until golden and bubbly. 4. Serve warm with vanilla ice cream.', 8, 20, 40, 35);



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
('Rice or Noodles', 1.50, 150, 3, 1),

('Chicken Breast', 3.99, 150, 25, 0),
('Lemon', 0.75, 17, 0.5, 2),
('Garlic', 0.5, 5, 0.2, 0.5),
('Olive Oil', 2.99, 120, 0, 0),
('Mixed Herbs', 1.25, 5, 0.2, 0.5),

('Arborio Rice', 2.5, 150, 3, 1),
('Butternut Squash', 1.99, 82, 2, 3),
('Sage', 1.25, 4, 0.2, 1),
('Onion', 0.75, 40, 1, 1),
('Parmesan Cheese', 3.99, 110, 7, 0),


('Shrimp', 5.99, 120, 20, 0),
('Sausage', 4.99, 250, 12, 0),
('Cajun Seasoning', 1.5, 5, 0.2, 1),
('Rice or Pasta', 1.99, 200, 5, 3),
('Vegetables', 2.5, 50, 2, 2),


('Quinoa', 3.5, 120, 4, 3),
('Zucchini', 2.0, 20, 1, 2),
('Cherry Tomatoes', 2.99, 15, 1, 1),
('Kalamata Olives', 4.5, 40, 1, 2),
('Feta Cheese', 3.75, 60, 4, 0.5),

('Tomatoes', 2.5, 15, 1, 1),
('Fresh Basil', 1.99, 5, 0.5, 0.5),
('Garlic', 0.5, 5, 0.2, 0.5),
('Baguette', 2.0, 100, 3, 1),
('Balsamic Glaze', 4.5, 30, 0, 0),

('Salmon Fillets', 7.99, 200, 25, 0),
('Sesame Oil', 4.0, 120, 0, 0),
('Soy Sauce', 2.5, 10, 2, 0),
('Ginger', 1.99, 5, 0.2, 0),
('Garlic', 0.5, 5, 0.2, 0.5),
('Sesame Seeds', 3.0, 30, 1, 1),
('Green Onions', 1.25, 5, 0.2, 1),


('Sweet Potatoes', 2.5, 112, 2, 4),
('Black Beans', 1.5, 120, 6, 5),
('Onions', 0.75, 40, 1, 1),
('Garlic', 0.5, 5, 0.2, 0.5),
('Chili Powder', 1.99, 5, 0.2, 1),
('Cumin', 1.5, 5, 0.2, 1),
('Tomatoes', 2.99, 15, 1, 1),
('Avocado', 2.0, 50, 1, 2),
('Cilantro', 1.25, 5, 0.2, 0.5),

('Flour', 1.99, 100, 3, 1),
('Baking Powder', 1.0, 0, 0, 0),
('Poppy Seeds', 2.5, 30, 1, 1),
('Butter', 3.5, 100, 0, 0),
('Sugar', 2.0, 45, 0, 0),
('Eggs', 2.5, 70, 6, 0),
('Lemon Zest', 1.99, 5, 0.2, 0.5),
('Lemon Juice', 2.5, 10, 0.2, 0),
('Powdered Sugar', 3.0, 30, 0, 0),

('Salmon Fillets', 7.99, 200, 25, 0),
('Sesame Oil', 4.0, 120, 0, 0),
('Soy Sauce', 2.5, 10, 2, 0),
('Ginger', 1.99, 5, 0.2, 0),
('Garlic', 0.5, 5, 0.2, 0.5),
('Sesame Seeds', 3.0, 30, 1, 1),
('Green Onions', 1.25, 5, 0.2, 1),

('Sweet Potatoes', 2.5, 112, 2, 4),
('Black Beans', 1.5, 120, 6, 5),
('Onions', 0.75, 40, 1, 1),
('Garlic', 0.5, 5, 0.2, 0.5),
('Chili Powder', 1.99, 5, 0.2, 1),
('Cumin', 1.5, 5, 0.2, 1),
('Tomatoes', 2.99, 15, 1, 1),
('Avocado', 2.0, 50, 1, 2),
('Cilantro', 1.25, 5, 0.2, 0.5),

('Flour', 1.99, 100, 3, 1),
('Baking Powder', 1.0, 0, 0, 0),
('Poppy Seeds', 2.5, 30, 1, 1),
('Butter', 3.5, 100, 0, 0),
('Sugar', 2.0, 45, 0, 0),
('Eggs', 2.5, 70, 6, 0),
('Lemon Zest', 1.99, 5, 0.2, 0.5),
('Lemon Juice', 2.5, 10, 0.2, 0),
('Powdered Sugar', 3.0, 30, 0, 0),

('Chickpeas', 1.5, 130, 7, 5),
('Spinach', 2.99, 20, 2, 2),
('Onions', 0.75, 40, 1, 1),
('Garlic', 0.5, 5, 0.2, 0.5),
('Tomatoes', 2.99, 15, 1, 1),
('Coconut Milk', 3.0, 120, 1, 0),
('Curry Powder', 1.99, 5, 0.2, 1),
('Cumin', 1.5, 5, 0.2, 1),

('Peaches', 3.0, 60, 1, 2),
('Raspberries', 4.5, 32, 1, 8),
('Sugar', 2.0, 45, 0, 0),
('Lemon Juice', 2.5, 10, 0.2, 0),
('Oats', 1.99, 120, 3, 5),
('Flour', 1.99, 100, 3, 1),
('Butter', 3.5, 100, 0, 0),
('Cinnamon', 1.5, 5, 0.2, 1);


-- RecipeIngredients for Peach and Raspberry Crisp
INSERT INTO RecipeIngredients (RecipeID, IngredientID, Units) VALUES
(35, 59, 2),
(35, 60, 1),
(35, 61, 1),
(35, 62, 1),
(35, 63, 1),
(35, 64, 0.5),
(35, 65, 0.5),
(35, 66, 0.5);



-- RecipeIngredients for Chickpea and Spinach Curry
INSERT INTO RecipeIngredients (RecipeID, IngredientID, Units) VALUES
(34, 51, 1),
(34, 52, 0.5),
(34, 53, 2),
(34, 54, 1),
(34, 55, 1),
(34, 56, 1),
(34, 57, 1),
(34, 58, 0.5);

-- RecipeIngredients for Lemon Poppy Seed Muffins
INSERT INTO RecipeIngredients (RecipeID, IngredientID, Units) VALUES
(33, 42, 2),
(33, 43, 1),
(33, 44, 1),
(33, 45, 0.5),
(33, 46, 1),
(33, 47, 2),
(33, 48, 1),
(33, 49, 0.5),
(33, 50, 0.5);

-- RecipeIngredients for Sweet Potato Black Bean Chili
INSERT INTO RecipeIngredients (RecipeID, IngredientID, Units) VALUES
(32, 33, 2),
(32, 34, 1),
(32, 35, 1),
(32, 36, 2),
(32, 37, 1),
(32, 38, 1),
(32, 39, 1),
(32, 40, 0.5),
(32, 41, 0.5);


-- RecipeIngredients for Sesame Ginger Glazed Salmon
INSERT INTO RecipeIngredients (RecipeID, IngredientID, Units) VALUES
(31, 26, 2),
(31, 27, 0.5),
(31, 28, 1),
(31, 29, 1),
(31, 30, 0.5),
(31, 31, 1),
(31, 32, 0.5);


-- RecipeIngredients for Lemon Poppy Seed Muffins
INSERT INTO RecipeIngredients (RecipeID, IngredientID, Units) VALUES
(33, 42, 2),
(33, 43, 1),
(33, 44, 1),
(33, 45, 0.5),
(33, 46, 1),
(33, 47, 2),
(33, 48, 1),
(33, 49, 0.5),
(33, 50, 0.5);


-- RecipeIngredients for Sweet Potato Black Bean Chili
INSERT INTO RecipeIngredients (RecipeID, IngredientID, Units) VALUES
(32, 33, 2),
(32, 34, 1),
(32, 35, 1),
(32, 36, 2),
(32, 37, 1),
(32, 38, 1),
(32, 39, 1),
(32, 40, 0.5),
(32, 41, 0.5);



-- RecipeIngredients for Sesame Ginger Glazed Salmon
INSERT INTO RecipeIngredients (RecipeID, IngredientID, Units) VALUES
(31, 26, 2),
(31, 27, 0.5),
(31, 28, 1),
(31, 29, 1),
(31, 30, 0.5),
(31, 31, 1),
(31, 32, 0.5);



-- RecipeIngredients for Tomato Basil Bruschetta
INSERT INTO RecipeIngredients (RecipeID, IngredientID, Units) VALUES
(30, 21, 2),
(30, 22, 0.5),
(30, 23, 2),
(30, 24, 4),
(30, 25, 1);



-- RecipeIngredients for Mediterranean Quinoa Bowl
INSERT INTO RecipeIngredients (RecipeID, IngredientID, Units) VALUES
(29, 16, 1),
(29, 17, 0.5),
(29, 18, 1),
(29, 19, 0.25),
(29, 20, 0.5);


-- RecipeIngredients for Lemon Herb Grilled Chicken
INSERT INTO RecipeIngredients (RecipeID, IngredientID, Units) VALUES
(26, 1, 4),
(26, 2, 1),
(26, 3, 2),
(26, 4, 2),
(26, 5, 1);

-- RecipeIngredients for Butternut Squash Risotto
INSERT INTO RecipeIngredients (RecipeID, IngredientID, Units) VALUES
(27, 6, 1),
(27, 7, 1),
(27, 8, 0.5),
(27, 9, 1),
(27, 10, 1);

-- RecipeIngredients for Cajun Shrimp and Sausage Skillet
INSERT INTO RecipeIngredients (RecipeID, IngredientID, Units) VALUES
(28, 11, 0.5),
(28, 12, 0.25),
(28, 13, 2),
(28, 14, 1),
(28, 15, 1);



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

-- RecipeCategories for Spaghetti Bolognese
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES (1, 1);

-- RecipeCategories for Vegetarian Tacos
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES (2, 2);

-- RecipeCategories for Chocolate Cake
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES (3, 3);

-- RecipeCategories for Caprese Salad
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES (4, 7);

-- RecipeCategories for Blueberry Pancakes
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES (5, 9);

-- RecipeCategories for Chicken Alfredo Pasta
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES (6, 5);

-- RecipeCategories for Quinoa Salad
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES (7, 7);

-- RecipeCategories for Lemon Garlic Shrimp
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES (8, 5);

-- RecipeCategories for Berry Smoothie Bowl
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES (9, 10);

-- RecipeCategories for Vegetable Stir-Fry
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES (10, 5);

-- RecipeCategories for Grilled Salmon with Lemon Dill Sauce
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES (11, 5);

-- RecipeCategories for Vegetable Lasagna
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES (12, 6);

-- RecipeCategories for Mango Avocado Salsa Chicken
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES (13, 1);

-- RecipeCategories for Greek Salad with Chicken
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES (14, 7);

-- RecipeCategories for Homemade Pizza
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES (15, 6);

-- RecipeCategories for Beef and Broccoli Stir Fry
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES (16, 5);

-- RecipeCategories for Crispy Baked Chicken Thighs
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES (17, 5);

-- RecipeCategories for Mushroom Risotto
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES (18, 6);

-- RecipeCategories for Honey Mustard Glazed Salmon
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES (19, 5);

-- RecipeCategories for Pesto Pasta with Cherry Tomatoes
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES (20, 1);

-- RecipeCategories for Teriyaki Chicken Skewers
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES (21, 5);

-- RecipeCategories for Spinach and Feta Stuffed Chicken
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES (22, 5);

-- RecipeCategories for Black Bean and Corn Salsa
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES (23, 2);

-- RecipeCategories for Shrimp Scampi Pasta
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES (24, 5);

-- RecipeCategories for BBQ Pulled Pork Sandwiches
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES (25, 5);

-- RecipeCategories for Lemon Herb Grilled Chicken
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES (26, 5);

-- RecipeCategories for Butternut Squash Risotto
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES (27, 6);

-- RecipeCategories for Cajun Shrimp and Sausage Skillet
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES (28, 5);

-- RecipeCategories for Mediterranean Quinoa Bowl
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES (29, 7);

-- RecipeCategories for Tomato Basil Bruschetta
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES (30, 1);

-- RecipeCategories for Sesame Ginger Glazed Salmon
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES (31, 5);

-- RecipeCategories for Sweet Potato Black Bean Chili
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES (32, 2);

-- RecipeCategories for Lemon Poppy Seed Muffins
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES (33, 3);

-- RecipeCategories for Chickpea and Spinach Curry
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES (34, 2);

-- RecipeCategories for Peach and Raspberry Crisp
INSERT INTO RecipeCategories (RecipeID, CategoryID) VALUES (35, 3);


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


-- Reviews for Spaghetti Bolognese (RecipeID: 1)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (26, 1, 'Delicious! My family loved it.', 5),
                                                               (15, 1, 'Classic recipe, always a winner.', 4),
                                                               (7, 1, 'Easy to make and very tasty.', 5),
                                                               (12, 1, 'The best Bolognese I ever had!', 5),
                                                               (18, 1, 'Comfort food at its finest.', 4);

-- Reviews for Vegetarian Tacos (RecipeID: 2)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (8, 2, 'A great meatless option. Loved it!', 4),
                                                               (19, 2, 'Taco night just got healthier!', 5),
                                                               (5, 2, 'Flavorful and satisfying.', 4),
                                                               (21, 2, 'Even meat lovers enjoyed these tacos.', 5),
                                                               (14, 2, 'Will definitely make again.', 4);

-- Reviews for Chocolate Cake (RecipeID: 3)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (10, 3, 'Moist and rich. Perfect chocolate cake!', 5),
                                                               (23, 3, 'A chocolate lover''s dream!', 5),
                                                               (3, 3, 'Easy to follow recipe. Great results.', 4),
                                                               (29, 3, 'Made this for a birthday, everyone loved it.', 5),
                                                               (6, 3, 'Delicious! The frosting is amazing.', 4);

-- Reviews for Caprese Salad (RecipeID: 4)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (1, 4, 'Simple and refreshing. A summer favorite.', 5),
                                                               (25, 4, 'Classic Caprese done right.', 4),
                                                               (13, 4, 'Great balance of flavors.', 5),
                                                               (9, 4, 'Perfect appetizer or side dish.', 4),
                                                               (17, 4, 'Love the balsamic glaze.', 5);

-- Reviews for Blueberry Pancakes (RecipeID: 5)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (11, 5, 'Light and fluffy. The blueberries are a nice touch.', 5),
                                                               (27, 5, 'My family requested these again!', 4),
                                                               (4, 5, 'Best blueberry pancakes I''ve had.', 5),
                                                               (20, 5, 'Great breakfast option.', 4),
                                                               (2, 5, 'Quick and easy recipe.', 5);

-- Reviews for Chicken Alfredo Pasta (RecipeID: 6)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (22, 6, 'Creamy and delicious. A family favorite.', 5),
                                                               (16, 6, 'Amazing Alfredo sauce! Loved every bite.', 4),
                                                               (24, 6, 'Simple to make, tastes restaurant-quality.', 5),
                                                               (10, 6, 'The grilled chicken adds a nice touch.', 4),
                                                               (5, 6, 'Will be making this again soon.', 5);

-- Reviews for Quinoa Salad (RecipeID: 7)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (18, 7, 'Healthy and tasty. A great side dish.', 4),
                                                               (8, 7, 'Refreshing salad with a good mix of veggies.', 5),
                                                               (12, 7, 'Love the combination of quinoa and feta.', 4),
                                                               (3, 7, 'Perfect for a light lunch.', 5),
                                                               (26, 7, 'Great way to incorporate quinoa into my diet.', 4);

-- Reviews for Lemon Garlic Shrimp (RecipeID: 8)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (1, 8, 'Garlicky goodness! Shrimp cooked to perfection.', 5),
                                                               (13, 8, 'Quick and flavorful. Loved the lemon twist.', 4),
                                                               (7, 8, 'Delicious over pasta. A new favorite.', 5),
                                                               (23, 8, 'Simple yet so tasty. Will make again.', 4),
                                                               (19, 8, 'Great recipe for a seafood lover.', 5);

-- Reviews for Berry Smoothie Bowl (RecipeID: 9)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (15, 9, 'Refreshing and healthy breakfast option.', 4),
                                                               (6, 9, 'Beautiful presentation. Tastes great too!', 5),
                                                               (27, 9, 'Love the combination of berries and granola.', 4),
                                                               (14, 9, 'Quick and easy to make in the morning.', 5),
                                                               (11, 9, 'Perfect for a summer breakfast.', 4);

-- Reviews for Vegetable Stir-Fry (RecipeID: 10)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (9, 10, 'Colorful and delicious stir-fry!', 5),
                                                                (21, 10, 'Easy weeknight meal. Loved the flavors.', 4),
                                                                (4, 10, 'Great way to eat more veggies.', 5),
                                                                (17, 10, 'Soy sauce adds a nice umami flavor.', 4),
                                                                (28, 10, 'Will definitely make this again.', 5);

-- Reviews for Grilled Salmon with Lemon Dill Sauce (RecipeID: 11)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (20, 11, 'The dill sauce is a game-changer! Delicious.', 5),
                                                                    (2, 11, 'Perfectly grilled salmon. Loved the citrusy flavor.', 4),
                                                                    (25, 11, 'Healthy and flavorful. A great weeknight dinner.', 5),
                                                                    (7, 11, 'The lemon dill sauce is so refreshing!', 4),
                                                                    (14, 11, 'Impressed with how easy and tasty this was.', 5);

-- Reviews for Vegetable Lasagna (RecipeID: 12)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (8, 12, 'Loaded with veggies. A satisfying meal.', 4),
                                                                    (3, 12, 'The roasted vegetables add a nice depth of flavor.', 5),
                                                                    (19, 12, 'Cheesy and comforting. Perfect for a family dinner.', 4),
                                                                    (27, 12, 'Will make this again for sure!', 5),
                                                                    (12, 12, 'A vegetarian delight. Even the kids loved it.', 4);

-- Reviews for Mango Avocado Salsa Chicken (RecipeID: 13)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (24, 13, 'The salsa is a burst of tropical flavors!', 5),
                                                                    (11, 13, 'Grilled chicken perfection. Loved the mango salsa.', 4),
                                                                    (22, 13, 'Refreshing and light. Perfect for summer.', 5),
                                                                    (5, 13, 'A unique twist to grilled chicken. Loved it!', 4),
                                                                    (16, 13, 'Delicious and colorful. Will make again.', 5);

-- Reviews for Greek Salad with Chicken (RecipeID: 14)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (21, 14, 'Classic Greek salad with a protein boost. Yum!', 4),
                                                                    (10, 14, 'Grilled chicken adds a nice touch to the salad.', 5),
                                                                    (6, 14, 'Healthy and satisfying. A favorite in our house.', 4),
                                                                    (26, 14, 'Love the combination of flavors. Will repeat!', 5),
                                                                    (1, 14, 'Perfect for a light and nutritious lunch.', 4);

-- Reviews for Homemade Pizza (RecipeID: 15)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (13, 15, 'Great pizza dough recipe. Loved customizing toppings.', 5),
                                                                    (4, 15, 'Fun and easy to make with the family.', 4),
                                                                    (17, 15, 'Better than ordering takeout. Delicious!', 5),
                                                                    (28, 15, 'Homemade pizza night is a hit! Thanks for the recipe.', 4),
                                                                    (9, 15, 'A classic with a personal touch. Will make again.', 5);


-- Reviews for Beef and Broccoli Stir Fry (RecipeID: 16)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (23, 16, 'Tender beef and flavorful sauce. A quick and tasty stir fry!', 5),
                                                                    (3, 16, 'Better than takeout. Loved the broccoli!', 4),
                                                                    (18, 16, 'A go-to recipe for busy weeknights. Delicious!', 5),
                                                                    (29, 16, 'The sauce is perfect. Will be making this often.', 4),
                                                                    (7, 16, 'Simple and tasty. Family-approved.', 5);

-- Reviews for Crispy Baked Chicken Thighs (RecipeID: 17)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (2, 17, 'Crispy skin and juicy meat. A winner!', 5),
                                                                    (14, 17, 'Perfectly seasoned. The whole family loved it.', 4),
                                                                    (22, 17, 'Easy and delicious. A new favorite.', 5),
                                                                    (11, 17, 'Crispy perfection. Great for a weeknight dinner.', 4),
                                                                    (25, 17, 'Best baked chicken thighs Ive ever had.', 5);

-- Reviews for Mushroom Risotto (RecipeID: 18)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (10, 18, 'Creamy and flavorful. The mushrooms are a nice touch.', 4),
                                                                    (4, 18, 'The risotto turned out amazing. A must-try!', 5),
                                                                    (16, 18, 'Impressed with the creamy texture. Will make again.', 4),
                                                                    (27, 18, 'Perfect comfort food. Loved every bite.', 5),
                                                                    (6, 18, 'Great recipe for mushroom lovers. Highly recommend!', 4);

-- Reviews for Honey Mustard Glazed Salmon (RecipeID: 19)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (28, 19, 'The honey mustard glaze is a game-changer!', 5),
                                                                    (12, 19, 'Sweet and tangy perfection. Loved the flavor.', 4),
                                                                    (20, 19, 'Impressed with how easy and tasty this was.', 5),
                                                                    (5, 19, 'Perfectly glazed salmon. A new favorite.', 4),
                                                                    (17, 19, 'The sauce adds a delightful twist. Will make again.', 5);

-- Reviews for Pesto Pasta with Cherry Tomatoes (RecipeID: 20)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (1, 20, 'The pesto is so flavorful. Loved the cherry tomatoes!', 4),
                                                                    (19, 20, 'Delicious and easy. A great summer dish.', 5),
                                                                    (9, 20, 'Fresh and tasty. Will be making this often.', 4),
                                                                    (26, 20, 'The cherry tomatoes add a burst of freshness.', 5),
                                                                    (8, 20, 'Perfect for a quick and satisfying meal.', 4);


-- Reviews for Teriyaki Chicken Skewers (RecipeID: 21)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (13, 21, 'The teriyaki glaze is amazing. A family favorite now.', 5),
                                                                    (24, 21, 'Simple and delicious. Perfect for a barbecue.', 4),
                                                                    (3, 21, 'Tender and flavorful. Great for parties.', 5),
                                                                    (15, 21, 'The skewers were a hit. Will be making again!', 4),
                                                                    (22, 21, 'Easy to make and so tasty. Highly recommend.', 5);

-- Reviews for Spinach and Feta Stuffed Chicken (RecipeID: 22)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (5, 22, 'The spinach and feta filling is divine. Loved it!', 5),
                                                                    (16, 22, 'Impressed with how juicy the chicken turned out.', 4),
                                                                    (26, 22, 'A delicious and elegant dish. Perfect for guests.', 5),
                                                                    (9, 22, 'Stuffed chicken perfection. A new dinner favorite.', 4),
                                                                    (18, 22, 'The flavors meld beautifully. Will make this again.', 5);

-- Reviews for Black Bean and Corn Salsa (RecipeID: 23)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (23, 23, 'A refreshing and flavorful salsa. Great for parties.', 5),
                                                                    (7, 23, 'Love the combination of black beans and corn.', 4),
                                                                    (11, 23, 'Great as a topping or with chips. So delicious!', 5),
                                                                    (29, 23, 'A quick and healthy snack option. Highly recommend.', 4),
                                                                    (1, 23, 'Perfect for summer gatherings. Will make it again.', 5);

-- Reviews for Shrimp Scampi Pasta (RecipeID: 24)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (14, 24, 'The shrimp scampi pasta was a hit. Flavorful and light.', 5),
                                                                    (19, 24, 'The lemony garlic sauce is perfection. Loved it!', 4),
                                                                    (27, 24, 'A restaurant-quality dish. Impressed with the flavors.', 5),
                                                                    (8, 24, 'Easy to make and so delicious. Will be a regular meal.', 4),
                                                                    (10, 24, 'Perfect for seafood lovers. The family loved it.', 5);

-- Reviews for BBQ Pulled Pork Sandwiches (RecipeID: 25)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (2, 25, 'The pulled pork is so tender and flavorful. A barbecue delight!', 5),
                                                                    (12, 25, 'Slow-cooked perfection. The barbecue sauce is amazing.', 4),
                                                                    (20, 25, 'Great for a crowd. The sandwiches disappeared quickly!', 5),
                                                                    (6, 25, 'The coleslaw adds a nice crunch. Will make it again.', 4),
                                                                    (28, 25, 'Delicious and easy. A hit at our family gathering.', 5);

-- Reviews for Teriyaki Chicken Skewers (RecipeID: 21)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (13, 21, 'The teriyaki glaze is amazing. A family favorite now.', 5),
                                                                    (24, 21, 'Simple and delicious. Perfect for a barbecue.', 4),
                                                                    (3, 21, 'Tender and flavorful. Great for parties.', 5),
                                                                    (15, 21, 'The skewers were a hit. Will be making again!', 4),
                                                                    (22, 21, 'Easy to make and so tasty. Highly recommend.', 5);

-- Reviews for Spinach and Feta Stuffed Chicken (RecipeID: 22)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (5, 22, 'The spinach and feta filling is divine. Loved it!', 5),
                                                                    (16, 22, 'Impressed with how juicy the chicken turned out.', 4),
                                                                    (26, 22, 'A delicious and elegant dish. Perfect for guests.', 5),
                                                                    (9, 22, 'Stuffed chicken perfection. A new dinner favorite.', 4),
                                                                    (18, 22, 'The flavors meld beautifully. Will make this again.', 5);

-- Reviews for Black Bean and Corn Salsa (RecipeID: 23)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (23, 23, 'A refreshing and flavorful salsa. Great for parties.', 5),
                                                                    (7, 23, 'Love the combination of black beans and corn.', 4),
                                                                    (11, 23, 'Great as a topping or with chips. So delicious!', 5),
                                                                    (29, 23, 'A quick and healthy snack option. Highly recommend.', 4),
                                                                    (1, 23, 'Perfect for summer gatherings. Will make it again.', 5);

-- Reviews for Shrimp Scampi Pasta (RecipeID: 24)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (14, 24, 'The shrimp scampi pasta was a hit. Flavorful and light.', 5),
                                                                    (19, 24, 'The lemony garlic sauce is perfection. Loved it!', 4),
                                                                    (27, 24, 'A restaurant-quality dish. Impressed with the flavors.', 5),
                                                                    (8, 24, 'Easy to make and so delicious. Will be a regular meal.', 4),
                                                                    (10, 24, 'Perfect for seafood lovers. The family loved it.', 5);

-- Reviews for BBQ Pulled Pork Sandwiches (RecipeID: 25)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (2, 25, 'The pulled pork is so tender and flavorful. A barbecue delight!', 5),
                                                                    (12, 25, 'Slow-cooked perfection. The barbecue sauce is amazing.', 4),
                                                                    (20, 25, 'Great for a crowd. The sandwiches disappeared quickly!', 5),
                                                                    (6, 25, 'The coleslaw adds a nice crunch. Will make it again.', 4),
                                                                    (28, 25, 'Delicious and easy. A hit at our family gathering.', 5);

-- Reviews for Lemon Herb Grilled Chicken (RecipeID: 26)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (4, 26, 'The lemon herb marinade is fantastic. Grilled to perfection!', 5),
                                                                    (13, 26, 'Simple and flavorful. Loved the grilled chicken.', 4),
                                                                    (21, 26, 'The herbs add a nice touch. Great for a summer barbecue.', 5),
                                                                    (25, 26, 'Delicious and moist. A new favorite in our house.', 4),
                                                                    (3, 26, 'Perfectly grilled chicken. Will be making this often.', 5);

-- Reviews for Butternut Squash Risotto (RecipeID: 27)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (15, 27, 'Creamy and comforting. The butternut squash adds a lovely sweetness.', 5),
                                                                    (22, 27, 'Risotto perfection. The roasted squash is a great addition.', 4),
                                                                    (10, 27, 'Delicious fall dish. The sage gives it a nice flavor.', 5),
                                                                    (1, 27, 'Creamy and satisfying. Will be making it again for sure.', 4),
                                                                    (19, 27, 'Impressed with the rich flavors. Great for a cozy night.', 5);

-- Reviews for Cajun Shrimp and Sausage Skillet (RecipeID: 28)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (7, 28, 'Spicy and flavorful. Loved the combination of shrimp and sausage.', 5),
                                                                    (11, 28, 'Cajun perfection. A bit spicy but so delicious!', 4),
                                                                    (29, 28, 'Quick and easy dinner. Will be making it again.', 5),
                                                                    (14, 28, 'The flavors are bold and satisfying. A favorite now!', 4),
                                                                    (6, 28, 'Great one-pan dish. Perfect for busy weeknights.', 5);

-- Reviews for Mediterranean Quinoa Bowl (RecipeID: 29)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (23, 29, 'A healthy and satisfying bowl. Loved the Mediterranean flavors.', 5),
                                                                    (8, 29, 'The quinoa and roasted veggies are a great combination.', 4),
                                                                    (2, 29, 'Simple and nutritious. A great lunch option!', 5),
                                                                    (12, 29, 'Delicious and filling. Will be adding this to my rotation.', 4),
                                                                    (16, 29, 'The feta adds a nice tang. A well-balanced meal.', 5);

-- Reviews for Tomato Basil Bruschetta (RecipeID: 30)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (9, 30, 'Classic and flavorful bruschetta. Great for appetizers!', 5),
                                                                    (18, 30, 'The tomatoes and basil are so fresh. A perfect snack.', 4),
                                                                    (26, 30, 'Simple to make and bursting with flavor. Loved it!', 5),
                                                                    (5, 30, 'Delicious and light. A great way to start a meal.', 4),
                                                                    (20, 30, 'Perfect for summer gatherings. Will be making it again.', 5);

-- Reviews for Sesame Ginger Glazed Salmon (RecipeID: 31)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (19, 31, 'The sesame ginger glaze is a game-changer. Loved the flavors!', 5),
                                                                    (28, 31, 'Delicious and easy to make. A hit with the family.', 4),
                                                                    (13, 31, 'The salmon turned out perfectly. Great weeknight meal.', 5),
                                                                    (3, 31, 'The ginger adds a nice kick. Will be making it again.', 4),
                                                                    (14, 31, 'Impressed with how flavorful and moist the salmon is. A keeper!', 5);

-- Reviews for Sweet Potato Black Bean Chili (RecipeID: 32)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (6, 32, 'Hearty and flavorful. The sweet potatoes add a nice touch.', 5),
                                                                    (16, 32, 'Perfect for cold nights. A new favorite chili recipe.', 4),
                                                                    (21, 32, 'The spices are just right. Will make it again.', 5),
                                                                    (25, 32, 'Healthy and satisfying. Great with some crusty bread.', 4),
                                                                    (4, 32, 'The black beans and sweet potatoes complement each other well. Loved it!', 5);

-- Reviews for Lemon Poppy Seed Muffins (RecipeID: 33)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (5, 33, 'Moist and tangy. The lemon glaze is a delightful finish.', 5),
                                                                    (15, 33, 'Perfectly sweet and tangy. A great breakfast treat.', 4),
                                                                    (24, 33, 'The poppy seeds add a nice crunch. Loved these muffins!', 5),
                                                                    (10, 33, 'Delicious muffins. A hit with my family.', 4),
                                                                    (8, 33, 'Easy to make and so flavorful. Will be making them again.', 5);

-- Reviews for Chickpea and Spinach Curry (RecipeID: 34)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (12, 34, 'A flavorful and satisfying vegetarian curry. Loved it!', 5),
                                                                    (1, 34, 'Great meatless option. The spices are well-balanced.', 4),
                                                                    (29, 34, 'The coconut milk adds creaminess. Will make it again.', 5),
                                                                    (19, 34, 'Delicious curry. Perfect with some naan or rice.', 4),
                                                                    (23, 34, 'Easy to make and so tasty. A regular in our house now.', 5);

-- Reviews for Peach and Raspberry Crisp (RecipeID: 35)
INSERT INTO Reviews (UserID, RecipeID, ReviewContent, Rating) VALUES (9, 35, 'The peach and raspberry combination is heavenly. Loved the crisp!', 5),
                                                                    (26, 35, 'Perfectly sweet and fruity. A great dessert.', 4),
                                                                    (17, 35, 'The oat topping is so good. Will be making it again.', 5),
                                                                    (22, 35, 'Delicious with a scoop of vanilla ice cream. A crowd-pleaser!', 4),
                                                                    (7, 35, 'Great way to use fresh peaches and raspberries. Loved it!', 5);

-- Continue this pattern for the remaining recipes...



















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

