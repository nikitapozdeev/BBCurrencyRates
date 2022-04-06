//
//  BBCurrencyRatesApp.swift
//  BBCurrencyRates
//
//  Created by Nikita Pozdeev on 3/9/22.
//

import SwiftUI

@main
struct BBCurrencyRatesApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        SwiftUI.Settings {
            AnyView(ContentView())
        }
    }
}
