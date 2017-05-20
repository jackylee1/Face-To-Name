//
//  SearchViewController.swift
//  Face-To-Name
//
//  Created by John Bales on 5/10/17.
//  Copyright © 2017 John T Bales. All rights reserved.
//

import UIKit
import AWSCore
import AWSRekognition
import AWSMobileHubHelper
import AWSS3

class SearchViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var faceImageView: UIImageView!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        autoShowSelectImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set ImageView to display the selected image.
        faceImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //Get face Meta Data
    
    
    //Search Face
    
    
    //Show Face Found
    
    
    //MARK: Actions
    
    //Click on image view
    @IBAction func imageTypeSelect(_ sender: UITapGestureRecognizer) {
        imageTypeSelect()
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        if !AWSIdentityManager.default().isLoggedIn {
            presentSignInViewController()
        } else if !searching {
            if faceImageView.image == nil || faceImageView.image == #imageLiteral(resourceName: "NoPhotoSelected") {
                self.alertMessageOkay("Photo Required", "Make sure the image has a clear view of the person's face and no one else's.")
            } else {
                AWSRekognition.default().searchForFacesFTN(faceImageView.image!, { (matchingFaces) -> Void? in
                    //Success
                    self.searchStopping()
                    self.presentationSync {
                        self.performSegue(withIdentifier: "ShowSearchResult", sender: matchingFaces)
                    }
                    return nil
                }, { (alertParams) -> Void? in
                    //Failure
                    self.searchStopping()
                    self.alertMessageOkay(alertParams)
                    return nil
                })
            }
        } else {
            print("Currently searching. Done trigger skipped.")
        }
    }
    
    func searchStarting() {
        searching = true
        doneBarButton.isEnabled = false
        alertMessageNoCancel("Loading...", "")
    }
    func searchStopping() {
        searching = false
        doneBarButton.isEnabled = true
    }
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Search Results
        if let destinationViewController = segue.destination as? SearchResultViewController {
            destinationViewController.matchingFaces = sender as? [AWSRekognitionFaceMatch]
        }
    }
 
    
    
    

}