//
//  ListViewController.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/12.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import Firebase
import UIKit

protocol ListViewInterface: class {
    func reloadData()
    func toPost()
    func toBack()
}

class ListViewController: UIViewController, ListViewInterface {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!

    var presenter: ListPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        initializeTableView()
        initializeUI()
        initializePresenter()
        presenter.loadPosts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }

    @IBAction private func addButtonTapped(_ sender: Any) {
        presenter.addButtonTapped()
    }

    private func configureNavigation() {
        navigationItem.title = "ToDoList"
        navigationItem.removeBackBarButtonTitle()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(self.logOut))
    }

    private func initializeTableView() {
        tableView.register(R.nib.listTableViewCell)

        tableView.delegate = self
        tableView.dataSource = self

        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
    }

    private func initializeUI() {
        addButton.layer.cornerRadius = addButton.bounds.height / 2.0
        addButton.backgroundColor = UIColor.systemYellow
        addButton.tintColor = UIColor.white
    }

    func initializePresenter() {
        presenter = ListPresenter(with: self)
    }

    func reloadData() {
        tableView.reloadData()
    }

    func toPost() {
        guard let vc = R.storyboard.postViewController.instantiateInitialViewController() else { return }
        if let snap = presenter.selectedSnapshot {
            let postPresenter = PostPresenter(with: vc, and: Post(
                    id: snap.documentID,
                    user: snap["user"] as! String,
                    content: snap["content"] as! String,
                    date: (snap["date"] as! Timestamp).dateValue()
                )
            )
            vc.presenter = postPresenter
        }
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }

    @objc
    private func logOut() {
        presenter.logOut()
    }

    func toBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.contentArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.listTableViewCell, for: indexPath) else { return UITableViewCell() }

        let content = presenter.contentArray[indexPath.row]
        let date = content["date"] as! Timestamp
        cell.setCellData(date: date.dateValue(), content: String(describing: content["content"] ?? ""))
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.select(at: indexPath.row)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.delete(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
        }
    }
}
