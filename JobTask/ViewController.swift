//
//  ViewController.swift
//  JobTask
//
//  Created by Selçuk İleri on 6.11.2024.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    var lists = [String]()
    var descriptions = [String]()
    var selectedTitle: String?
    var selectedDescription: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    private func configure(){
        view.backgroundColor = .systemBackground
        let addButton = UIBarButtonItem(image: .add, style: .done, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func setupTableView(){
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Infos")
            
            do {
                let results = try context.fetch(fetchRequest) as! [NSManagedObject]
                
                context.delete(results[indexPath.row])
                lists.remove(at: indexPath.row)
                
                try context.save()
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            } catch {
                print("Silme işlemi başarısız: \(error)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = lists[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTitle = lists[indexPath.row]
        selectedDescription = descriptions[indexPath.row]
        
        let detailsVC = DetailsVC()
        detailsVC.selectedTitle = selectedTitle
        detailsVC.selectedDescription = selectedDescription
        
        navigationController?.pushViewController(detailsVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func addTapped(){
        let detailsVC = DetailsVC()
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    private func fetchData(){
        lists.removeAll()
        descriptions.removeAll()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Infos")
        
        do {
            let results = try context.fetch(fetchRequest) as! [NSManagedObject]
            for result in results {
                if let title = result.value(forKey: "title") as? String,
                   let description = result.value(forKey: "descriptionn") as? String {
                    lists.append(title)
                    descriptions.append(description)
                }
            }
            tableView.reloadData()
        } catch {
            print("Data fetch failed: \(error)")
        }
    }
}
