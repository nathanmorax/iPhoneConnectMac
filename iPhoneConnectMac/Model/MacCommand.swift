//
//  MacCommand.swift
//  iPhoneConnectMac
//
//  Created by Jesus Mora on 26/08/25.
//
import Foundation

enum MacCommand: String {
    case ping = "ping"
    case shutdown = "shutdown"
    case restart = "restart"
    case exit = "exit"
    case openMusic = "open music"
    case openSafari = "opensafari"
    case closeMusic = "close music"
    case playMusic = "play music"
    case volumeUp = "volume up"
    case volumeDown = "volume down"
    
    case say = "say"
    
    static func sayMessage(_ message: String) -> String {
        return "say \(message)"
    }
}
