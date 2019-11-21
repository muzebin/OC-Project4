//
//  ViewController.swift
//  Instagrid
//
//  Created by Jérôme Guèrin on 20/11/2019.
//  Copyright © 2019 Jérôme Guèrin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
// MARK: Annonce des variables et outlet
    
    // Outil pour récuperer la photo choisie.
    var buttonReference = UIButton()
    
    // Vue principale celle sur laquelle on effectue le montage.
    @IBOutlet weak var editPictureView: UIView!
    
    // Enumeration permettant par la suite la transformation de la vue.
    enum move { case out, back }
    
    // Les différents boutons de l'interface (Outlet).
    @IBOutlet weak var buttonLayoutOne: UIButton!
    @IBOutlet weak var buttonLayoutTwo: UIButton!
    @IBOutlet weak var buttonLayoutThree: UIButton!
    @IBOutlet weak var buttonTopLeft: UIButton!
    @IBOutlet weak var buttonTopRight: UIButton!
    @IBOutlet weak var buttonBottomLeft: UIButton!
    @IBOutlet weak var buttonBottomRight: UIButton!
    
    // Les labels permettant de savoir dans quelle orientation est le téléphone.
    @IBOutlet weak var swipeLeftLabel: UILabel!
    @IBOutlet weak var swipeUpLabel: UILabel!
    
// MARK: Fonctionnalité 1 - Choix de la disposition des photos
    
    // Affiche la première disposition en cachant les "selected" des autres boutons.
    @IBAction func tapLayoutOne() {
        buttonTopLeft.isHidden = true
        buttonTopRight.isHidden = false
        buttonBottomLeft.isHidden = false
        buttonBottomRight.isHidden = false
        buttonLayoutOne.setImage(UIImage(named: "Selected"), for: .normal)
        buttonLayoutTwo.setImage(nil, for: .normal)
        buttonLayoutThree.setImage(nil, for: .normal)
    }
    
    // Affiche la deuxième disposition en cachant les "selected" des autres boutons.
    @IBAction func tapLayoutTwo() {
        buttonTopLeft.isHidden = false
        buttonTopRight.isHidden = false
        buttonBottomLeft.isHidden = true
        buttonBottomRight.isHidden = false
        buttonLayoutOne.setImage(nil, for: .normal)
        buttonLayoutTwo.setImage(UIImage(named: "Selected"), for: .normal)
        buttonLayoutThree.setImage(nil, for: .normal)
    }
    
    // Affiche la troisième disposition en cachant les "selected" des autres boutons.
    @IBAction func tapLayoutThree() {
        buttonTopLeft.isHidden = false
        buttonTopRight.isHidden = false
        buttonBottomLeft.isHidden = false
        buttonBottomRight.isHidden = false
        buttonLayoutOne.setImage(nil, for: .normal)
        buttonLayoutTwo.setImage(nil, for: .normal)
        buttonLayoutThree.setImage(UIImage(named: "Selected"), for: .normal)
    }

// MARK: Fonctionnalité 2 - Choix de photo en cliquant sur les boutons
    
    // Action qui affiche la libraire de photo lorsqu'on clique à un endroit de la disposition.
    @IBAction func tapChoosePicture(_ sender: UIButton) {
        buttonReference = sender
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // Effectué lors de l'appui sur le cancel.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Permet de choisir la photo et donc remplacer le vide dans la disposition.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pictureChosen = info[.originalImage] as? UIImage {
            buttonReference.setImage(pictureChosen, for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
    
// MARK: Fonctionnalité 3 - Swipe pour enregistrer ou partager la photo
    
    // Création et implémentation du mouvement de swipe up ou swipe left.
    private func createGesture() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeMovement))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeMovement))
        swipeUp.direction = .up
        swipeLeft.direction = .left
        editPictureView.addGestureRecognizer(swipeUp)
        editPictureView.addGestureRecognizer(swipeLeft)
    }
    
    // Effecuté lors du swipe : transforme la vue et présente l'activity controller.
    @objc func swipeMovement(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .up && swipeUpLabel.isHidden == false {
            transformViewUp(.out)
            presentActivityController(UIView.asImage(self.editPictureView)(), orientation: "portrait")
        } else if sender.direction == .left && swipeLeftLabel.isHidden == false {
            transformViewLeft(.out)
            presentActivityController(UIView.asImage(self.editPictureView)(), orientation: "landscape")
        }
    }
    
    // Pour faire disparaître la vue vers le haut ou la faire revenir à l'identique.
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
    
    // Pour faire disparaître la vue vers la gauche ou la faire revenir à l'identique.
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
    
    // Fait apparaître l'activity controller, effectue le choix de l'utilisateur et remet la vue à sa place initiale.
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
        // Au départ on souhaite avoir la vue sélectionnée comme ceci.
        tapLayoutTwo()
        // On implémente les reconnaissances de swipe.
        createGesture()
    }
}

extension UIView {
    
    // Fonction permettant la transformation d'un UIView en image.
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

