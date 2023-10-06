//
//  RootView.swift
//  Minimal
//
//  Created by Yegor Cheprasov on 2.10.23.
//

import SwiftUI
import SwiftUINavigation

struct RootView: View {
    @ObservedObject
    var viewModel: RootViewModel = .init()

    @SectionedFetchRequest(sectionIdentifier: \.date, sortDescriptors: [
        SortDescriptor(\TaskEntity.date, order: .forward),
        SortDescriptor(\TaskEntity.isDone, order: .forward),
        SortDescriptor(\TaskEntity.timestamp, order: .forward)
    ], animation: .default)
    private var sectionsDates: SectionedFetchResults<Date?, TaskEntity>

    @State
    private var isShowAddTaskView: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(sectionsDates, id: \.id) { section in
                    if section.id != nil {
                        Text(section.id!.toText())
                            .font(.largeTitle)
                            .bold()
                        ForEach(section) { task in
                            TaskView(task: task)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .environmentObject(viewModel)
        .sheet(isPresented: $isShowAddTaskView, content: {
            NavigationView {
                AddTaskView()
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                isShowAddTaskView.toggle()
                            }
                        }
                    }
            }
        })
        .floatingActionButton(color: .black, image: Image(systemName: "plus").foregroundColor(.white)
            .scaleEffect(1.5))
        {
            isShowAddTaskView.toggle()
        }
    }
}

#Preview {
    let dataManager = DataManager.preview
    @ObservedObject
    var viewModel: RootViewModel = .init(dataManager: dataManager)
    return RootView(viewModel: viewModel)
        .environment(\.managedObjectContext, dataManager.contex)
}

extension Date {
    func toText() -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(self) {
            return "Today"
        } else if calendar.isDateInTomorrow(self){
            return "Tomorrow"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            return dateFormatter.string(from: self)
        }
    }
}

extension Date {
   static var tomorrow: Date { return Date().dayAfter }
   static var today: Date {return Date()}
   var dayAfter: Date {
      return Calendar.current.date(byAdding: .day, value: 1, to: Date())!
   }
}
