//
//  SuperHeroHumanPropertiesCell.swift
//  SuperHeroes
//
//  Created by Rafael Gil Pastor on 22/8/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation
import UIKit

public class SuperHeroHumanPropertiesCell: UITableViewCell, SuperHeroDetailCellProtocol {
    
    static let identifier: String = "SuperHeroHumanPropertiesCell"
    
    lazy var realNameTitle: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: SuperHeroHumanPropertiesCellConstants.titleFontSize)
        label.textColor = UIColor.darkText
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.text = NSLocalizedString("SH_REAL_NAME_TITLE", comment: "")
        label.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        label.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        return label
    }()

    lazy var realNameValue: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: SuperHeroHumanPropertiesCellConstants.valueFontSize)
        label.textColor = UIColor.darkText
        label.textAlignment = .right
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
        return label
    }()

    lazy var heightTitle: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: SuperHeroHumanPropertiesCellConstants.titleFontSize)
        label.textColor = UIColor.darkText
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.text = NSLocalizedString("SH_HEIGHT_TITLE", comment: "")
        label.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        label.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        return label
    }()
    
    lazy var heightValue: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: SuperHeroHumanPropertiesCellConstants.valueFontSize)
        label.textColor = UIColor.darkText
        label.textAlignment = .right
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
        return label
    }()
    
    public init() {
        super.init(style: .default, reuseIdentifier: SuperHeroHumanPropertiesCell.identifier)
        setupCell()
    }
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: SuperHeroHumanPropertiesCell.identifier)
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
    
    public func bindProperties(WithProperties properties: SuperHeroProperties, forType propertyType: SuperHeroDetailPropertiesEnum) {
        
        if let realName = properties[SuperHeroPropertyEnum.RealName] {
            self.realNameValue.text = realName
            self.realNameValue.sizeToFit()
        }
        if let height = properties[SuperHeroPropertyEnum.Height] {
            self.heightValue.text = height
            self.heightValue.sizeToFit()
        }
    }
}

private extension SuperHeroHumanPropertiesCell {
    
    func setupCell() {
        
        selectionStyle = .none
        clipsToBounds = true
        
        contentView.addSubview(realNameTitle)
        contentView.addSubview(realNameValue)
        contentView.addSubview(heightTitle)
        contentView.addSubview(heightValue)

        setupRealNameTitle()
        setupRealNameValue()
        setupHeightTitle()
        setupHeightValue()
    }
    
    func setupRealNameTitle() {
        
        realNameTitle.centerYAnchor.constraint(equalTo: realNameValue.centerYAnchor).isActive = true
        realNameTitle.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: SuperHeroHumanPropertiesCellConstants.contentPadding).isActive = true
    }
    
    func setupRealNameValue() {
        
        realNameValue.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SuperHeroHumanPropertiesCellConstants.contentPadding).isActive = true
        realNameValue.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: SuperHeroHumanPropertiesCellConstants.valueWidthFactor).isActive = true
        realNameValue.leftAnchor.constraint(equalTo: realNameTitle.rightAnchor, constant: SuperHeroHumanPropertiesCellConstants.valueLeftMargin).isActive = true
        realNameValue.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -SuperHeroHumanPropertiesCellConstants.contentPadding).isActive = true
    }
    
    func setupHeightTitle() {
        
        heightTitle.centerYAnchor.constraint(equalTo: heightValue.centerYAnchor).isActive = true
        heightTitle.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: SuperHeroHumanPropertiesCellConstants.contentPadding).isActive = true
    }
    
    func setupHeightValue() {
        
        heightValue.topAnchor.constraint(equalTo: realNameValue.bottomAnchor, constant:SuperHeroHumanPropertiesCellConstants.valueTopMargin).isActive = true
        heightValue.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -SuperHeroHumanPropertiesCellConstants.contentPadding).isActive = true
        heightValue.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: SuperHeroHumanPropertiesCellConstants.valueWidthFactor).isActive = true
        heightValue.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -SuperHeroHumanPropertiesCellConstants.contentPadding).isActive = true
        heightValue.leftAnchor.constraint(equalTo: heightTitle.rightAnchor, constant: SuperHeroHumanPropertiesCellConstants.valueLeftMargin).isActive = true
   }
}

private struct SuperHeroHumanPropertiesCellConstants {
    
    static let titleFontSize: CGFloat = 14.0
    static let valueFontSize: CGFloat = 16.0

    static let contentPadding: CGFloat = 16.0
    static let valueLeftMargin: CGFloat = 8.0
    static let valueTopMargin: CGFloat = 8.0
    static let valueWidthFactor: CGFloat = 0.6

    
}
