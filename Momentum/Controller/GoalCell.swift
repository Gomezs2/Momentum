//
//  GoalCell.swift
//  Momentum
//
//  Created by Kevin Kim on 3/20/19.
//  Copyright © 2019 Triceratops. All rights reserved.
//

import Foundation
import UIKit

class GoalCell: UITableViewCell {
    var title : String?
    var progress : Int?
    
    var titleView : UITextView = {
        var titleView = UITextView()
        titleView.translatesAutoresizingMaskIntoConstraints = false
        return titleView
    }()
    
    var progressView : UIProgressView = {
        var progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        super.addSubview(titleView)
        super.addSubview(progressView)
        
        titleView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        titleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        titleView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        
        progressView.leftAnchor.constraint(equalTo: self.titleView.rightAnchor).isActive = true
        progressView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        progressView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        progressView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let title = title {
            titleView.text = title
        }
        if let progress = progress {
            progressView.progress = 50
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("Init(coder:) has not been implemented")
    }
}
