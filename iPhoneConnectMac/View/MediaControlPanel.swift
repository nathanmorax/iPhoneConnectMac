//
//  PlayerVieww.swift
//  iPhoneConnectMac
//
//  Created by Jesus Mora on 27/08/25.
//
import SwiftUI

struct MediaControlPanel: View {
    
    var progressWidth: Double
    var currentTime: Double
    var totalTime: Double
    var viewModel: RemoteControlViewModel
    
    var body: some View {
        
        VStack {
            
            ZStack {
                
                Image("nevermind")
                    .resizable()
                    .scaledToFill()
                    .blur(radius: 36)
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.4), Color.clear]),
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                
                VStack {
                    Image("nevermind")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(8)
                        .padding()
                    
                    NowPlayingInfoView()
                    
                    
                    ProgressBar(progressWidth: progressWidth, currentTime: currentTime, totalTime: totalTime)
                    
                    // Controles de reproducción
                    HStack(spacing: 36) {
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
                            .frame(maxWidth: 38)
                            .background(Circle().fill(action.backgroundColor))
                            
                        }
                    }
                }
                
            }
            
        }
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.black.opacity(1), lineWidth: 1)
        )
        .frame(width: 120)

    }
}

#Preview {
                        MediaControlPanel(progressWidth: 0.0, currentTime: 1.0, totalTime: 2.0, viewModel: RemoteControlViewModel())
        .previewLayout(.sizeThatFits)
}




