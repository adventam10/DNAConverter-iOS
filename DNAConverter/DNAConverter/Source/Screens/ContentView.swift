//
//  ContentView.swift
//  DNAConverter
//
//  Created by am10 on 2023/06/16.
//  Copyright © 2023 am10. All rights reserved.
//

import SwiftUI

enum RecordState {
    case enable(isRecording: Bool)
    case disable

    var isDisabled: Bool {
        switch self {
        case .enable:
            return false
        case .disable:
            return true
        }
    }
}

struct ContentView: View {

    private let dnaConverter = DNAConverter()
    private let speechManager = SpeechManager()
    private let fileExporter = FileExporter()
    private let twitterManager = TwitterManager()
    private let historyRepository = HistoryRepository()

    enum Field: Hashable {
        case originalText
    }
    @FocusState private var focusedField: Field?

    @State private var originalText: String = ""
    @State private var convertedText: String = ""
    @State private var selectedHistory: String = ""
    @State private var value = 0
    @State private var isHistoryShown = false
    @State private var isDocumentPickerShown = false
    @State private var documentPickerURLs = [URL]()
    @State private var recordState = RecordState.disable
    @State private var toastMessage = ""
    @State private var isToastShown = false
    @State private var toastOpacity: CGFloat = 0.0

    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    Picker("conversion_mode", selection: $value) {
                        Text("segmented_title_lang").tag(0)
                        Text("segmented_title_dna").tag(1)
                    }.pickerStyle(.segmented)

                    ZStack {
                        Color.clear
                        TextField(
                            "original_place_holder",
                            text: $originalText,
                            axis: .vertical
                        )
                        .font(.body)
                        .focused($focusedField, equals: .originalText)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("convert") {
                                    closeKeyboard()
                                    convertText()
                                }
                            }
                        }
                    }.padding(16)
                    #if targetEnvironment(macCatalyst)
                    #else
                    HStack {
                        Spacer()
                        Button(action: {
                            closeKeyboard()
                            if speechManager.isRecording {
                                stopRecording()
                            } else {
                                record()
                            }
                        }) {
                            switch recordState {
                            case .enable(let isRecording):
                                if isRecording {
                                    Image(systemName: "mic")
                                        .renderingMode(.template)
                                        .foregroundColor(.white)
                                        .background(.blue)
                                } else {
                                    Image(systemName: "mic")
                                }
                            case .disable:
                                Image(systemName: "mic")
                                    .renderingMode(.template)
                                    .foregroundColor(.gray)
                            }
                        }.disabled(recordState.isDisabled)
                    }.padding(.horizontal, 16)
                    #endif

                    ZStack {
                        Color.gray.cornerRadius(5)
                        ScrollView(.vertical, showsIndicators: true) {
                            HStack {
                                Text(convertedText)
                                      .multilineTextAlignment(.leading)
                                      .font(.body)
                                Spacer(minLength: 0)
                            }
                        }.padding(8)
                    }.padding(16)
                }
                .navigationTitle("dna_converter_title")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading){
                        Button("clear_button_title") {
                            closeKeyboard()
                            clear()
                        }
                    }

                    ToolbarItem(placement: .navigationBarTrailing){
                        Button(action: {
                            closeKeyboard()
                            showHistory()
                        }) {
                            Image("icon_history")
                                .renderingMode(.template)
                                .foregroundColor(.blue)
                        }.accessibilityLabel("history_title")
                    }

                    ToolbarItem(placement: .navigationBarTrailing){
                        Button(action: {
                            closeKeyboard()
                        }) {
                            ShareLink(item: convertedText)
                        }
                    }

                    ToolbarItem(placement: .bottomBar) {
                        Button("convert") {
                            closeKeyboard()
                            convertText()
                        }
                    }
                    ToolbarItem(placement: .bottomBar) {
                        Spacer()
                    }
                    ToolbarItem(placement: .bottomBar) {
                        Button(action: {
                            closeKeyboard()
                            #if targetEnvironment(macCatalyst)
                            isDocumentPickerShown.toggle()
                            #else
                            exportText()
                            #endif
                        }) {
                            Image(systemName: "arrow.down.doc")
                        }.accessibilityLabel("download")
                    }
                    ToolbarItem(placement: .bottomBar) {
                        Button(action: {
                            closeKeyboard()
                            copyText()
                        }) {
                            Image(systemName: "doc.on.clipboard")
                        }.accessibilityLabel("copy")
                    }
                    ToolbarItem(placement: .bottomBar) {
                        Button(action: {
                            closeKeyboard()
                            tweet()
                        }) {
                            Image("twitter")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())

            if isToastShown {
                ToastView(message: $toastMessage)
                    .frame(width: 280, height: 280)
                    .cornerRadius(10)
                    .opacity(toastOpacity)
            }
        }
        .sheet(isPresented: $isHistoryShown) {
            HistoryView(isPresented: $isHistoryShown, selected: $selectedHistory)
        }
        .sheet(isPresented: $isDocumentPickerShown) {
            DocumentPickerView(urls: $documentPickerURLs)
        }
        .onAppear {
            #if targetEnvironment(macCatalyst)
            #else
            speechManager.requestAuthorization { available in
                if available {
                    recordState = .enable(isRecording: false)
                } else {
                    recordState = .disable
                }
            }
            #endif
        }
        .onChange(of: selectedHistory) { newValue in
            clear()
            originalText = newValue
            value = 1
            convertText()
            historyRepository.add(history: newValue)
        }
        .onChange(of: documentPickerURLs) { newValue in
            let url = newValue.first!
            exportText(directoryPath: url.path)
        }
    }
}

