//
//  ViewController.swift
//  Climy
//
//  Created by Kittisak Panluea on 24/6/2565 BE.
//

import UIKit

// UITextFieldDelegate มันเป็น class ที่ช่วยให้เราจัดการกับการแก้ไขการตรวจสอบข้อความต่าง ๆ บน textfield น่ะนะ

class WeatherViewController: UIViewController , UITextFieldDelegate{

    @IBOutlet weak var conditionalIV: UIImageView!
    
    @IBOutlet weak var temperatureLB: UILabel!
    @IBOutlet weak var cityLB: UILabel!
    
    @IBOutlet weak var searchTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        delegate เป็นตัวจัดการกับการตอบสนองของข้อความต่าง ๆ รวมไปถึงคำสั่งพิเศษที่เกิดขึ้นใน textfield เช่นว่า
//        เห้ยผู้ใช้กดตุ่ม GO มาจะให้ทำไรอะ หรือเห้ยผู้ใช้ไปกดอะไรนอก textfield แล้วจะให้ปิดคีย์บอร์ดไหมฟร้ะ
        searchTF.delegate = self
    }

    @IBAction func searchPressed(_ sender: UIButton) {
        searchTF.endEditing(true)
        print(searchTF.text!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
//    ฟังก์ชันนี้เอาไว้จัดการเวลาที่ผู้ใช้กดตุ่ม Return มาเหมือนตุ่ม enter แหละ
//    แล้วพอเค้ากดมาจะให้ทำไรฟร้ะ อะไรแบบนั้น
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTF.endEditing(true)
        print(searchTF.text!)
        return true
    }
    
//    อันต่อไปคือเวลาที่เรากดตุ่มค้นหาแล้ว ข้อความที่อยู่ใน textfield มันควรจะหายไปเพื่อให้เราพิมพ์ชื่อเมืองอันใหม่เข้าไปใช่ป่ะ
//    เราจะใช้ไอ้เจ้า method ตัวข้างล่างมาจัดการ มันจะอารมณ์ว่า controller โว๊ยยคนใช้เค้าหยุดพิมพ์แล้วจะให้ทำไรต่อฟร้ะ
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchTF.text = ""
    }
    
}

