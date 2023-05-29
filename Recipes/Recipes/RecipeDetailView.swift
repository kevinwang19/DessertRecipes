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
        self.meal = meal
        // Scale Navigation title to fit the screen
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
    }
    
    var body: some View {
        NavigationView {
            // Ensure dessert details exist
            if let details = viewModel.details {
                ScrollView(.vertical, showsIndicators: true) {
                    VStack {
                        Group {
                            // Dessert image
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
                            
                            // Drink alternate
                            if let drinkAlternate = details.strDrinkAlternate {
                                SmallSubtitle(text: "Drink Alternate", value: drinkAlternate)
                            }
                            
                            // Category and area of the meal
                            SmallSubtitle(text: "Category", value: details.strCategory)
                            SmallSubtitle(text: "Area", value: details.strArea)
                            
                            // Dessert tags
                            if let tags = details.strTags {
                                SmallSubtitle(text: "Tags", value: tags)
                            }
                            Spacer()
                        }
                        LargeSubtitle(text: "Ingredients")
                        
                        // List of measurements combined with list of ingredients
                        ingredientsList
                        
                        LargeSubtitle(text: "Instructions")
                        
                        // Instructions
                        Text(details.strInstructions)
                        
                        LargeSubtitle(text: "Video")
                        
                        // Video player for the recipe youtube video
                        if let url = details.strYoutube {
                            VideoView(url: url)
                                .frame(width: 300, height: 300, alignment: .center)
                                .aspectRatio(contentMode: .fill)
                                .cornerRadius(10)
                        }
                        
                        // Sources, creative commons confirmed, and date modified
                        Group {
                            if details.strSource != nil || details.strImageSource != nil {
                                let source = details.strSource ?? ""
                                let imageSource = details.strImageSource ?? ""
                                LargeSubtitle(text: "Sources")
                                Text(.init(source))
                                Text(.init(imageSource))
                            }
                            Group {
                                if let creativeCommonsConfirmed = details.strCreativeCommonsConfirmed {
                                    Text("Creative Commons Confirmed: " + creativeCommonsConfirmed)
                                }
                                if let dateModified = details.dateModified {
                                    Text("Date Modified: " + dateModified)
                                }
                            }
                            .padding(.top, 20)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(30)
                }
            }
        }
        .navigationTitle(meal.strMeal)
        // Retrieve details of the desserts from the API using the dessert ID
        .onAppear {
            viewModel.fetchDetails(id: meal.idMeal)
        }
    }
    
    @ViewBuilder
        var ingredientsList: some View {
            // Concatenate list of measurements with list of ingredients
            VStack {
                ForEach(0..<viewModel.ingredients.count, id: \.self) { index in
                    Text("   - " + viewModel.measures[index] + " " + viewModel.ingredients[index])
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
       }
}

// Small subtitle where the title and value are in the same line
struct SmallSubtitle: View {
    let text: String
    let value: String
    
    var body: some View {
        HStack {
            Text(text + ":")
                .bold()
            Text(value)
        }
        .scaledToFill()
        .minimumScaleFactor(0.5)
        .lineLimit(1)
    }
}

// Large subtitle where the title is its own line
struct LargeSubtitle: View {
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

// Video Player
struct VideoView: UIViewRepresentable {
    let url: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let youtubeURL = URL(string: url) else {
            return
        }
        uiView.scrollView.isScrollEnabled = false
        uiView.load(URLRequest(url: youtubeURL))
    }
}