extension ContentView {

    private func showToast(message: String) {
        toastMessage = message
        isToastShown = true
        let duration: TimeInterval = 0.5
        withAnimation(.linear(duration: duration)) {
            toastOpacity = 1.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration + 1.0) {
            hideToast()
        }
    }

    private func hideToast() {
        let duration: TimeInterval = 1.0
        withAnimation(.linear(duration: duration)) {
            toastOpacity = 0.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            isToastShown = false
        }
    }

    private func copyText() {
        UIPasteboard.general.string = convertedText
        showToast(message: NSLocalizedString("copy_message", comment: ""))
    }

    private func tweet() {
        if !twitterManager.tweet(text: convertedText) {
            showToast(message: NSLocalizedString("error_message", comment: ""))
        }
    }

    private func convertText() {
        let result: Result<String, DNAConvertError>
        switch value {
        case 0:
            result = dnaConverter.convertToDNA(originalText)
        case 1:
            result = dnaConverter.convertToLanguage(originalText)
        default:
            return
        }

        switch result {
        case .success(let text):
            convertedText = text
            if value == 0 {
                historyRepository.add(history: text)
            }
        case .failure(let error):
            convertedText = error.text
        }
    }

    private func closeKeyboard() {
        focusedField = nil
    }

    private func clear() {
        originalText = ""
        convertedText = ""
    }

    private func exportText(directoryPath: String? = nil) {
        let isSuccess: Bool
        if let path = directoryPath {
            isSuccess = fileExporter.export(convertedText, directoryPath: path)
        } else {
            isSuccess = fileExporter.export(convertedText)
        }

        if isSuccess {
            showToast(message: NSLocalizedString("download_message", comment: ""))
        } else {
            showToast(message: NSLocalizedString("error_message", comment: ""))
        }
    }

    private func showHistory() {
        isHistoryShown.toggle()
    }

    private func record() {
        do {
            try speechManager.start { (text, finished) in
                if let text = text {
                    originalText = text
                    convertedText = ""
                }
                if finished {
                    recordState = .enable(isRecording: false)
                } else {
                    if speechManager.isRecording == false {
                        recordState = .enable(isRecording: false)
                    }
                }
            }
            recordState = .enable(isRecording: true)
        } catch {
            recordState = .enable(isRecording: false)
        }
    }

    private func stopRecording() {
        speechManager.stop()
        recordState = .enable(isRecording: false)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
