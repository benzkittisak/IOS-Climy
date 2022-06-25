//
//  WeatherManager.swift
//  Climy
//
//  Created by Kittisak Panluea on 24/6/2565 BE.
//

import Foundation

struct WeatherManager {
    let weatherURL:String = "https://api.openweathermap.org/data/2.5/weather?appid=fe99ad0e670a43e24cdebc3f9a3b32e0&units=metric"
    
    func fetchWeather(cityName:String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString:String) {
        //        ในการติดต่อกับ API Server เราจะทำกัน 4 ขั้นตอน
        //        1. สร้าง URL
        //        สิ่งที่ได้จะเป็น Optional URL อะนะ ดังนั้นเราจะใช้ if let มาจัดการถ้ามันได้ url มาจริงๆ
        //        let url = URL(string: urlString)
        if let url = URL(string: urlString) {
            //        2. สร้าง URLSession
            let session = URLSession(configuration: .default)
            //        3. เอา session ที่สร้างได้มาเป็น task
            let task = session.dataTask(with: url) { data, reponse, error in
                guard error == nil else {
                    self.handle(.failure(error!))
                    return
                }
                
                self.handle(.success(data!))
            }
            //        4. สั่งให้ task เริ่มทำงาน
            task.resume()
        }
    }
    
    func handle(_ result:Result<Data , Error>){
        switch result {
        case let .success(data):
//            คือมันก็อ่านยากแหละนะเพราะว่ามันเป็น String อยู่
//            let dataString = String(data: data, encoding: .utf8)
//            print(dataString!)
//
//            เราก็จะเอามันไปแปลงให้เป็น JSON เพื่อให้มันอ่านง่ายขึ้นด้วย
            parseJSON(weatherData: data)
        case let .failure(error):
            print(error)
            return
        }
    }
    
    func parseJSON(weatherData:Data){
//        ก่อนจะเอาไปทำเป็น JSON ได้เราต้องมีหรือรู้ก่อนว่าโครงสร้างของข้อมูลมันเป็นยังไง ซึ่งโครงสร้างของข้อมูลที่จะรับมาจะ
//        อยู่ในไฟล์ WeatherData
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            print(decodedData.name)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}