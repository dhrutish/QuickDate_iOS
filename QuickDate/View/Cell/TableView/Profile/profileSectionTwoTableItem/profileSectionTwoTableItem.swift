//
//  profileSectionTwoTableItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
class profileSectionTwoTableItem: UITableViewCell {
    
    @IBOutlet weak var collectionViewProfileGride: UICollectionView!
    
    let HARIZONTAL_SPCE_IMAGE: CGFloat = 10
    let VERTICAL_SPCE_IMAGE: CGFloat = 1
    let COLUMN_IMAGE: CGFloat = 3
    
    var items: [[String : String]] = []
    var onDidSelect: ((IndexPath) -> ())?
    
    //MARK: - Life Cycle Function -
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionViewProfileGride.register(UINib(nibName: "ProfileGideCell", bundle: nil), forCellWithReuseIdentifier: "ProfileGideCell")
        self.collectionViewProfileGride.delegate = self
        self.collectionViewProfileGride.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func reloadCollectionView() {
        self.collectionViewProfileGride.reloadData()
    }
}

//MARK: - UICollectionView Delegate and DataSources Methods -
extension profileSectionTwoTableItem: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileGideCell", for: indexPath) as! ProfileGideCell
        cell.itemIconImage.image = UIImage(named: items[indexPath.row]["icon"]!)?.withRenderingMode(.alwaysTemplate)
        cell.labelItemTitle.text = items[indexPath.row]["title"]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.onDidSelect?(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { return 16 }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.frame.width - 32) / COLUMN_IMAGE
        print(width)
        return CGSize(width: width, height: width)
    }
}
