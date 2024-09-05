//
//  Menu.swift
//  HostApp
//
//  Created by Italo Guilherme Monte on 05/09/24.
//

import SwiftUI

struct Menu: View {
    
    @ObservedObject var navigationVM = NavigationViewModel()
    
    var body: some View {
        NavigationStack{
            VStack (spacing: 16){
                Text("Escolha se quer criar ou entrar em uma  uma sala.")
                
                Spacer()
                
                VStack{
                    Button(action: {
                        navigationVM.isOnHostView = true
                    }, label: {
                        Text("Criar Sala")
                            .foregroundStyle(.white)
                            .bold()
                    })
                    .frame(width: 250)
                    .padding()
                    .background(.blue)
                    .clipShape(.capsule)
                    
                    Button(action: {
                        navigationVM.isOnPeerView = true
                    }, label: {
                        Text("Entrar em uma sala")
                            .foregroundStyle(.white)
                            .bold()
                    })
                    .frame(width: 250)
                    .padding()
                    .background(.blue)
                    .clipShape(.capsule)
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Chat")
        }
        .sheet(isPresented: $navigationVM.isOnHostView, content: {
            HostView()
        })
        .sheet(isPresented: $navigationVM.isOnPeerView, content: {
            PeerView()
        })
    }
}

#Preview {
    Menu()
}
