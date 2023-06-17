//
//  HistoryView.swift
//  DNAConverter
//
//  Created by am10 on 2023/06/17.
//  Copyright © 2023 am10. All rights reserved.
//

import SwiftUI

struct HistoryView: View {

    // FIXME: Mac版レイアウト

    private let repository = HistoryRepository()
    @Binding var isPresented: Bool
    @Binding var selected: String
    var body: some View {
        NavigationView {
            ZStack {
                if repository.histories.isEmpty {
                    Text("no_history_message")
                } else {
                    List(repository.histories, id: \.self) { history in
                        Button {
                            isPresented.toggle()
                            selected = history
                        } label: {
                            Text(history)
                        }
                    }
                }
            }
            .navigationTitle("history_title")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("close") {
                        isPresented.toggle()
                    }
                }
            }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {

    @State static var isPresented = true
    @State static var selected = ""

    static var previews: some View {
        HistoryView(isPresented: $isPresented, selected: $selected)
    }
}
