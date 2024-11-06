//
//  DetailsVC.swift
//  JobTask
//
//  Created by Selçuk İleri on 6.11.2024.
//

import UIKit
import SnapKit
import CoreData

class DetailsVC: UIViewController {
    
    let titleText = UITextField()
    let descriptionText = UITextField()
    let addButton = UIButton()
    
    var selectedTitle: String?
    var selectedDescription: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        
        if let title = selectedTitle {
            titleText.text = title
        }
        
        if let description = selectedDescription {
            descriptionText.text = description
        }
    }
    
    private func configure(){
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleText)
        view.addSubview(descriptionText)
        view.addSubview(addButton)
        
        let titlePadding = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: titleText.frame.height))
        let descriptionPadding = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: descriptionText.frame.height))
        
        titleText.placeholder = "Enter title"
        titleText.textColor = .label
        titleText.layer.borderColor = UIColor.lightGray.cgColor
        titleText.layer.borderWidth = 1.0
        titleText.layer.masksToBounds = true
        titleText.layer.cornerRadius = 10
        titleText.leftView = titlePadding
        titleText.leftViewMode = .always
        titleText.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        descriptionText.placeholder = "Enter Description"
        descriptionText.textColor = .label
        descriptionText.layer.borderColor = UIColor.lightGray.cgColor
        descriptionText.layer.borderWidth = 1.0
        descriptionText.layer.masksToBounds = true
        descriptionText.layer.cornerRadius = 10
        descriptionText.leftView = descriptionPadding
        descriptionText.leftViewMode = .always
        descriptionText.snp.makeConstraints { make in
            make.top.equalTo(titleText.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        addButton.setTitle("Save", for: .normal)
        addButton.setTitleColor(.label, for: .normal)
        addButton.layer.cornerRadius = 10
        addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        addButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionText.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    @objc func addButtonClicked() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newPlace = NSEntityDescription.insertNewObject(forEntityName: "Infos", into: context)
        
        if titleText.text == "" {
            makeAlert(title: "Alert", message: "Please enter a title!")
        } else if descriptionText.text == "" {
            makeAlert(title: "Alert", message: "Please enter a description!")
        } else {
            newPlace.setValue(titleText.text, forKey: "title")
            newPlace.setValue(descriptionText.text, forKey: "descriptionn")
            do {
                try context.save()
            } catch {
                makeAlert(title: "Uyarı", message: error.localizedDescription)
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}
