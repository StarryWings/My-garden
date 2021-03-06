//
//  AddNewPlantViewController.swift
//  My garden
//
//  Created by Ivan Nikitin on 15/04/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class AddNewPlantViewController: UIViewController {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var sortTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var plantClassTextField: UITextField!
    @IBOutlet weak var landingDateTextField: UITextField!
    @IBOutlet weak var maturationTimeTextField: UITextField!
    @IBOutlet weak var squareTextField: UITextField!
    @IBOutlet weak var harvestTextField: UITextField!
    //pickers
    var pickerOfPlantClass = UIPickerView()
    var datePicker = UIDatePicker()
    let imagePicker = UIImagePickerController()
    
    var plant = Plant()
    var plantImage: UIImage?
    var plantClass: PlantClass!
    var landingDate: Date!
    
    var plantIndex: IndexPath?
    //save
    let save = SaveToPlist()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        pickersSetup()
        registerForKeyboardNotification()
        
        pickerOfPlantClass.delegate = self
        pickerOfPlantClass.dataSource = self
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showPlant()
        updateUI()
    }
    
    //MARK: - IBActions
    
    @IBAction func abbImageButtonPressed(_ sender: UIButton) {
        saveTextInFields()
        let alert = UIAlertController(title: "Photo", message: "Choose photo from camera or photo library", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let libraryAction = UIAlertAction(title: "Photo library", style: .default) { (action) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) && !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.message =
            """
            Camera and photo library not available
            """
        } else if UIImagePickerController.isSourceTypeAvailable(.camera) && !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            alert.addAction(cameraAction)
            alert.message =
            """
            Choose photo from camera
            Photo library not available
            """
        } else if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) && !UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(libraryAction)
            alert.message =
            """
            Choose photo from photo library
            Camera not available
            """
        } else {
            alert.addAction(cameraAction)
            alert.addAction(libraryAction)
        }
        
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - ...Selectors
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

// MARK: - Keyboard apearence
extension AddNewPlantViewController {
    
    //    Register keyboard appearance
    func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    // Selectors
    @objc func kbDidShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        bottomConstraint.constant = kbFrameSize.height
    }
    
    @objc func kbDidHide() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.1, animations: {
                self.bottomConstraint.constant = 0
                self.updateViewConstraints()
            })
        }
    }
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension AddNewPlantViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    
    func pickersSetup() {
        
        //LandingDate Picker
        datePicker.datePickerMode = .date
        
        let toolBarDatePicker = UIToolbar()
        toolBarDatePicker.barStyle = .blackTranslucent
        toolBarDatePicker.isTranslucent = true
        toolBarDatePicker.tintColor = UIColor.white
        toolBarDatePicker.sizeToFit()
        
        let doneButtonDate = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(doneDatePicker))
        toolBarDatePicker.setItems([doneButtonDate], animated: false)
        toolBarDatePicker.isUserInteractionEnabled = true
        
        landingDateTextField.inputView = datePicker
        landingDateTextField.inputAccessoryView = toolBarDatePicker
        
        //plantClass picker
        
        plantClassTextField.inputView = pickerOfPlantClass
        let toolBar = UIToolbar()
        toolBar.barStyle = .blackTranslucent
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.white
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        plantClassTextField.inputView = pickerOfPlantClass
        plantClassTextField.inputAccessoryView = toolBar
    }
    
    @objc func donePicker() {
        plantClassTextField.resignFirstResponder()
    }
    
    @objc func doneDatePicker() {
        landingDateTextField.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return PlantClass.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        plantClassTextField.text = PlantClass.allCases[row].rawValue
        plantClass = PlantClass.allCases[row]
        updateUI()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let cases = PlantClass.allCases
        return cases[row].rawValue
    }
    
    @IBAction func landingDatePick(_ sender: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        updateUI()
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        landingDateTextField.text = dateFormatter.string(from: sender.date)
        landingDate = sender.date
    }
}

// MARK: - Methods
extension AddNewPlantViewController {
    func areFieldsReady() -> Bool {
        return !nameTextField.isEmpty && !sortTextField.isEmpty && !descriptionTextField.isEmpty && !plantClassTextField.isEmpty && !landingDateTextField.isEmpty && !maturationTimeTextField.isEmpty && !squareTextField.isEmpty && !harvestTextField.isEmpty
    }
    
    func savePlant() {
        plant.name = nameTextField.text ?? ""
        plant.sort = sortTextField.text ?? ""
        plant.description = descriptionTextField.text ?? ""
        plant.plantClass = plantClass
        plant.landingDate = landingDate
        plant.maturationTime = Int(maturationTimeTextField.text ?? "0") ?? 0
        plant.squareOfPlant = Double(squareTextField.text?.setDotInsteadOfComma() ?? "0") ?? 0
        plant.harvest = Double(harvestTextField.text?.setDotInsteadOfComma() ?? "0") ?? 0
        guard let image = plantImage else { return }
        if plant.image == plant.id.description {
            save.saveImage(image, with: plant.id.description)
        }
    }
    
    func saveTextInFields() {
        plant.name = nameTextField.text ?? ""
        plant.sort = sortTextField.text ?? ""
        plant.description = descriptionTextField.text ?? ""
        plant.plantClass = plantClass
        plant.landingDate = landingDate
        plant.maturationTime = Int(maturationTimeTextField.text ?? "0") ?? 0
        plant.squareOfPlant = Double(squareTextField.text?.setDotInsteadOfComma() ?? "0") ?? 0
        plant.harvest = Double(harvestTextField.text?.setDotInsteadOfComma() ?? "0") ?? 0
    }
    
    func showPlant() {
        if plant.image == plant.id.description {
            if let image = save.loadImageWithName(plant.image){
                addImageButton.setImage(image, for: [])
            }
            
        } else {
            addImageButton.setImage(UIImage(named: plant.image), for: [])
        }
        nameTextField.text = plant.name
        sortTextField.text = plant.sort
        descriptionTextField.text = plant.description
        plantClassTextField.text = plant.plantClass.rawValue
        plantClass = plant.plantClass
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        landingDateTextField.text = dateFormatter.string(from: plant.landingDate)
        landingDate = plant.landingDate
        
        maturationTimeTextField.text = "\(plant.maturationTime)"
        squareTextField.text = "\(plant.squareOfPlant.toString())"
        harvestTextField.text = "\(plant.harvest.toString())"
    }
    
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        updateUI()
    }
    
    
    func updateUI() {
        title = nameTextField.text
        saveButton.isEnabled = areFieldsReady()
    }
    
    /// Resize image from imagePicker
    ///
    /// - Parameters:
    ///   - image: Original Image
    ///   - targetSize: Size what we want
    /// - Returns: Resized image, to our size
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func scrollToTextField(textField: UITextField) {
        scrollView.scrollRectToVisible(textField.frame, animated: true)
    }
}

// MARK: - Navigation
extension AddNewPlantViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        savePlant()
    }
}

// MARK: - UIImagePickerControllerDelegate
extension AddNewPlantViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let newImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            let size = CGSize(width: 500.0, height: 500.0)
            let resizedImage = resizeImage(image: newImage, targetSize: size)
            DispatchQueue.main.async {
                self.addImageButton.setImage(resizedImage, for: [])
            }
            plantImage = resizedImage
            plant.image = plant.id.description
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

extension AddNewPlantViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
