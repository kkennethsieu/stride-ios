//
//  RecentActivityList.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/8/26.
//

import SwiftUI

struct RecentActivityList: View, Equatable {
    // MARK: Data shared with me
    var runs: [RunDetails]
    var onSelect: (RunDetails) -> Void
    var onShowAll: () -> Void
    
    // MARK: Body
    var body: some View {
        VStack(alignment:.leading, spacing: 12) {
            Text("Recent Activity")
                .font(.title2)
                .fontWeight(.semibold)
            ForEach(runs.prefix(4)) { run in
                RecentActivityCard(run:run){ selectRun in
                    onSelect(selectRun)
                }
            }
            
            ClearActionButton(text: "All Activity"){
                onShowAll()
            }
        }
        .padding(20)
    }
}

extension RecentActivityList{
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.runs == rhs.runs
    }
}

//#Preview {
//    RecentActivityList()
//}

