//
//  CoverMovieAlbum.swift
//  iPhoneConnectMac
//
//  Created by Jesus Mora on 25/08/25.
//
import SwiftUI

struct CoverMovieAlbum: View {
    
    var dragOffset: Double
    
    var body: some View {
        // Imagen del álbum con efecto 3D
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.orange, Color.red]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 280, height: 280)
                            .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                        
                        // Imagen de la artista (placeholder)
                        VStack {
                            Circle()
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.title)
                                        .foregroundColor(.white)
                                )
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .frame(width: 120, height: 60)
                                .overlay(
                                    VStack(spacing: 4) {
                                        RoundedRectangle(cornerRadius: 2)
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 80, height: 4)
                                        RoundedRectangle(cornerRadius: 2)
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 60, height: 4)
                                    }
                                )
                        }
                    }
                    .rotation3DEffect(
                        .degrees(dragOffset * 0.1),
                        axis: (x: 0, y: 1, z: 0)
                    )

    }
}
