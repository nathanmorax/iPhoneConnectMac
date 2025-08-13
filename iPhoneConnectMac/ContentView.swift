//
//  ContentView.swift
//  iPhoneConnectMac
//
//  Created by Jonathan Mora on 10/08/25.
//
import SwiftUI

import SwiftUI

struct ContentView: View {
    @StateObject private var bonjourClient = BonjourClient()
    
    var body: some View {
        VStack(spacing: 20) {
            Text(bonjourClient.statusMessage)
                .padding()
                .multilineTextAlignment(.center)
            
            if bonjourClient.isConnected {
                VStack(spacing: 15) {
                    Button("Apagar Mac") {
                        bonjourClient.sendShutdown()
                    }
                    
                    // Trackpad integrado con función de gesto
                    TrackpadView { gesture in
                        switch gesture {
                        case "up":
                            bonjourClient.sendKeyCodeToMac("key code 126")
                        case "down":
                            bonjourClient.sendKeyCodeToMac("key code 125")
                        case "left":
                            bonjourClient.sendKeyCodeToMac("key code 123")
                        case "right":
                            bonjourClient.sendKeyCodeToMac("key code 124")
                        case "enter":
                            bonjourClient.sendKeyCodeToMac("key code 36")
                        case "click":
                            bonjourClient.sendKeyCodeToMac("mouse click")
                        default:
                            break
                        }
                    }
                    
                    Button("Abrir Apple Music") {
                        bonjourClient.openAppleMusicOnMac()
                    }
                    
                    Button("Cerrar Apple Music") {
                        bonjourClient.closeAppleMusicOnMac()
                    }
                    
                    Button("Play Apple Music") {
                        bonjourClient.playMusicOnMac()
                    }
                    
                    Button("Enviar mensaje") {
                        bonjourClient.sendMessageToMac("Hola desde el iPhone!")
                    }
                }
                .buttonStyle(.borderedProminent)
                
            } else {
                Button("Conectar a Mac") {
                    bonjourClient.connectDirectly()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
}

struct TrackpadView: View {
    var onGesture: (String) -> Void
    
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.8))
            .gesture(
                DragGesture()
                    .onEnded { value in
                        let dx = value.translation.width
                        let dy = value.translation.height
                        
                        if abs(dx) > abs(dy) {
                            onGesture(dx > 0 ? "right" : "left")
                        } else {
                            onGesture(dy > 0 ? "down" : "up")
                        }
                    }
            )
            .onTapGesture {
                onGesture("click")
            }
            .frame(height: 300)
            .cornerRadius(12)
    }
}
