//
//  UITableViewCell+ReuseIdentifier.swift
//  gzstudy
//
//  Created by hy110831 on 10/20/16.
//  Copyright © 2016 hy110831. All rights reserved.
//

import Foundation
import UIKit

func autocast<T>(some: Any) -> T? {
    return some as? T
}

extension UICollectionViewCell {
    
    class var defaultReuseIdentifier:String {
        return "\(self)"
    }
    
    
    class func dequeue(collectionView:UICollectionView, for indexPath:IndexPath) -> Self  {
        return autocast(some: collectionView.dequeueReusableCell(withReuseIdentifier: defaultReuseIdentifier, for: indexPath))!
    }
    
    class func registerXib(for tableView:UITableView) {
        tableView.register(UINib(nibName: defaultReuseIdentifier, bundle: nil),  forCellReuseIdentifier: defaultReuseIdentifier)
    }
    
}


extension UITableViewCell {
    
    class var defaultReuseIdentifier:String {
        return "\(self)"
    }
    
    class func dequeue(tableView:UITableView) -> Self?  {
        return autocast(some: tableView.dequeueReusableCell(withIdentifier: defaultReuseIdentifier)!)
    }
    
    class func dequeue(tableView:UITableView, for indexPath:IndexPath) -> Self  {
        return autocast(some: tableView.dequeueReusableCell(withIdentifier: defaultReuseIdentifier, for: indexPath))!
    }
    
    class func registerXib(for tableView:UITableView) {
        tableView.register(UINib(nibName: defaultReuseIdentifier, bundle: nil),  forCellReuseIdentifier: defaultReuseIdentifier)
    }
    
}
