//
//  RecipesViewModel.swift
//  Recipes
//
//  Created by Kevin Wang on 2023-05-27.
//

import Foundation
import SwiftUI

struct Meals: Codable {
    let meals: [Meal]
}

struct Details: Codable {
    let meals: [Detail]
}

struct Meal: Hashable, Codable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
}

struct Detail: Hashable, Codable {
    let idMeal: String
    let strMeal: String
    let strDrinkAlternate: String?
    let strCategory: String
    let strArea: String
    let strInstructions: String
    let strMealThumb: String
    let strTags: String?
    let strYoutube: String?
    let strSource: String?
    let strImageSource: String?
    let strCreativeCommonsConfirmed: String?
    let dateModified: String?
}

class RecipesViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var details: Detail?
    @Published var ingredients: [String] = []
    @Published var measures: [String] = []
    
    func fetchMeals() {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else {
            return
        }
        
        // Retrieve the json data
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                // Parse json data into the Meals object
                let meals = try JSONDecoder().decode(Meals.self, from: data)
                DispatchQueue.main.async {
                    // Assign array of values to the Meals object array
                    self?.meals = meals.meals
                }
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func fetchDetails(id: String) {
        let urlString = "https://themealdb.com/api/json/v1/1/lookup.php?i=" + id
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        // Retrieve the json data
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                // Parse selective json data into the Details object
                let details = try JSONDecoder().decode(Details.self, from: data)
                DispatchQueue.main.async {
                    // There is only one element in the details array so use the first and assign selective values to the object
                    self?.details = details.meals.first
                }
                
                // Parse all json data into a dictionary
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                DispatchQueue.global().async {
                    // Get the array of details
                    if let meals = json?["meals"] as? [[String: Any]] {
                        // There is only one element in the details array so use the first
                        if let meal = meals.first {
                            var ingredients: [String] = []
                            var measures: [String] = []
                            
                            // Iterate through the 20 ingredient elements
                            for index in 1...20 {
                                // Add ingredient values to the ingredients array, ensuring that the value is not empty
                                if let ingredient = meal["strIngredient\(index)"] as? String, !ingredient.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    ingredients.append(ingredient)
                                }
                            }
                            
                            // Iterate through the 20 measure elements
                            for index in 1...20 {
                                // Add measure values to the measures array, ensuring that the value is not empty
                                if let measure = meal["strMeasure\(index)"] as? String, !measure.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    measures.append(measure)
                                }
                            }
                            
                            // Assign to ingredients and measures array in the main thread
                            DispatchQueue.main.async {
                                self?.ingredients = ingredients
                                self?.measures = measures
                            }
                        }
                    }
                }
            }
            catch {
                print(error)
            }
        }
        
        task.resume()
    }
}
