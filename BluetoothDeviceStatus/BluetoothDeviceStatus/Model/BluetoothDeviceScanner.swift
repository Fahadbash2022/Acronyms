//
//  BluetoothDeviceScanner.swift
//  BluetoothDeviceStatus
//
//  Copyright © 2021 Ankit. All rights reserved.
//

import Foundation
import CoreBluetooth

class BluetoothDeviceScanner: NSObject {
    
    static let shared = BluetoothDeviceScanner()
    
    lazy var centralManager: CBCentralManager = {
        let instance = CBCentralManager(
            delegate: self,
            queue: DispatchQueue(label: "com.ankit.BluetoothDeviceScanner"))
        return instance
    }()
    
    // TODO: Hold a private set, and expose a list?
    var scannedDevices = Set<BluetoothDevice>()
    
    var isScanning: Bool {
        return centralManager.isScanning
    }
    
    // TODO: Should be a list? Can connect to > 1 device
    private var connectedDevices = [String: BluetoothDevice]()
    private var scanChangesHandler: ((BluetoothDevice) -> Void)?
    private var scanCompleteHandler: (([BluetoothDevice]) -> Void)?
    
    override init() { }
}

extension BluetoothDeviceScanner {
    func retrievePeripherals(withIdentifiers uuids: [UUID]) -> [BluetoothDevice] {
        let cbPeripherals = centralManager.retrievePeripherals(withIdentifiers: uuids)
        return cbPeripherals.map { BluetoothDevice(uid: $0.identifier.uuidString, name: $0.name ?? "Unknown") }
    }
}

extension BluetoothDeviceScanner {
    
    func scan() {
        scannedDevices.removeAll()
        centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }
    
    func scan(changes: ((BluetoothDevice) -> Void)?) {
        scanChangesHandler = changes
        scan()
    }
    
    func scan(for timeout: TimeInterval = 10, changes: ((BluetoothDevice) -> Void)? = nil, complete: @escaping ([BluetoothDevice]) -> Void) {
        scanChangesHandler = changes
        scanCompleteHandler = complete
        DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
            self.stopScan()
        }
        scan()
    }
    
    func stopScan() {
        centralManager.stopScan()
        scanCompleteHandler?(Array(scannedDevices))
        
        scanChangesHandler = nil
        scanCompleteHandler = nil
    }
}

extension BluetoothDeviceScanner: CBCentralManagerDelegate {
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch (central.state) {
        case .unknown:
            print("Bluetooth state is unknown.")
        case .resetting:
            print("Bluetooth state is resetting.")
        case .unsupported:
            print("Bluetooth state is unsupported.")
        case .unauthorized:
            print("Bluetooth state is unauthorized.")
        case .poweredOff:
            print("Bluetooth state is powered off.")
        case .poweredOn:
            print("Bluetooth state is powered on")
            centralManager.retrievePeripherals(withIdentifiers: [])
        default:
            print("Bluetooth state is not in supported switches")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard let name = peripheral.name else { return }
        let device = BluetoothDevice(uid: peripheral.identifier.uuidString, name: name)
        scannedDevices.insert(device)
        scanChangesHandler?(device)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("centralManager: didConnect to \(peripheral.identifier) with maximum write value of \(peripheral.maximumWriteValueLength(for: .withoutResponse)) and \(peripheral.maximumWriteValueLength(for: .withResponse))")
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("centralManager: didFailToConnect to \(peripheral.identifier)")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("centralManager: didDisconnect from \(peripheral.identifier)")
    }
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        
    }
}
