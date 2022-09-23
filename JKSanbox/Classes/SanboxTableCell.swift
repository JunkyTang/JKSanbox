//
//  SanboxTableCell.swift
//  JKSanbox_Example
//
//  Created by Junky on 2022/9/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import SnapKit

class SanboxTableCell: UITableViewCell {

    var model: FileType? {
        didSet {
            
            guard let model else { return }
            let name = model.isDirectory ? "[\(model.name)]" : model.name
            nameLab.text = name
            
        }
    }
    
    var longPressBlock: ((FileType) -> Void)?
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    lazy var nameLab: UILabel = {
        let tmp = UILabel()
        tmp.numberOfLines = 0
        return tmp
    }()
    
    lazy var descLab: UILabel = {
        let tmp = UILabel()
        return tmp
    }()
    
    func setupUI() {
        
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(8)
        }
        
        
        contentView.addSubview(descLab)
        descLab.snp.makeConstraints { make in
            make.left.right.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom).offset(5)
            make.bottom.equalTo(-8)
        }
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(sender:)))
        addGestureRecognizer(longPress)
        
    }
    
    
    @objc func didLongPress(sender: UILongPressGestureRecognizer) {
        
        if sender.state == .recognized {
            guard let model else { return }
            longPressBlock?(model)
        }
    }
    
}
