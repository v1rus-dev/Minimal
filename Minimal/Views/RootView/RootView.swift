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
    
    @FetchRequest<TaskEntity>(sortDescriptors: [
        SortDescriptor(\.date, order: .forward),
        SortDescriptor(\.timestamp, order: .forward)
    ])
    private var tasks: FetchedResults<TaskEntity>
    
    @State
    private var isShowAddTaskView: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(tasks, id: \.id) { task in
                    TaskView(task: task)
                }
            }
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
    var viewModel: RootViewModel = RootViewModel(dataManager: dataManager)
    return RootView(viewModel: viewModel)
        .environment(\.managedObjectContext, dataManager.contex)
}
