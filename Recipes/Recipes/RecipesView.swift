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
                    NavigationLink {
                        RecipeDetailView(meal: meal)
                    } label: {
                        HStack {
                            AsyncImage(url: URL(string: meal.strMealThumb)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                ProgressView()
                            }
                                .frame(width: 100, height: 100)
                                .background(Color.gray)
                                .cornerRadius(15)
                            Text(meal.strMeal)
                                .font(.title3)
                                .bold()
                                .padding(.leading, 10)
                        }
                        .padding(5)
                    }
                }
            }
            .padding(.top, 10)
            .listStyle(PlainListStyle())
            .navigationTitle("Desserts")
            .onAppear {
                viewModel.fetchMeals()
            }
        }
    }
}
