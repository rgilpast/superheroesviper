//
//  ViewController.swift
//  SuperHeroes
//
//  Created by Rafael Gil Pastor on 22/8/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import UIKit
import DisplaySwitcher

public protocol SuperHeroesListsViewProtocol:class {
    
    var presenter: SuperHeroesListPresenterProtocol? { get set }

    func showMessageError(error: Error?, completion: AlertMessageCompletion?)
    func show(heroes: [SuperHeroViewEntity] )
}

public typealias SuperHeroesListUIProtocol = SuperHeroesListsViewProtocol & ListLoadingIndicatorProtocol & AlertMessageProtocol

public class SuperHeroesListViewController: UIViewController, SuperHeroesListUIProtocol, DisplaySwitcherProtocol{

    @IBOutlet weak public var listView: UIScrollView?
    var component: DisplaySwitcherComponent = DisplaySwitcherComponent(listCellHeight: SuperHeroesListViewControllerConstants.listLayoutStaticCellHeight, gridCellHeight: SuperHeroesListViewControllerConstants.gridLayoutStaticCellHeight, animationDuration: SuperHeroesListViewControllerConstants.listModeButtonAnimationDuration)
    fileprivate var heroes: [SuperHeroViewEntity] = []
    public var presenter: SuperHeroesListPresenterProtocol?
    
    public lazy var loadingIndicator: UIRefreshControl = { [unowned self] in
        // Initialize the refresh control.
        let control = UIRefreshControl(frame: .zero)
        control.backgroundColor = UIColor.red
        control.tintColor = UIColor.white
        control.addTarget(self, action: #selector(refreshHeroes), for: .valueChanged)
        return control
    }()

    override public func viewDidLoad() {
        super.viewDidLoad()

        listModeButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        listModeButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        listModeButton.addTarget(self, action: #selector(listModeButtonTapped), for: .touchUpInside)
        listModeButton.isSelected = false

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: listModeButton)

        title = NSLocalizedString("SH_APP_TITLE", comment: "")

        setupTable(withLoadingIndicator: loadingIndicator)
        
        //call to presenter to give a chance when view did load
        presenter?.viewDidLoad()
        
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

fileprivate extension SuperHeroesListViewController {

    func showEmptyMessage()
    {
        // Display a message when the table is empty
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.listView?.bounds.size.width ?? 0, height: self.listView?.bounds.size.height ?? 0))

        messageLabel.text = NSLocalizedString("SH_NO_HEROES_AVAILABLE", comment: "")
        messageLabel.textColor = UIColor.black;
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont.systemFont(ofSize: 20);
        messageLabel.sizeToFit()
        if let collectionView = listView as? UICollectionView {
            collectionView.backgroundView = messageLabel;
        }
    }

    func setupTable(withLoadingIndicator loadingIndicator: UIRefreshControl) {

        //add refresh control to table (refresh control will be the loading indicator)

        if let collectionView = listView as? UICollectionView {
            collectionView.refreshControl = loadingIndicator
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(SuperHeroListCell.classForCoder(), forCellWithReuseIdentifier: SuperHeroListCell.identifier)
            collectionView.register(SuperHeroTileCell.classForCoder(), forCellWithReuseIdentifier: SuperHeroTileCell.identifier)
        }
    }

    @objc func listModeButtonTapped(_ sender: AnyObject) {
        toggleListMode()
    }
}

// MARK : ListLoadingIndicatorProtocol and Refresh Control Action Handler
public extension SuperHeroesListViewController {

    func refreshHeroes()
    {
        presenter?.askForHeroes()
    }

    func reloadListData() {
        if let collectionView = listView as? UICollectionView {
            collectionView.reloadData()
        }
    }
}

//MARK : SuperHeroesListsViewProtocol
public extension SuperHeroesListViewController
{

    func show(heroes: [SuperHeroViewEntity]) {
        self.heroes = heroes
        if heroes.count > 0 {
            if let collectionView = listView as? UICollectionView {
                collectionView.backgroundView = nil
                collectionView.reloadData()
            }
        }
        else {
            showEmptyMessage()
        }
    }

    func showMessageError(error: Error?, completion: AlertMessageCompletion?)
    {
        showAlertMessage(fromView: self, error: error, completion: completion)
    }
}


//MARK: Scroll View Delegate
extension SuperHeroesListViewController {

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        beginScrolling()
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        endScrolling()
    }
}

//MARK: Collection View Data Source Handler
extension SuperHeroesListViewController: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heroes.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        var cell: UICollectionViewCell

        if layoutState == .list {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: SuperHeroListCell.identifier, for: indexPath as IndexPath) as! SuperHeroListCell
        }
        else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: SuperHeroTileCell.identifier, for: indexPath as IndexPath) as! SuperHeroTileCell
        }

        //pass data to cell from the related hero
        if let cell = cell as? SuperHeroCellProtocol {
            cell.bindHero(hero: heroes[indexPath.row], presenter: presenter)
        }

        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {

        return transitionLayout(transitionLayoutForOldLayout: fromLayout, newLayout: toLayout)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if layoutState == .list {
            return CGSize(width: collectionView.frame.size.width, height: SuperHeroListCell.preferredHeight())
        }
        else {
            return CGSize(width: collectionView.frame.size.width/3, height: SuperHeroTileCell.preferredHeight())
        }
    }
}

// MARK: Collection View Delegate Handler
extension SuperHeroesListViewController: UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row >= 0 && indexPath.row < heroes.count {
            presenter?.didSelectHero(hero: heroes[indexPath.row])
        }
    }
}

fileprivate struct SuperHeroesListViewControllerConstants {

    static let listModeButtonAnimationDuration: TimeInterval = 0.3
    static let listLayoutStaticCellHeight: CGFloat = 80
    static let gridLayoutStaticCellHeight: CGFloat = 165
}
