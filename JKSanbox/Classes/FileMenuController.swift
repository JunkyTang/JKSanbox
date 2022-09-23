//
//  JKFileMenuController.swift
//  JKSanbox
//
//  Created by Junky on 2022/9/23.
//

import UIKit

class FileMenuController: UIViewController {
    
    static var fileWillBeMove: FileType?
    
    var model: FileType
    var list: [FileActionModel] = []
    
    var refreshBlock: (() -> Void)?
    
    init(file: FileType) {
        self.model = file
        super.init(nibName: nil, bundle: nil)
        super.modalTransitionStyle = .coverVertical
        super.modalPresentationStyle = .overCurrentContext
        self.list = FileActionModel.actionFile(file, target: self)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    
    lazy var bgBtn: UIButton = {
        let tmp = UIButton(type: .custom)
        tmp.addTarget(self, action: #selector(hide), for: .touchUpInside)
        return tmp
    }()
    
    
    lazy var container: UIView = {
        let tmp = UIView()
        tmp.backgroundColor = UIColor.white
        return tmp
    }()
    
    
    lazy var fileNameFld: UITextField = {
        let tmp = UITextField()
        tmp.placeholder = "请输入新文件名称"
        return tmp
    }()
    
    lazy var sureBtn: UIButton = {
        let tmp = UIButton(type: .roundedRect)
        tmp.setTitle("确定", for: .normal)
        tmp.addTarget(self, action: #selector(actionSure), for: .touchUpInside)
        return tmp
    }()
    
    @objc func actionSure() {
        bar.isHidden = true
        guard var name = fileNameFld.text else {
            return
        }
        
        let folderPre = name.hasPrefix("[")
        let folderSub = name.hasSuffix("]")
        let isFolder = folderPre && folderSub
        if isFolder {
            name.removeFirst()
            name.removeLast()
        }
        
        if name.count == 0 {
            return
        }
        if isFolder {
            model.createFolder(name)
        }
        else{
            model.createFile(name)
        }
        refreshBlock?()
    }
    
    
    lazy var bar: UIView = {
        let tmp = UIView()
        tmp.backgroundColor = UIColor.white
        tmp.isHidden = true
        return tmp
    }()
    
    
    lazy var collect: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let width = (view.bounds.size.width - 30) / 2
        layout.itemSize = CGSize(width: width, height: 44)
        
        
        let tmp = UICollectionView(frame: .zero, collectionViewLayout: layout)
        tmp.delegate = self
        tmp.dataSource = self
        tmp.backgroundColor = .clear
        tmp.register(FileMenuCell.self, forCellWithReuseIdentifier: "FileMenuCell")
        return tmp
    }()
    
    
    
}

extension FileMenuController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func setupUI() {
        
        view.backgroundColor = UIColor.clear
        
        
        view.addSubview(bgBtn)
        bgBtn.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        
        view.addSubview(container)
        container.snp.makeConstraints { make in
            make.bottom.left.right.equalTo(view)
        }
        
        
        var rows = list.count / 2
        if list.count % 2 != 0 {
            rows = rows + 1
        }
        
        container.addSubview(collect)
        collect.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(15)
            make.bottom.equalTo(container.snp.bottomMargin).offset(-15)
            make.height.equalTo(rows * 54)
        }
        
        
        bar.addSubview(sureBtn)
        sureBtn.snp.makeConstraints { make in
            make.right.top.bottom.equalTo(0)
            make.width.equalTo(80)
            make.height.equalTo(44)
        }
        
        bar.addSubview(fileNameFld)
        fileNameFld.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(sureBtn.snp.left).offset(-15)
            make.top.bottom.equalTo(0)
        }
        
        
        view.addSubview(bar)
        bar.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.bottom.equalTo(container.snp.top)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FileMenuCell", for: indexPath) as! FileMenuCell
        let action = list[indexPath.item]
        cell.model = action
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let action = list[indexPath.item]
        action.method()
    }
    
    
    
    @objc func hide() {
        dismiss(animated: true)
    }
    
    
    
}

// action
extension FileMenuController {
    func actionNew() {
        bar.isHidden = false
    }
    
    func actionRefresh() {
        
        refreshBlock?()
    }
    
    func actionDelete() {
        
        model.remove()
        refreshBlock?()
        hide()
    }
    
    
    func actionMoveStart() {
        FileMenuController.fileWillBeMove = model
    }
    
    func actionMoveEnd() {
        
        guard let willMovedFile = FileMenuController.fileWillBeMove else { return }
        let name = willMovedFile.name
        let toPath = model.path + "/" + name
        try? FileManager.default.moveItem(atPath: willMovedFile.path, toPath: toPath)
        FileMenuController.fileWillBeMove = nil
        refreshBlock?()
    }
    
}



struct FileActionModel {
    
    let name: String
        
    let method: () -> Void
    
    
    static func actionFile(_ file: FileType, target: FileMenuController) -> [FileActionModel] {
        
        var result: [FileActionModel] = []
        
        if file.isDirectory {
            result.append(FileActionModel(name: "新建", method: target.actionNew))
            result.append(FileActionModel(name: "刷新", method: target.actionRefresh))
            if let _ = FileMenuController.fileWillBeMove {
                result.append(FileActionModel(name: "这里", method: target.actionMoveEnd))
            }
        }
        else {
            if FileManager.default.isDeletableFile(atPath: file.path) {
                result.append(FileActionModel(name: "删除", method: target.actionDelete))
            }
            result.append(FileActionModel(name: "移到", method: target.actionMoveStart))
        }
        return result
    }
    
}




