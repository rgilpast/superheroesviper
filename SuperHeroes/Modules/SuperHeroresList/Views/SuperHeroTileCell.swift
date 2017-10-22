//
//  SuperHeroTileCell.swift
//  SuperHeroes
//
//  Created by Rafael Gil Pastor on 30/9/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation
import UIKit


public class SuperHeroTileCell: UICollectionViewCell
{
    static let identifier: String = "SuperHeroTileCell"

    lazy var name: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        label.textColor = UIColor.white
        label.textAlignment = .center
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

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCell()
    }

    public override init(frame: CGRect) {
        super.init(frame: .zero)
        setupCell()
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }

    public override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
    }
}

extension SuperHeroTileCell: SuperHeroCellProtocol{

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

    public static func preferredHeight() -> CGFloat {
        return SuperHeroTileCellConstants.preferredCellHeight
    }
}

private extension SuperHeroTileCell {

    func setupCell() {

        clipsToBounds = true

        contentView.addSubview(thumbnail)
        contentView.addSubview(name)

        setupThumbnail()
        setupName()
    }

    func setupThumbnail() {
        thumbnail.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        thumbnail.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        thumbnail.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        thumbnail.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }

    func setupName() {
        name.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: SuperHeroTileCellConstants.nameMarginSize).isActive = true
        name.leftAnchor.constraint(equalTo: thumbnail.rightAnchor, constant: SuperHeroTileCellConstants.nameMarginSize).isActive = true
        name.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: SuperHeroTileCellConstants.nameMarginSize).isActive = true
        name.setContentCompressionResistancePriority(1000, for: .vertical)
        name.setContentHuggingPriority(1000, for: .vertical)
    }
}

private struct SuperHeroTileCellConstants {
    static let nameMarginSize: CGFloat = 16.0
    static let preferredCellHeight: CGFloat = 140.0
}
