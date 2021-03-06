//
//  AddViewController.swift
//  DiscountCardWallet
//
//  Created by Sebastian on /19/2/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import UIKit

protocol cardDelegate: class {
    func addCard(card: card)
    func removeCard(index: Int)
    func editCard(card: card, index: Int)
}

protocol favCardDelegate: class {
    func addCard(card: card)
    func removeCard(index: Int)
    func editCard(card: card, index: Int)
}

class AddViewController: UIViewController {
    
    var code: String?
    weak var delegate: cardDelegate?
    weak var delegate1: favCardDelegate?
    let shops = [ "", "CCC", "Watsons", "Rukavychka", "Other"]
    var pickedShop: String?
    
    @IBOutlet weak var shopTF: UITextField!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var barcodeImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupShopPicker()
        setUpToolbar()
        barcodeImg.image = fromString(string: code!)
        self.hideKeyboardWhenTappedAround()
    }
    
    func setupShopPicker() {
        
        let shopPicker = UIPickerView()
        shopPicker.delegate = self
        shopPicker.backgroundColor = .lightGray
        
        shopTF.inputView = shopPicker
    }
    
    func setUpToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.backgroundColor = UIColor.darkGray
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissPicker))
        
        toolBar.setItems([doneBtn], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        shopTF.inputAccessoryView = toolBar
    }
    
    func getRandomColor() -> UIColor{
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue + 10, alpha: 1.0)
    }
    
    func fromString(string : String) -> UIImage? {
        let data = string.data(using: .ascii)
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            
            if let outputCIImage = filter.outputImage {
                return UIImage(ciImage: outputCIImage)
            }
        }
        return nil
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
    @IBAction func doneBtn(_ sender: Any) {
        if (shopTF.text != "" && titleTF.text != "" && shopTF.text != "Other") {
            delegate?.addCard(card: card(backgroundColor: getRandomColor(), logo: shopTF.text, barcode: self.code!, title: titleTF.text!))
            delegate1?.addCard(card: card(backgroundColor: getRandomColor(), logo: shopTF.text, barcode: self.code!, title: titleTF.text!, isFav: true))
            performSegue(withIdentifier: "doneAddingSegue", sender: nil)
        }
        else if (shopTF.text != "" && titleTF.text != "") {
            delegate?.addCard(card: card(backgroundColor: getRandomColor(), logo: nil, barcode: self.code!, title: titleTF.text!))
            delegate1?.addCard(card: card(backgroundColor: getRandomColor(), logo: nil, barcode: self.code!, title: titleTF.text!, isFav: true))
            performSegue(withIdentifier: "doneAddingSegue", sender: nil)
        }
        else {
            let alert = UIAlertController(title: title, message: "Please enter all fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        performSegue(withIdentifier: "doneAddingSegue", sender: nil)
    }
}

extension AddViewController:  UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return shops.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return shops[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickedShop = shops[row]
        shopTF.text = pickedShop
        
        if (pickedShop != "Other") {
            titleTF.text = pickedShop
        }
    }
}
