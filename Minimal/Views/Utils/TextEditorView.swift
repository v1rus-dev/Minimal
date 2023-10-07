//
//  TextEditor.swift
//  Minimal
//
//  Created by Yegor Cheprasov on 8.10.23.
//

import SwiftUI

struct TextEditorView: View {
    
    @Binding
    var text: String
    
    @State
    private var placeHolder: String = ""
    
    @FocusState
    private var isFocused: Bool
    
    init(text: Binding<String>, placeHolder: String) {
        _text = text
        _placeHolder = .init(initialValue: placeHolder)
    }
    
    var body: some View {
            ZStack {
                if self.text.isEmpty {
                    TextEditor(text: $placeHolder)
                        .font(.body)
                        .foregroundColor(.gray)
                        .disabled(true)
                }
                TextEditor(text: $text)
                    .font(.body)
                    .textInputAutocapitalization(.sentences)
                    .autocorrectionDisabled(false)
                    .opacity(self.text.isEmpty ? 0.25 : 1)
                    .focused($isFocused)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                isFocused = false
                            }
                        }
                    }
            }
    }
}

#Preview {
    
    @State
    var text = ""
    
    return TextEditorView(text: $text, placeHolder: "Placeholder")
}
