//
//  ConnectMusicButton.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 3/31/26.
//

import SwiftUI

struct ConnectMusicButton: View {
    var body: some View {
        Button{}label:{
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.black)
                .aspectRatio(5,contentMode: .fit)
                .overlay{
                    Text("Connect Music")
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                }
            
        }
    }
}

#Preview {
    ConnectMusicButton()
}
