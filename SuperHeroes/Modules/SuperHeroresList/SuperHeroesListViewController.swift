//
//  ViewController.swift
//  SuperHeroes
//
//  Created by Rafael Gil Pastor on 22/8/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import UIKit

public protocol SuperHeroesListsViewProtocol:class {
    
    var presenter: SuperHeroesListPresenterProtocol? { get set }

    func showMessageError(error: Error?, completion: AlertMessageCompletion?)
    func show(heroes: [SuperHeroViewEntity] )
}

public typealias SuperHeroesListUIProtocol = SuperHeroesListsViewProtocol & TableLoadingIndicatorProtocol & AlertMessageProtocol

public class SuperHeroesListViewController: UIViewController, SuperHeroesListUIProtocol{

    @IBOutlet weak public var tableView: UITableView?
    
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
        
        title = NSLocalizedString("SH_APP_TITLE", comment: "")
        
        setupTable(withLoadingIndicator: loadingIndicator)
        
        //call to presenter to give a chance when view did load
        presenter?.viewDidLoad()
        
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public func show(heroes: [SuperHeroViewEntity]) {
        self.heroes = heroes
        tableView?.separatorStyle = .singleLine
        tableView?.reloadData()
    }

    public func refreshHeroes()
    {
        presenter?.askForHeroes()
    }
    
    public func showEmptyMessage()
    {
        // Display a message when the table is empty
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView?.bounds.size.width ?? 0, height: self.tableView?.bounds.size.height ?? 0))
        
        messageLabel.text = NSLocalizedString("SH_NO_HEROES_AVAILABLE", comment: "")
        messageLabel.textColor = UIColor.black;
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont.systemFont(ofSize: 20);
        messageLabel.sizeToFit()
        tableView?.backgroundView = messageLabel;
        tableView?.separatorStyle = .none;
    }
}

fileprivate extension SuperHeroesListViewController {
    
    func setupTable(withLoadingIndicator loadingIndicator: UIRefreshControl) {
        
        //add refresh control to table (refresh control will be the loading indicator)
        tableView?.refreshControl = loadingIndicator
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 44.0
        tableView?.register(SuperHeroCell.classForCoder(), forCellReuseIdentifier: SuperHeroCell.identifier)
        tableView?.separatorStyle = .none
        tableView?.allowsSelection = true
        tableView?.allowsMultipleSelection = false
    }
}

//MARK : Message Error Management
extension SuperHeroesListViewController
{
    public func showMessageError(error: Error?, completion: AlertMessageCompletion?)
    {
        showAlertMessage(fromView: self, error: error, completion: completion)
    }
}

//MARK: Table View Data Source Handler
extension SuperHeroesListViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return heroes.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SuperHeroCell.identifier, for: indexPath as IndexPath) as! SuperHeroCell
        
        //pass data to cell from the related hero
        cell.bindHero(hero: heroes[indexPath.row], presenter: presenter)
        
        return cell
    }
}

// MARK: Table View Delegate Handler
extension SuperHeroesListViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row >= 0 && indexPath.row < heroes.count {
            presenter?.didSelectHero(hero: heroes[indexPath.row])
        }
    }
}
