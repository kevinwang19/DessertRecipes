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
                                SmallSubtitle(text: "Drink Alternate", value: drinkAlternate)
                            }
                            
                            SmallSubtitle(text: "Category", value: details.strCategory)
                            SmallSubtitle(text: "Area", value: details.strArea)
                            
                            if let tags = details.strTags {
                                SmallSubtitle(text: "Tags", value: tags)
                            }
                            Spacer()
                        }
                        LargeSubtitle(text: "Ingredients")
                        
                        ingredientsList
                        
                        LargeSubtitle(text: "Instructions")
                        
                        Text(details.strInstructions)
                        
                        LargeSubtitle(text: "Video")
                        
                        if let url = details.strYoutube {
                            VideoView(url: url)
                                .frame(width: 300, height: 300, alignment: .center)
                                .aspectRatio(contentMode: .fill)
                                .cornerRadius(10)
                        }
                        
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
                                Text("DateModified: " + dateModified)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 20)
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

struct SmallSubtitle: View {
    let text: String
    let value: String
    
    var body: some View {
        HStack {
            Text(text + ":")
                .bold()
            Text(value)
        }
    }
}

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

struct VideoView: UIViewRepresentable {
    let url: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let youtubeURL = URL(string: url) else {
            return
        }
        uiView.load(URLRequest(url: youtubeURL))
    }
}
