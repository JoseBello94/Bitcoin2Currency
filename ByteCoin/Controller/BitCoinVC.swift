//
//  ViewController.swift
//  ByteCoin
//
//  Created by Jose Bello on 5/19/20.
//  Copyright © 2020 Jose Bello. All rights reserved.
//

import UIKit

class BitCoinVC: UIViewController {
   
    @IBOutlet weak var bitcoinLable: UILabel!
    @IBOutlet weak var currencyLable: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }
    
}

//MARK: - UIPickerViewDataSource and Delegate
extension BitCoinVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currencyName = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: currencyName)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
}

//MARK: - CoinManagerDelegate
extension BitCoinVC: CoinManagerDelegate {
    
    func didUpdateRate(_ currencyType: String, _ coinValue: String) {
        DispatchQueue.main.async {
            self.bitcoinLable.text = coinValue
            self.currencyLable.text = currencyType
        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
    
}
