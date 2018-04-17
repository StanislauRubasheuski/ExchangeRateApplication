//
//  CellCurrency.swift
//  ExchangeRateApplication
//
//  Created by Stanislau on 17.04.2018.
//  Copyright © 2018 Stanislau. All rights reserved.
//

import UIKit

class CellCurrency: UITableViewCell {
    
    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let labelWithRate = UILabel()
    let labelWithScale = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has been not implemented")
    }
    
    func setup() {
        addSubview(cellView)
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        cellView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        cellView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        cellView.addSubview(labelWithRate)
        cellView.addSubview(labelWithScale)
        labelWithRate.translatesAutoresizingMaskIntoConstraints = false
        labelWithScale.translatesAutoresizingMaskIntoConstraints = false
        
        labelWithRate.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 5).isActive = true
        labelWithRate.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 8).isActive = true
        labelWithRate.trailingAnchor.constraint(equalTo: cellView.trailingAnchor).isActive = true
        
        labelWithScale.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -5).isActive = true
        labelWithScale.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 8).isActive = true
        labelWithScale.trailingAnchor.constraint(equalTo: cellView.trailingAnchor).isActive = true
        
        labelWithScale.heightAnchor.constraint(equalTo: labelWithRate.heightAnchor).isActive = true
        labelWithScale.topAnchor.constraint(equalTo: labelWithRate.bottomAnchor).isActive = true
    }

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
