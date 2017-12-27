//
//  UserDefaultsManager.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 26/12/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import Foundation


class UserDefaultsManager
{
    private static let useDarkThemeKey = "useDarkThemeKey"
    private static let ownerSectionCollapsedKey = "ownerSectionCollapsed"
    private static let dognameSectionCollapsedKey = "dognameSectionCollapsed"
    private static let genderSectionCollapsedKey = "genderSectionCollapsed"
    private static let sizeSectionCollapsedKey = "sizeSectionCollapsed"
    private static let temperamentSectionCollapsedKey = "temperamentSectionCollapsed"
    private static let breedSectionCollapsedKey = "breedSectionCollapsed"
    private static let pictureSectionCollapsedKey = "pictureSectionCollapsed"
    
    static var useDarkTheme: Bool
    {
        get
        {
            return UserDefaults.standard.bool(forKey: useDarkThemeKey)
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: useDarkThemeKey)
        }
    }
    
    static var ownerSectionCollapsed: Bool
    {
        get
        {
            return UserDefaults.standard.bool(forKey: ownerSectionCollapsedKey)
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: ownerSectionCollapsedKey)
        }
    }
    
    static var dognameSectionCollapsed: Bool
    {
        get
        {
            return UserDefaults.standard.bool(forKey: dognameSectionCollapsedKey)
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: dognameSectionCollapsedKey)
        }
    }
    
    static var genderSectionCollapsed: Bool
    {
        get
        {
            return UserDefaults.standard.bool(forKey: genderSectionCollapsedKey)
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: genderSectionCollapsedKey)
        }
    }
    static var sizeSectionCollapsed: Bool
    {
        get
        {
            return UserDefaults.standard.bool(forKey: sizeSectionCollapsedKey)
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: sizeSectionCollapsedKey)
        }
    }
    static var temperamentSectionCollapsed: Bool
    {
        get
        {
            return UserDefaults.standard.bool(forKey: temperamentSectionCollapsedKey)
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: temperamentSectionCollapsedKey)
        }
    }
    static var breedSectionCollapsed: Bool
    {
        get
        {
            return UserDefaults.standard.bool(forKey: breedSectionCollapsedKey)
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: breedSectionCollapsedKey)
        }
    }
    static var pictureSectionCollapsed: Bool
    {
        get
        {
            return UserDefaults.standard.bool(forKey: pictureSectionCollapsedKey)
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: pictureSectionCollapsedKey)
        }
    }
    
}
