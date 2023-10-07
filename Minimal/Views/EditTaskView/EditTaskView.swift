//
//  EditTaskView.swift
//  Minimal
//
//  Created by Yegor Cheprasov on 8.10.23.
//

import SwiftUI

struct EditTaskView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject
    var viewModel: EditTaskViewModel
    
    @State
    private var showConfirmationDeleteDialog = false
    @State
    private var showConfirmationSaveEmptyTextDialog = false
    
    @State
    private var taskEntity: TaskEntity
    
    init(taskEntity: TaskEntity, viewModel: EditTaskViewModel = .init()) {
        self.viewModel = viewModel
        _taskEntity = State(initialValue: taskEntity)
    }
    
    var body: some View {
        VStack {
            TextEditorView(text: $taskEntity.text, placeHolder: "Text of task")
        }
        .navigationTitle("Edit task")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog("Delete task?", isPresented: $showConfirmationDeleteDialog) {
            Button("Delete", role: .destructive) {
                viewModel.remove(task: taskEntity)
                dismiss()
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    if !taskEntity.text.isEmpty {
                        viewModel.dataManager.saveData()
                        dismiss()
                    }
                }
            }
            ToolbarItem(placement: .destructiveAction) {
                Button("Delete") {
                    self.showConfirmationDeleteDialog = true
                }
            }
            ToolbarItem(placement: .navigation) {
                Button("Back") {
                    taskEntity.cancelChanges()
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    
    @ObservedObject
    var dataManager = DataManager.preview
    let taskEntity = TaskEntity(context: dataManager.contex)
    taskEntity.text = "Editable text"
    taskEntity.date = .now.removeTimeStamp
    taskEntity.timestamp = .now
    taskEntity.id = UUID()
    dataManager.saveData()
    
    
    return NavigationView { EditTaskView(taskEntity: taskEntity, viewModel: EditTaskViewModel(dataManager: dataManager)) }
}
