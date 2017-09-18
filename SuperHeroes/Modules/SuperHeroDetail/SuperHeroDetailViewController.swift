//
//  SuperHeroDetailViewController.swift
//  SuperHeroes
//
//  Created by Rafael Gil Pastor on 22/8/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import UIKit


public protocol SuperHeroDetailViewProtocol:class {
    
    var presenter: SuperHeroDetailPresenter? { get set }
    
    func showMessageError(error: Error?, completion: AlertMessageCompletion?)
    func showHeroDetail(detail: SuperHeroDetailViewEntity)
}

public typealias SuperHeroDetailUIProtocol = SuperHeroDetailViewProtocol & AlertMessageProtocol & ViewLoadingIndicatorProtocol

public class SuperHeroDetailViewController: UIViewController, SuperHeroDetailUIProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var superHeroHeaderView: SuperHeroDetailHeaderView!
    var headerHeight: CGFloat!

    fileprivate var heroDetail: SuperHeroDetailViewEntity?
    
    fileprivate lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: NSLocalizedString("SH_DETAIL_BACK", comment: ""), style: .plain, target: self, action: #selector(backButtonTapped(_:)))
        return button
    }()
    
    public var presenter: SuperHeroDetailPresenter?

    override public func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("SH_DETAIL_TITLE", comment: "")
        
        setupBackButton()
        setupTable()

        presenter?.viewDidLoad()
    }

    override public func viewDidLayoutSubviews() {
        setupHeader()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public func showHeroDetail(detail: SuperHeroDetailViewEntity) {

        heroDetail = detail

        showHeroName()
        showHeroImage()

        tableView.reloadData()
    }
}

fileprivate extension SuperHeroDetailViewController {
    
    func setupTable() {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.register(SuperHeroHumanPropertiesCell.classForCoder(), forCellReuseIdentifier: SuperHeroHumanPropertiesCell.identifier)
        tableView.register(SuperHeroAdditionalPropertyCell.classForCoder(), forCellReuseIdentifier: SuperHeroAdditionalPropertyCell.identifier)
        tableView.separatorStyle = .none
    }

    func setupBackButton() {
        
        self.navigationItem.hidesBackButton = true;
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func backButtonTapped(_ sender : UIButton) {
        presenter?.back()
    }
    
    func showHeroName() {
        if let name = heroDetail?.name {
            superHeroHeaderView.showHeroName(withHeroName: name)
        }
    }
    
    func showHeroImage() {
        presenter?.askForHeroImage(hero: heroDetail, onCompletion: {[weak self] (imageData) -> (Void) in
            if let data = imageData, let image = UIImage(data: data)
            {
                self?.superHeroHeaderView.showHeroImage(withImage: image)
            }
        })
    }
}

//ScrollView delegate and header management
extension SuperHeroDetailViewController: UIScrollViewDelegate {

    fileprivate func setupHeader() {

        //add the header for super hero image at the top bounce area of table view
        headerHeight = tableView.frame.size.height*SuperHeroDetailViewControllerConstants.headerHeightFactor
        let headerRect = CGRect(x: 0, y: -headerHeight, width: tableView.bounds.width, height: headerHeight)
        superHeroHeaderView.frame = headerRect
        tableView.contentInset = UIEdgeInsets(top: headerHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -headerHeight)
    }

    //update the position and height of header view when user pulling down beyond the top of the table view
    fileprivate func updateHeaderView() {

        var headerRect: CGRect = .zero
        if tableView.contentOffset.y < 0 {
            headerRect = CGRect(x: 0, y: tableView.contentOffset.y, width: tableView.bounds.width, height: -tableView.contentOffset.y)
        }
        else {
            headerRect = CGRect(x: 0, y: -headerHeight, width: tableView.bounds.width, height: headerHeight)
        }
        superHeroHeaderView.frame = headerRect
        view.layoutIfNeeded()
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {

        //update the position and height of header view 
        updateHeaderView()
    }
}

//MARK : Message Error Management
public extension SuperHeroDetailViewController {
    
    public func showMessageError(error: Error?, completion: AlertMessageCompletion?)
    {
        showAlertMessage(fromView: self, error: error, completion: completion)
    }
}

//MARK: Table View Data Source Handler
extension SuperHeroDetailViewController: UITableViewDataSource, UITableViewDelegate {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return heroDetail?.properties?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        
        if let propertyType: SuperHeroDetailPropertiesEnum = heroDetail?.properties?[indexPath.row].keys.first, let properties = heroDetail?.properties?[indexPath.row].values.first, let detailCell =  tableView.dequeueReusableCell(withIdentifier: propertyType.cellIdentifier()) as? SuperHeroDetailCellProtocol {
            //pass data to cell
            detailCell.bindProperties(WithProperties: properties, forType: propertyType)
            cell = detailCell as! UITableViewCell
            
        } else {
            cell = UITableViewCell()
        }
        
        return cell
    }

    public func tableView(_ tableView: UITableView,
                   estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
}

fileprivate struct SuperHeroDetailViewControllerConstants {
    static let mainInfoCellIndex: UInt = 0
    static let additionalInfoCellIndex: UInt = 1
    static let heroNameFontSize: CGFloat = 24.0
    static let headerHeightFactor: CGFloat = 0.30
}
