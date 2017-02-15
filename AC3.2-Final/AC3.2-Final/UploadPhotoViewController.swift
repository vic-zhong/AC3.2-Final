//
//  UploadPhotoViewController.swift
//  AC3.2-Final
//
//  Created by Victor Zhong on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices

class UploadPhotoViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var picView: UIImageView!
    @IBOutlet weak var commentField: UITextField!
    
    @IBOutlet var photoGesture: UITapGestureRecognizer!
    
    @IBAction func tappedPhoto(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = [String(kUTTypeImage)]
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    lazy var doneButton: UIBarButtonItem = {
        let view = UIBarButtonItem()
        view.title = "Done"
        return view
    }()
    
    var databaseReference: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.parent?.navigationItem.rightBarButtonItem = doneButton
        doneButton.isEnabled = false
        self.doneButton.action = #selector(didTapDoneButton)
        //        self.doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        commentField.delegate = self
        databaseReference = FIRDatabase.database().reference().child("posts")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.parent?.navigationItem.rightBarButtonItem = doneButton
        self.doneButton.action = #selector(didTapDoneButton)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            picView.image = image
            picView.contentMode = .scaleAspectFit
            doneButton.isEnabled = true
        }
        
        picker.dismiss(animated: true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func didTapDoneButton() {
        if let comment = commentField.text {
            if comment != "" {
                let linkRef = self.databaseReference.childByAutoId()
                let storage = FIRStorage.storage()
                let storageRef = storage.reference()
                let spaceRef = storageRef.child("images/\(linkRef.key)")
                let user = FIRAuth.auth()?.currentUser
                
                // downsize the image by compressing it
                let image = self.picView.image!
                let jpeg = UIImageJPEGRepresentation(image, 0.5)
                
                let metadata = FIRStorageMetadata()
                metadata.cacheControl = "public,max-age=300";
                metadata.contentType = "image/jpeg";
                
                let _ = spaceRef.put(jpeg!, metadata: metadata) { (metadata, error) in
                    if error != nil {
                        print("put error")
                        self.alertUser(text: "Upload Failed!", message: error?.localizedDescription)
                    }
                    
                    if metadata != nil {
                        // put in the database only if upload succeeded
                        let pic = Pic(key: linkRef.key, user: (user?.uid)!, comment: comment)
                        let dict = pic.asDictionary
                        
                        linkRef.setValue(dict) { (error, reference) in
                            if let error = error {
                                print(error)
                            }
                            else {
                                print(reference)
                                
                                self.alertUser(text: "Upload Completed!", completion: {
                                    self.doneButton.isEnabled = false
                                    self.picView.image = UIImage(named: "camera_icon")
                                    self.picView.contentMode = .center
                                    self.commentField.text = ""
                                } )
                            }
                        }
                    }
                }
            }
            else {
                self.alertUser(text: "Please Enter Some Text")
            }
        }
    }
    
    func alertUser(text: String, message: String? = nil, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: text, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: completion)
    }
}
