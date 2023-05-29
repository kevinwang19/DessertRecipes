# DessertRecipes

This app allows you to browse a list of 64 desserts, sorted alphabetically.

<img src="https://github.com/kevinwang19/DessertRecipes/assets/70813550/bd15bf3c-459e-458c-9559-6bacf10eddbb" height="400">

When selecting a row in the desserts list, the user is taken to a detailed page of the dessert information, ingredients, instructions, and video.

<img src="https://github.com/kevinwang19/DessertRecipes/assets/70813550/c9e4adb4-b283-450d-89f4-1fb2dde4146a" height="400">
<img src="https://github.com/kevinwang19/DessertRecipes/assets/70813550/570f38b4-20cf-4263-b27d-774a9acd1466" height="400">

##
The list of desserts is fetched from the api endpoint https://themealdb.com/api/json/v1/1/filter.php?c=Dessert, which has variables strMeal (dessert name), strMealThumb (dessert image link), and idMeal (dessert ID for fetching the details). A JSON decoder is used to assign these variables to a Meal object, which is then added to an array of Meal objects. This array is then iterated through to display each dessert in the view.
Navigation Links are used to display a new dessert detail view for when a dessert row is clicked, using the idMeal variable. The dessert details is fetched from the api endpoint https://themealdb.com/api/json/v1/1/lookup.php?i=[idMeal], which has variables idMeal (dessert ID), strMeal (dessert name), strDrinkAlternate, strCategory (dessert category), strArea (dessert origin), strInstructions (dessert instructions), strMealThumb (dessert image link), strTags (dessert key words), strYoutube (Youtube video link), strIngredient1-20 (ingredients), strMeasure1-20 (measurements), strSource (source link), strImageSource (image source link), strCreativeCommonsConfirmed, and dateModified. A JSON decoder is used to assign all these variables (except ingredients and measures) to a Detail object. For the strIngredient and strMeasure variables, a JSON Serialization is used instead to parse the data into a dictionary so that all the strIngredient values can be added to an ingredients array and all the strMeasure values can be added to a measures array. The Detail object values and the ingredients and measures arrays are then displayed in the dessert detail view.
