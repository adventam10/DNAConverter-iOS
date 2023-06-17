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

    // FIXME: SFSpeechRecognizerの許可設定
    // FIXME: Mac版レイアウト

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
    @State private var value = 0
    @State private var isPresented = false
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
                        exportText()
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
        .sheet(isPresented: $isPresented) {
            HistoryView(isPresented: $isPresented)
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

    private func exportText() {
        // FIXME: トースト表示
        if fileExporter.export(convertedText) {

        } else {

        }
    }

    private func showHistory() {
        isPresented.toggle()
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
