//
//  ProgressBar.swift
//  iPhoneConnectMac
//
//  Created by Jesus Mora on 25/08/25.
//
import SwiftUI

struct ProgressBar: View {
    
    var progressWidth: Double
    var currentTime: Double
    var totalTime: Double
    
    
    var body: some View {
        
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
    }
    
    // Convierte segundos a formato mm:ss
    private func timeString(from seconds: Double) -> String {
        let minutes = Int(seconds) / 60
        let remainingSeconds = Int(seconds) % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
}

