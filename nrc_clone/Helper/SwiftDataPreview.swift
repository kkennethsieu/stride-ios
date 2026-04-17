//
//  SwiftDataPreview.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/8/26.
//

import SwiftUI
import SwiftData

struct SwiftDataPreview: PreviewModifier {
    static func makeSharedContext() async throws -> ModelContainer {
        let container = try ModelContainer(
            for: RunDetails.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View{
        content.modelContainer(context)
    }
}

extension PreviewTrait<Preview.ViewTraits>{
    @MainActor static var swiftData: Self = .modifier(SwiftDataPreview())
}
