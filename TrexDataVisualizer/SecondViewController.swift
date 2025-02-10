import UIKit
import Alamofire
import Charts

class SecondViewController: UIViewController {

    var lineChartView1: LineChartView!
    var lineChartView2: LineChartView!
    var lineChartView3: LineChartView!
    
    var quantityKey = "QUANTITY"
    var lossQtyKey = "LOSSQTY"

    override func viewDidLoad() {
        super.viewDidLoad()
        createLineCharts()
        fetchDataFromAPI()
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
                    self?.updateLineCharts(data1: chartData1, data2: chartData2, data3: chartData3)
                }
            case .failure(let error):
                print("Veri çekme hatası: \(error.localizedDescription)")
            }
        }
    }

    func createLineCharts() {
        let chartHeight: CGFloat = 200 // Her bir grafik yüksekliği
        let topMargin: CGFloat = 150 // Üst boşluk
        
        // İlk grafik
        lineChartView1 = LineChartView()
        lineChartView1.frame = CGRect(x: 0, y: topMargin,
                                    width: self.view.frame.size.width,
                                    height: chartHeight)
        view.addSubview(lineChartView1)
        
        // İkinci grafik
        lineChartView2 = LineChartView()
        lineChartView2.frame = CGRect(x: 0, y: topMargin + chartHeight + 10,
                                    width: self.view.frame.size.width,
                                    height: chartHeight)
        view.addSubview(lineChartView2)
        
        // Üçüncü grafik
        lineChartView3 = LineChartView()
        lineChartView3.frame = CGRect(x: 0, y: topMargin + (chartHeight + 10) * 2,
                                    width: self.view.frame.size.width,
                                    height: chartHeight)
        view.addSubview(lineChartView3)
    }

    func updateLineCharts(data1: [String: Any], data2: [String: Any], data3: [String: Any]) {
        // Verileri hazırlayın
        var entries1 = [ChartDataEntry]()
        var entries2 = [ChartDataEntry]()
        var entries3 = [ChartDataEntry]()

        if let quantity1 = data1[quantityKey] as? Double,
           let lossQty1 = data1[lossQtyKey] as? Double {
            entries1.append(ChartDataEntry(x: 0.0, y: quantity1))
            entries1.append(ChartDataEntry(x: 1.0, y: lossQty1))
        }
        
        if let quantity2 = data2[quantityKey] as? Double,
           let lossQty2 = data2[lossQtyKey] as? Double {
            entries2.append(ChartDataEntry(x: 0.0, y: quantity2))
            entries2.append(ChartDataEntry(x: 1.0, y: lossQty2))
        }
        
        if let quantity3 = data3[quantityKey] as? Double,
           let lossQty3 = data3[lossQtyKey] as? Double {
            entries3.append(ChartDataEntry(x: 0.0, y: quantity3))
            entries3.append(ChartDataEntry(x: 1.0, y: lossQty3))
        }

        // Veri setleri oluşturun
        let dataSet1 = LineChartDataSet(entries: entries1, label: "Grafik 1")
        let dataSet2 = LineChartDataSet(entries: entries2, label: "Grafik 2")
        let dataSet3 = LineChartDataSet(entries: entries3, label: "Grafik 3")
        
        // Renkleri ayarlayın
        dataSet1.colors = [NSUIColor.blue]
        dataSet2.colors = [NSUIColor.red]
        dataSet3.colors = [NSUIColor.green]
        
        // Veri etiketlerini görünür yapın
        dataSet1.drawValuesEnabled = true
        dataSet2.drawValuesEnabled = true
        dataSet3.drawValuesEnabled = true

        // Grafiği güncelleyin
        let lineChartData1 = LineChartData(dataSet: dataSet1)
        let lineChartData2 = LineChartData(dataSet: dataSet2)
        let lineChartData3 = LineChartData(dataSet: dataSet3)
        
        lineChartView1.data = lineChartData1
        lineChartView2.data = lineChartData2
        lineChartView3.data = lineChartData3
    }
}

