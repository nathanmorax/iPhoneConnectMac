//
//  NowPlayingInfoView.swift
//  iPhoneConnectMac
//
//  Created by Jesus Mora on 25/08/25.
//

import SwiftUI

struct NowPlayingInfoView: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("Back In My Body")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
            
            Text("Maggie Rogers")
                .font(.body)
                .foregroundStyle(.white)
            
        }
    }
}

#Preview {
    NowPlayingInfoView()
}

