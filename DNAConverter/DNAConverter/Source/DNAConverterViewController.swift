//
//  DNAConverterViewController.swift
//  DNAConverter
//
//  Created by am10 on 2020/01/03.
//  Copyright © 2020 am10. All rights reserved.
//

import UIKit
import Speech

final class DNAConverterViewController: UIViewController {

    @IBOutlet private weak var recordButton: RecordButton!
    
    @IBOutlet weak var originalTextToolView: UIView!
    @IBOutlet private weak var modeSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var convertedTextView: UITextView! {
        didSet {
            convertedTextView.layer.cornerRadius = 5
            convertedTextView.layer.masksToBounds = true
        }
    }
    @IBOutlet private weak var originalTextView: PlaceHolderTextView! {
        didSet {
            originalTextView.placeHolder = NSLocalizedString("original_place_holder", comment: "")
            let toolBar = UIToolbar()
            let button = UIBarButtonItem(title: NSLocalizedString("convert", comment: ""),
                                         style: .done, target: self,
                                         action: #selector(convert(_:)))
            let space = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolBar.setItems([space, button], animated: false)
            toolBar.sizeToFit()
            originalTextView.inputAccessoryView = toolBar
        }
    }

    private let model = DNAConverterModel()
    private let historyModel = HistoryModel()
    private let speechModel = SpeechModel()
    enum Mode: Int {
        case language
        case dna
    }
    private var mode: Mode {
        return Mode(rawValue: modeSegmentedControl.selectedSegmentIndex)!
    }
    private let alertMessage = NSLocalizedString("alert_message", comment: "")
    private let alertMessageEmpty = NSLocalizedString("alert_message_empty", comment: "")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        originalTextView.text = ""
        convertedTextView.text = ""
        originalTextView.changeVisiblePlaceHolder()
        #if targetEnvironment(macCatalyst)
        originalTextToolView.isHidden = true
        #else
        originalTextToolView.isHidden = false
        speechModel.speechRecognizer?.delegate = self
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                    case .authorized:
                        self.recordButton.recordState = .enable(isRecording: false)
                    case .denied, .restricted, .notDetermined:
                        self.recordButton.recordState = .disable
                @unknown default:
                    fatalError("error")
                }
            }
        }
        #endif
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let historyViewController = segue.destination as? HistoryTableViewController {
            historyViewController.delegate = self
        }
    }
    
    private func setTexts() {
        model.originalText = originalTextView.text
        model.convertedText = convertedTextView.text
    }

    //MARK:- IBActions
    @IBAction private func record(_ sender: Any) {
        if speechModel.isRunning {
            speechModel.stop()
            recordButton.recordState = .enable(isRecording: false)
            return
        }
        do {
            try speechModel.start { [weak self] (text, finished) in
                if let text = text {
                    self?.originalTextView.text = text
                    self?.originalTextView.changeVisiblePlaceHolder()
                }
                if finished {
                    self?.recordButton.recordState = .enable(isRecording: false)
                }
            }
            recordButton.recordState = .enable(isRecording: true)
        } catch {
            recordButton.recordState = .enable(isRecording: false)
        }
    }

    @IBAction private func clear(_ sender: Any) {
        originalTextView.text = ""
        convertedTextView.text = ""
        setTexts()
        originalTextView.changeVisiblePlaceHolder()
    }

    @IBAction private func share(_ sender: Any) {
        view.endEditing(true)
        setTexts()
        #if targetEnvironment(macCatalyst)
        guard let convertedText = model.convertedText,
            !model.isInvalidDNA(convertedText) else {
                showAlert(message: alertMessage)
                return
        }
        #else
        guard let convertedText = model.convertedText,
            !convertedText.isEmpty else {
                showAlert(message: alertMessageEmpty)
                return
        }
        #endif
        let controller = UIActivityViewController(activityItems: [convertedText],
                                                  applicationActivities: nil)
        controller.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
        present(controller, animated: true, completion: nil)
    }

    @IBAction private func exportText(_ sender: Any) {
        view.endEditing(true)
        setTexts()
        if model.isInvalidDNA(model.convertedText) {
            showAlert(message: alertMessage)
            return
        }
        #if targetEnvironment(macCatalyst)
        let picker = UIDocumentPickerViewController(documentTypes: [kUTTypeFolder as String], in: .open)
        picker.delegate = self
        present(picker, animated: true)
        #else
        if !model.export(model.convertedText) {
            showAlert(message: alertMessage)
        }
        #endif
    }

    @IBAction private func changedMode(_ sender: Any) {
    }

    @IBAction private func copyText(_ sender: Any) {
        view.endEditing(true)
        setTexts()
        UIPasteboard.general.string = model.convertedText
    }

    @objc
    @IBAction private func convert(_ sender: Any) {
        view.endEditing(true)
        setTexts()
        let result = mode == .language ? model.convertToDNA(originalTextView.text) : model.convertToLanguage(originalTextView.text)
        switch result {
        case .success(let convertedText):
            convertedTextView.text = convertedText
            if mode == .language {
                historyModel.add(history: convertedText)
            }
        case .failure(let error):
            convertedTextView.text = error.text
        }
    }

    @IBAction private func linkToTwitter(_ sender: Any) {
        view.endEditing(true)
        setTexts()
        if UIApplication.shared.canOpenURL(URL(string: "https://twitter.com/intent/tweet")!),
            let url = model.twitterURL {
            UIApplication.shared.open(url)
        } else {
            showAlert(message: alertMessage)
        }
    }
}

#if targetEnvironment(macCatalyst)
extension DNAConverterViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let url = urls.first!
        if !model.export(model.convertedText, directoryPath: url.path) {
            showAlert(message: alertMessage)
        }
    }
}
#endif

extension DNAConverterViewController: HistoryTableViewControllerDelegate {
    func historyTableViewController(_ historyTableViewController: HistoryTableViewController, didSelectHistory history: String) {
        historyTableViewController.dismiss(animated: true)
        modeSegmentedControl.selectedSegmentIndex = Mode.dna.rawValue
        originalTextView.text = history
        convertedTextView.text = ""
        originalTextView.changeVisiblePlaceHolder()
        historyModel.add(history: history)
        convert(history)
    }
}

extension DNAConverterViewController: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            recordButton.recordState = .enable(isRecording: false)
        } else {
            recordButton.recordState = .disable
        }
    }
}
