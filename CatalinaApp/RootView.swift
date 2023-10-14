//
//  RootView.swift
//  CatalinaApp
//
//  Created by Jacobo Osorio on 7/08/23.
//

import SwiftUI

// Declaracion de variables Globales
class GlobalState: ObservableObject {
    // Variable que calcula si la fecha es menos 1 dia o no
    @Published var BudgetMes:Int64 {
        didSet {
            UserDefaults.standard.set(BudgetMes, forKey: "BudgetMes")
        }
    }
    @Published var tipoFecha:Bool {
        didSet {
            UserDefaults.standard.set(tipoFecha, forKey: "tipoFecha")
        }
    }
    @Published var modoOscuro:Bool {
        didSet {
            UserDefaults.standard.set(modoOscuro, forKey: "modoOscuro")
        }
    }
    // Pestaña de Config donde se cambia el Budget
    @Published var configBudge:Bool {
        didSet {
            UserDefaults.standard.set(configBudge, forKey: "configBudge")
        }
    }
    // Pestaña de Config donde se cambia el nombre
    @Published var configNA:Bool {
        didSet {
            UserDefaults.standard.set(configNA, forKey: "configNA")
        }
    }
    // Pestaña en donde se visualiza la view de ver Mas
    @Published var ToggleMes:Bool {
        didSet {
            UserDefaults.standard.set(ToggleMes, forKey: "ToggleMes")
        }
    }
    // Pestaña en donde se visualiza la view de ver Mas (Resumen Mensual)
    @Published var ToggleDiario:Bool {
        didSet {
            UserDefaults.standard.set(ToggleDiario, forKey: "ToggleDiario")
        }
    }
    // Pestaña donde se visualiza la view de filtros
    @Published var filtroview:Bool {
        didSet {
            UserDefaults.standard.set(filtroview, forKey: "filtroview")
        }
    }
    // Variable si dice si es admin o no
    @Published var esAdmin:Bool {
        didSet {
            UserDefaults.standard.set(esAdmin, forKey: "esAdmin")
        }
    }
    // Variable de nombre
    @Published var nombrePer:String {
        didSet {
            UserDefaults.standard.set(nombrePer, forKey: "nombrePer")
        }
    }
    // Variable de Apellido
    @Published var apellidoPer: String {
        didSet {
            UserDefaults.standard.set(apellidoPer, forKey: "apellidoPer")
        }
    }
    // Variable para obtener la fecha de filtro
    @Published var fechaInfo: Int {
        didSet {
            UserDefaults.standard.set(fechaInfo, forKey: "fechaInfo")
        }
    }
    @Published var dataArray: [ObjectBudget] = []
    @Published var TuplaBudget: (Int, Double, Double, Double, Double, Double, Double, Double, Double, Double, Double, Double, Double, Double) = (0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)

    
    init() {
        self.tipoFecha = Bool(UserDefaults.standard.bool(forKey: "tipoFecha"))
        self.modoOscuro = false
        self.filtroview = false
        self.configNA = false
        self.ToggleMes = false
        self.ToggleDiario = false
        self.configBudge = false
        self.BudgetMes = 0
        self.fechaInfo = 0
        self.esAdmin = Bool(UserDefaults.standard.bool(forKey: "esAdmin"))
        self.nombrePer = UserDefaults.standard.string(forKey: "nombrePer") ?? "NombreD"
        self.apellidoPer = UserDefaults.standard.string(forKey: "apellidoPer") ?? "ApellidoD"
        self.dataArray = []
        self.TuplaBudget = (0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)

    }
}

struct RootView: View {
    @StateObject private var globalState = GlobalState()
    
    var body: some View {
        VistaRoot()
            .environmentObject(globalState)
    }
    
}

struct VistaRoot: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var globalState: GlobalState
    @Environment(\.managedObjectContext) private var moc
    @State var selectedTab: Tabs = .historico
    @State var isLoading = false

    
    var body: some View {
        ZStack{
            VStack {
                TabView(selection: $selectedTab) {
                    MainMes()
                        .environmentObject(globalState)
                        .tag(Tabs.historico)
                        .id(UUID())
                    
                    Historico3()
                        .environmentObject(globalState)
                        .tag(Tabs.historico1)
                        .id(UUID())
                    
                    ConfiguracionView()
                        .environmentObject(globalState)
                        .tag(Tabs.config)
                        .id(UUID())
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                VStack(alignment: .leading){
                    CustomTabBar(selectedTab: $selectedTab)
                        .environment(\.managedObjectContext, self.moc)
                }
            }
            if globalState.configNA{
                ConfigNombre()
                    .environment(\.managedObjectContext, self.moc)
                    .background(colorScheme == .light ? Color.white : Color.black)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(AnyTransition.move(edge: .trailing).combined(with: .opacity))
                    .zIndex(1)
            }
            if globalState.configBudge{
                ConfigBudget()
                    .environment(\.managedObjectContext, self.moc)
                    .background(colorScheme == .light ? Color.white : Color.black)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(AnyTransition.move(edge: .trailing).combined(with: .opacity))
                    .zIndex(1)
            }
        }
        
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
