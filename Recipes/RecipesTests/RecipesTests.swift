//
//  RecipesTests.swift
//  RecipesTests
//
//  Created by Kevin Wang on 2023-05-27.
//

import XCTest
@testable import Recipes
 
class RecipesTests: XCTestCase {
    private var viewModel = RecipesViewModel()
    private let idMeal = "52893"
    
    func testFetchingMealsAPI() {
        viewModel.fetchMeals()
        
        let asyncExpectation = self.expectation(description: "TestFetchingMealsAPI")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            XCTAssertEqual(self.viewModel.meals[0].strMeal, "Apam balik")
            XCTAssertEqual(self.viewModel.meals[0].strMealThumb, "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")
            XCTAssertEqual(self.viewModel.meals[0].idMeal, "53049")
            
            XCTAssertEqual(self.viewModel.meals[1].strMeal, "Apple & Blackberry Crumble")
            XCTAssertEqual(self.viewModel.meals[1].strMealThumb, "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg")
            XCTAssertEqual(self.viewModel.meals[1].idMeal, "52893")
            
            XCTAssertEqual(self.viewModel.meals[2].strMeal, "Apple Frangipan Tart")
            XCTAssertEqual(self.viewModel.meals[2].strMealThumb, "https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg")
            XCTAssertEqual(self.viewModel.meals[2].idMeal, "52768")
            asyncExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchingDetailsAPI() {
        viewModel.fetchDetails(id: idMeal)
        
        let asyncExpectation = self.expectation(description: "TestFetchingDetailsAPI")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            XCTAssertEqual(self.viewModel.details?.idMeal, "52893")
            XCTAssertEqual(self.viewModel.details?.strMeal, "Apple & Blackberry Crumble")
            XCTAssertNil(self.viewModel.details?.strDrinkAlternate)
            XCTAssertEqual(self.viewModel.details?.strCategory, "Dessert")
            XCTAssertEqual(self.viewModel.details?.strArea, "British")
            XCTAssertEqual(self.viewModel.details?.strInstructions, "Heat oven to 190C/170C fan/gas 5. Tip the flour and sugar into a large bowl. Add the butter, then rub into the flour using your fingertips to make a light breadcrumb texture. Do not overwork it or the crumble will become heavy. Sprinkle the mixture evenly over a baking sheet and bake for 15 mins or until lightly coloured.\r\nMeanwhile, for the compote, peel, core and cut the apples into 2cm dice. Put the butter and sugar in a medium saucepan and melt together over a medium heat. Cook for 3 mins until the mixture turns to a light caramel. Stir in the apples and cook for 3 mins. Add the blackberries and cinnamon, and cook for 3 mins more. Cover, remove from the heat, then leave for 2-3 mins to continue cooking in the warmth of the pan.\r\nTo serve, spoon the warm fruit into an ovenproof gratin dish, top with the crumble mix, then reheat in the oven for 5-10 mins. Serve with vanilla ice cream.")
            XCTAssertEqual(self.viewModel.details?.strMealThumb, "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg")
            XCTAssertEqual(self.viewModel.details?.strTags, "Pudding")
            XCTAssertEqual(self.viewModel.details?.strYoutube, "https://www.youtube.com/watch?v=4vhcOwVBDO4")
            XCTAssertEqual(self.viewModel.details?.strSource, "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble")
            XCTAssertNil(self.viewModel.details?.strImageSource)
            XCTAssertNil(self.viewModel.details?.strCreativeCommonsConfirmed)
            XCTAssertNil(self.viewModel.details?.dateModified)
            asyncExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchingIngredientDetailsAPI() {
        viewModel.fetchDetails(id: idMeal)
        
        let asyncExpectation = self.expectation(description: "TestFetchingIngredientDetailsAPI")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            XCTAssertEqual(self.viewModel.ingredients, ["Plain Flour", "Caster Sugar", "Butter", "Braeburn Apples", "Butter", "Demerara Sugar", "Blackberrys", "Cinnamon", "Ice Cream"])
            asyncExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchingMeasureDetailsAPI() {
        viewModel.fetchDetails(id: idMeal)
        
        let asyncExpectation = self.expectation(description: "TestFetchingMeasureDetailsAPI")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            XCTAssertEqual(self.viewModel.measures, ["120g", "60g", "60g", "300g", "30g", "30g", "120g", "\u{00bc} teaspoon", "to serve"])
            asyncExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
