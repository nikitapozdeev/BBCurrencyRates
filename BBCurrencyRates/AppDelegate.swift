//
//  AppDelegate.swift
//  BBCurrencyRates
//
//  Created by Nikita Pozdeev on 3/9/22.
//

import Foundation
import AppKit

struct Banks: Codable {
    let banks: [Bank]
}

struct Bank: Codable, Hashable {
    let usd: Rate
}

struct Rate: Codable, Hashable {
    let buy: Double
    let sale: Double
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var rate: Float?
    var banks: [Bank] = []
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = self.statusItem?.button {
            let str = NSString(format: "%.2f", self.rate ?? 0)
            
            button.title = "$" + (str as String)
        }
        
        let timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { timer in
            self.synchronize()
        }
        timer.fire()
    }
    
    func synchronize() {
        Task {
            do {
                self.banks = try await fetchRatesWithAsyncURLSession()
                render()
            } catch {
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func render() {
        guard let bank = (self.banks.count > 0 ? self.banks[0] : nil) else {
            return
        }
        
        if let button = self.statusItem?.button {
            let str = NSString(format: "%.2f", bank.usd.buy)
            
            button.title = "$" + (str as String)
        }
    }
    
    func fetchRatesWithAsyncURLSession() async throws -> [Bank] {
        guard let url = URL(string: "https://www.bystrobank.ru/sitecurrency/data/CurrentExchangeRates_izhevsk.js") else {
            return []
        }

        // Use the async variant of URLSession to fetch data
        // Code might suspend here
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Parse the JSON data
        let jsonResult = try JSONDecoder().decode(Banks.self, from: data)
        return jsonResult.banks
    }
}
