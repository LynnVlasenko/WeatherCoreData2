//
//  WeatherData+CoreDataProperties.swift
//  WeatherCoreData2
//
//  Created by Алина Власенко on 27.03.2023.
//
//

import Foundation
import CoreData


extension WeatherData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherData> {
        return NSFetchRequest<WeatherData>(entityName: "WeatherData")
    }

    @NSManaged public var nameCity: String?
    @NSManaged public var descriptions: String?
    @NSManaged public var icons: String?
    @NSManaged public var temperatures: Float
    @NSManaged public var pressures: Int32
    @NSManaged public var humidities: Int32
    @NSManaged public var feelsLike: Float
    @NSManaged public var windSpeed: Float

}

extension WeatherData : Identifiable {

}
