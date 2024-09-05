
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
                title: Text("Do you want to join \(vm.permissionRequest?.peerId.displayName ?? "")"),
                primaryButton: .default(Text("Yes"), action: {
                    vm.permissionRequest?.onRequest(true)
                    
                    
                    
                }),
                secondaryButton: .cancel(Text("No"), action: {
                    vm.permissionRequest?.onRequest(false)
                    
                })
            )
        }
        

    }
}

#Preview {
    PeerView()
}
