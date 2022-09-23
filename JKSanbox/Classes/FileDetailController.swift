//
//  FileDetailController.swift
//  JKSanbox
//
//  Created by Junky on 2022/9/23.
//

import UIKit

class FileDetailController: UIViewController {

    var file: FileType
    
    init(file: FileType) {
        self.file = file
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        textView.isEditable = FileManager.default.isWritableFile(atPath: file.path)
        
        let url = URL(fileURLWithPath: file.path, isDirectory: false)
        do {
            let data = try Data(contentsOf: url)
            let obj = String(data: data, encoding: .utf8)
            textView.text = obj
        } catch {
            textView.text = error.localizedDescription
        }
    }
    

    lazy var textView: UITextView = {
        let tmp = UITextView()
        tmp.delegate = self
        return tmp
    }()
    

}


extension FileDetailController: UITextViewDelegate {
    
    func setupUI() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(actionSave))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    @objc func actionSave() {
        
        guard let txt = textView.text else { return }
        let data = txt.data(using: .utf8)
        
        let url = URL(fileURLWithPath: file.path)
        try? data?.write(to: url)
        textView.endEditing(true)
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
}
