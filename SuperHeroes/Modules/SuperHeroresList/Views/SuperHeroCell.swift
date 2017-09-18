//
//  BookCell.swift
//  SuperHeroes
//
//  Created by Rafael Gil Pastor on 22/8/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation
import UIKit


public class SuperHeroCell: UITableViewCell
{
    static let identifier: String = "SuperHeroCell"
    
    lazy var name: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        label.textColor = UIColor.darkText
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    lazy var thumbnail: UIImageView = {
        var heroImage = UIImageView(frame: .zero)
        heroImage.translatesAutoresizingMaskIntoConstraints = false
        heroImage.contentMode = .scaleAspectFill
        //assign by default image
        heroImage.image = UIImage(named: "generic_superheroe")
        return heroImage
    }()
    
    public init() {
        super.init(style: .default, reuseIdentifier: SuperHeroCell.identifier)
        setupCell()
    }
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: SuperHeroCell.identifier)
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
    
    public func bindHero(hero: SuperHeroViewEntity?, presenter: SuperHeroesListPresenterProtocol?)
    {
        name.text =  hero?.name
        name.sizeToFit()
        
        presenter?.askForHeroImage(hero: hero, onCompletion: {[weak self] (imageData) -> (Void) in
            if let data = imageData
            {
                self?.thumbnail.image = UIImage(data: data)
            }
        })
    }
}

private extension SuperHeroCell {
    
    func setupCell() {
        
        selectionStyle = .none
        accessoryType = .none
        clipsToBounds = true
        
        contentView.addSubview(thumbnail)
        contentView.addSubview(name)

        setupThumbnail()
        setupName()
    }
    
    func setupThumbnail() {
        thumbnail.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        thumbnail.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        thumbnail.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: SuperHeroCellConstants.thumbnailLeftMargin).isActive = true
        
        thumbnail.heightAnchor.constraint(equalToConstant: SuperHeroCellConstants.thumbnailHeight).isActive = true
        thumbnail.widthAnchor.constraint(equalTo: thumbnail.heightAnchor, multiplier: 1).isActive = true
    }
    
    func setupName() {
        name.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        name.leftAnchor.constraint(equalTo: thumbnail.rightAnchor, constant: SuperHeroCellConstants.nameMarginSize).isActive = true
        name.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: SuperHeroCellConstants.nameMarginSize).isActive = true
        name.setContentCompressionResistancePriority(1000, for: .vertical)
        name.setContentHuggingPriority(1000, for: .vertical)
    }
}

private struct SuperHeroCellConstants {
    static let nameMarginSize: CGFloat = 16.0
    static let thumbnailLeftMargin: CGFloat = 0
    static let thumbnailHeight: CGFloat = 96.0
}
