//
//  RemoteAction.swift
//  iPhoneConnectMac
//
//  Created by Jesus Mora on 25/08/25.
//

enum RemoteAction: CaseIterable, Hashable {
    case playPause
    case rewind15
    case forward15
    case toggleConnection
    
    
    var iconName: String {
        switch self {
        case .playPause:
            return "play.fill"
        case .rewind15:
            return "15.arrow.trianglehead.counterclockwise"
        case .forward15:
            return "15.arrow.trianglehead.clockwise"
        case .toggleConnection:
            return "macbook.slash"
        }
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


