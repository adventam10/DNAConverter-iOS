//
//  DocumentPickerView.swift
//  DNAConverter
//
//  Created by am10 on 2023/06/17.
//  Copyright © 2023 am10. All rights reserved.
//

import SwiftUI
import UIKit

struct DocumentPickerView: UIViewControllerRepresentable {

    final class Coordinator: NSObject, UIDocumentPickerDelegate {
        @Binding var urls: [URL]

        init(urls: Binding<[URL]>) {
            _urls = urls
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            self.urls = urls
        }
    }

    @Binding var urls: [URL]

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.folder])
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ controller: UIDocumentPickerViewController, context: Context) {
    }

    func makeCoordinator() -> DocumentPickerView.Coordinator {
        let coordinator = Coordinator(urls: $urls)
        return coordinator
    }
}
