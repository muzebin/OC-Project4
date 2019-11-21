//
//  ViewController.swift
//  Instagrid
//
//  Created by Jérôme Guèrin on 20/11/2019.
//  Copyright © 2019 Jérôme Guèrin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var buttonReference = UIButton()
    @IBOutlet weak var editPictureView: UIView!
    enum move { case out, back }
    
    @IBOutlet weak var buttonLayoutOne: UIButton!
    @IBOutlet weak var buttonLayoutTwo: UIButton!
    @IBOutlet weak var buttonLayoutThree: UIButton!
    @IBOutlet weak var buttonTopLeft: UIButton!
    @IBOutlet weak var buttonTopRight: UIButton!
    @IBOutlet weak var buttonBottomLeft: UIButton!
    @IBOutlet weak var buttonBottomRight: UIButton!
    
    @IBOutlet weak var swipeLeftLabel: UILabel!
    @IBOutlet weak var swipeUpLabel: UILabel!
    
    
    @IBAction func tapLayoutOne() {
        buttonTopLeft.isHidden = true
        buttonTopRight.isHidden = false
        buttonBottomLeft.isHidden = false
        buttonBottomRight.isHidden = false
        buttonLayoutOne.setImage(UIImage(named: "Selected"), for: .normal)
        buttonLayoutTwo.setImage(nil, for: .normal)
        buttonLayoutThree.setImage(nil, for: .normal)
    }
    
    @IBAction func tapLayoutTwo() {
        buttonTopLeft.isHidden = false
        buttonTopRight.isHidden = false
        buttonBottomLeft.isHidden = true
        buttonBottomRight.isHidden = false
        buttonLayoutOne.setImage(nil, for: .normal)
        buttonLayoutTwo.setImage(UIImage(named: "Selected"), for: .normal)
        buttonLayoutThree.setImage(nil, for: .normal)
    }
    
    @IBAction func tapLayoutThree() {
        buttonTopLeft.isHidden = false
        buttonTopRight.isHidden = false
        buttonBottomLeft.isHidden = false
        buttonBottomRight.isHidden = false
        buttonLayoutOne.setImage(nil, for: .normal)
        buttonLayoutTwo.setImage(nil, for: .normal)
        buttonLayoutThree.setImage(UIImage(named: "Selected"), for: .normal)
    }
    
    @IBAction func tapChoosePicture(_ sender: UIButton) {
        buttonReference = sender
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pictureChosen = info[.originalImage] as? UIImage {
            buttonReference.setImage(pictureChosen, for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func createGesture() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeMovement))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeMovement))
        swipeUp.direction = .up
        swipeLeft.direction = .left
        editPictureView.addGestureRecognizer(swipeUp)
        editPictureView.addGestureRecognizer(swipeLeft)
    }
    
    @objc func swipeMovement(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .up && swipeUpLabel.isHidden == false {
            transformViewUp(.out)
            presentActivityController(UIView.asImage(self.editPictureView)(), orientation: "portrait")
        } else if sender.direction == .left && swipeLeftLabel.isHidden == false {
            transformViewLeft(.out)
            presentActivityController(UIView.asImage(self.editPictureView)(), orientation: "landscape")
        }
    }
    
    private func transformViewUp(_ instant: move) {
        switch instant {
        case .out:
            UIView.animate(withDuration: 0.5) {
                self.editPictureView.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
            }
        case .back:
            UIView.animate(withDuration: 0.5) {
                self.editPictureView.transform = .identity
            }
        }
    }
    
    private func transformViewLeft(_ instant: move) {
        switch instant {
        case .out:
            UIView.animate(withDuration: 0.5) {
                self.editPictureView.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
            }
        case .back:
            UIView.animate(withDuration: 0.5) {
                self.editPictureView.transform = .identity
            }
        }
    }
    
    private func presentActivityController(_ image: UIImage, orientation: String) {
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        switch orientation {
        case "portrait":
            activityController.completionWithItemsHandler = {(UIActivityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
                self.transformViewUp(.back)
            }
        case "landscape":
            activityController.completionWithItemsHandler = {(UIActivityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
                self.transformViewLeft(.back)
            }
        default:
            break
        }
        present(activityController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapLayoutTwo()
        createGesture()
    }
}

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

