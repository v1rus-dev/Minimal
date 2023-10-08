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

    @SectionedFetchRequest(
        sectionIdentifier: \.date,
        sortDescriptors: [
            SortDescriptor(\TaskEntity.date, order: .forward),
            SortDescriptor(\TaskEntity.isDone, order: .forward),
            SortDescriptor(\TaskEntity.timestamp, order: .forward)
        ],
        animation: .easeOut
    )
    private var sectionsDates: SectionedFetchResults<Date?, TaskEntity>

    @State
    private var isShowAddTaskView: Bool = false
    
    @State
    private var isShowEditTaskView: TaskEntity? = nil

    @State
    private var isHideCompleted: Bool = false
    
    init(viewModel: RootViewModel = .init()) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(sectionsDates, id: \.id) { section in
                    if section.id != nil {
                        Text(section.id!.toText())
                            .font(.largeTitle)
                            .bold()
                        ForEach(section) { task in
                            TaskView(task: task) {
                                isShowEditTaskView = $0
                            }
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
        .fullScreenCover(unwrapping: $isShowEditTaskView, content: { task in
            NavigationView {
                EditTaskView(taskEntity: task.wrappedValue)
            }
        })
        .floatingActionButton(color: .black, image: Image(systemName: "plus").foregroundColor(.white)
            .scaleEffect(1.5))
        {
            isShowAddTaskView.toggle()
        }
        .toolbar {
            if (!sectionsDates.isEmpty) {
                ToolbarItem(placement: .primaryAction) {
                    Button(getHideCompletionTaskButtonText()) {
                        withAnimation {
                            isHideCompleted.toggle()
                        }
                    }
                }
            }
        }
        .onChange(of: isHideCompleted) {
            if isHideCompleted {
                sectionsDates.nsPredicate = NSPredicate(format: "isDone == %@", false as NSNumber)
            } else {
                sectionsDates.nsPredicate = nil
            }
        }
    }
    
    private func getHideCompletionTaskButtonText() -> String {
        if isHideCompleted {
            return "Show completed"
        } else {
            return "Hide completed"
        }
    }
}

#Preview {
    let dataManager = DataManager.preview
    @ObservedObject
    var viewModel: RootViewModel = .init(dataManager: dataManager)
    return NavigationView { RootView(viewModel: viewModel)
        .environment(\.managedObjectContext, dataManager.contex)
    }
}

extension Date {
    func toText() -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(self) {
            return "Today"
        } else if calendar.isDateInTomorrow(self) {
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
    static var today: Date { return Date() }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    }
}

extension Bool {
    var string: String {
         self ? "TRUE" : "FALSE"
    }
}
