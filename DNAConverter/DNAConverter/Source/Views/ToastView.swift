//
//  ToastView.swift
//  DNAConverter
//
//  Created by am10 on 2023/06/17.
//  Copyright © 2023 am10. All rights reserved.
//

import SwiftUI

struct ToastView: View {

    @Binding var message: String
    var body: some View {
        ZStack{
            Color("toast_background")
            VStack {
                Image(systemName: "checkmark")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(Color("toast_message"))
                    .frame(width: 100, height: 100)
                Text(message)
                    .padding(.vertical, 8)
                    .foregroundColor(Color("toast_message"))
            }
        }
    }
}

struct ToastView_Previews: PreviewProvider {
    @State static var message = ""

    static var previews: some View {
        ToastView(message: $message)
    }
}
