//
//  BluetoothDevice.swift
//  BluetoothDeviceStatus
//
//  Copyright © 2021 Ankit. All rights reserved.
//

import Foundation

struct BluetoothDevice: Hashable {
    let uid: String
    let name: String
    
    init(uid: String, name: String) {
        self.uid = uid
        self.name = name
    }
    
    static func ==(lhs: BluetoothDevice, rhs: BluetoothDevice) -> Bool {
        return lhs.uid == rhs.uid
    }
}
