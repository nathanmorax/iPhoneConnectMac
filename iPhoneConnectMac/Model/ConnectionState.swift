//
//  ConnectionState.swift
//  iPhoneConnectMac
//
//  Created by Jesus Mora on 26/08/25.
//
import Foundation

enum ConnectionState {
    case disconnected
    case connecting
    case connected
    case failed(Error)
    
    var displayMessage: String {
        switch self {
        case .disconnected:
            return "Listo para conectar"
        case .connecting:
            return "🔌 Conectando a Mac..."
        case .connected:
            return "¡Conectado a la Mac!"
        case .failed(let error):
            return "❌ Error: \(error.localizedDescription)"
        }
    }
    
    var isConnected: Bool {
        if case .connected = self { return true }
        return false
    }
}
