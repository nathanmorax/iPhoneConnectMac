//
//  RemoteAction.swift
//  iPhoneConnectMac
//
//  Created by Jesus Mora on 26/08/25.
//
import SwiftUI

enum RemoteAction: CaseIterable, Hashable {
    case rewind15
    case playPause
    case forward15
    case toggleConnection
    
    
    func iconName(viewModel: RemoteControlViewModel) -> String {
        switch self {
        case .playPause:
            return viewModel.isPlaying ? "play.fill" : "pause.fill"
        case .rewind15:
            return "15.arrow.trianglehead.counterclockwise"
        case .forward15:
            return "15.arrow.trianglehead.clockwise"
        case .toggleConnection:
            return viewModel.isConnecting ? "macbook" : "macbook.slash"
        }
    }
    
    var foregroundColor: Color {
        self == .toggleConnection ? .black : .white
    }
    
    var backgroundColor: Color {
        self == .toggleConnection ? .white : Color.black.opacity(0.3)
    }
    
    func remoteAction(viewModel: RemoteControlViewModel) {
        
        switch self {
        case .playPause:
            viewModel.togglePlay()
        case .rewind15:
            viewModel.rewind()
        case .forward15:
            viewModel.forward()
        case .toggleConnection:
            viewModel.toggleConnection()
        }
        
    }
}
