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
    private var timeOfNotification: Date = .now

    @State private var placeholderText = "Text of task"
    @State private var notificationIsEnabled = false
    @FocusState var isInputActive: Bool

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
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
                    
                    TextField("Text of task", text: $text)
                        .focused($isInputActive)
                        .onSubmit {
                            isInputActive = false
                        }
                        .submitLabel(.done)
                        .padding(.top, 10)
                    
                    Spacer()
                    
                    datePart
                        .padding(.top, 20)

                    notificationPart
                        .padding(.top, 20)
                }

                Button("Save") {
                    if !text.isEmpty {
                        Task {
                            await viewModel.addNewTask(text: text, date: date, isNotifieble: notificationIsEnabled, timeOfNotification: timeOfNotification)
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
            .ignoresSafeArea(.keyboard)
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

            DatePicker("Date of task", selection: $date, in: Date.now..., displayedComponents: .date)
                .datePickerStyle(.automatic)
                .padding(.top, 10)
                .onChange(of: date) {
                    timeOfNotification = date
                }
        }
    }

    @ViewBuilder
    private var notificationPart: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            Text("Notification")
                .font(.title)
                .bold()

            Toggle("Notification", isOn: $notificationIsEnabled.animation())

            if notificationIsEnabled {
                DatePicker("Time of notification", selection: $timeOfNotification, in: (Date.now + 2 * 60)..., displayedComponents: .hourAndMinute)
                    .datePickerStyle(.automatic)
            }
        })
    }
}

#Preview {
    NavigationView {
        AddTaskView(viewModel: AddTaskViewModel(dataManager: .preview))
    }
}
