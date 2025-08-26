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

    func togglePlay() {
        isPlaying.toggle()
        bonjourClient.sendKeyCodeToMac("mouse click")
    }
    
    func rewind() {
        bonjourClient.rewind15SecondsOnMac("key code 123")
    }
    
    func forward() {
        bonjourClient.rewind15SecondsOnMac("key code 124")
    }

    func toggleConnection() {
        isConnecting.toggle()
        bonjourClient.toggleConnection()
    }
}
