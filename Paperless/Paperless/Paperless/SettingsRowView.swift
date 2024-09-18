//
//  SettingsRowView.swift
//  Paperless
//
//  Created by Marvin Barsal on 18.09.24.
//

import SwiftUI

struct SettingsRowView: View {
    let iconName: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            HStack(alignment: .center) {
                Image(systemName: iconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .foregroundColor(.black)
                    .padding(.trailing, 10)
                
                Text(title)
                    .font(.title2)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)  // Sicherstellen, dass der Text linksbündig ist
                    .lineLimit(nil)  // Entfernt die Begrenzung der Zeilenanzahl, sodass der Text umgebrochen wird
                    .fixedSize(horizontal: false, vertical: true)  // Erlaubt flexibles Wachstum in der Höhe
                
                Spacer()  // Schiebt den Text nach links
            }
            .padding()
            .background(Color.gray.opacity(0.08))
            .cornerRadius(10)
        }
    }
}


struct SettingsRowView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            SettingsRowView(iconName: "info.circle", title: "About the App") {
                print("About the App tapped")
            }
            SettingsRowView(iconName: "gear", title: "Settings") {
                print("Settings tapped")
            }
            SettingsRowView(iconName: "bell", title: "Notifications") {
                print("Notifications tapped")
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
