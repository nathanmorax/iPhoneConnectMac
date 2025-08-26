//
//  NWConnection+Extensions.swift
//  iPhoneConnectMac
//
//  Created by Jesus Mora on 26/08/25.
//

import Network

extension NWConnection.State {
    var isReady: Bool {
        if case .ready = self { return true }
        return false
    }
    
    var displayName: String {
        switch self {
        case .setup:
            return "Setup"
        case .waiting:
            return "Waiting"
        case .preparing:
            return "Preparing"
        case .ready:
            return "Ready"
        case .failed:
            return "Failed"
        case .cancelled:
            return "Cancelled"
        @unknown default:
            return "Unknown"
        }
    }
}
