//
//  NetworkError.swift
//  iPhoneConnectMac
//
//  Created by Jesus Mora on 14/08/25.
//
import SwiftUI

enum NetworkError: LocalizedError {
    case connectionRefused
    case hostNotFound
    case timeout
    case sendFailed(String)
    case encodingFailed
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .connectionRefused:
            return "❌ Servidor no responde - ¿está ejecutándose?"
        case .hostNotFound:
            return "❌ Mac no encontrada en la red"
        case .timeout:
            return "❌ Timeout - conexión muy lenta"
        case .sendFailed(let message):
            return "❌ Error enviando: \(message)"
        case .encodingFailed:
            return "❌ Error codificando mensaje"
        case .unknown(let message):
            return "❌ Error: \(message)"
        }
    }
}
