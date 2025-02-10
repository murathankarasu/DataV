import UIKit
import Alamofire
import Charts

class ThirdViewController: UIViewController {

    var pieChartView1: PieChartView!
    var pieChartView2: PieChartView!
    var pieChartView3: PieChartView!
    
    var quantityKey = "QUANTITY"
    var lossQtyKey = "LOSSQTY"

    override func viewDidLoad() {
        super.viewDidLoad()
        createPieCharts()
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
                    self?.updatePieCharts(data1: chartData1, data2: chartData2, data3: chartData3)
                }
            case .failure(let error):
                print("Veri çekme hatası: \(error.localizedDescription)")
            }
        }
    }

    func createPieCharts() {
        let chartWidth: CGFloat = 200 // Her bir grafik genişliği
        let chartHeight: CGFloat = 200 // Her bir grafik yüksekliği
        let topMargin: CGFloat = 150 // Üst boşluk
        
        // İlk grafik
        pieChartView1 = PieChartView()
        pieChartView1.frame = CGRect(x: (self.view.frame.size.width - chartWidth) / 2, y: topMargin,
                                    width: chartWidth,
                                    height: chartHeight)
        view.addSubview(pieChartView1)
        
        // İkinci grafik
        pieChartView2 = PieChartView()
        pieChartView2.frame = CGRect(x: (self.view.frame.size.width - chartWidth) / 2, y: topMargin + chartHeight + 10,
                                    width: chartWidth,
                                    height: chartHeight)
        view.addSubview(pieChartView2)
        
        // Üçüncü grafik
        pieChartView3 = PieChartView()
        pieChartView3.frame = CGRect(x: (self.view.frame.size.width - chartWidth) / 2, y: topMargin + (chartHeight + 10) * 2,
                                    width: chartWidth,
                                    height: chartHeight)
        view.addSubview(pieChartView3)
    }

    func updatePieCharts(data1: [String: Any], data2: [String: Any], data3: [String: Any]) {
        var entries1 = [PieChartDataEntry]()
        var entries2 = [PieChartDataEntry]()
        var entries3 = [PieChartDataEntry]()

        if let quantity1 = data1[quantityKey] as? Double,
           let lossQty1 = data1[lossQtyKey] as? Double {
            entries1.append(PieChartDataEntry(value: quantity1, label: quantityKey))
            entries1.append(PieChartDataEntry(value: lossQty1, label: lossQtyKey))
        }
        
        if let quantity2 = data2[quantityKey] as? Double,
           let lossQty2 = data2[lossQtyKey] as? Double {
            entries2.append(PieChartDataEntry(value: quantity2, label: quantityKey))
            entries2.append(PieChartDataEntry(value: lossQty2, label: lossQtyKey))
        }
        
        if let quantity3 = data3[quantityKey] as? Double,
           let lossQty3 = data3[lossQtyKey] as? Double {
            entries3.append(PieChartDataEntry(value: quantity3, label: quantityKey))
            entries3.append(PieChartDataEntry(value: lossQty3, label: lossQtyKey))
        }

        let dataSet1 = PieChartDataSet(entries: entries1, label: "Grafik 1")
        let dataSet2 = PieChartDataSet(entries: entries2, label: "Grafik 2")
        let dataSet3 = PieChartDataSet(entries: entries3, label: "Grafik 3")
        
        dataSet1.colors = ChartColorTemplates.joyful()
        dataSet2.colors = ChartColorTemplates.joyful()
        dataSet3.colors = ChartColorTemplates.joyful()

        // Veri etiketleri görünür yapmak için
        dataSet1.drawValuesEnabled = true
        dataSet2.drawValuesEnabled = true
        dataSet3.drawValuesEnabled = true

        // Tüm değerler sıfırsa dilimler arasında boşluk ekle
        if entries1.allSatisfy({ $0.value == 0.0 }) {
            dataSet1.sliceSpace = 1.0
        }

        if entries2.allSatisfy({ $0.value == 0.0 }) {
            dataSet2.sliceSpace = 1.0
        }

        if entries3.allSatisfy({ $0.value == 0.0 }) {
            dataSet3.sliceSpace = 1.0
        }

        // Pasta grafiği güncelle
        let pieChartData1 = PieChartData(dataSet: dataSet1)
        let pieChartData2 = PieChartData(dataSet: dataSet2)
        let pieChartData3 = PieChartData(dataSet: dataSet3)
        
        pieChartView1.data = pieChartData1
        pieChartView2.data = pieChartData2
        pieChartView3.data = pieChartData3
    }
}

