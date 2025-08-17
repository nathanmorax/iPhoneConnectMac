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
    var shapeStyle: ShapeStyle = .rounded(cornerRadius: 8)
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .resizable()
                .scaledToFit()
                .frame(width: 90 * 0.5, height: 90 * 0.5)
                .foregroundColor(.white)
                .padding(90 * 0.25)
        }
        .background(Color.secondBackground)
        .frame(width: 90, height: 90)
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
