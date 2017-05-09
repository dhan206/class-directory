//
//  DirectoryTableViewController.swift
//  Class Directory
//
//  Created by Will Kwon on 5/7/17.
//  Copyright © 2017 William Kwon. All rights reserved.
//

import UIKit
import CoreData

class DirectoryTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    var appDelegate: AppDelegate!
    var managedObjectContext: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showWelcomeDialogIfFirstTimeUser()
    }
    
    @IBAction func onAddTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Welcome", message: "Here's the directory of the class", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { (nameTextField) in
            nameTextField.placeholder = "Name"
        })
        alertController.addTextField(configurationHandler: { (ageTextField) in
            ageTextField.placeholder = "Age"
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (okClicked) in
            let name = alertController.textFields![0].text!
            let age = Int16(alertController.textFields![1].text!)!
            
            let student = NSEntityDescription.insertNewObject(forEntityName: "Student", into: self.managedObjectContext) as! Student
            student.name = name
            student.age = age
            
            do {
                try self.managedObjectContext.save()
            } catch {
                fatalError()
            }
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showWelcomeDialogIfFirstTimeUser() {
        let isNewUser = UserDefaults.standard.bool(forKey: "IsNewUser")
        if isNewUser {
            let alertController = UIAlertController(title: "Welcome", message: "Here's the directory of the class", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            
            UserDefaults.standard.set(false, forKey: "IsNewUser")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)

        let student = self.fetchedResultsController!.object(at: indexPath) as! Student
        
        cell.textLabel?.text = student.name
        cell.detailTextLabel?.text = String(student.age)

        return cell
    }
}
