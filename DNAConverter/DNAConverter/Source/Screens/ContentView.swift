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

    var body: some View {
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
                    ).focused($focusedField, equals: .originalText)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
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
                    TextField(
                        "",
                        text: $convertedText,
                        axis: .vertical
                    )
                    .disabled(true)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(8)
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
                    }
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
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        closeKeyboard()
                        copyText()
                    }) {
                        Image(systemName: "doc.on.clipboard")
                    }
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
        }
        .onChange(of: documentPickerURLs) { newValue in
            let url = newValue.first!
            exportText(directoryPath: url.path)
        }
    }
}

extension ContentView {

    private func copyText() {
        // FIXME: トースト表示
        UIPasteboard.general.string = convertedText
    }

    private func tweet() {
        // FIXME: トースト表示
        if twitterManager.tweet(text: convertedText) {

        } else {

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

        // FIXME: トースト表示
        if isSuccess {

        } else {

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
