//
//  RootView.swift
//  Minimal
//
//  Created by Yegor Cheprasov on 2.10.23.
//

import SwiftUI

struct RootView: View {
    
    @ObservedObject
    var viewModel: RootViewModel = RootViewModel()
    
    
    var body: some View {
        VStack {
            
        }
    }
}

#Preview {
    RootView(viewModel: RootViewModel(dataManager: DataManager.preveiw))
}
