//
//  ListViewController.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/12.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import Firebase
import RxSwift
import RxCocoa
import UIKit

class ListViewController: UIViewController {
    typealias ViewModelType = ListViewModel

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!

    private var viewModel: ViewModelType!
    private let disposeBag = DisposeBag()

    func inject(viewModel: ViewModelType) {
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        initializeTableView()
        initializeUI()
        bindViewModel()
    }

    private func configureNavigation() {
        navigationItem.title = "ToDoList"
        navigationItem.removeBackBarButtonTitle()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: nil)
    }

    private func initializeTableView() {
        tableView.register(R.nib.listTableViewCell)
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
    }

    private func initializeUI() {
        addButton.layer.cornerRadius = addButton.bounds.height / 2.0
        addButton.backgroundColor = UIColor.systemYellow
        addButton.tintColor = UIColor.white
    }

    func bindViewModel() {

        let input = ListViewModel.Input(
            trigger: Driver.just(()),
            postTrigger: addButton.rx.tap.asDriver(),
            selectTrigger: tableView.rx.itemSelected.asDriver().map { $0.row },
            deleteTrigger: tableView.rx.itemDeleted.asDriver().map { $0.row },
            logOutTrigger: navigationItem.rightBarButtonItem!.rx.tap.asDriver()
        )
        let output = viewModel.transform(input: input)

        output.posts
            .drive(tableView.rx.items(cellIdentifier: R.reuseIdentifier.listTableViewCell.identifier, cellType: ListTableViewCell.self)) { _, element, cell in
                cell.setCellData(date: element.date, content: element.content)
            }
            .disposed(by: disposeBag)
    }
}
