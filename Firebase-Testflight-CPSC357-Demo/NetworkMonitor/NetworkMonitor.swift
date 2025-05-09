//
//  NetworkMonitor.swift
//  Firebase-Testflight-CPSC357-Demo
//
//  Created by Luc Rieffel on 5/9/25.
//

import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)

    private(set) var isConnected: Bool = false

    func observeNetwork(completion: @escaping((Bool) -> ())) {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            print("Internet connection status: \(self?.isConnected == true ? "Connected" : "Not Connected")")
            completion(self?.isConnected == true)
        }
        monitor.start(queue: queue)
    }
}

