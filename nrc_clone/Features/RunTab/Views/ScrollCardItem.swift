//
//  ScrollCardItem.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 3/31/26.
//

import SwiftUI

struct ScrollCardItem: View {
    var item: CardDetail
    
    var body: some View {
        HStack{
            RoundedRectangle(cornerRadius:10)
                .foregroundStyle(.white)
                .aspectRatio(1 ,contentMode: .fit)
                .overlay{
                    Image(systemName: item.img)
                        .font(.system(size:24))
                }
            VStack(alignment: .leading){
                if let category = item.category {
                    Text(category)
                        .font(.caption2)
                }
                Text(item.title)
                    .font(.caption)
                    .fontWeight(.semibold)
                Text("A 100% chance of miles")
                    .font(.caption2)
            }
            Spacer()
        }
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        .padding()
        .frame(width: 300, height: 100)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .background(.white)
        .overlay{
            RoundedRectangle(cornerRadius: 10)
                .stroke(.tertiary, lineWidth: 1)
        }
    }
}

#Preview {
    let item = CardDetail(
        img: "figure.run",
        title: "Morning Shake Out",
        description: "An easy morning run to wake up the legs",
        category: "Everyday",
        length: 20,
        type: "Audio Guided"
    )
    
    ScrollCardItem(item:item)
}
