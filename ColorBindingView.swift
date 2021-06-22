//
//  SwiftUIView.swift
//  Melomania Proto without firebase
//
//  Created by Djallil Elkebir on 2021-06-22.
//

import SwiftUI

struct ColorBindingView: View {
    // Starting Color is #000000 -> Black, you can put any hex color on it
    @HexColorBinding("#000000") var color: String
    var body: some View {
        VStack{
            HStack {
                Spacer()
                VStack {
                    RoundedRectangle(cornerRadius: 20).frame(width: 100, height: 100, alignment: .center)
                        .foregroundColor(Color(hexString: color))
                        .padding()
                    ColorPicker("", selection: $color, supportsOpacity: false).fixedSize()
                }
                
                Spacer()
            }
           Text(color)
        }
        
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ColorBindingView()
    }
}


