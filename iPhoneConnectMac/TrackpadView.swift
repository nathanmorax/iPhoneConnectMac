//
//  TrackpadView.swift
//  iPhoneConnectMac
//
//  Created by Jesus Mora on 14/08/25.
//
import SwiftUI

struct TrackpadView: View {
    var onGesture: (String) -> Void
    
    var body: some View {
        Rectangle()
            .fill(Color.secondBackGround)
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

import SwiftUI

struct PlayerView: View {
    @State private var isPlaying = false
    @State private var currentTime: Double = 72
    @State private var totalTime: Double = 204
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Fondo con gradiente
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Spacer()
                
                CoverMovieAlbum(dragOffset: dragOffset)
                
                Spacer().frame(height: 40)
                
                // Información de la canción
                VStack(spacing: 8) {
                    Text("Back In My Body")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                    
                    Text("Maggie Rogers")
                        .font(.body)
                        .foregroundStyle(.white)

                }
                
                // Barra de progreso
                VStack(spacing: 8) {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 6)
                        
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.white)
                            .frame(width: progressWidth, height: 6)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                    
                    // Tiempo
                    HStack {
                        Text(timeString(from: currentTime))
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text(timeString(from: totalTime))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 20)
                }
                
                // Controles de reproducción
                HStack(spacing: 35) {
                    // Shuffle
                    Button(action: {}) {
                        Image(systemName: "shuffle")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Circle().fill(Color.black.opacity(0.3)))
                    
                    // Repetir
                    Button(action: {}) {
                        Image(systemName: "repeat")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Circle().fill(Color.black.opacity(0.3)))
                    
                    // Loop
                    Button(action: {}) {
                        Image(systemName: "infinity")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Circle().fill(Color.black.opacity(0.3)))
                    
                    // AirPlay/Cast
                    Button(action: {}) {
                        Image(systemName: "tv")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Circle().fill(Color.black.opacity(0.3)))
                    
                    // Conexión (Bluetooth/WiFi)
                    Button(action: {}) {
                        Image(systemName: "wifi")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .background(Circle().fill(Color.white))
                    
                    // Más opciones
                    Button(action: {}) {
                        Image(systemName: "ellipsis")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Circle().fill(Color.black.opacity(0.3)))
                }
                .padding(.horizontal)
                
                Spacer().frame(height: 60)
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragOffset = value.translation.width
                }
                .onEnded { _ in
                    withAnimation(.spring()) {
                        dragOffset = 0
                    }
                }
        )
        .onAppear {
            startProgressSimulation()
        }
    }
    
    // Calcula el ancho de la barra de progreso
    private var progressWidth: CGFloat {
        let screenWidth = UIScreen.main.bounds.width - 40 // padding horizontal
        return CGFloat(currentTime / totalTime) * screenWidth
    }
    
    // Convierte segundos a formato mm:ss
    private func timeString(from seconds: Double) -> String {
        let minutes = Int(seconds) / 60
        let remainingSeconds = Int(seconds) % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
    
    // Simula el progreso de la canción
    private func startProgressSimulation() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if currentTime < totalTime {
                currentTime += 1
            } else {
                timer.invalidate()
            }
        }
    }
}

// Vista de controles de reproducción principal (para agregar si quieres)
struct PlaybackControlsView: View {
    @State private var isPlaying = false
    
    var body: some View {
        HStack(spacing: 40) {
            Button(action: {}) {
                Image(systemName: "backward.fill")
                    .font(.title)
                    .foregroundColor(.white)
            }
            
            Button(action: { isPlaying.toggle() }) {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
            .scaleEffect(isPlaying ? 1.1 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPlaying)
            
            Button(action: {}) {
                Image(systemName: "forward.fill")
                    .font(.title)
                    .foregroundColor(.white)
            }
        }
    }
}

// Vista de previsualización
struct MusicPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}
