//
//  Rewind15SecView.swift
//  iPhoneConnectMac
//
//  Created by Jesus Mora on 16/08/25.
//
import SwiftUI

struct MediaControlButton: View {
    
    enum ShapeStyle {
        case circle
        case rounded(cornerRadius: CGFloat)
    }
    
    let systemImage: String
    var size: CGFloat = 60
    var shapeStyle: ShapeStyle = .rounded(cornerRadius: 8)
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .resizable()
                .scaledToFit()
                .frame(width: size * 0.5, height: size * 0.5)
                .foregroundColor(.white)
                .padding(size * 0.25)
        }
        .background(.gray)
        .frame(width: size, height: size)
        .modifier(ShapeModifier(style: shapeStyle))
        .buttonStyle(.plain)
    }
}

struct ShapeModifier: ViewModifier {
    let style: MediaControlButton.ShapeStyle

    func body(content: Content) -> some View {
        switch style {
        case .circle:
            content.clipShape(Circle())
        case .rounded(let radius):
            content.clipShape(RoundedRectangle(cornerRadius: radius))
        }
    }
}
