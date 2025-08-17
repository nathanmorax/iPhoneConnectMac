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
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                
                Text(bonjourClient.nameMac)
                
                
                VStack(spacing: 38) {
                    
                    
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
                    
                    VStack(spacing: 24) {
                        
                        /*MediaControlButton(systemImage: "15.arrow.trianglehead.counterclockwise", action: {
                         bonjourClient.rewind15SecondsOnMac("key code 123")
                         })*/
                        
                        HStack(spacing: 60) {
                            MediaControlButton(systemImage: "wave.3.right", size: 80, shapeStyle: .circle, action: {
                                bonjourClient.connectDirectly()
                            })
                            
                            
                            
                            /*MediaControlButton(systemImage: "15.arrow.trianglehead.clockwise", action: {
                             bonjourClient.rewind15SecondsOnMac("key code 124")
                             })*/
                            
                            MediaControlButton(systemImage: "speaker.wave.3.fill", size: 80, shapeStyle: .rounded(cornerRadius: 8)) {
                                changeVolume(by: 15)
                                bonjourClient.increaseVolume()
                            }
                            
                            
                        }
                        
                        HStack(spacing: 60) {
                            
                            MediaControlButton(systemImage: isPlaying ? "pause.fill" : "play.fill", size: 80, shapeStyle: .rounded(cornerRadius: 8)) {
                                isPlaying.toggle()
                                bonjourClient.sendKeyCodeToMac("mouse click")
                            }
                            
                            MediaControlButton(systemImage: "speaker.wave.1.fill", size: 80, shapeStyle: .rounded(cornerRadius: 8)) {
                                changeVolume(by: -15)
                                bonjourClient.decreaseVolume()
                                
                            }
                            
                        }
                        
                    }
                }
                .buttonStyle(.borderedProminent)
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
