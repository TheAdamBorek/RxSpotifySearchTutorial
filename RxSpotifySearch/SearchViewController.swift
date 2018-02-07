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
        static let minimumSearchLength = 3
    }
    @IBOutlet weak var searchBar: UISearchBar!
    private let disposeBag = DisposeBag()
    
    let tracksProvider = TracksProvider(api: APIClient())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = searchBar
        setupTableView()
        setupCancelSearchButton()
        bindTracksWithTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = nil
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        tableView.dataSource = nil
        tableView.rx.itemSelected.subscribe(onNext: { [tableView] index in
            tableView?.deselectRow(at: index, animated: false)
        })
        .disposed(by: disposeBag)
        let refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
        self.refreshControl = refreshControl
    }
    
    private func setupCancelSearchButton() {
        let shouldShowCancelButton = Observable.of(
            searchBar.rx.textDidBeginEditing.map { return true },
            searchBar.rx.textDidEndEditing.map { return false } )
            .merge()
        
        shouldShowCancelButton.subscribe(onNext: { [searchBar] shouldShow in
            searchBar?.showsCancelButton = shouldShow
        })
        .disposed(by: disposeBag)
        
        searchBar.rx.cancelButtonClicked.subscribe(onNext: { [searchBar] in
            searchBar?.resignFirstResponder()
        })
        .disposed(by: disposeBag)
    }
    
    private func bindTracksWithTableView() {
        tracks.bind(to: tableView.rx.items(cellIdentifier: "TrackCell", cellType: TrackCell.self)) { index, track, cell in
            cell.render(trackRenderable: track)
            }
        .disposed(by: disposeBag)
    }
    
    var tracks: Observable<[TrackRenderable]> {
        return Observable.of(tracksFromSpotify.do(onNext: { [refreshControl] _ in refreshControl?.endRefreshing() }),
                             clearPreviousTracksOnTextChanged).merge()
    }
    
    private var tracksFromSpotify: Observable<[TrackRenderable]> {
        let refreshLastQueryOnPullToRefresh = isRefreshing.filter { $0 == true }
            .withLatestFrom(query)
        
        return Observable.of(query, refreshLastQueryOnPullToRefresh).merge()
            .startWith("Let it go - frozen")
            .flatMapLatest { [tracksProvider] query in
                return tracksProvider.tracks(for: query)
                    .map { return $0.map(TrackRenderable.init) }
                    .catchErrorJustReturn([])
        }
    }
    
    private lazy var query: Observable<String> = {
        return self.searchText
            .debounce(0.3, scheduler: MainScheduler.instance)
            .filter(self.filterQuery(containsLessCharactersThan: Constatnts.minimumSearchLength))
    }()
    
    private func filterQuery(containsLessCharactersThan minimumCharacters: Int) -> (String) -> Bool {
        return { query in
            return query.count >= minimumCharacters
        }
    }
    
    private lazy var searchText: Observable<String> = {
        return self.searchBar.rx.text.orEmpty.asObservable()
            .skip(1)
    }()
    
    private lazy var isRefreshing: Observable<Bool> = {
        let refreshControl = self.refreshControl
        return refreshControl?.rx.controlEvent(.valueChanged)
            .map { return refreshControl?.isRefreshing ?? false }
            ?? .just(false)
    }()
    
    private var clearPreviousTracksOnTextChanged: Observable<[TrackRenderable]> {
        return searchText
            .filter(self.filterQuery(containsLessCharactersThan: Constatnts.minimumSearchLength))
            .map { _ in
                return [TrackRenderable]()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}
