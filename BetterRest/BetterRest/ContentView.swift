//
//  ContentView.swift
//  BetterRest
//
//  Created by Gaurav Thakkar on 04/01/21.
//

import SwiftUI
import CoreML


extension Color {
    static let neuBackground = Color("f0f0f3")
}

struct NeumorphicButtonStyle: ButtonStyle {
    var bgColor: Color

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(20)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .shadow(color: .white, radius: configuration.isPressed ? 7: 10, x: configuration.isPressed ? -5: -15, y: configuration.isPressed ? -5: -15)
                        .shadow(color: .black, radius: configuration.isPressed ? 7: 10, x: configuration.isPressed ? 5: 15, y: configuration.isPressed ? 5: 15)
                        .blendMode(.overlay)
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(bgColor)
                }
        )
            .scaleEffect(configuration.isPressed ? 0.95: 1)
            .foregroundColor(.primary)
            .animation(.spring())
    }
}


struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 0
    
    @State private var alertTitle = ""
    @State private var alertMsg = ""
    @State private var alertMessageShown = false
    
    init(){
            UITableView.appearance().backgroundColor = .clear
        }
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    var body: some View {
        NavigationView{
            VStack(alignment: .center){
                Form {
                    VStack{
                        Text ("What time do you wake up at?")
                            .font(.headline)
                        DatePicker("Please Enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .datePickerStyle(WheelDatePickerStyle())
                    }
                    VStack(alignment : .leading, spacing: 0){
                        Text("Desired amount of sleep")
                            .font(.headline)

                        Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                            Text("\(sleepAmount, specifier: "%g") hours")
                        }
                        
                    }
                    VStack(alignment : .leading, spacing: 0){
                        Text("Daily coffee intake")
                            .font(.headline)
                        
                        Picker("\(coffeeAmount)", selection: $coffeeAmount){
                            
                            ForEach(0..<21){cup in
                                Text("\(cup) cups")
                            }
                        }.pickerStyle(InlinePickerStyle()).navigationTitle("Pick a value")

//                        Stepper(value: $coffeeAmount, in: 1...20) {
//                            if coffeeAmount == 0 {
//                                Text ("No caffeine")
//                            } else if coffeeAmount == 1{
//                                Text("1 cup")
//                            }
//                            else {
//                                Text("\(coffeeAmount) cups")
//                            }
//                        }
                    }
              
                }.background(Color.white)
                .frame(height: 550)
                .alert(isPresented: $alertMessageShown, content: {
                    Alert(title: Text(alertTitle), message: Text(alertMsg), dismissButton: .default(Text("OK")))
                })
                
            
                    Button(
                        action: calculateBedtime,
                        label: {
                        Text("Calculate")
                        }).buttonStyle(NeumorphicButtonStyle(bgColor: .neuBackground))
                        
                
                
                
                
                        
                
            }
            .navigationTitle("BetterRest")
            
        }
        }
       
    
    func calculateBedtime() {
        do{
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let model = try SleepCalculator(configuration: MLModelConfiguration())
            let prediction = try model.prediction(wake: Double(hour+minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            let formatter = DateFormatter()
            formatter.timeStyle = .short

            alertMsg = formatter.string(from: sleepTime)
            alertTitle = "Your ideal bedtime is…"
            
        }
        catch{
            alertTitle = "Error"
            alertMsg = "Something Went Wrong"
            
        }

        alertMessageShown = true
        
        
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
