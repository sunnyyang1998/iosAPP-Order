//
//  OrderManagerController.swift
//  Order
//
//  Created by 荞汐爱吃猫 on 1/8/2023.
//

import Combine
import Foundation
import MultipeerConnectivity

protocol OrderManagerControllerDelegate: AnyObject {
    func didSendOrderSuccessfully()
    func didFailToSendOrder(error: Error)
}

class OrderManagerController: NSObject, ObservableObject {
    private let serviceType = "kitchen-service"
    private let peerID = MCPeerID(displayName: UIDevice.current.name)

    private lazy var session: MCSession = {
        let session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        return session
    }()

    private lazy var advertiser: MCNearbyServiceAdvertiser = {
        let advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
        advertiser.delegate = self
        return advertiser
    }()

    weak var delegate: OrderManagerControllerDelegate?

    @Published var orders = [Order]()

    func addOrder(_ order: Order) {
        orders.append(order)
    }

    override init() {
        super.init()
        advertiser.startAdvertisingPeer()
    }

    deinit {
        advertiser.stopAdvertisingPeer()
    }
}

extension OrderManagerController: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("Failed to start advertising: \(error)")
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }
}

extension OrderManagerController: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("Peer \(peerID.displayName) changed state: \(state)")
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        // Implement this method if needed.
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        // Implement this method if needed.
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        // Implement this method if needed.
    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        // Implement this method if needed.
    }
}
