//
//  BonjourClient.swift
//  iPhoneConnectMac
//
//  Created by Jonathan Mora on 10/08/25.
//

import SwiftUI
import Network
import Combine
import Foundation
import OSLog


// MARK: - BonjourClient
final class BonjourClient: ObservableObject {
    
    // MARK: - Published Properties
    @Published private(set) var connectionState: ConnectionState = .disconnected
    @Published private(set) var macHostname: String = ""
    @Published private(set) var currentVolume: Float = 0
    
    // Computed properties para compatibilidad con UI existente
    var statusMessage: String { connectionState.displayMessage }
    var isConnected: Bool { connectionState.isConnected }
    var nameMac: String { macHostname }
    
    // MARK: - Properties
    weak var delegate: BonjourClientDelegate?
    
    private var connection: NWConnection?
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "BonjourClient", category: "Network")
    private let connectionQueue = DispatchQueue(label: "com.app.bonjour.connection", qos: .userInitiated)
    
    // MARK: - Constants
    private enum Constants {
        static let defaultHostname = "Laptop-de-Jesus.local"
        static let defaultPort: UInt16 = 50506
        static let connectionTimeout: TimeInterval = 15
        static let tcpTimeout: Int = 10
    }
    
    // MARK: - Initialization
    init() {
        setupLogger()
    }
    
    deinit {
        disconnect()
    }
}

// MARK: - Public Interface
extension BonjourClient {
    
    /// Conecta directamente al Mac usando el hostname conocido
    func connectDirectly() {
        disconnect()
        updateConnectionState(.connecting)
        
        let hostname = NWEndpoint.Host(Constants.defaultHostname)
        macHostname = hostname.debugDescription
        
        guard let port = NWEndpoint.Port(rawValue: Constants.defaultPort) else {
            logger.error("Puerto inválido: \(Constants.defaultPort)")
            updateConnectionState(.failed(NetworkError.invalidPort))
            return
        }
        
        let endpoint = NWEndpoint.hostPort(host: hostname, port: port)
        let connection = createConnection(to: endpoint)
        
        setupConnectionHandlers(for: connection)
        startConnection(connection)
    }
    
    /// Alterna entre conectar y desconectar
    func toggleConnection() {
        withAnimation {
            if connectionState.isConnected {
                disconnect()
            } else {
                connectDirectly()
            }
        }
    }
    
    /// Desconecta de la Mac
    func disconnect() {
        connection?.cancel()
        connection = nil
        updateConnectionState(.disconnected)
        logger.info("Conexión desconectada")
    }
}

// MARK: - Mac Commands
extension BonjourClient {
    
    func sendPing() {
        sendCommand(.ping)
    }
    
    func sendShutdown() {
        sendCommand(.shutdown)
    }
    
    func sendRestart() {
        sendCommand(.restart)
    }
    
    func sendCloseAppMac() {
        sendCommand(.exit)
    }
    
    func openAppleMusicOnMac() {
        sendCommand(.openMusic)
    }
    
    func openSafariOnMac() {
        sendCommand(.openSafari)
    }
    
    func closeAppleMusicOnMac() {
        sendCommand(.closeMusic)
    }
    
    func playMusicOnMac() {
        sendCommand(.playMusic)
    }
    
    func increaseVolume() {
        sendCommand(.volumeUp)
    }
    
    func decreaseVolume() {
        sendCommand(.volumeDown)
    }
    
    func sendMessageToMac(_ message: String = "Hola desde el iPhone") {
        let command = MacCommand.sayMessage(message)
        sendMessage(command)
    }
    
    func sendKeyCodeToMac(_ code: String) {
        sendMessage(code)
    }
    
    func rewind15SecondsOnMac(_ code: String) {
        sendMessage(code)
    }
    
    func forward15SecondsOnMac(_ code: String) {
        sendMessage(code)
    }
}

// MARK: - Private Methods - Connection Management
private extension BonjourClient {
    
    func createConnection(to endpoint: NWEndpoint) -> NWConnection {
        let parameters = NWParameters.tcp
        let tcpOptions = NWProtocolTCP.Options()
        tcpOptions.connectionTimeout = Constants.tcpTimeout
        tcpOptions.noDelay = true
        parameters.defaultProtocolStack.transportProtocol = tcpOptions
        
        return NWConnection(to: endpoint, using: parameters)
    }
    
