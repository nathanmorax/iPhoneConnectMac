//
//  ContentView.swift
//  iPhoneConnectMac
//
//  Created by Jonathan Mora on 10/08/25.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var bonjourClient = BonjourClient()
    @State private var isPlaying = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 20) {
                Text(bonjourClient.statusMessage)
                    .padding()
                    .multilineTextAlignment(.center)
                
                Text(bonjourClient.nameMac)
                
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
                            default:
                                break
                            }
                        }
                        
                        HStack(spacing: 24) {
                            VStack {
                                Button {
                                    bonjourClient.rewind15SecondsOnMac("key code 123")
                                } label: {
                                    Image(systemName: "15.arrow.trianglehead.counterclockwise")
                                }
                                .buttonStyle(.plain)
                            }
                            .padding()
                            
                            
                            HStack {
                                Button {
                                    isPlaying.toggle()
                                    bonjourClient.sendKeyCodeToMac("mouse click")
                                } label: {
                                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                        .resizable() // permite ajustar el tamaño libremente
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 36, height: 36)
                                    
                                }
                                .buttonStyle(.plain)
                            }
                            
                            
                            VStack {
                                Button {
                                    bonjourClient.rewind15SecondsOnMac("key code 124")
                                } label: {
                                    Image(systemName: "15.arrow.trianglehead.clockwise")
                                }
                                .buttonStyle(.plain)
                            }
                            .padding()
                            
                        }
                        .padding(.vertical, 14)
                        .padding(.horizontal, 40)
                        .background(.gray)
                        .cornerRadius(8)
                        
                        
                        
                        HStack {
                            VStack {
                                Button {
                                    bonjourClient.decreaseVolume()
                                } label: {
                                    Image(systemName: "speaker.wave.1.fill")
                                }
                                .buttonStyle(.plain)
                            }
                            .padding()
                            .background(.gray)
                            .cornerRadius(8)
                            
                            VStack {
                                Button {
                                    bonjourClient.increaseVolume()
                                } label: {
                                    Image(systemName: "speaker.wave.3.fill")
                                }
                                .buttonStyle(.plain)
                            }
                            .padding()
                            .background(.gray)
                            .cornerRadius(8)
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
}

#Preview {
    ContentView()
}

