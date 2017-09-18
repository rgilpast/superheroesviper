//
//  SuperHeroDetailHeaderView.swift
//  SuperHeroes
//
//  Created by Rafael Gil Pastor on 16/9/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation
import UIKit

public class SuperHeroDetailHeaderView: UIView {
    
    fileprivate var heroDetail: SuperHeroDetailViewEntity?

    fileprivate lazy var heroNameLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: SuperHeroDetailHeaderConstants.heroNameFontSize)
        label.textColor = .white
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate lazy var heroImageView: UIImageView = {
        var heroImage = UIImageView(frame: .zero)
        heroImage.translatesAutoresizingMaskIntoConstraints = false
        heroImage.contentMode = .scaleAspectFill
        //assign by default image
        heroImage.image = UIImage(named: "generic_superheroe")
        return heroImage
    }()
    
    public init() {
        super.init(frame: .zero)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public func showHeroName(withHeroName name:String) {
        heroNameLabel.text = name
        heroNameLabel.sizeToFit()
    }
    
    public func showHeroImage(withImage image: UIImage) {
        heroImageView.image = image
    }
}

fileprivate extension SuperHeroDetailHeaderView {
    
    func setup() {
        
        addSubview(heroImageView)
        addSubview(heroNameLabel)
        
        setupHeroImageView()
        setupHeroNameLabel()
    }

    func setupHeroImageView() {
        
        heroImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        heroImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        heroImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        heroImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    func setupHeroNameLabel() {
        
        heroNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -SuperHeroDetailHeaderConstants.heroNameBottomMargin).isActive = true
        heroNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
}

fileprivate struct SuperHeroDetailHeaderConstants {
    static let heroNameFontSize: CGFloat = 24.0
    static let heroNameBottomMargin: CGFloat = 16.0
}
