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
                Text("\(bonjourClient.statusMessage)\n\(bonjourClient.nameMac)")
                    .padding(.all, 28)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .background(Color.secondBackground)
                    .cornerRadius(8)
                
                VStack(spacing: 38) {
                    
                    
                    // Trackpad integrado con función de gesto
                    TrackpadView { gesture in
                        switch gesture {
                        case "up":
                            bonjourClient.sendKeyCodeToMac("previousCard")
                        case "down":
                            bonjourClient.sendKeyCodeToMac("nextCard")
                        case "enter":
                            bonjourClient.sendKeyCodeToMac("selectCard")
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
                            MediaControlButton(systemImage: bonjourClient.isConnected ? "macbook.slash" : "macbook.and.iphone", shapeStyle: .circle, action: {
                                bonjourClient.toggleConnection()
                            })
                            
                            
                            
                            /*MediaControlButton(systemImage: "15.arrow.trianglehead.clockwise", action: {
                             bonjourClient.rewind15SecondsOnMac("key code 124")
                             })*/
                            
                            MediaControlButton(systemImage: "speaker.wave.3.fill", shapeStyle: .rounded(cornerRadius: 8)) {
                                changeVolume(by: 10)
                                bonjourClient.increaseVolume()
                            }
                            
                            
                        }
                        
                        HStack(spacing: 60) {
                            
                            MediaControlButton(systemImage: isPlaying ? "pause.fill" : "play.fill", shapeStyle: .rounded(cornerRadius: 8)) {
                                isPlaying.toggle()
                                bonjourClient.sendKeyCodeToMac("mouse click")
                            }
                            
                            MediaControlButton(systemImage: "speaker.wave.1.fill", shapeStyle: .rounded(cornerRadius: 8)) {
                                changeVolume(by: -10)
                                bonjourClient.decreaseVolume()
                                
                            }
                            
                            /*MediaControlButton(systemImage: "file", shapeStyle: .rounded(cornerRadius: 8)) {
                                bonjourClient.openSafariOnMac()
                                
                            }*/
                        }
                        
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.all, 24)
            
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
