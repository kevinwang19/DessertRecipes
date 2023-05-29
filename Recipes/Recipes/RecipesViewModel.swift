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
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let meals = try JSONDecoder().decode(Meals.self, from: data)
                DispatchQueue.main.async {
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
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let details = try JSONDecoder().decode(Details.self, from: data)
                DispatchQueue.main.async {
                    self?.details = details.meals.first
                }
                
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                DispatchQueue.global().async {
                    if let meals = json?["meals"] as? [[String: Any]] {
                        if let meal = meals.first {
                            var ingredients: [String] = []
                            var measures: [String] = []
                            
                            for index in 1...20 {
                                if let ingredient = meal["strIngredient\(index)"] as? String, !ingredient.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    ingredients.append(ingredient)
                                }
                            }
                            
                            for index in 1...20 {
                                if let measure = meal["strMeasure\(index)"] as? String, !measure.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    measures.append(measure)
                                }
                            }
                            
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
