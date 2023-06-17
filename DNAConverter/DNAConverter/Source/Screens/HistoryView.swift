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

    var body: some View {
        NavigationView {
            ZStack {
                if repository.histories.isEmpty {
                    Text("no_history_message")
                } else {
                    // FIXME: 選択処理
                    List(repository.histories, id: \.self) { history in
                        Text(history)
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

    static var previews: some View {
        HistoryView(isPresented: $isPresented)
    }
}
