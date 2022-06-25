//
//  WeatherData.swift
//  Climy
//
//  Created by Kittisak Panluea on 25/6/2565 BE.
//

import Foundation

// Decode เป็นตัวถอด JSON มาเป็นสตริงธรรมดา แต่ encode ก็เอาข้อมูลธรรมดากลับไปเป็น JSON
// แบบว่าจะส่งไปให้ไฟล์อื่นใช้อะนะ
// ส่วน Codable ก็คือเอา Decodable กับ Encodable มารวมกัล

struct WeatherData:Codable {
    let name:String
//    คือใน API ตัว main มันมี object ข้างในอีกอะนะ เลยต้องไปสร้างเป็น struct แยกมารองรับมัน
    let main:MainObject
    let weather:[WeatherObject]
}

struct MainObject:Codable {
    let temp: Double
}

struct WeatherObject : Codable {
    let id:Int
}
