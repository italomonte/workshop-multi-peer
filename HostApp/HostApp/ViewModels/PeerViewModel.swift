
import Foundation
import MultipeerConnectivity
import Combine

class PeerViewModel: NSObject, ObservableObject {
    
    let peerId = MCPeerID(displayName: UIDevice.current.name)
    var hostId: MCPeerID?
    
    let session: MCSession
    let advertiser: MCNearbyServiceAdvertiser
    
    @Published var showingPermissionRequest = false
    @Published var invitationPeerName = ""
    var invitationHandler: ((Bool, MCSession?) -> Void)?
    
    
    var isAdvertising = false {
        didSet {
            isAdvertising ? advertiser.startAdvertisingPeer() : advertiser.stopAdvertisingPeer()
        }
    }
    
    @Published var messages: [String] = []
    
    override init() {
        
        self.session = MCSession(peer: peerId)
        self.advertiser = MCNearbyServiceAdvertiser(peer: peerId, discoveryInfo: nil, serviceType: "nearby-devices")
        
        super.init()
        
        session.delegate = self
        advertiser.delegate = self
                
    }
    
    func respondToInvitation(accept: Bool) {
        if let handler = invitationHandler {
            handler(accept, accept ? session : nil)
        }
    }
}

extension PeerViewModel: MCSessionDelegate {
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        guard let message = String(data: data, encoding: .utf8) else {
            return
        }
        
        DispatchQueue.main.async {
            self.messages.append(message)
        }
        
    }
    
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: (any Error)?) {
        
    }
}

extension PeerViewModel: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        DispatchQueue.main.async {
            self.invitationHandler = invitationHandler
            self.invitationPeerName = peerID.displayName
            self.showingPermissionRequest = true
            self.hostId = self.peerId
        }
    }
}


