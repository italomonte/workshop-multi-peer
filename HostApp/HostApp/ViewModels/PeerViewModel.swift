
import Foundation
import MultipeerConnectivity
import Combine

class PeerViewModel: NSObject, ObservableObject {
    
    let peerId: MCPeerID
    var hostId: MCPeerID?
    
    let session: MCSession
    let advertiser: MCNearbyServiceAdvertiser
    
    @Published var showingPermissionRequest = false
    @Published var invitationPeerName = ""
    var invitationHandler: ((Bool, MCSession?) -> Void)?
    
    
    var isAdvertising = false {
        didSet {
            print(isAdvertising)
            isAdvertising ? advertiser.startAdvertisingPeer() : advertiser.stopAdvertisingPeer()
        }
    }
    
    var message: String = ""
    @Published var messages: [String] = []
    
    let messagePublisher = PassthroughSubject<String, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    override init() {
        self.peerId = MCPeerID(displayName: UIDevice.current.name)
        self.session = MCSession(peer: peerId)
        self.advertiser = MCNearbyServiceAdvertiser(peer: peerId, discoveryInfo: nil, serviceType: "nearby-devices")
        
        super.init()
        
        session.delegate = self
        advertiser.delegate = self
        
        messagePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.messages.append($0)
            }
            .store(in: &subscriptions)
    }
    
    func respondToInvitation(accept: Bool) {
        if let handler = invitationHandler {
            handler(accept, accept ? session : nil)
        }
    }
}

extension PeerViewModel: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        guard let message = String(data: data, encoding: .utf8) else {
            return
        }
        messagePublisher.send(message)
        
    }
    
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: (any Error)?) {
        
    }
}

extension PeerViewModel: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
        self.invitationHandler = invitationHandler
        self.invitationPeerName = peerID.displayName
        showingPermissionRequest = true
        hostId = peerId
    }
}


