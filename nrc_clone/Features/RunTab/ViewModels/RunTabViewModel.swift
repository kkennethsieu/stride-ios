//
//  RunTabViewModel.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 3/31/26.
//

import Foundation

@Observable
class RunTabViewModel{
    var cards: [CardDetail] = [
        CardDetail(
            img: "figure.run",
            title: "Morning Shake Out",
            description: "An easy morning run to wake up the legs",
            category: "Everyday",
            length: 20,
            type: "Audio Guided"
        ),
            CardDetail(img: "bolt.fill", title: "Speed Intervals", description: "Push your limits with high intensity intervals", category: "Speed", length: 35, type: "Audio Guided"),
            CardDetail(img: "mountain.2.fill", title: "Hill Crusher", description: "Build strength tackling elevation changes", category: "Long", length: 50, type: "Audio Guided"),
            CardDetail(img: "heart.fill", title: "Recovery Jog", description: "Keep it easy and let your body recover", category: "Everyday", length: 25, type: "Audio Guided"),
            CardDetail(img: "flame.fill", title: "Tempo Burn", description: "Sustained effort at your threshold pace", category: "Speed", length: 40, type: "Audio Guided"),
        
    ]
}
