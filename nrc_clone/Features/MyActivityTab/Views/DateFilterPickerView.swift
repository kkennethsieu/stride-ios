//
//  DateFilterPickerView.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/7/26.
//

import SwiftUI

struct DateFilterPickerView: View {
    // MARK: Data shared with me
    let selectedFilter: FilterOption
    @Binding var selectedDate: Date
    
    // this is for the local month
    @State private var selectedYear: Int
    @State private var selectedMonth: Int

    let weeks: [Date] = (0...3).map { offset in
        let date = Calendar.current.date(byAdding: .weekOfYear, value: -offset, to: .now)!
        return Calendar.current.dateInterval(of: .weekOfYear, for: date)!.start
    }
    
    let years: [Int] = Array(2022...2026)
    let months: [String] = Calendar.current.monthSymbols
    
    init(selectedFilter: FilterOption, selectedDate: Binding<Date>) {
        self.selectedFilter = selectedFilter
        self._selectedDate = selectedDate
        self._selectedYear = State(initialValue: Calendar.current.component(.year, from: selectedDate.wrappedValue))
        self._selectedMonth = State(initialValue: Calendar.current.component(.month, from: selectedDate.wrappedValue))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            switch selectedFilter {
            case .week:  filterByWeek()
            case .month: filterByMonth()
            case .year:  filterByYear()
            case .all:   Text("Showing all runs").foregroundStyle(.secondary).padding()
            }
        }
    }
    
    func filterByWeek() -> some View {
        Picker("Week", selection: $selectedDate) {
            ForEach(weeks, id: \.self) { week in
                let end = Calendar.current.date(byAdding: .day, value: 6, to: week)!
                Text("\(week.formatted(.dateTime.month(.abbreviated).day())) - \(end.formatted(.dateTime.month(.abbreviated).day()))").tag(week)
            }
        }
        .pickerStyle(.wheel)
    }
    
    func filterByMonth () -> some View {
        HStack{
            Picker("Month", selection: $selectedMonth) {
                ForEach(1...12, id: \.self) { m in
                    Text(months[m - 1]).tag(m)
                }
            }
            .pickerStyle(.wheel)
            
            Picker("Year", selection: $selectedYear) {
                ForEach(years, id: \.self) { y in
                    Text(String(y)).tag(y)
                }
            }
            .pickerStyle(.wheel)
        }
        .onChange(of: selectedYear){
            updateDate()
        }
        .onChange(of: selectedMonth){
            updateDate()
        }
    }
    func filterByYear() -> some View {
        HStack{
            Picker("Year", selection: $selectedDate) {
                ForEach(years, id: \.self) { y in
                    Text(String(y)).tag(y)
                }
            }
            .pickerStyle(.wheel)
        }
    }
    
    func updateDate() {
        var components = DateComponents()
        components.year = selectedYear
        components.month = selectedMonth
        components.day = 1
        if let date = Calendar.current.date(from: components) {
            selectedDate = date
        }
    }
}

#Preview {
    @Previewable @State var date: Date = .now
    DateFilterPickerView(selectedFilter: .week, selectedDate: $date)
}
