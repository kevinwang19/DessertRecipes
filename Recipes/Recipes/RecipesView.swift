//
//  ContentView.swift
//  Recipes
//
//  Created by Kevin Wang on 2023-05-27.
//

import SwiftUI

struct RecipesView: View {
    @StateObject var viewModel = RecipesViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.meals, id: \.self) { meal in
                    HStack {
                        MealImage(url: meal.strMealThumb)
                        Text(meal.strMeal)
                            .bold()
                            .padding(.leading, 10)
                    }
                    .padding(5)
                }
            }
            .navigationTitle("Desserts")
            .onAppear {
                viewModel.fetchMeals()
            }
        }
    }
}

struct MealImage: View {
    let url: String
    @State var data: Data?
    
    var body: some View {
        if let data = data, let image = UIImage(data: data) {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 100)
                .background(Color.gray)
        }
        else {
            Image(systemName: "image")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 100)
                .background(Color.gray)
                .onAppear {
                    fetchImage()
                }
        }
    }
                    
    private func fetchImage() {
        guard let url = URL(string: url) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            self.data = data
        }
        task.resume()
    }
}
