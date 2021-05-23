//
//  ContentView.swift
//  Convertio
//
//  Created by Gaurav Thakkar on 01/01/21.
//

import SwiftUI


public struct DarkModeViewModifier: ViewModifier {

    var isDarkMode: Bool

    public func body(content: Content) -> some View {
        withAnimation(Animation.spring().delay(5)){
            content
                .environment(\.colorScheme, isDarkMode ? .dark : .light)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
        
    }
}

struct ContentView: View {
    
    @State private var fromUnit = 1
    @State private var toUnit = 1
    @State private var inputValue = ""
    @State var selectedTheme = 1
    let conversionValues = ["liters","milliliters","pints"]
    let themes = ["Dark","Light"]
    
    var convertedValue:Double{
        var conversionFactor:Double = 0
        let inputValueAsDouble = Double(inputValue) ?? 0
        if fromUnit == 0 {
            if toUnit == 0{
                // convert liters to liters
                conversionFactor = 1
            }
            else if toUnit == 1{
                // convert liters to milliliters
                conversionFactor = 1000
            }
            else{
                // convert liters to pints
                conversionFactor = 2.11338
            }
        }
        else if fromUnit == 1{
            if toUnit == 0{
                // convert milliliters to liters
                conversionFactor = 0.001
            }
            else if toUnit == 1{
                // convert milliliters to milliliters
                conversionFactor = 1
            }
            else{
                // convert milliliters to pints
                conversionFactor = 0.00211338
            }
        }
        else {
            if toUnit == 0{
                // convert pints to liters
                conversionFactor = 0.47308
            }
            else if toUnit == 1{
                // convert pints to milliliters
                conversionFactor = 0.0047308
            }
            else{
                // convert pints to pints
                conversionFactor = 1
            }
        }
        return inputValueAsDouble * conversionFactor
    }
    
    var body: some View {
        NavigationView{
            Form{
                
                Section(header:Text("What value should I convert?")){
                    TextField("Value to be convereted",text:$inputValue).keyboardType(.decimalPad)
                }
                Section(header: HStack{
                    Text("FROM")
                        .fontWeight(.black)
                        .multilineTextAlignment(.trailing)
                        .padding(6)
                    Spacer()
                    Text ("TO")
                        .fontWeight(.black)
                        .multilineTextAlignment(.center)
                        .padding(6)
                }){
                    HStack{
                        Picker("\(conversionValues[fromUnit])", selection: $fromUnit) {
                            ForEach(0 ..< conversionValues.count) {
                                Text("\(conversionValues[$0])")
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        Spacer()
                        Picker("\(conversionValues[toUnit])", selection: $toUnit) {
                            ForEach(0 ..< conversionValues.count) {
                                Text("\(conversionValues[$0])").multilineTextAlignment(.trailing)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    
                    }
                    
                }
                
                Section(header: Text("Converted Value")){
                    Text("\(convertedValue, specifier: "%.2f")")
                }
                
                Section (header:Text("Theme")){
                    Picker("\(themes[selectedTheme])", selection: $selectedTheme) {
                        ForEach(0 ..< themes.count) {
                            Text("\(themes[$0])").multilineTextAlignment(.trailing)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }.navigationTitle("Convertio")
            
        }
        .modifier(DarkModeViewModifier(isDarkMode: selectedTheme == 0 ? true : false))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
