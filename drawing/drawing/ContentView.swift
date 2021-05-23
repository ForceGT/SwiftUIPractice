//
//  ContentView.swift
//  drawing
//
//  Created by Gaurav Thakkar on 22/02/21.
//

import SwiftUI

struct Arrow : Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 200, y: 0))
        path.addLine(to: CGPoint(x: 200, y: 200))
       // path.addLine(to: CGPoint(x: 0, y: 200))
        return path
    }
    
    var arrowWidth: Double = 2.0
}

struct ContentView: View {
    
    @State var width: Double = 2.0
    var body: some View {
        VStack {
                    Arrow(arrowWidth: width)
                        .stroke()
                }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
