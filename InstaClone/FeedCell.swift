//
//  FeedCell.swift
//  InstaClone
//
//  Created by Omer Keskin on 7.03.2024.
//

import UIKit
import Firebase

class FeedCell: UITableViewCell {

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var imageTableView: UIImageView!
    @IBOutlet weak var documentIdLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        
        let firestoreDataBase = Firestore.firestore()
        if let likeCount = Int(likeLabel.text!){
            
            let likeStore = ["likes" : likeCount + 1] as [String : Any]
            firestoreDataBase.collection("Posts").document(documentIdLabel.text!).setData(likeStore, merge: true)
        }
        
    }
    
}
