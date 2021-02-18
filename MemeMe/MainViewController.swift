//
//  MainViewController.swift
//  MemeMe
//
//  Created by Tomasz Milczarek on 30/08/2018.
//  Copyright © 2018 Plumya. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: - Configuration
    
    private enum Configuration {
        static let defaultTopText = "TOP"
        static let defaultBottomText = "BOTTOM"
    }
    
    // MARK: - IB Outlets

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    // MARK: - Variables
    
    lazy var paragraph: NSMutableParagraphStyle = {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        return paragraph
    }()
    
    var memedImage: UIImage?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInputTextField(topTextField, text: Configuration.defaultTopText)
        setupInputTextField(bottomTextField, text: Configuration.defaultBottomText)
        setupNavigationBar()
        setupBottomToolbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Setup
    
    private func setupInputTextField(_ textField: UITextField, text: String) {
        let memeTextAttributes: [NSAttributedStringKey: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth:  -4.0,
            NSAttributedString.Key.paragraphStyle: paragraph
        ]
        
        textField.text = text
        textField.backgroundColor = .clear
        textField.defaultTextAttributes = memeTextAttributes.toTypingAttributes()
        textField.delegate = self
    }
    
    private func setupNavigationBar() {
        shareButton.isEnabled = false
    }
    
    private func setupBottomToolbar() {
        bottomToolbar.frame = CGRect(x: bottomToolbar.frame.origin.x, y: bottomToolbar.frame.origin.y - 36, width: bottomToolbar.frame.size.width, height: 80)
    }
    // MARK: - Actions

    @IBAction func pickAnImage(_ sender: Any) {
        presentPickerViewController(sourceType: .photoLibrary)
    }
    
    @IBAction func takeAnImage(_ sender: Any) {
        presentPickerViewController(sourceType: .camera)
    }
    
    private func presentPickerViewController(sourceType: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func shareMemeImage(_ sender: Any) {
        guard let memedImage = generateMemedImage() else { return }
        
        let items = [memedImage]
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        activityController.completionWithItemsHandler = {[weak self] (activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if completed {
                self?.saveMeme()
            }
        }
        
        present(activityController, animated: true)
    }
    
    private func saveMeme() {
        guard let topText = topTextField.text,
              let bottomText = bottomTextField.text,
              let image = imagePickerView.image,
              let memedImage = memedImage else { return }
        
        let meme = Meme(topText: topText, bottomText:bottomText, originalImage: image, memedImage: memedImage)
    }
    
    private func generateMemedImage() -> UIImage? {
        hideBars()

        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        guard let memedImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        
        showBars()

        return memedImage
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
        view.setNeedsLayout()
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        guard let keyboardSize = userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return 0.0 }
        
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    private func hideBars() {
        navigationBar.isHidden = true
        bottomToolbar.isHidden = true
    }
    
    private func showBars() {
        navigationBar.isHidden = false
        bottomToolbar.isHidden = false
    }
}

// MARK: - Generate meme image

extension MainViewController {
    
    func generateMemedImage() -> UIImage {
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return memedImage
    }
}

// MARK: - UIImagePickerControllerDelegate

extension MainViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            shareButton.isEnabled = true
        }
        
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate

extension MainViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard textField.text == Configuration.defaultTopText || textField.text == Configuration.defaultBottomText else { return }
        
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}

extension Dictionary where Key == NSAttributedStringKey {
    
    func toTypingAttributes() -> [String: Any] {
        var convertedDictionary = [String: Any]()

        for (key, value) in self {
            convertedDictionary[key.rawValue] = value
        }

        return convertedDictionary
    }
}
