//
//  RecipeDetailView.swift
//  Recipes
//
//  Created by Kevin Wang on 2023-05-27.
//

import SwiftUI
import WebKit

struct RecipeDetailView: View {
    let meal: Meal
    @StateObject var viewModel = RecipesViewModel()
    
    init(meal: Meal) {
        self.meal=meal
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
    }
    
    var body: some View {
        NavigationView {
            if let details = viewModel.details {
                ScrollView(.vertical, showsIndicators: true) {
                    VStack {
                        Group {
                            AsyncImage(url: URL(string: details.strMealThumb)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 300, height: 250)
                            .background(Color.gray)
                            .cornerRadius(15)
                            if let drinkAlternate = details.strDrinkAlternate {
                                Text("Drink Alternate: " + drinkAlternate)
                            }
                            Text("Category: " + details.strCategory)
                            Text("Area: " + details.strArea)
                            Spacer()
                        }
                        Subtitle(text: "Ingredients")
                        
                        ingredientsList
                        
                        Subtitle(text: "Instructions")
                        
                        Text(details.strInstructions)
                        
                        Subtitle(text: "Video")
                        
                        if let url = details.strYoutube {
                            VideoView(url: url)
                                .frame(width: 300, height: 300, alignment: .center)
                                .aspectRatio(contentMode: .fill)
                                .cornerRadius(10)
                        }
                        //if let tags = details.strTags {
                        //    Text("Tags: " + tags)
                        //}
                    }
                    .padding(30)
                }
            }
        }
        .navigationTitle(meal.strMeal)
        .onAppear {
            viewModel.fetchDetails(id: meal.idMeal)
        }
    }
    
    @ViewBuilder
        var ingredientsList: some View {
            VStack {
                ForEach(0..<viewModel.ingredients.count, id: \.self) { index in
                    Text("   - " + viewModel.measures[index] + " " + viewModel.ingredients[index])
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
       }
}

struct Subtitle: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.title2)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 20)
            .padding(.bottom, 10)
    }
}

struct VideoView: UIViewRepresentable {
    let url: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        print(url)
        guard let youtubeURL = URL(string: url) else {
            return
        }
        uiView.load(URLRequest(url: youtubeURL))
    }
}
