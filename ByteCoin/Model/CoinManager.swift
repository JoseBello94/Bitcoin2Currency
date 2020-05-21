//
//  CurrencyManager.swift
//  ByteCoin
//
//  Created by Jose Bello on 5/20/20.
//  Copyright © 2020 Jose Bello. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateRate(_ currencyType: String, _ coinValue: String)
    func didFailWithError(_ error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "?apikey=ABFE5952-E0CE-4735-BD4C-2DD9DAB43DC7"
    let currencyArray = ["AUD","BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) {
        let completeURL = "\(baseURL)/\(currency+apiKey)"
        //create url
        if let url = URL(string: completeURL) {
            //create url session
            let session = URLSession(configuration: .default)
            //give url session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                if let safeData = data {
                    if let coinValue = self.parseJSON(safeData) {
                        self.delegate?.didUpdateRate(currency, String(format: "%.2f", coinValue))
                    }
                }
            }
            //resume the task
            task.resume()
        }
    }
    
    //Converts JSON type data into swift object
    func parseJSON(_ coinData: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let coinValue = decodedData.rate
            return coinValue
        }
        catch {
            self.delegate?.didFailWithError(error)
            return nil
        }
    }

}
