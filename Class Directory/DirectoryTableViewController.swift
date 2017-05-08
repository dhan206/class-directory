//
//  DirectoryTableViewController.swift
//  Class Directory
//
//  Created by Will Kwon on 5/7/17.
//  Copyright © 2017 William Kwon. All rights reserved.
//

import UIKit

class DirectoryTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showWelcomeDialogIfFirstTimeUser()
    }
    
    @IBAction func onAddTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Welcome", message: "Here's the directory of the class", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertController.addTextField(configurationHandler: { (nameTextField) in
            nameTextField.placeholder = "Name"
        })
        alertController.addTextField(configurationHandler: { (ageTextField) in
            ageTextField.placeholder = "Age"
        })
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    func showWelcomeDialogIfFirstTimeUser() {
        let hasSeenWelcomeDialog = UserDefaults.standard.bool(forKey: "HasSeenWelcomeDialog")
        if !hasSeenWelcomeDialog {
            let alertController = UIAlertController(title: "Welcome", message: "Here's the directory of the class", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            
            UserDefaults.standard.set(true, forKey: "HasSeenWelcomeDialog")
        }
    }
}
