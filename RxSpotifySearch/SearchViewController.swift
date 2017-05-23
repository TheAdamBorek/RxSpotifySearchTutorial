//
//  ViewController.swift
//  RxSpotifySearch
//
//  Created by Adam Borek on 04/11/2016.
//  Copyright (c) 2016 Adam Borek. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import RxSwift
import RxCocoa

class SearchViewController: UITableViewController {
    fileprivate enum Constatnts {
        static let rowHeight: CGFloat = 50.0
    }
    @IBOutlet weak var searchBar: UISearchBar!
    private let disposeBag = DisposeBag()
    
    let spotifyClient = SpotifyClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = searchBar
        setupTableView()
        bindData()
    }

    private func setupTableView() {
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.rowHeight = Constatnts.rowHeight
    }

    private func bindData() {

    }
}
