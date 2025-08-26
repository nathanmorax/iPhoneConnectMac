//
//  NetworkError.swift
//  iPhoneConnectMac
//
//  Created by Jesus Mora on 14/08/25.
//
import Foundation

enum NetworkError: LocalizedError {
    case invalidPort
    case serverNotResponding
    case hostNotFound
    case connectionTimeout
    case unknownState
    
    var errorDescription: String? {
        switch self {
        case .invalidPort:
            return "Puerto de conexión inválido"
        case .serverNotResponding:
            return "Servidor no responde - ¿está ejecutándose?"
        case .hostNotFound:
            return "Mac no encontrada en la red"
        case .connectionTimeout:
            return "Timeout - conexión muy lenta"
        case .unknownState:
            return "Estado de conexión desconocido"
        }
    }
}
