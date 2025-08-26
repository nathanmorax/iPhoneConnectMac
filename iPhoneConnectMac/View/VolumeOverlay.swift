//
//  VolumeOverlay.swift
//  iPhoneConnectMac
//
//  Created by Jesus Mora on 16/08/25.
//
import SwiftUI

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
        .background(.black.opacity(0.7))
        .cornerRadius(12)
    }
}

#Preview {
    VolumeOverlay(volume: 0.4)
}
