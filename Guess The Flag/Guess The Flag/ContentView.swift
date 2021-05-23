//
//  ContentView.swift
//  Guess The Flag
//
//  Created by Gaurav Thakkar on 02/01/21.
//

import SwiftUI

struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var isAlertShown = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var initDegrees = 0.0
    @State private var initOpacity = 1.0
    
    var body: some View {
        
        
            ZStack{
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                VStack(spacing: 60){
                    VStack{
                        Text("Find The Flag")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        Spacer()
                        Text("Select the Country").foregroundColor(.white)
                        Text(countries[correctAnswer]).font(.largeTitle).foregroundColor(.white).fontWeight(.black)
                        ForEach(0..<3){ number in
                            Button( action: {
                                self.flagTapped(number)
                            }){
                                Image(countries[number])
                                    .renderingMode(.original)
                                    .shadow(color: .black, radius: 2)
                                    .cornerRadius(16.0)
                                    .frame(maxHeight: 140)
                                    .rotation3DEffect(
                                         .degrees(initDegrees),
                                        axis: /*@START_MENU_TOKEN@*/(x: 0.0, y: 1.0, z: 0.0)/*@END_MENU_TOKEN@*/)
                                    .animation((correctAnswer == number) ? Animation.default : nil)
                                    .opacity(correctAnswer == number ? 1 : initOpacity)
                                    .animation((correctAnswer == number) ? nil : Animation.default)
                                    
                                    
                            }
                        }
                        Text("Your Total Score is: \(score)").foregroundColor(.white)
                        
                        Spacer()
                        
                    }
                    .alert(isPresented: $isAlertShown) {
                        let texttoBeShown = scoreTitle == "Correct" ? "Hurray!Well Done": "The Correct Answer was Flag \(correctAnswer + 1)\n Better Luck Next Time"
                               return Alert(title: Text(scoreTitle), message: Text(texttoBeShown), dismissButton: .default(Text("Continue")) {
                                    self.askQuestion()
                                })
                            }
                    
                }
            }.preferredColorScheme(.light)
    
    }
    
    func flagTapped(_ number: Int) {
            if number == correctAnswer {
                initDegrees += 360.0
                scoreTitle = "Correct"
                if(score < 0) {score = 0}
                score = score + 10
            } else {
                initOpacity = 0.25
                scoreTitle = "Wrong"
                initDegrees = 0.0
                if (score - 10 < 0) {
                    score = 0
                }
                else {
                    score -= 10
                }
            }

            isAlertShown = true
        }

        func askQuestion() {
            
            
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
            initOpacity = 1.0
            
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
