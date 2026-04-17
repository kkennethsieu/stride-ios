//
//  CardPagination.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 3/31/26.
//

import SwiftUI

struct CardPagination: View {
    let count: Int
    var body: some View {
        HStack{
            ForEach(0..<count, id: \.self) { _ in
                RoundedRectangle(cornerRadius:99)
                    .foregroundStyle(.green)
                    .frame(maxWidth: 20, maxHeight: 3)
            }
        }
    }
}

#Preview {
    var count: Int = 5
    CardPagination(count:count)
}

