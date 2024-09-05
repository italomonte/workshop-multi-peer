//
//  ContentView.swift
//  HostApp
//
//  Created by Italo Guilherme Monte on 17/08/24.
//

import SwiftUI

struct HostView: View {
    
    @ObservedObject var vm = HostViewModel()
    
    var body: some View {
        NavigationStack {
            VStack{
                
                Button {
                    vm.sendMessage(message: "Hello", toPeers: vm.session.connectedPeers)
                } label: {
                    Text("Send Message")
                }
                .padding()
                .clipShape(.capsule)
                
                
                Text("Dispositivos disponíveis: ")
                    
                
                ScrollView {
                    ScrollView {
                        ForEach(vm.browsedPeers, id: \.self) { peer in
                            Button(action: {
                                vm.selectedPeer = peer
                            }, label: {
                                Text(peer.displayName)
                            })
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Messages")
            .toolbar {
                ToolbarItem {
                    Toggle(isOn: $vm.isBrowsing, label: {
                        Text("Is Browsing? ")
                    }).toggleStyle(.switch)
                }
            }
        }
    }
}

#Preview {
    HostView()
}
