//
//  WeatherManager.swift
//  Climy
//
//  Created by Kittisak Panluea on 24/6/2565 BE.
//

import Foundation

// สร้าง protocols มาส่งข้อมูลเนาะ
protocol WeatherManagerDelegate {
//    delegate นอกจากจะช่วยส่งข้อมูลสภาพอากาศให้แล้ว
    func didUpdateWeather(_ weatherManager : WeatherManager , weather:WeatherModel)
//    มันก็ควรจะต้องช่วยส่ง error ด้วย
    func didFailureWithError(with error:Error)
}

struct WeatherManager {
    let weatherURL:String = "https://api.openweathermap.org/data/2.5/weather?appid=fe99ad0e670a43e24cdebc3f9a3b32e0&units=metric"
    
//    เราจะเอาน้องมาส่งข้อมูลไปให้อีกไฟล์นึงน่ะนะ
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather(cityName:String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString)
    }
    
    
    func performRequest(_ urlString:String) {
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
            if let weather = self.parseJSON(data){
                
                delegate?.didUpdateWeather(self , weather:weather)
            }
        case let .failure(error):
            delegate?.didFailureWithError(with: error)
            return
        }
    }
    
    func parseJSON(_ weatherData:Data) -> WeatherModel? {
        //        ก่อนจะเอาไปทำเป็น JSON ได้เราต้องมีหรือรู้ก่อนว่าโครงสร้างของข้อมูลมันเป็นยังไง ซึ่งโครงสร้างของข้อมูลที่จะรับมาจะ
        //        อยู่ในไฟล์ WeatherData
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let weatherID = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: weatherID, cityName: name, temperature: temp)
            
            return weather
            
        } catch let error {
            delegate?.didFailureWithError(with: error)
            return nil
        }
    }
    
}
