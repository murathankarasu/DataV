import UIKit
import Alamofire

class MainViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var text2: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var data: [YourCustomModel] = []
    var senderWorkstationID: Int = 0 // Başlatıcı ile varsayılan değer atanmış
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        fetchDataFromAPI()
    }
    
    struct YourCustomModel: Codable {
        let PWORKSTATIONID: Int
        // Diğer özellikler
    }
    
    func fetchDataFromAPI() {
        let apiUrl = "http://localhost:3000/api/data" // API URL'nizi buraya ekleyin
        
        AF.request(apiUrl).responseDecodable(of: [YourCustomModel].self) { response in
            switch response.result {
            case .success(let models):
                self.data = models
                self.pickerView.reloadAllComponents()
            case .failure(let error):
                print("Hata: \(error)")
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(data[row].PWORKSTATIONID)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        senderWorkstationID = data[row].PWORKSTATIONID
    }
    
    @IBAction func button(_ sender: Any) {
        performSegue(withIdentifier: "SG", sender: self) // `sender` olarak `self` kullanın
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SG" {
            if let destinationVC = segue.destination as? ViewController {
                if let selectedID = senderWorkstationID as? Int {
                    destinationVC.selectedWorkstationID = selectedID
                }
            }
        }
    }
}

