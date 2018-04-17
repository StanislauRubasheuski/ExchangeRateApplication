//
//  ViewController.swift
//  ExchangeRateApplication
//
//  Created by Stanislau on 17.04.2018.
//  Copyright © 2018 Stanislau. All rights reserved.
//

import UIKit
import Reachability

class ViewController: UIViewController {
    
    var tableViewCurrencies = UITableView()

    let cellCurrencyID = "cell"
    
    var currentCurrency = ""
    var currentScale = ""
    var currentName = ""
    var currentRate = ""
    var currentCharCode = ""
    
    var reachability: Reachability?
    var currenciesData = Data()
    var currenciesAttributesDataSource = [CurrencyAttributes]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        reachability = Reachability.init()
        if reachability!.connection != .none {
            setupTableViewCurrencies()
            parseNBRB()
        } else {
            Alert.showBasic(title: "Ошибка связи", message: "Проверьте подключение интернета", vc: self)
        }
    }
    
    func setupTableViewCurrencies() {
        view.addSubview(tableViewCurrencies)
        
        tableViewCurrencies.delegate = self
        tableViewCurrencies.dataSource = self
        tableViewCurrencies.register(CellCurrency.self, forCellReuseIdentifier: cellCurrencyID)
        tableViewCurrencies.isEditing = true
        
        tableViewCurrencies.translatesAutoresizingMaskIntoConstraints = false
        tableViewCurrencies.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableViewCurrencies.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableViewCurrencies.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableViewCurrencies.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

    }
    
    func parseNBRB() {
        let path = "http://www.nbrb.by/Services/XmlExRates.aspx"
        let url = URL(string: path)
        
        do {
            currenciesData = try Data(contentsOf: url!)
            let parser = XMLParser(data: currenciesData)
            parser.delegate = self
            
            if !parser.parse() {
                Alert.showBasic(title: "Ошибка обработки данных", message: "Некорректный ответ от сервера", vc: self)
            }
        } catch {
            Alert.showBasic(title: "Ошибка ответа от сервера", message: "Сбой на сервере", vc: self)
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currenciesAttributesDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellCurrencyID) as! CellCurrency
        cell.labelWithRate.text = "\(currenciesAttributesDataSource[indexPath.row].CharCode) \(currenciesAttributesDataSource[indexPath.row].Rate) BYN"
        cell.labelWithScale.text = "\(currenciesAttributesDataSource[indexPath.row].Name) за \(currenciesAttributesDataSource[indexPath.row].Scale) ед."
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = #colorLiteral(red: 0, green: 0.7176470588, blue: 0.8, alpha: 1)
        let label = UILabel()
        vw.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: vw.leadingAnchor, constant: 5).isActive = true
        label.trailingAnchor.constraint(equalTo: vw.trailingAnchor, constant: -5).isActive = true
        label.topAnchor.constraint(equalTo: vw.topAnchor, constant: 5).isActive = true
        label.bottomAnchor.constraint(equalTo: vw.bottomAnchor, constant: -5).isActive = true
        label.text = "Курсы валют"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return vw
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let rowToMove = self.currenciesAttributesDataSource[sourceIndexPath.row]
        currenciesAttributesDataSource.remove(at: sourceIndexPath.row)
        currenciesAttributesDataSource.insert(rowToMove, at: destinationIndexPath.row)
        self.tableViewCurrencies.reloadData()
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension ViewController: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentCurrency = elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if data.count != 0 {
            switch currentCurrency {
            case "CharCode": currentCharCode = data
            case "Rate": currentRate = data
            case "Name": currentName = data
            case "Scale": currentScale = data
            default: break
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Currency" {
            var myCurrency = CurrencyAttributes()
            myCurrency.CharCode = currentCharCode
            myCurrency.Name = currentName
            myCurrency.Rate = currentRate
            myCurrency.Scale = currentScale
            currenciesAttributesDataSource.append(myCurrency)
        }
    }
}
