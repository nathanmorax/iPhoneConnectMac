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
    
    
    func iconName(viewModel: RemoteControlViewModel) -> String {
          switch self {
          case .playPause:
              return viewModel.isPlaying ? "pause.fill" : "play.fill"
          case .rewind15:
              return "15.arrow.trianglehead.counterclockwise"
          case .forward15:
              return "15.arrow.trianglehead.clockwise"
          case .toggleConnection:
              return viewModel.isConnecting ? "macbook" : "macbook.slash"
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


