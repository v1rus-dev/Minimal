//
//  AddTaskView.swift
//  Minimal
//
//  Created by Yegor Cheprasov on 3.10.23.
//

import SwiftUI
import SwiftUINavigation

struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss

    @ObservedObject
    var viewModel: AddTaskViewModel = .init()
    @State
    private var text: String = ""
    @State
    private var date: Date = .now

    @State
    private var placeholderText = "Text of task"

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Add Task")
                .font(.largeTitle)
                .bold()
                .padding(.top, 10)
                .padding(.leading, 0)

            Text("Text")
                .font(.title)
                .bold()
                .padding(.top, 20)
                .padding(.leading, 1)

            NavigationView {
                VStack(spacing: 0) {
                    TextEditorView(text: $text, placeHolder: "Text of task")
                    Spacer()
                }
            }

            Spacer()

            datePart
                .padding(.top, 20)

            Button("Save") {
                if !text.isEmpty {
                    Task {
                        await viewModel.addNewTask(text: text, date: date)
                        dismiss()
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.black)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.top, 20)
        }
        .frame(alignment: .topLeading)
        .padding(.horizontal, 16)
        .navigationTitle("Task")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private var datePart: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Date")
                .font(.title)
                .bold()

            DatePicker("Date of task", selection: $date, displayedComponents: .date)
                .datePickerStyle(.automatic)
                .padding(.top, 10)
        }
    }
}

#Preview {
    NavigationView {
        AddTaskView(viewModel: AddTaskViewModel(dataManager: .preview))
    }
}
