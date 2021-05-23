//
//  ContentView.swift
//  WeSplit
//
//  Created by Gaurav Thakkar on 30/12/20.
//

import SwiftUI

struct ContentView: View {
    @State private var noOfPeople = ""
    @State private var tipPercentage = 1
    @State private var amount = ""
    let tipPercentages = ["5","10","15","20"]
    
    var totalPerPerson : Double {
        let finalamount = Double(amount) ?? 0
        let people = Double(noOfPeople) ?? 0
        let tip = Double(tipPercentages[tipPercentage])!
        let tipValue = (finalamount / 100) * tip
        let totalAmount = tipValue + finalamount
        let amountPerPerson = people != 0 ?(totalAmount / people) : 0
        print(amountPerPerson)
        return amountPerPerson
    }
    
    var body: some View {
        NavigationView{
         Form{
            Section(header:Text("How and What Should I Split?")){
                TextField("$  Amount",text:$amount).keyboardType(.decimalPad).multilineTextAlignment(.center)
                HStack {
                   Text("Among:").frame(maxWidth:.infinity).multilineTextAlignment(.leading)
                   TextField("Number", text:$noOfPeople).frame(maxWidth: .infinity).multilineTextAlignment(.trailing).font(/*@START_MENU_TOKEN@*/.body/*@END_MENU_TOKEN@*/).keyboardType(/*@START_MENU_TOKEN@*/.numberPad/*@END_MENU_TOKEN@*/)
                   Text("people").frame(maxWidth:.infinity).multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
               }
            }
             
            Section(header: Text("How much tip do you want to leave?")) {
                Picker("Tip percentage", selection: $tipPercentage) {
                    ForEach(0 ..< tipPercentages.count) {
                        Text("\(tipPercentages[$0])%")
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            Section(header:Text("The total amount per person")){
                Text("$ \(totalPerPerson, specifier: "%.2f")")
            }
            
            
            
         }.navigationTitle("WeSplit")
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
