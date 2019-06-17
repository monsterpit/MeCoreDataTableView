//
//  TableViewCell.swift
//  MeCoreDataTableView
//
//  Created by MB on 6/18/19.
//  Copyright © 2019 MB. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var photoImage: UIImageView!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func setPhotoCellWith(photo: Photo) {
        DispatchQueue.main.async {
            self.authorLabel.text = photo.author
            self.tagLabel.text = photo.tags
            
            
            if let url = photo.mediaURL {
                self.photoImage.loadImageUsingCacheWithURLString(url, placeHolder: UIImage(named: "placeholder"))
            }
        }
    }
}
