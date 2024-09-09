
import SwiftUI

struct PeerView: View {
    
    @ObservedObject var vm = PeerViewModel()
    
    var body: some View {
        NavigationStack{
            VStack {
                if vm.messages.isEmpty {
                    Text("You don`t have messages to read :(")
                } else {
                    List {
                        ForEach (vm.messages, id: \.self) { message in
                            Text(message)
                        }
                    }
                }
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Toggle(isOn: $vm.isAdvertising, label: {
                        Text("Is Advertising")
                    })
                    .toggleStyle(.switch)
                    
                }
            }
            .navigationTitle("Messages")
        }
        .alert(isPresented: $vm.showingPermissionRequest ){
            Alert(
                title: Text("Convite de \(vm.invitationPeerName)"),
                message: Text("Deseja aceitar o convite para se conectar?"),
                primaryButton: .default(Text("Aceitar"), action: {
                    vm.respondToInvitation(accept: true)
                }),
                secondaryButton: .cancel(Text("Recusar"), action: {
                    vm.respondToInvitation(accept: false)
                })
            )
        }
        

    }
}

#Preview {
    PeerView()
}
