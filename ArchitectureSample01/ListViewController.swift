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

    let db = Firestore.firestore()

    var contentArray: [DocumentSnapshot] = []
    var selectedSnapshot: DocumentSnapshot?

    var listner: ListenerRegistration?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        initializeTableView()
        initializeUI()
        read()
    }

    @IBAction private func addButtonTapped(_ sender: Any) {
        selectedSnapshot = nil
        self.toPost()
    }

    private func configureNavigation() {
        navigationItem.title = "ToDoList"
        navigationItem.removeBackBarButtonTitle()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(self.logOut))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes(Appearance.textAttributes(17, color: UIColor.systemYellow), for: .normal)
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

    private func read() {
        listner = db.collection("posts").order(by: "date")
            .addSnapshotListener(includeMetadataChanges: true) { [weak self] snapshot, error in
                guard let snap = snapshot else {
                    print("Error fetching document: \(String(describing: error))")
                    return
                }
                for diff in snap.documentChanges where diff.type == .added {
                    print("New data: \(diff.document.data())")
                }
                print("Current data: \(snap)")
                self?.reload(with: snap)
            }
    }

    private func delete(deleteIndexPath indexPath: IndexPath) {
        db.collection("posts").document(contentArray[indexPath.row].documentID).delete()
        contentArray.remove(at: indexPath.row)
    }

    private func reload(with snap: QuerySnapshot) {
        if !snap.isEmpty {
            contentArray.removeAll()
            for item in snap.documents {
                contentArray.append(item)
            }
            print("!!!contentArray", contentArray)
            self.tableView.reloadData()
        }
    }

    private func toPost() {
        guard let vc = R.storyboard.postViewController.instantiateInitialViewController() else { return }
        vc.selectedSnapshot = selectedSnapshot
        present(vc, animated: true, completion: nil)
    }

    @objc
    private func logOut() {
        do {
            try Auth.auth().signOut()
            navigationController?.popViewController(animated: true)
        } catch {
            print("logout error")
        }
    }

}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contentArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.listTableViewCell, for: indexPath) else { return UITableViewCell() }

        let content = contentArray[indexPath.row]
        let date = content["date"] as! Timestamp
        cell.setCellData(date: date.dateValue(), content: String(describing: content["content"]!))
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedSnapshot = contentArray[indexPath.row]
        self.toPost()
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.delete(deleteIndexPath: indexPath)
            tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
        }
    }
}
