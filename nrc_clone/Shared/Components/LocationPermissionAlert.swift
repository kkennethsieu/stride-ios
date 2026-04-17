//
//  LocationPermissionAlert.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/10/26.
//

import SwiftUI

extension View {
    func locationPermissionAlert(isPresented: Binding<Bool>) -> some View{
        self.alert("Location Service required to track run", isPresented: isPresented){
            Button("Open Settings"){
                if let url = URL(string: UIApplication.openSettingsURLString){
                    UIApplication.shared.open(url)
                }
            }
            Button("Cancel", role:.cancel) {}
        } message:{
            Text("Enable location access in Settings to track your runs.")
        }
    }
}
