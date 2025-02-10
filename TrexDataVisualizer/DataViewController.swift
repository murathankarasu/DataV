import Foundation

struct YourDataModel: Codable {
    let quantity: Double
    let lossQty: Double
    let quantity2: Double
    let lossQty2: Double
    let quantity3: Double
    let lossQty3: Double
    
    enum CodingKeys: String, CodingKey {
        case quantity = "QUANTITY"
        case lossQty = "LOSSQTY"
        case quantity2 = "QUANTITY2"
        case lossQty2 = "LOSSQTY2"
        case quantity3 = "QUANTITY3"
        case lossQty3 = "LOSSQTY3"
    }
    
}
