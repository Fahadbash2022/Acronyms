//
//  BluetoothDeviceViewModel.swift
//  BluetoothDeviceStatus
//
//  Copyright © 2021 Ankit. All rights reserved.
//

import Foundation

class BluetoothDeviceViewModel {
    private let deviceScanner = BluetoothDeviceScanner.shared
    private var devices: [BluetoothDevice] = [.init(uid: "dsd", name: "Macbook")]
    
    func startScan(completion: @escaping () -> Void) {
        deviceScanner.scan { [weak self] list in
            self?.devices = list
            completion()
        }
    }
    
    var numberOfDevices: Int {
        return devices.count
    }
    
    func titleFor(row: Int) -> String {
        return devices[row].name
    }
}
