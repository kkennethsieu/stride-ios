//
//  FilterOptions.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/6/26.
//

import SwiftUI

enum FilterOption: String, CaseIterable {
    case week = "W"
    case month = "M"
    case year = "Y"
    case all = "All"
}

struct FilterOptions: View {
    // MARK: Data shared with me
    @Binding var selectedFilter: FilterOption
    
    // MARK: Data owned by me
    @State private var showFilterOptions: Bool = false
    @Namespace private var filterNamespace
    
    // MARK: Body
    var body: some View {
        HStack(spacing: 0) {
            ForEach(FilterOption.allCases, id:\.self){option in
                Button{
                    withAnimation(.snappy) {
                        selectedFilter = option
                    }
                }
                label:{
                    Text(option.rawValue)
                        .font(.subheadline)
                        .foregroundStyle(option == selectedFilter ? .primary : .secondary)
                        .fontWeight(option == selectedFilter ? .semibold : .regular)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background{
                            if option == selectedFilter {
                                RoundedRectangle(cornerRadius: 22)
                                    .fill(.blue.opacity(0.7))
                                    .matchedGeometryEffect(id: "filter", in: filterNamespace)
                            }
                        }
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .overlay{
            RoundedRectangle(cornerRadius: 12)
                .stroke(.tertiary, lineWidth: 1)
        }
    }
}

#Preview {
    @Previewable @State var selectedFilter: FilterOption = .month
    FilterOptions(selectedFilter: $selectedFilter)
}
