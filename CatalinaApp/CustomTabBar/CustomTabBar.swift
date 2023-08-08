//
//  CustomTabBar.swift
//  CatalinaApp
//
//  Created by Jacobo Osorio on 8/08/23.
//

import SwiftUI

enum Tabs: Int{
    case historico = 0
    case config = 1
}

struct CustomTabBar: View {
    
    @Environment(\.managedObjectContext) private var moc
    @EnvironmentObject var globalState: GlobalState
    @Binding var selectedTab: Tabs
    @State private var isShowingPopUp = false
    
    var body: some View {
        
        HStack (alignment: .center){
            
            Button {
                selectedTab = .historico
                globalState.verMasVista = false
                globalState.filtroview = false
                //
            } label: {
                //
                TabBarButton(buttonText: "Historico", imageName: "doc.plaintext", isActive: selectedTab == .historico, imageBigger: true)
                /*
                GeometryReader { geo in
                    if selectedTab == .chats {
                        Rectangle()
                            .foregroundColor(.blue)
                            .frame(width: geo.size.width/2, height: 4)
                            .padding(.leading, geo.size.width/4)
                    }
                        VStack (alignment: .center, spacing: 4) {
                            Image(systemName: "bubble.left")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                            Text("Chats")
                            // Agregar el archivo Helpers
                            //.font(Font.)
                        }
                        .frame(width: geo.size.width, height: geo.size.height)
                }
                 */
            }
            //Agregar el archivo
            //.tint(Color("icons-secundary"))
            if globalState.esAdmin {
                Button {
                    //
                    isShowingPopUp = true
                } label: {
                    GeometryReader { geo in
                        VStack (alignment: .center, spacing: 4) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            
                            Text("Nuevo")
                            // Agregar el archivo Helpers
                            //.font(Font.)
                        }
                        
                        .frame(width: geo.size.width, height: geo.size.height)
                    }
                    .sheet(isPresented: $isShowingPopUp, content:{
                        AgregarInformacion(isShowingPopUp: $isShowingPopUp)
                            .environment(\.managedObjectContext, self.moc)
                    })
                }
            }
            Spacer()
            Button {
                selectedTab = .config
                //
            } label: {
                //
                TabBarButton(buttonText: "Configuracion", imageName: "gear", isActive: selectedTab == .config, imageBigger: true)
                /*
                GeometryReader { geo in
                    if selectedTab == .contacts{
                        Rectangle()
                            .foregroundColor(.blue)
                            .frame(width: geo.size.width/2, height: 4)
                            .padding(.leading, geo.size.width/4)
                    }
                        VStack (alignment: .center, spacing: 4) {
                            Image(systemName: "person")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                            Text("Contacts")
                            // Agregar el archivo Helpers
                            //.font(Font.)
                        }
                        .frame(width: geo.size.width, height: geo.size.height)
                }
                 */
            }
            //Agregar el archivo
            //.tint(Color("icons-secundary"))
        }
        .frame(height: 82)
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar(selectedTab: .constant(.historico))
    }
}
