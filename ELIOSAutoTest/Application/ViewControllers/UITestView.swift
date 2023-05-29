//
//  UITestView.swift
//  ELIOSAutoTest
//
//  Created by jack on 28.02.2023.
//

import SwiftUI

class Order: ObservableObject {
    var name = "test"
}

struct UITestView: View {
    @StateObject var order = Order()
    
    var body: some View {
        Text("test")
            .foregroundColor(Color.red)
            .padding(.top, 8.0).background(Color.blue)
    }
}

struct UITestView_Previews: PreviewProvider {
    static var previews: some View {
        UITestView()
    }
}
