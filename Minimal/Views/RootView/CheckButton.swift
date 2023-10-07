//
//  CheckButton.swift
//  Minimal
//
//  Created by Yegor Cheprasov on 7.10.23.
//

import SwiftUI

struct CheckButton: View {
    
    var isChecked: Bool
    
    let onClick: () -> ()
    
    init(_ isChecked: Bool, onClick: @escaping () -> Void) {
        self.isChecked = isChecked
        self.onClick = onClick
    }
    
    var body: some View {
        if isChecked {
            VStack {
                Image(systemName: "checkmark")
                    .resizable()
                    .foregroundStyle(.white)
                    .padding(.all, 5)
            }
                .frame(width: 20, height: 20)
                .background(.black)
                .clipShape(RoundedRectangle(cornerRadius: 6.0))
                .onTapGesture {
                    onClick()
                }
        } else {
            Rectangle()
                .frame(width: 20, height: 20)
                .clipShape(RoundedRectangle(cornerRadius: 6.0))
                .foregroundColor(.white)
                .overlay {
                    RoundedRectangle(cornerRadius: 6.0)
                        .stroke(Color(red: 0.91, green: 0.91, blue: 0.91), lineWidth: 1.0)
                }
                .onTapGesture {
                    onClick()
                }
        }
    }
}

#Preview {
    VStack {
        CheckButton(false) {}
        CheckButton(true) {}
    }
}
