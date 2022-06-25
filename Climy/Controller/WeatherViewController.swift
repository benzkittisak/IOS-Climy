//
//  ViewController.swift
//  Climy
//
//  Created by Kittisak Panluea on 24/6/2565 BE.
//

import UIKit

// UITextFieldDelegate มันเป็น class ที่ช่วยให้เราจัดการกับการแก้ไขการตรวจสอบข้อความต่าง ๆ บน textfield น่ะนะ

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionalIV: UIImageView!
    
    @IBOutlet weak var temperatureLB: UILabel!
    @IBOutlet weak var cityLB: UILabel!
    
    @IBOutlet weak var searchTF: UITextField!
    
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //        delegate เป็นตัวจัดการกับการตอบสนองของข้อความต่าง ๆ รวมไปถึงคำสั่งพิเศษที่เกิดขึ้นใน textfield เช่นว่า
        //        เห้ยผู้ใช้กดตุ่ม GO มาจะให้ทำไรอะ หรือเห้ยผู้ใช้ไปกดอะไรนอก textfield แล้วจะให้ปิดคีย์บอร์ดไหมฟร้ะ
        searchTF.delegate = self
        weatherManager.delegate = self
    }
    
}

//MARK: - UITextFieldDelegate Section

// ต่อไปเราจะมาใช้ตัว extensions กัน
// extensions เป็นฟังก์ชันที่ช่วยให้เราเพิ่มความสามารถให้กับ class ปัจจุบันได้
// อารมณ์แบบว่าเราทำงานเสร็จไปแล้ว แล้วลูกค้าบอกว่าเอ๊อยากเพิ่มฟังก์ชันนี้เข้าไปในแอปของเค้า
// เเล้วเราไม่ต้องการที่จะไปแก้โค้ดใน class ให้มันมีปัญหา ดังนั้น extensions ก็จะมาช่วยเราในส่วนนี้

extension WeatherViewController:UITextFieldDelegate {
    //    จากนั้นเราจะทำการย้ายโค้ดที่เกี่ยวกับ textfield ทั้งหมดมาไว้ที่นี่ class มาอยู่ที่นี่
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTF.endEditing(true)
        print(searchTF.text!)
    }
    
    
    //    ฟังก์ชันนี้เอาไว้จัดการเวลาที่ผู้ใช้กดตุ่ม Return มาเหมือนตุ่ม enter แหละ
    //    แล้วพอเค้ากดมาจะให้ทำไรฟร้ะ อะไรแบบนั้น
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTF.endEditing(true)
        print(searchTF.text!)
        return true
    }
    
    //    อันต่อไปคือเมื่อผู้ใช้กดไปที่ textfield หรือกดอะไรที่ไม่ได้อยู่ใน textfield จะให้มันทำอะไรต่อ
    //    อารมณ์แบบว่าขอโทษนะ controller ผู้ใช้เค้ากดไปนอกคีย์บอร์ดแล้วจะให้ปิดคีย์บอร์ดเลยไหม มันจะต่างจาก method อัน
    //    textFieldDidEndEditing อันนั้นจะทำงานหลังจากที่คีย์บอร์ดมันหายไปแล้วหรือจบการพิมพ์แล้ว แต่อันนี้คือมันจะทำงานระหว่าง
    //    ที่คีย์บอร์ดกำลังเปิดอยู่ แล้วกำลังลังเลว่าเอ๊ะ ชั้นจะปิดตัวเองดีไหมนะ หรือยังดี
    //    เราใช้มันเอาไว้เช็คค่าได้ด้วยว่าถ้าผู้ใช้ยังไม่พิมพ์อะไรมาใน textview เลยแต่เราไปกดข้างนอกคีย์บอร์ดแล้ว แล้วจะให้ปิดคีย์บอร์ด
    //    ไหม หรือว่าจะไม่ปิดจนกว่าผู้ใช้จะพิมพ์มา ยาวจังฟร้ะ
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTF.text != nil {
            //            return true แปลว่าปิดคีย์บอร์ดได้เลยคา
            return true
        } else {
            searchTF.placeholder = "Type Someting"
            //            return false แปลว่ายังไม่ปิดคา
            return false
        }
    }
    
    //    อันต่อไปคือเวลาที่เรากดตุ่มค้นหาแล้ว ข้อความที่อยู่ใน textfield มันควรจะหายไปเพื่อให้เราพิมพ์ชื่อเมืองอันใหม่เข้าไปใช่ป่ะ
    //    เราจะใช้ไอ้เจ้า method ตัวข้างล่างมาจัดการ มันจะอารมณ์ว่า controller โว๊ยยคนใช้เค้าหยุดพิมพ์แล้วจะให้ทำไรต่อฟร้ะ
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTF.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTF.text = ""
    }
    
}

//MARK: - WeatherManagerDelegate Section

// จากนั้นจะทำการใช้ extension อีกตัว
extension WeatherViewController:WeatherManagerDelegate {
    //    จากนั้นก็ทำการย้ายโค้ดที่เป็นส่วนของ WeatherManager มาไว้ที่นี่
    
    //    ฟังก์ชันที่รับค่ามาจาก Weather Manager แล้วก็จะเอามาอัปเดตข้อมูลใน UI
    //    มาจาก protocol แหละ
    func didUpdateWeather(_ weatherManager : WeatherManager , weather:WeatherModel) {
        
        //        ตอนนี้มันจะมีปัญหาเรื่องของ Thead เพราะว่าตัวการทำงานของเราพวก API มันทำงานอยู่เบื้องหลัง มันต้องใช้เวลา
        //        ฉะนั้นเวลาที่เราพยายามจะอัปเดต UI มันจะ Error วิธีแก้ก็ให้ใช้ DispatchQueue
        //        temperatureLB.text = weather.temperatureString
        //        แบบนิ้
        DispatchQueue.main.async {
            self.temperatureLB.text = weather.temperatureString
            self.conditionalIV.image = UIImage(systemName: weather.conditionName)
            self.cityLB.text = weather.cityName
        }
    }
    
    func didFailureWithError(with error: Error) {
        print(error.localizedDescription)
    }
//    ทีนี้ class หลักของเราก็จะมีโค้ดจึ๋งนึง
}
