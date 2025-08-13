//
//  ContentView.swift
//  iPhoneConnectMac
//
//  Created by Jonathan Mora on 10/08/25.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var bonjourClient = BonjourClient()
    
    var body: some View {
        VStack(spacing: 20) {
            Text(bonjourClient.statusMessage)
                .padding()
                .multilineTextAlignment(.center)
            
            if bonjourClient.isConnected {
                VStack {
                    Button("Apagar Mac") {
                        bonjourClient.sendShutdown()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Reiniciar Mac") {
                        bonjourClient.sendRestart()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Desconectar") {
                        bonjourClient.disconnect()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Enviar mensaje") {
                        bonjourClient.sendMessageToMac("Hola desde el iPhone!")
                    }
                    .buttonStyle(.bordered)
                }
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

