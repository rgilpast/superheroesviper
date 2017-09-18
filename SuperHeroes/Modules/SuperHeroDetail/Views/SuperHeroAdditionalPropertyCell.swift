//
//  SuperHeroHumanPropertiesCell.swift
//  SuperHeroes
//
//  Created by Rafael Gil Pastor on 22/8/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation
import UIKit

public class SuperHeroAdditionalPropertyCell: UITableViewCell, SuperHeroDetailCellProtocol {
    
    static let identifier: String = "SuperHeroAdditionalPropertyCell"
    
    lazy var propertyTitle: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: SuperHeroAdditionalPropertyCellConstants.titleFontSize)
        label.textColor = UIColor.darkText
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.text = NSLocalizedString("SH_REAL_NAME_TITLE", comment: "")
        return label
    }()
    
    lazy var propertyValue: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: SuperHeroAdditionalPropertyCellConstants.valueFontSize)
        label.textColor = UIColor.darkText
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    public init() {
        super.init(style: .default, reuseIdentifier: SuperHeroAdditionalPropertyCell.identifier)
        setupCell()
    }
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: SuperHeroAdditionalPropertyCell.identifier)
        setupCell()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCell()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    public func bindProperties(WithProperties properties: SuperHeroProperties, forType propertiesType: SuperHeroDetailPropertiesEnum)
    {
            self.propertyTitle.text = propertiesType.description()
            self.propertyTitle.sizeToFit()
            
            if let key = properties.keys.first, let value = properties[key] {
                self.propertyValue.text = value
                self.propertyValue.sizeToFit()
            }
    }
}

fileprivate extension SuperHeroAdditionalPropertyCell {
    
    func setupCell() {
        
        selectionStyle = .none
        clipsToBounds = true
        
        contentView.addSubview(propertyTitle)
        contentView.addSubview(propertyValue)
        
        setupPropertyTitle()
        setupPropertyValue()
    }
    
    func setupPropertyTitle() {
        
        propertyTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        propertyTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SuperHeroAdditionalPropertyCellConstants.contentPadding).isActive = true
    }

    func setupPropertyValue() {
        
        propertyValue.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: SuperHeroAdditionalPropertyCellConstants.contentPadding).isActive = true
        propertyValue.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -SuperHeroAdditionalPropertyCellConstants.contentPadding).isActive = true
        propertyValue.topAnchor.constraint(equalTo: propertyTitle.bottomAnchor, constant: SuperHeroAdditionalPropertyCellConstants.valueTopMargin).isActive = true
        propertyValue.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -SuperHeroAdditionalPropertyCellConstants.contentPadding).isActive = true
    }
}

fileprivate struct SuperHeroAdditionalPropertyCellConstants {
    
    static let titleFontSize: CGFloat = 18.0
    static let valueFontSize: CGFloat = 14.0
    static let contentPadding: CGFloat = 16.0
    static let valueTopMargin: CGFloat = 8.0
}
