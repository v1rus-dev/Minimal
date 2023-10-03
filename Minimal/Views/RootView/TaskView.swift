//
//  TaskView.swift
//  Minimal
//
//  Created by Yegor Cheprasov on 3.10.23.
//

import SwiftUI

struct TaskView: View {
    var task: TaskEntity
    
    @EnvironmentObject
    var rootViewModel: RootViewModel
    
    private var taskIsChecked: Bool = false
    
    init(task: TaskEntity) {
        self.task = task
        self.taskIsChecked = self.task.isDone
    }
    
    var body: some View {
        HStack(spacing: 0) {
            checkBox
            VStack(alignment: .leading, spacing: 0) {
                Text(task.text)
                if let timestamp = task.timestamp {
                    Text(timestamp, style: .time)
                        .padding(.top, 5)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.leading, 12)
            Spacer()
        }
    }
    
    @ViewBuilder
    private var checkBox: some View {
        Button(action: {
            rootViewModel.toggleCheckBox(task: task)
        }, label: {
            HStack {
                Image(systemName: taskIsChecked ? "checkmark.square" : "square")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .tint(.black)
            }
        })
    }
}

#Preview {
    @State
    var dataManager = DataManager.preview
    @ObservedObject
    var viewModel = RootViewModel(dataManager: dataManager)
    let task = TaskEntity(context: dataManager.contex)
    task.id = UUID()
    task.date = .now
    task.text = "Example of task"
    task.timestamp = .now
    dataManager.saveData()
    return TaskView(task: task)
        .environmentObject(viewModel)
}
