import UIKit
import Alamofire
import Charts

class ViewController: UIViewController {
        
    @IBOutlet weak var label: UILabel!
    
    var barChartView1: BarChartView!
    var barChartView2: BarChartView!
    var barChartView3: BarChartView!
    
    var selectedWorkstationID: Int?
    
    var quantityKey = "QUANTITY"
    var lossQtyKey = "LOSSQTY"
    
    var selectedId: Int?
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBarCharts()
        fetchDataFromAPI()
        
        if let workstationID = selectedWorkstationID {
                   label.text = "Seçilen Workstation ID: \(workstationID)"
        } else {
            label.text = "404"}
          }

    
    
    func fetchDataFromAPI() {
        let workstationID = "55" // Varsayılan workstationID
        let apiUrl = "http://localhost:3000/api/data/\(workstationID)"

        AF.request(apiUrl).responseJSON { [weak self] response in
            switch response.result {
            case .success(let value):
                if let jsonData = try? JSONSerialization.data(withJSONObject: value),
                   let data = try? JSONDecoder().decode(YourDataModel.self, from: jsonData) {
                    let chartData1 = [
                        self?.quantityKey ?? "QUANTITY": data.quantity,
                        self?.lossQtyKey ?? "LOSSQTY": data.lossQty,
                    ]
                    let chartData2 = [
                        self?.quantityKey ?? "QUANTITY": data.quantity2,
                        self?.lossQtyKey ?? "LOSSQTY": data.lossQty2,
                    ]
                    let chartData3 = [
                        self?.quantityKey ?? "QUANTITY": data.quantity3,
                        self?.lossQtyKey ?? "LOSSQTY": data.lossQty3,
                    ]
                    self?.updateBarCharts(data1: chartData1, data2: chartData2, data3: chartData3)
                }
            case .failure(let error):
                print("Veri çekme hatası: \(error.localizedDescription)")
            }
        }
    }
    
    func createBarCharts() {
        let chartHeight: CGFloat = 200 // Her bir grafik yüksekliği
        let topMargin: CGFloat = 150 // Üst boşluk
        
        // İlk grafik
        barChartView1 = BarChartView()
        barChartView1.frame = CGRect(x: 0, y: topMargin,
                                    width: self.view.frame.size.width,
                                    height: chartHeight)
        view.addSubview(barChartView1)
        
        // İkinci grafik
        barChartView2 = BarChartView()
        barChartView2.frame = CGRect(x: 0, y: topMargin + chartHeight + 10,
                                    width: self.view.frame.size.width,
                                    height: chartHeight)
        view.addSubview(barChartView2)
        
        // Üçüncü grafik
        barChartView3 = BarChartView()
        barChartView3.frame = CGRect(x: 0, y: topMargin + (chartHeight + 10) * 2,
                                    width: self.view.frame.size.width,
                                    height: chartHeight)
        view.addSubview(barChartView3)
    }

    func updateBarCharts(data1: [String: Any], data2: [String: Any], data3: [String: Any]) {
        var entries1 = [BarChartDataEntry]()
        var entries2 = [BarChartDataEntry]()
        var entries3 = [BarChartDataEntry]()

        if let quantity1 = data1[quantityKey] as? Double,
           let lossQty1 = data1[lossQtyKey] as? Double {
            entries1.append(BarChartDataEntry(x: 0.0, y: quantity1))
            entries1.append(BarChartDataEntry(x: 1.0, y: lossQty1))
        }
        
        if let quantity2 = data2[quantityKey] as? Double,
           let lossQty2 = data2[lossQtyKey] as? Double {
            entries2.append(BarChartDataEntry(x: 0.0, y: quantity2))
            entries2.append(BarChartDataEntry(x: 1.0, y: lossQty2))
        }
        
        if let quantity3 = data3[quantityKey] as? Double,
           let lossQty3 = data3[lossQtyKey] as? Double {
            entries3.append(BarChartDataEntry(x: 0.0, y: quantity3))
            entries3.append(BarChartDataEntry(x: 1.0, y: lossQty3))
        }

        let set1 = BarChartDataSet(entries: entries1, label: "Grafik 1")
        let set2 = BarChartDataSet(entries: entries2, label: "Grafik 2")
        let set3 = BarChartDataSet(entries: entries3, label: "Grafik 3")
        
        set1.colors = ChartColorTemplates.joyful()
        set2.colors = ChartColorTemplates.joyful()
        set3.colors = ChartColorTemplates.joyful()
        
        let chartData1 = BarChartData(dataSet: set1)
        let chartData2 = BarChartData(dataSet: set2)
        let chartData3 = BarChartData(dataSet: set3)

        // X ekseni etiketleri için özel bir konfigürasyon oluşturun
        let xAxis1 = barChartView1.xAxis
        xAxis1.valueFormatter = IndexAxisValueFormatter(values: [quantityKey, lossQtyKey])
        xAxis1.labelCount = 2

        let xAxis2 = barChartView2.xAxis
        xAxis2.valueFormatter = IndexAxisValueFormatter(values: [quantityKey, lossQtyKey])
        xAxis2.labelCount = 2

        let xAxis3 = barChartView3.xAxis
        xAxis3.valueFormatter = IndexAxisValueFormatter(values: [quantityKey, lossQtyKey])
        xAxis3.labelCount = 2

        // Veri etiketleri görünür yapmak için
        set1.drawValuesEnabled = true
        set2.drawValuesEnabled = true
        set3.drawValuesEnabled = true

        // Her bir grafik görünümüne veriyi ata
        barChartView1.data = chartData1
        barChartView2.data = chartData2
        barChartView3.data = chartData3
    }
}

