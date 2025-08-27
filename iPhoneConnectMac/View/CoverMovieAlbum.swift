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
            
            // Imagen de la artista (placeholder)
            VStack {
                Image("nevermind")
                    .font(.title)
                    .foregroundColor(.white)
                
                
            }
        }
        .rotation3DEffect(
            .degrees(dragOffset * 0.1),
            axis: (x: 0, y: 1, z: 0)
        )
        
    }
}
