//
//  HostViewModel.swift
//  HostApp
//
//  Created by Italo Guilherme Monte on 17/08/24.
//

import Foundation
import MultipeerConnectivity

class HostViewModel: NSObject, ObservableObject {
    
    let hostId: MCPeerID
    let session: MCSession
    let browser: MCNearbyServiceBrowser
    
    var isBrowsing = false {
        didSet {
            isBrowsing ? browser.startBrowsingForPeers() : browser.stopBrowsingForPeers()
        }
    }
    
    var selectedPeer: MCPeerID? {
        didSet{
            connect()
        }
    }
    
    @Published var browsedPeers: [MCPeerID] = []
    
    override init() {
        
        self.hostId = MCPeerID(displayName: UIDevice.current.name)
        self.session = MCSession(peer: hostId)
        self.browser = MCNearbyServiceBrowser(peer: hostId, serviceType: "nearby-devices")
        
        super.init()
        
        browser.delegate = self
    }
    
    // Manda o convite
    private func connect() {
        guard let selectedPeer else {
            return
        }
        if !(session.connectedPeers.contains(selectedPeer)) {
            browser.invitePeer(selectedPeer, to: session, withContext: nil, timeout: 60)
        }
        
    }
    
    // helps send data between peers.
    public func sendMessage(message: String, toPeers: [MCPeerID]) {
        guard let data = message.data(using: .utf8) else {
            return
        }
        
        do {
            try session.send(data, toPeers: toPeers, with: .reliable)
            
        } catch {
            print("Error for sending: \(String(describing: error))")
        }
        
    }
    
    
}

//extension HostViewModel: MCSessionDelegate {
//    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
//        
//    }
//    
//    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
//    
//    }
//    
//    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
//        
//    }
//    
//    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
//        
//    }
//    
//    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: (any Error)?) {
//        
//    }
//   
//    
//}

extension HostViewModel: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
        
        // Verificar se dispositivo encontrado ja foi adicionado a lista de browsed peers
        
        var peerBrowsed = false
        for peer in self.browsedPeers {
            if peer == peerID {
                peerBrowsed = true
            }
        }
        
        // Se não foi adicionado ainda, coloca na lista
        
        if !peerBrowsed {
            browsedPeers.append(peerID)
        }
        
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
        //remove o peer da lista browsedPeers
        browsedPeers.removeAll(where: { $0 == peerID })

    }
    
}
