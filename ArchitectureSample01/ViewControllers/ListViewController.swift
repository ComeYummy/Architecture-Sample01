//
//  ListViewController.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/12.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import Firebase
import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!

    let listModel = ListModel()
    let authModel = AuthModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        initializeTableView()
        initializeUI()
        configureModel()
    }

    @IBAction private func addButtonTapped(_ sender: Any) {
        self.toPost()
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

    private func configureModel() {
        listModel.delegate = self
        authModel.delegate = self
        listModel.read()
    }

    private func toPost() {
        guard let vc = R.storyboard.postViewController.instantiateInitialViewController() else { return }
        if let snap = listModel.selectedSnapshot {
            let postModel = PostModel(with:
                Post(
                    id: snap.documentID,
                    user: snap["user"] as! String,
                    content: snap["content"] as! String,
                    date: (snap["date"] as! Timestamp).dateValue()
                )
            )
            vc.postModel = postModel
            present(vc, animated: true, completion: nil)
        }
    }

    @objc
    private func logOut() {
        authModel.logOut()
    }
}

extension ListViewController: AuthModelDelegate {
    func didLogOut() {
        navigationController?.popViewController(animated: true)
    }
}

extension ListViewController: ListModelDelegate {
    func listDidChange() {
        tableView.reloadData()
    }
    func errorDidOccur(error: Error) {
        print(error.localizedDescription)
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listModel.contentArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.listTableViewCell, for: indexPath) else { return UITableViewCell() }

        let content = listModel.contentArray[indexPath.row]
        let date = content["date"] as! Timestamp
        cell.setCellData(date: date.dateValue(), content: String(describing: content["content"] ?? ""))
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listModel.selectedSnapshot = listModel.contentArray[indexPath.row]
        self.toPost()
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            listModel.delete(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
        }
    }
}
