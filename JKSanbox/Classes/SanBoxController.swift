//
//  JKSanBoxFileController.swift
//  JKSanbox
//
//  Created by Junky on 2022/9/23.
//

import UIKit

class SanBoxController: UIViewController {

    
    var model: FileType = NSHomeDirectory()
    private var list: [FileType] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupUI()
        refreshData()
    }
    
    
    lazy var table: UITableView = {
        let tmp = UITableView(frame: view.bounds, style: .plain)
        tmp.delegate = self
        tmp.dataSource = self
        tmp.register(SanboxTableCell.self, forCellReuseIdentifier: "SanboxTableCell")
        tmp.rowHeight = 60
        return tmp
    }()
    

}


extension SanBoxController: UITableViewDataSource, UITableViewDelegate {
    
    
    func setupUI() {
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "action", style: .plain, target: self, action: #selector(actionNaviRight))
        
        view.addSubview(table)
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func actionNaviRight() {
        
        let vc = FileMenuController(file: model)
        vc.refreshBlock = { [weak self] in
            self?.refreshData()
        }
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SanboxTableCell", for: indexPath) as! SanboxTableCell
        let file = list[indexPath.row]
        cell.model = file
        cell.longPressBlock = { [weak self] sender in
            let vc = FileMenuController(file: sender)
            vc.refreshBlock = {
                self?.refreshData()
            }
            self?.present(vc, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let file = list[indexPath.row]
        didTapFile(file: file)
    }
    
    
    func didTapFile(file: FileType) {
        
        if file.isDirectory {
            let vc = SanBoxController()
            vc.model = file
            navigationController?.pushViewController(vc, animated: true)
        }else{
            
            if file.fileSize > 1024 * 1024 {
                return
            }
            
            let vc = FileDetailController(file: file)
            navigationController?.pushViewController(vc, animated: true)
        }
    
    }
    
    
    
    func refreshData() {
        title = model.name
        list = model.subList
        print(">>>>>>>>>>>>>>><<<<<<<<<<<<<<<")
        print(model.attribute)
        print(model.isDirectory)
        print(">>>>>>>>>>>>>>><<<<<<<<<<<<<<<")
        table.reloadData()
    }
    
}
