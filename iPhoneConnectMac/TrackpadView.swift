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
            .fill(Color.gray.opacity(0.8))
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
