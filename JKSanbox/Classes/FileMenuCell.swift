//
//  UIFileMenuCell.swift
//  JKSanbox
//
//  Created by Junky on 2022/9/23.
//

import UIKit

class FileMenuCell: UICollectionViewCell {
    
    
    var model: FileActionModel? {
        didSet {
            nameLab.text = model?.name
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var nameLab: UILabel = {
        let tmp = UILabel()
        tmp.textAlignment = .center
        tmp.textColor = UIColor.systemBlue
        return tmp
    }()
    
}


extension FileMenuCell {
    func setupUI() {
        
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
    }
}
