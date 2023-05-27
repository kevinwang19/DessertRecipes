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

struct Meal: Hashable, Codable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
}

class RecipesViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    
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
                print(meals)
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
}
