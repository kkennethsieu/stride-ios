//
//  OrLoginWithLine.swift
//  quiz
//
//  Created by Kenneth Sieu on 3/20/26.
//

import SwiftUI

struct OrLoginWithLine: View {
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 99)
                .frame(height: 1)
                .foregroundStyle(.tertiary)
            
            Text("Or login with")
                .font(.footnote)
                .foregroundStyle(.tertiary)
            
            RoundedRectangle(cornerRadius: 99)
                .frame(height: 1)
                .foregroundStyle(.tertiary)
        }
    }
}

//#Preview {
//    OrLoginWithLine()
//}

