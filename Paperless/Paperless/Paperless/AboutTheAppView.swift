//
//  AboutTheAppView.swift
//  Paperless
//
//  Created by Marvin Barsal on 18.09.24.
//

import SwiftUI

struct AboutTheAppView: View {
    var body: some View {
        
        Text("💡 About the App")
            .font(.headline)
            .padding(.bottom, 20)  // Abstand nach unten zum nächsten Text
            .padding(.top, 30)
        
        VStack(alignment: .leading, spacing: 50) {  // Legt die Texte linksbündig und den Abstand fest
            Text("📄 Turn your physical documents into a searchable, digital format with just a few taps.")
                .frame(maxWidth: .infinity, alignment: .leading)  // Links ausgerichtet
            
            Text(" 🗂️Reduce clutter and enhance efficiency by transforming your paper archives into a comprehensive digital library.")
                .frame(maxWidth: .infinity, alignment: .leading)  // Links ausgerichtet
            
            Spacer()  // Schiebt den Inhalt nach oben und fügt einen flexiblen Abstand hinzu
        }
        .padding()  // Außenabstände für das gesamte VStack
        Text("Made with ❤️ in Berlin")
    }
}

#Preview {
    AboutTheAppView()
}
