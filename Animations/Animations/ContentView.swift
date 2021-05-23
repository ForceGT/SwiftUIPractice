//
//  ContentView.swift
//  Animations
//
//  Created by Gaurav Thakkar on 06/01/21.
//

import SwiftUI


struct ContentView: View {
    
    let letters = Array("Hello SwiftUI")
        @State private var enabled = true
        @State private var dragAmount = CGSize.zero

        var body: some View {
            HStack(spacing: 0) {
                ForEach(0..<letters.count) { num in
                    Text(String(self.letters[num]))
                        .padding(5)
                        .font(.title)
                        .background(self.enabled ? Color.blue : Color.red)
                        .animation(Animation.interpolatingSpring(mass: 2.0, stiffness: 4.0, damping: 2.0, initialVelocity: 2.0).delay(Double(num)/20))
                        .foregroundColor(self.enabled ? Color.black : Color.white)
                        .animation(Animation.easeInOut.delay(Double(num)/20))
                        .offset(self.dragAmount)
                        .animation(Animation.default.delay(Double(num)/20))
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { self.dragAmount = $0.translation }
                    .onEnded { _ in
                        self.dragAmount = .zero
                        self.enabled.toggle()
                    }
            )
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
