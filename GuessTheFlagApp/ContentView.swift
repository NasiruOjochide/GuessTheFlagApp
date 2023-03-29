//
//  ContentView.swift
//  GuessTheFlagApp
//
//  Created by Danjuma Nasiru on 28/12/2022.
//

import SwiftUI


struct LargeTitle: ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.bold())
            .foregroundColor(.blue)
    }
}

extension View{
    func blueTitle() -> some View{
        modifier(LargeTitle())
    }
}


struct FlagImage : View{
    var labels : [String : String]
    var countries: [String]
    var number: Int
    var body: some View{
        Image(countries[number])
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 10)
            .accessibilityLabel(labels[countries[number], default: "Unknown flag"])
            
    }
}


struct ContentView: View {
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    @State private var rotationAmount = 0.0
    @State private var selected : Int? = nil
    @State private var tapped = false
    @State private var gameIterations = 0
    @State private var showingScore = false
    @State private var showFinalAlert = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    var body: some View {
        ZStack{
            RadialGradient(stops: [.init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3), .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                VStack(spacing: 15){
                    VStack {
                            Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                            Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                            
                        }
                    ForEach(0..<3, id: \.self) { number in
                        Button {
                            
                           flagTapped(number)
                            withAnimation{
                                rotationAmount += 360
                                tapped = true
                            }
                            
                        } label: {
                            FlagImage(labels: labels, countries: countries, number: number)
                             
                        }.rotation3DEffect(.degrees(selected == number ? rotationAmount : 0), axis: (x: 0, y: 1, z: 0))
                            .opacity(tapped ? (selected == number ? 1 : 0.25) : 1)
                            .scaleEffect(tapped ? (selected == number ? 1 : 0.75) : 1)
                            
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                
                Text("Score: \(score)")
                    .blueTitle()
                Spacer()
            }
            .padding()
        }.alert(scoreTitle, isPresented: $showingScore, actions: {Button("Continue", action: askQuestion)}, message: {Text("Your score is \(score)")})
            .alert(scoreTitle, isPresented: $showFinalAlert, actions: {Button("Continue", action: askQuestion)}, message: {Text("Click Continue to start Again.")})
            
    }
    func flagTapped(_ number: Int){
        selected = number
        gameIterations += 1
        
        if gameIterations < 8{
            if number == correctAnswer{
                scoreTitle = "Correct"
                score += 1
            }else{
                scoreTitle = "Wrong! That's the flag of \(countries[number])"
            }
            
            showingScore = true
        }else{
            if number == correctAnswer{
                score += 1
                scoreTitle = "Correct, your final score is \(score)"
                
            }else{
                
                scoreTitle = "Wrong! That's the flag of \(countries[number]) and your Final score is: \(score)"
                
            }
            showFinalAlert = true
        }
        
        
    }
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        tapped.toggle()
        
        if gameIterations == 8{
            gameIterations = 0
            score = 0
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
