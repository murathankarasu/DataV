import UIKit
import Alamofire
import Charts

class ViewController: UIViewController {

    @IBOutlet weak var picker1: UIPickerView!
    
    var barChart = BarChartView()
    var chartData: [String: Any]?

    override func viewDidLoad() {
        super.viewDidLoad()
        barChart.delegate = self

        fetchDataFromAPI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        barChart.frame = CGRect(x: 0, y: 0,
                                width: self.view.frame.size.width,
                                height: self.view.frame.size.width)
        barChart.center = view.center
        view.addSubview(barChart)
    }

    func fetchDataFromAPI() {
        let workstationID = "55"
        let apiUrl = "http://localhost:3000/api/data/\(workstationID)"

        AF.request(apiUrl).responseJSON { [weak self] response in
            switch response.result {
            case .success(let value):
                if let jsonData = try? JSONSerialization.data(withJSONObject: value),
                   let data = try? JSONDecoder().decode(YourDataModel.self, from: jsonData) {
                    self?.chartData = [
                        "QUANTITY": data.quantity,
                        //"QUANTITY2": data.quantity2,
                        //"QUANTITY3": data.quantity3,
                        "LOSSQTY": data.lossQty,
                        //"LOSSQTY2": data.lossQty2,
                        //"LOSSQTY3": data.lossQty3
                    ]
                    self?.createBarChart()
                }
            case .failure(let error):
                print("Veri çekme hatası: \(error.localizedDescription)")
            }
        }
    }

    func createBarChart() {
        guard let data = chartData else {
            // Veri alınamadı, hata işleme kodunu ekleyin
            return
        }

        var entries = [BarChartDataEntry]()

        if let quantity = data["QUANTITY"] as? Double,
           //let quantity2 = data["QUANTITY2"] as? Double,
           //let quantity3 = data["QUANTITY3"] as? Double,
           let lossQty = data["LOSSQTY"] as? Double
           //let lossQty2 = data["LOSSQTY2"] as? Double,
           //let lossQty3 = data["LOSSQTY3"] as? Double
        {
            entries.append(BarChartDataEntry(x: 0.0, y: quantity))
            //entries.append(BarChartDataEntry(x: 1.0, y: quantity2))
            //entries.append(BarChartDataEntry(x: 2.0, y: quantity3))
            entries.append(BarChartDataEntry(x: 6.0, y: lossQty))
            //entries.append(BarChartDataEntry(x: 7.0, y: lossQty2))
            //entries.append(BarChartDataEntry(x: 8.0, y: lossQty3))
        }

        let set = BarChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.joyful()
        let chartData = BarChartData(dataSet: set)

        // X ekseni etiketleri için özel bir konfigürasyon oluşturun
        let xAxis = barChart.xAxis
        xAxis.valueFormatter = IndexAxisValueFormatter(values: ["QUANTITY","LOSSQTY"])
        xAxis.labelCount = 2 // Etiket sayısını veri noktalarının sayısına ayarlayın

        // Veri etiketleri görünür yapmak için
        set.drawValuesEnabled = true

        barChart.data = chartData
    }
}

extension ViewController: ChartViewDelegate {
    // Gerekirse grafik olaylarına yanıt vermek için bu uzantıyı kullanabilirsiniz
}