    func setupConnectionHandlers(for connection: NWConnection) {
        connection.stateUpdateHandler = { [weak self] state in
            self?.handleConnectionStateChange(state)
        }
        
        setupMessageReceiving(for: connection)
    }
    
    func startConnection(_ connection: NWConnection) {
        connection.start(queue: connectionQueue)
        self.connection = connection
        
        // Timeout de seguridad
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.connectionTimeout) { [weak self] in
            guard let self = self,
                  let currentConnection = self.connection,
                  currentConnection === connection,
                  !currentConnection.state.isReady,
                  currentConnection.state != .cancelled else { return }
            
            currentConnection.cancel()
            self.updateConnectionState(.failed(NetworkError.connectionTimeout))
        }
    }
    
    func handleConnectionStateChange(_ state: NWConnection.State) {
        logger.info("Estado de conexión cambió a: \(String(describing: state))")
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            switch state {
            case .setup, .preparing:
                self.updateConnectionState(.connecting)
                
            case .ready:
                self.updateConnectionState(.connected)
                self.sendPing()
                
            case .waiting(let error):
                self.logger.warning("Conexión esperando: \(error.localizedDescription)")
                self.updateConnectionState(.failed(error))
                
            case .failed(let error):
                self.logger.error("Conexión falló: \(error.localizedDescription)")
                let processedError = self.processNetworkError(error)
                self.updateConnectionState(.failed(processedError))
                
            case .cancelled:
                self.updateConnectionState(.disconnected)
                
            @unknown default:
                self.logger.error("Estado de conexión desconocido")
                self.updateConnectionState(.failed(NetworkError.unknownState))
            }
        }
    }
    
    func setupMessageReceiving(for connection: NWConnection) {
        connection.receiveMessage { [weak self] data, context, isComplete, error in
            self?.handleReceivedMessage(data: data, context: context, isComplete: isComplete, error: error)
        }
    }
    
    func handleReceivedMessage(data: Data?, context: NWConnection.ContentContext?, isComplete: Bool, error: Error?) {
        if let error = error {
            logger.error("Error recibiendo mensaje: \(error.localizedDescription)")
            return
        }
        
        guard let data = data,
              let message = String(data: data, encoding: .utf8) else {
            logger.warning("Datos recibidos inválidos")
            return
        }
        
        logger.info("Mensaje recibido: \(message)")
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.delegate?.client(self, didReceiveMessage: message)
        }
    }
}

// MARK: - Private Methods - Message Sending
private extension BonjourClient {
    
    func sendCommand(_ command: MacCommand) {
        sendMessage(command.rawValue)
    }
    
    func sendMessage(_ message: String) {
        guard let connection = connection,
              connection.state == .ready else {
            logger.warning("Intento de envío sin conexión activa")
            return
        }
        
        guard let data = message.data(using: .utf8) else {
            logger.error("Error codificando mensaje: \(message)")
            return
        }
        
        logger.info("Enviando mensaje: \(message)")
        
        connection.send(content: data, completion: .contentProcessed({ [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.logger.error("Error enviando mensaje: \(error.localizedDescription)")
                } else {
                    self?.logger.info("Mensaje enviado exitosamente: \(message)")
                }
            }
        }))
    }
}

// MARK: - Private Methods - Utilities
private extension BonjourClient {
    
    func updateConnectionState(_ newState: ConnectionState) {
        connectionState = newState
        delegate?.client(self, didChangeState: newState)
        logger.info("Estado actualizado a: \(String(describing: newState))")
    }
    
    func setupLogger() {
        logger.info("BonjourClient inicializado")
    }
    
    func processNetworkError(_ error: Error) -> Error {
        guard let nwError = error as? NWError,
              case .posix(let posixError) = nwError else {
            return error
        }
        
        switch posixError.rawValue {
        case 61:
            return NetworkError.serverNotResponding
        case 65:
            return NetworkError.hostNotFound
        case 60:
            return NetworkError.connectionTimeout
        default:
            return error
        }
    }
    
}
