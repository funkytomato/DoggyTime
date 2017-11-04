//
//  SampleData.swift
//  DoggyTime
//
//  Created by Spaceman on 18/09/2017.
//  Copyright © 2017 Spaceman. All rights reserved.
//

import Foundation

final class SampleData
{
    /*
    static func generateClientsData() -> [Client]
    {
        return [
            Client(forename: "Bill", surname: "Gates", street: "1 Gate Road", town: "Felpham", postcode: "PO21 2WE", mobile: "0123456789", eMail: "bgates@microsoft.com", dogname: "fluffy", dogpicture: #imageLiteral(resourceName: "fluffy"))!,
            Client(forename: "Jason", surname: "Fry", street: "7 Colston Road", town: "Aldwick", postcode: "PO21 3QL", mobile: "0796744179", eMail: "jasonfry@gmail.com", dogname: "winston", dogpicture: #imageLiteral(resourceName: "winston"))!,
            Client(forename: "Mark", surname: "Hullet", street: "69 Gordon Avenue", town: "Bognor Regis", postcode: "PO21 STD", mobile: "07967834534", eMail: "hulletisout@gmail.com", dogname: "hitler", dogpicture: #imageLiteral(resourceName: "hitler"))!,
            Client(forename: "Edward", surname: "King", street: "Buckingham Palace", town: "Pagham", postcode: "PO21 8UY", mobile: "0789765378", eMail: "king@gmail.com", dogname: "terry", dogpicture: #imageLiteral(resourceName: "terry"))!
        ]
    }

 
    static func generateWalksData() -> [Walk]
    {
        return [
            Walk(walkNo: 1, locationName: "Pagham", latitude: 50.769125, longitude: 0.738878, dogs: ["Bennet", "Hitler", "Bobs"])!,
            Walk(walkNo: 2, locationName: "Chichester", latitude: 50.836476, longitude: 0.778827, dogs: ["Hitler", "Bobs"])!,
            Walk(walkNo: 3, locationName: "Felpham", latitude: 50.796213, longitude: 0.657894, dogs: ["Bennet", "Hitler", "Bobs"])!
        ]
    }
    
    static func generateDogsData() -> [Dog]
    {
        return [
            Dog(dogname: "Hitler", breed: "Pointer", sex: "Male", size: "Medium", picture: #imageLiteral(resourceName: "hitler"))!,
            Dog(dogname: "Fluffy", breed: "Border Collie", sex: "Male", size: "Medium", picture: #imageLiteral(resourceName: "fluffy"))!,
            Dog(dogname: "Winston", breed: "Golden Retriever", sex: "Male", size: "Medium", picture: #imageLiteral(resourceName: "winston"))!,
            Dog(dogname: "Terry", breed: "Yorkshire Terrier", sex: "Female", size: "Small", picture: #imageLiteral(resourceName: "terry"))!,
            Dog(dogname: "Hitler", breed: "Boston Terrier", sex: "Male", size: "Large", picture: #imageLiteral(resourceName: "winston"))!
        ]
    }
     */
    static func generateWalkingDogsData() -> [Dog]
    {
        return [
            Dog(dogname: "Hitler", breed: "Golden Retriever", sex: "Male", size: "Medium", picture: #imageLiteral(resourceName: "hitler"))!,
            Dog(dogname: "Fluffy", breed: "Border Collie", sex: "Male", size: "Medium", picture: #imageLiteral(resourceName: "fluffy"))!,
            Dog(dogname: "Winston", breed: "Golden Retriever", sex: "Male", size: "Medium", picture: #imageLiteral(resourceName: "winston"))!,
            Dog(dogname: "Terry", breed: "Yorkshire Terrier", sex: "Female", size: "Small", picture: #imageLiteral(resourceName: "terry"))!,
            Dog(dogname: "Hitler", breed: "Golden Retriever", sex: "Male", size: "Large", picture: #imageLiteral(resourceName: "winston"))!
        ]
    }
    /*
    static func generateRoutesData() -> [Route]
    {
        return [
            Route(routeId: 1, name: "Pagham", terrain: "Beach", distance: 4.5, duration: 2.5)!,
            Route(routeId: 2, name: "Selsey", terrain: "Beach", distance: 3, duration: 1)!,
            Route(routeId: 3, name: "Summer Lane", terrain: "Fields", distance: 5, duration: 2.5)!,
            Route(routeId: 4, name: "Slindon", terrain: "Woods", distance: 8, duration: 3)!,
            Route(routeId: 5, name: "Pagham Sand Dunes", terrain: "Sand Dunes", distance: 1, duration: 0.5)!,
            Route(routeId: 6, name: "Arundel", terrain: "River", distance: 2, duration: 1.5)!
        ]
    }
 */
}
