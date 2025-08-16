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
    
    @State private var showVolumeOverlay = false
    @State private var currentVolume: Float = 0.5
    @State private var overlayTimer: Timer? = nil
    
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
                                    changeVolume(by: -15)
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
                                    changeVolume(by: 15)
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
            
            if showVolumeOverlay {
                VolumeOverlay(volume: currentVolume)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.2), value: showVolumeOverlay)
            }
        }
        
    }
    
    private func changeVolume(by amount: Float) {
        currentVolume = min(max(currentVolume + amount, 0), 100)
        showVolumeOverlay = true
        
        overlayTimer?.invalidate()
        overlayTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            withAnimation {
                showVolumeOverlay = false
            }
        }
    }
}

#Preview {
    ContentView()
}



struct VolumeOverlay: View {
    var volume: Float // 0.0 a 1.0
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: volume == 0 ? "speaker.slash.fill" :
                    (volume < 0.5 ? "speaker.wave.1.fill" : "speaker.wave.3.fill"))
            .font(.system(size: 40))
            .foregroundColor(.white)
        }
        .padding(.all, 38)
        //.background(.black.opacity(0.7))
        .cornerRadius(12)
    }
}
