//
//  TabBarButton.swift
//  CatalinaApp
//
//  Created by Jacobo Osorio on 8/08/23.
//

import SwiftUI

struct TabBarButton: View {
    
    var buttonText: String
    var imageName: String
    var isActive: Bool
    var imageBigger: Bool
    
    var body: some View {
        GeometryReader { geo in
                if isActive{
                    Rectangle()
                        .foregroundColor(.blue)
                        .frame(width: geo.size.width/2, height: 4)
                        .padding(.leading, geo.size.width/4)
                        .cornerRadius(5)
                }
            VStack (alignment: .center, spacing: imageBigger ? 2:4) {
                    Image(systemName: imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: imageBigger ? 26:24, height: imageBigger ? 26:24)
                    
                    Text(buttonText)
                    // Agregar el archivo Helpers
                    //.font(Font.)
                }
                
                .frame(width: geo.size.width, height: geo.size.height)
            }
    }
}

struct TabBarButton_Previews: PreviewProvider {
    static var previews: some View {
        HStack{
            TabBarButton(buttonText: "Historico", imageName: "dollarsign.circle", isActive: true, imageBigger: true)
            TabBarButton(buttonText: "Configuracion", imageName: "list.bullet.rectangle.portrait", isActive: true, imageBigger: false)
        }
    }
}
