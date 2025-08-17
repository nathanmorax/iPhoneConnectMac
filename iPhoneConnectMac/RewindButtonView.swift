//
//  Rewind15SecView.swift
//  iPhoneConnectMac
//
//  Created by Jesus Mora on 16/08/25.
//
import SwiftUI

struct RewindButtonView: View {
    
    let systemImage: String
    var action: () -> Void
    
    var body: some View {
        VStack {
            Button {
                action()
            } label: {
                Image(systemName: "15.arrow.trianglehead.counterclockwise")
            }
            .buttonStyle(.plain)
        }
        .padding()

    }
}


