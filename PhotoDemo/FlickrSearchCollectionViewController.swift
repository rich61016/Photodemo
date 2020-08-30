

import UIKit

private let reuseIdentifier = "Cell"


class FlickrSearchCollectionViewController: UICollectionViewController {

    var photos = [Photo]()
    
    var text:String!
    var qty:String!
    let refreshControl = UIRefreshControl()
    
   @objc  func fetchData() {
        if let url = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=e01d33b46cb13164b273fca2ed0031d4&text=\(text!)&per_page=\(qty!)&format=json&nojsoncallback=1") {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data, let searchData = try? JSONDecoder().decode(SearchData.self, from: data) {

                    self.photos = searchData.photos.photo

                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.refreshControl.endRefreshing()
                    }
                }

            }

            task.resume()
        }
        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "搜尋結果 \(text!)"
        let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let width = (view.bounds.width - 10) / 2
        layout?.itemSize = CGSize(width: width, height: width + 80)
        fetchData()
        
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            refreshControl.attributedTitle = NSAttributedString(string: "update", attributes: attributes)
            refreshControl.tintColor = UIColor.white
            refreshControl.backgroundColor = UIColor.black
            refreshControl.addTarget(self, action: #selector(fetchData), for:UIControl.Event.valueChanged)
            collectionView.refreshControl = refreshControl
    }

   
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return photos.count
    }

  
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
    
       
        let photo = photos[indexPath.item]
        cell.titleLabel.text = photo.title
        cell.imageURL = photo.imageUrl
        cell.photoImageView.image = nil
        NetworkUtility.downloadImage(url: cell.imageURL) { (image) in
            if cell.imageURL == photo.imageUrl, let image = image  {
                DispatchQueue.main.async {
                    cell.photoImageView.image = image
                }
            }
        }
       
        return cell
    }


}
