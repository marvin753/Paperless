//
//  SettingsView.swift
//  Paperless
//
//  Created by Marvin Barsal on 18.09.24.
//

import SwiftUI

struct SettingsView: View {
    @Binding var showSettings: Bool
    @State private var showAboutApp = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                // Header-Bereich mit Titel und Schließen-Button, ähnlich wie in ScannedDocumentsView
                HStack {
                    Text("Settings")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: {
                        showSettings = false  // Schließt das Fullscreen-Cover
                    }) {
                        Image(systemName: "xmark.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 29, height: 29)  // Gleiche Größe wie der Settings-Button
                    }
                    .contentShape(Rectangle())  // Erweitert den Touch-Bereich auf die gesamte Fläche des Buttons
                }
                .padding(.horizontal)
                .padding(.top, 18)  // Verschiebt den Header-Bereich weiter nach oben
                
                // Verwendung der wiederverwendbaren SettingsRowView für die "About the App"-Option
                SettingsRowView(iconName: "heart.fill", title: "About the App") {
                    showAboutApp = true
                }
                .padding([.top, .leading, .trailing], 12)
                .sheet(isPresented: $showAboutApp) {
                    AboutTheAppView()
                        .presentationDetents([.medium])
                }
                Spacer()
                
                Text("Paperless 1.0")
                    //.foregroundColor(.gray)
                    .font(.footnote)
                    .padding(.bottom, 12)
            }
        }
    }
}


#Preview {
    @Previewable @State var showSettings = true
    return SettingsView(showSettings: $showSettings)
}

