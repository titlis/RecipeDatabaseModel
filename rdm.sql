/*  Menus is the main table which contains all the menus with some
	basic information, such as name, type, description. Each menu 
	need to be assigned an unique id which is used to identify and
	retrive useful information from other tables. E.g. get recipes
	by a menu's id, see MenuRecipes.
 */
CREATE TABLE Menus
(
	menu_id int NOT NULL PRIMARY KEY,
	menu_name tinytext,
	menu_type tinytext, /* Dinner, Lunch, ... */
	menu_description text
);

/*  Recipes stores only the names and descriptions of the recipes.
	Ingredients and instructions are store in different tables
	because ingredients can be shared among different recipes and
	instructions might not be useful sometime. Each recipe also 
	need to have an unique id.
 */
CREATE TABLE Recipes
(
	recipe_id int NOT NULL PRIMARY KEY,
	recipe_name tinytext,
	recipe_type tinytext, /* Search recipes by types: Japanese, Vegetarian.. */
	recipe_description text
);

/*  MenuRecipes is the connection between Menus and Recipes. Since
	two menus can share the same recipe, instaed of having a 
	many-to-many relationship, we can convert them to one-to-many 
	relationship.
*/
CREATE TABLE MenuRecipes
(
    menu_id int,
    recipe_id int,
    FOREIGN KEY(menu_id) REFERENCES Menus(menu_id),
    FOREIGN KEY(recipe_id) REFERENCES Recipes(recipe_id)
);

/*  Ingredients stores the name and type of the ingrdients. The
	id of an ingredient is unique.
*/
CREATE TABLE Ingredients
(
	ingredient_id int NOT NULL PRIMARY KEY,
	ingredient_name tinytext,
	ingredient_type tinytext /* Meat, Vegs, Fish, Dairy.. */
);

/*  RecipesIngredients contains the quatity and the measurement unit
	of each ingredient in a recipe, which are different among different
	recipes. Same as MenuRecipes, it is the connection between 
	Recipes and Ingredients. Two Recipes can share the same ingredient, 
	instaed of having a many-to-many relationship, we can convert them to 
	one-to-many relationship. By this, we can also search recipes by 
	specifying the ingredients that we want to use in our cooking.
*/
CREATE TABLE RecipesIngredients
(
    recipe_id int,
    ingredient_id int,
    ingredient_quatity decimal(7,2),
    ingredient_unit varchar(10), /* g, kg, grams, slices, ... */
    FOREIGN KEY(recipe_id) REFERENCES Recipes(recipe_id),
    FOREIGN KEY(ingredient_id) REFERENCES Ingredients(ingredient_id)
);

/*  Instructions stores all the steps of recipes, each with their 
	step number and description. They are retrived by the recipe id.
*/
CREATE TABLE Instructions
(
    recipe_id int,
    step_number tinyint,
    step_description text,
    FOREIGN KEY(recipe_id) REFERENCES Recipes(recipe_id)
);

/* Examples */
/* Let's create two customer's menu. */
insert into Menus values(1, "Menu123", "Asian", "bhabhabha..");
insert into Menus values(2, "My favorite", "Japanese", "bhabhabha..");
/* Two of my favorite japanese food! */
insert into Recipes values(101, "Katsudon", "Donburi", "Katsudon (カツ丼) is a popular Japanese food, a bowl of rice topped with a deep-fried pork cutlet, egg, vegetables, and condiments.");
insert into Recipes values(102, "Gyudon", "Donburi", "Gyudon (牛丼), is a Japanese dish consisting of a bowl of rice topped with beef and onion simmered in a mildly sweet sauce flavored with dashi, soy sauce and mirin.");
/* Add some ingredients */
insert into Ingredients values(305, "Rice", "Grain");
insert into Ingredients values(389, "Pork cutlet", "Meat");
insert into Ingredients values(636, "Beef", "Meat");
insert into Ingredients values(423, "Egg", "Dairy");
insert into Ingredients values(523, "Onion", "Vegetables");
insert into Ingredients values(4933, "Mirin", "Condiments");
/* Associate ingredients with the recipes */
/* what is needed for a Katsudon? */
insert into RecipesIngredients values(101, 305, 2, "bowls");
insert into RecipesIngredients values(101, 389, 380, "grams");
insert into RecipesIngredients values(101, 423, 3, "large");
insert into RecipesIngredients values(101, 523, 90, "grams");
/* Gyudon? */
insert into RecipesIngredients values(102, 636, 150, "grams");
insert into RecipesIngredients values(102, 523, 100, "grams");
insert into RecipesIngredients values(102, 4933, 2, "spoon");
/* How to cook? */
insert into Instructions values(102, 1, "First, prepare the rice.");
insert into Instructions values(102, 2, "Second, cut the onion and cook the beef.");
insert into Instructions values(102, 3, "goto yoshinoya..");
/* Add the recipes to our menus */
insert into MenuRecipes values(1, 101);
insert into MenuRecipes values(2, 101);
insert into MenuRecipes values(2, 102);

/* Give me recipes of donburi */
select recipe_name, recipe_description from Recipes where recipe_type = "Donburi";
/* Okay I wanna cook gyudon! */
select step_number, step_description  from Recipes natural join Instructions where recipe_name = "Gyudon" order by step_number;
