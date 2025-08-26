//
//  RemoteControlViewModel.swift
//  iPhoneConnectMac
//
//  Created by Jesus Mora on 25/08/25.
//
import SwiftUI

@Observable
class RemoteControlViewModel {
    var bonjourClient = BonjourClient()
    var isPlaying = false
    var isConnecting = false
    var isConnected = false
    
    func togglePlay() {
        isPlaying.toggle()
        bonjourClient.playPauseOnMac()
    }
    
    func rewind() {
        bonjourClient.rewind15SecondsOnMac()
    }
    
    func forward() {
        bonjourClient.forward15SecondsOnMac()
    }
    
    func toggleConnection() {
        isConnecting.toggle()
        bonjourClient.toggleConnection()
    }
    
    // Determina si un botón específico debe estar deshabilitado
    
    func shouldDisableButton(_ action: RemoteAction) -> Bool {
        switch action {
        case .toggleConnection:
            // El botón de conexión solo se deshabilita mientras está conectando
            return isConnecting
            
        case .playPause, .rewind15, .forward15:
            // Los botones de control se deshabilitan si no está conectado O si está conectando
            return isConnected || isConnecting
        }
    }
}
