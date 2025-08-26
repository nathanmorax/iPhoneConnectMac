//
//  PlayerView.swift
//  iPhoneConnectMac
//
//  Created by Jesus Mora on 25/08/25.
//
import SwiftUI

struct PlayerView: View {
    @State private var currentTime: Double = 72
    @State private var totalTime: Double = 204
    @State private var dragOffset: CGFloat = 0
    @State var viewModel = RemoteControlViewModel()
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Spacer()
                
                CoverMovieAlbum(dragOffset: dragOffset)
                
                Spacer().frame(height: 40)
                
                NowPlayingInfoView()
                
                // Barra de progreso
                
                ProgressBar(progressWidth: progressWidth, currentTime: currentTime, totalTime: totalTime)
                
                // Controles de reproducción
                HStack(spacing: 16) {
                    ForEach(RemoteAction.allCases, id: \.self) { action in
                        Button {
                            action.remoteAction(viewModel: viewModel)
                        } label: {
                            Image(systemName: action.iconName(viewModel: viewModel))
                                .font(.title2)
                                .foregroundColor(action.foregroundColor)

                        }
                        //.disabled(viewModel.shouldDisableButton(action))
                        .padding()
                        .background(Circle().fill(action.backgroundColor))

                    }
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
