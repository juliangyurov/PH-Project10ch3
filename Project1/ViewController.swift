//
//  ViewController.swift
//  Project1
//
//  Created by Yulian Gyuroff on 17.09.23.
//

import UIKit

class ViewController: UICollectionViewController {
    
    var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Storm Viewer"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            let items = try! fm.contentsOfDirectory(atPath: path)
            for item in items {
                //print(item)
                if item.hasPrefix("nssl"){
                    //This is picture to load
                    self?.pictures.append(item)
                }
                self?.pictures.sort()
            }
            print(self?.pictures ?? ["NA"])
            
            DispatchQueue.main.async {
                [weak self] in
                self?.collectionView.reloadData()
            }
        }
 
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.selectedNumber = indexPath.row
            vc.numberImages = pictures.count
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
//            vc.selectedImage = pictures[indexPath.row]
//            vc.selectedNumber = indexPath.row
//            vc.numberImages = pictures.count
//            navigationController?.pushViewController(vc, animated: true)
//        }
//
//    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return pictures.count
//    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath) as? PictureCell else{ fatalError("Cannot dequeue reusable cell") }
        
        let label = cell.contentView.subviews.last as? UILabel
        label?.text  = pictures[indexPath.row]
        
        cell.imageView.image = UIImage(named: pictures[indexPath.row])
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }

//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
//        cell.textLabel?.text = pictures[indexPath.row]
//        return cell
//    }
    
    @objc func shareTapped(){
        let vc = UIActivityViewController(activityItems: ["Check my new app \"Storm Viewer\""], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

}

