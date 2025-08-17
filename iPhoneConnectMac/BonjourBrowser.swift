//
//  BonjourBrowser.swift
//  iPhoneConnectMac
//
//  Created by Jonathan Mora on 10/08/25.
//

import SwiftUI
import Network
import Combine

class BonjourClient: ObservableObject {
    @Published var statusMessage: String = "Listo para conectar"
    @Published var isConnected: Bool = false
    @Published var nameMac: String = ""
    @Published var currentVolume: Float = 0

    
    private var connection: NWConnection?
    
    func connectDirectly() {
        disconnect() // Limpiar conexiones previas
        
        statusMessage = "🔌 Conectando a Mac..."
        
        // Usar directamente el hostname y puerto que sabemos que funcionan
        let hostname = NWEndpoint.Host("MacBook-Pro-de-Administrador.local")
        nameMac = hostname.debugDescription
        let port = NWEndpoint.Port(rawValue: 50506)!
        let endpoint = NWEndpoint.hostPort(host: hostname, port: port)
        
        // Configurar parámetros TCP
        let parameters = NWParameters.tcp
        let tcpOptions = NWProtocolTCP.Options()
        tcpOptions.connectionTimeout = 10
        tcpOptions.noDelay = true
        parameters.defaultProtocolStack.transportProtocol = tcpOptions
        
        // Crear conexión
        let connection = NWConnection(to: endpoint, using: parameters)
        
        // Manejar estados de conexión
        connection.stateUpdateHandler = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .setup:
                    self?.statusMessage = "⚙️ Configurando conexión..."
                    
                case .preparing:
                    self?.statusMessage = "🔧 Preparando conexión..."
                    
                case .ready:
                    self?.statusMessage = "🎉 ¡Conectado a la Mac!"
                    self?.isConnected = true
                    self?.sendPing()
                    
                case .waiting(let error):
                    self?.statusMessage = "⏳ Esperando: \(error.localizedDescription)"
                    
                case .failed(let error):
                    self?.statusMessage = "❌ Error: \(error.localizedDescription)"
                    self?.isConnected = false
                    
                    // Información adicional del error
                    if let nwError = error as? NWError,
                       case .posix(let posixError) = nwError {
                        switch posixError.rawValue {
                        case 61:
                            self?.statusMessage = "❌ Servidor no responde - ¿está ejecutándose?"
                        case 65:
                            self?.statusMessage = "❌ Mac no encontrada en la red"
                        case 60:
                            self?.statusMessage = "❌ Timeout - conexión muy lenta"
                        default:
                            break
                        }
                    }
                    
                case .cancelled:
                    self?.statusMessage = "🚫 Conexión cancelada"
                    self?.isConnected = false
                    
                @unknown default:
                    self?.statusMessage = "❓ Estado desconocido"
                }
            }
        }
        
        // Configurar recepción de datos
        connection.receiveMessage { data, context, isComplete, error in
            if let data = data, let message = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    self.statusMessage = "📨 Respuesta: \(message)"
                }
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.statusMessage = "❌ Error recibiendo: \(error.localizedDescription)"
                }
            }
        }
        
        // Iniciar conexión
        connection.start(queue: .main)
        self.connection = connection
        
        // Timeout de seguridad
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
            if connection.state != .ready && connection.state != .cancelled {
                connection.cancel()
                self.statusMessage = "⏰ Timeout de conexión"
            }
        }
    }
    
    private func sendPing() {
        send(message: "ping")
    }
    
    func send(message: String) {
        guard let connection = connection, connection.state == .ready else {
            statusMessage = "❌ No hay conexión activa"
            return
        }
        
        guard let data = message.data(using: .utf8) else {
            statusMessage = "❌ Error codificando mensaje"
            return
        }
        
        connection.send(content: data, completion: .contentProcessed({ [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.statusMessage = "❌ Error enviando: \(error.localizedDescription)"
                } else {
                    self?.statusMessage = "✅ Enviado: \(message)"
                }
            }
        }))
    }
    
    func sendShutdown() {
        send(message: "shutdown")
    }
    
    func sendRestart() {
        send(message: "restart")
    }
    
    private func disconnect() {
        connection?.cancel()
        connection = nil
        isConnected = false
        statusMessage = "Desconectado"
    }
    
    func toggleConnection() {
        withAnimation {
            if isConnected {
                disconnect()
            } else {
                connectDirectly()
            }
        }
    }
    
    func sendMessageToMac(_ mensaje: String = "Hola desde el iPhone") {
        let comando = "say \(mensaje)"
        send(message: comando)
    }
    
    func sendMScrolloMac(_ mensaje: String = "Hola desde el iPhone") {
        let comando = "say \(mensaje)"
        send(message: comando)
    }
    
    func sendCloseAppMac() {
        send(message: "exit")
    }

    func openAppleMusicOnMac() {
        send(message: "open music")
    }

    func closeAppleMusicOnMac() {
        send(message: "close music")
    }
    
    func playMusicOnMac() {
        send(message: "play music")
    }

    func sendKeyCodeToMac(_ code: String) {
        send(message: code)
    }
    
    func rewind15SecondsOnMac(_ code: String) {
        send(message: code)
    }
    
    func forward15SecondsOnMac(_ code: String) {
        send(message: code)
    }
    
    func increaseVolume() {
        send(message: "volume up")
    }
    
    func decreaseVolume() {
        send(message: "volume down")
    }
    
    deinit {
        disconnect()
    }
}
