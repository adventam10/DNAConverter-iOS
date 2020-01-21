//
//  SpeechModel.swift
//  DNAConverter
//
//  Created by am10 on 2020/01/11.
//  Copyright © 2020 am10. All rights reserved.
//

import Foundation
import Speech

class SpeechModel {
    var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private (set) var isRecording = false

    init() {
        speechRecognizer = SFSpeechRecognizer(locale: Self.getSpeechRecognizerLocale())
    }

    private static func getSpeechRecognizerLocale() -> Locale {
        let supportedLocales = SFSpeechRecognizer.supportedLocales()
        let currentLocale = Locale.current
        if supportedLocales.contains(currentLocale) {
            return currentLocale
        }
        let currentLocaleIdentifierPrefix = currentLocale.identifier.components(separatedBy: "_").first!
        let locale = supportedLocales.first { $0.identifier.hasPrefix(currentLocaleIdentifierPrefix) }
        return locale ?? Locale(identifier: "en-US")
    }

    func start(resultHandler: @escaping (String?, Bool) -> Void) throws {
        isRecording = true
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: [])
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest?.shouldReportPartialResults = true
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest!) { [weak self] (result, error) in
            guard let weakSelf = self else { return }

            var isFinal = false
            var text: String?
            if let result = result {
                text = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }

            if error != nil || isFinal {
                weakSelf.stop()
            }
            resultHandler(text, isFinal)
        }

        let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        try? audioEngine.start()
    }

    func stop() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.inputNode.reset()
        recognitionTask?.cancel()
        recognitionRequest = nil
        recognitionTask = nil
        isRecording = false
    }
}
