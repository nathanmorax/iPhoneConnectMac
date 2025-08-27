//
//  ClickWheelView.swift
//  iPhoneConnectMac
//
//  Created by Jesus Mora on 26/08/25.
//
import SwiftUI

struct ClickWheelView: View {
    @State private var angle: Double = 0.0
    
    var body: some View {
        ZStack {
            // 🔘 Círculo exterior (rueda)
            Circle()
                .fill(Color.colorWheelOut)
                .frame(width: 250, height: 250)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let dx = value.location.x - 125
                            let dy = value.location.y - 125
                            let radians = atan2(dy, dx)
                            angle = radians * 180 / .pi
                        }
                )
            
            // Botones en posiciones cardinales
            VStack {
                // Arriba -> ConnectToMac
                Image(systemName: "tv.badge.wifi")
                    .font(.title3)
                    .foregroundColor(.colorWheelIcon)
                Spacer()
                // Abajo -> Play/Pause
                Image(systemName: "playpause.fill")
                    .font(.title3)
                    .foregroundColor(.colorWheelIcon)
            }
            .frame(height: 220)
            
            HStack {
                // Izquierda -> Back
                Image(systemName: "backward.fill")
                    .font(.title3)
                    .foregroundColor(.colorWheelIcon)
                Spacer()
                // Derecha -> Forward
                Image(systemName: "forward.fill")
                    .font(.title3)
                    .foregroundColor(.colorWheelIcon)
            }
            .frame(width: 220)
            
            // 🔘 Botón central
            Circle()
                .fill(Color.colorWheelIn)
                .frame(width: 100, height: 100)
                .shadow(radius: 4)
                .onTapGesture {
                    print("Botón central presionado")
                }
        }
        .frame(width: 250, height: 250)
    }
}

struct ClickWheelView_Previews: PreviewProvider {
    static var previews: some View {
        ClickWheelView()
    }
}
