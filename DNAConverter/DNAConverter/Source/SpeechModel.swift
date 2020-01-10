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
    var speechRecognizer = SFSpeechRecognizer(locale: Locale.current)
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    var isRunning: Bool {
        return audioEngine.isRunning
    }
    init() {
        if speechRecognizer == nil {
            speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
        }
    }

    func start(resultHandler: @escaping (String?, Bool) -> Void) throws {
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }

        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: [])
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        self.recognitionRequest = recognitionRequest
        recognitionRequest.shouldReportPartialResults = true
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] (result, error) in
            guard let weakSelf = self else { return }

            var isFinal = false
            var text: String?
            if let result = result {
                text = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }

            if error != nil || isFinal {
                weakSelf.audioEngine.stop()
                weakSelf.audioEngine.inputNode.removeTap(onBus: 0)
                weakSelf.recognitionRequest = nil
                weakSelf.recognitionTask = nil
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
        recognitionTask = nil
    }
}
