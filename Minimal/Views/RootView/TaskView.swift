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
    
    private var onOpenEditScreen: (TaskEntity) -> ()
    
    init(task: TaskEntity, onOpenEditScreen: @escaping (TaskEntity) -> () = { _ in}) {
        self.task = task
        self.taskIsChecked = self.task.isDone
        self.onOpenEditScreen = onOpenEditScreen
    }
    
    var body: some View {
        HStack(spacing: 0) {
            if task.isToday {
                CheckButton(task.isDone) {
                    rootViewModel.toggleCheckBox(task: task)
                }
            } else {
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: 10, height: 10)
            }
            VStack(alignment: .leading, spacing: 0) {
                if taskIsChecked {
                    Text(task.text)
                        .font(Font.custom("SF Pro Text", size: 15)
                        .weight(.medium))
                        .strikethrough()
                        .foregroundStyle(Color(red: 0.45, green: 0.45, blue: 0.45))
                } else {
                    Text(task.text)
                        .font(Font.custom("SF Pro Text", size: 15)
                            .weight(.medium))
                }
                if let timestamp = task.timestamp {
                    Text(timestamp, style: .time)
                        .font(Font.custom("SF Pro Text", size: 13)
                            .weight(.medium))
                        .padding(.top, 5)
                        .if(!taskIsChecked) { textView in
                            textView.foregroundStyle(.secondary)
                        }
                        .if(taskIsChecked) { textView in
                            textView
                                .strikethrough()
                                .foregroundStyle(Color(red: 0.64, green: 0.64, blue: 0.64))
                        }
                }
            }
            .padding(.leading, 12)
            .onTapGesture {
                onOpenEditScreen(task)
            }
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
    task.isDone = false
    dataManager.saveData()
    return TaskView(task: task)
        .environmentObject(viewModel)
}
