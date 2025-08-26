//
//  BonjourClientDelegate.swift
//  iPhoneConnectMac
//
//  Created by Jesus Mora on 26/08/25.
//

// MARK: - Protocols
protocol BonjourClientDelegate: AnyObject {
    func client(_ client: BonjourClient, didReceiveMessage message: String)
    func client(_ client: BonjourClient, didChangeState state: ConnectionState)
}
