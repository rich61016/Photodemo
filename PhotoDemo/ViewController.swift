

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var text: UITextField!
    
    @IBOutlet weak var qty: UITextField!
    
    @IBOutlet weak var search: UIButton!
    
    @IBAction func searchbtn(_ sender: Any) {
    
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        search.isEnabled = false;
        text.addTarget(self, action:  #selector(textFieldDidChange(_:)),  for:.editingChanged )
        qty.addTarget(self, action:  #selector(textFieldDidChange(_:)),  for:.editingChanged )
    }
    
    @objc func textFieldDidChange(_ sender: UITextField) {
        if text.text == "" || qty.text == "" {
            search.isEnabled = false;
        }else{
            search.backgroundColor = UIColor.blue
             search.isEnabled = true;
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       let vc = segue.destination as! FlickrSearchCollectionViewController
        vc.text = text.text!
        vc.qty = qty.text!
    }
    
}
