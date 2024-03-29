//
//  ListFriendCollectionItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async
import QuickDateSDK

protocol ListFriendDelegate {
    func btnPressed(_ sender: UIButton, id: Int)
}

class ListFriendCollectionItem: UICollectionViewCell {
    @IBOutlet var unfriendBtn: UIButton!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet weak var lblLastSeen: UILabel!
    @IBOutlet var profileImage: UIImageView!
    
    var delegate: ListFriendDelegate?
    var uid:Int? = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func unfriendBtn(_ sender: UIButton) {
        if let id = uid {
            self.delegate?.btnPressed(sender, id: id)
        }
    }
    
    func bind(_ object: UserProfileSettings) {
        self.uid = Int(object.id)
        var strURL = ""
        if object.avatar.contains("https") {
            strURL = object.avatar
        }else {
            strURL = object.userData?.avatar ?? ""
        }
        let url = URL(string: strURL)
        self.profileImage.sd_setImage(with: url, placeholderImage: R.image.thumbnail())
        if object.first_name == "" && object.last_name == "" {
            self.usernameLabel.text  = object.username
        }else {
            self.usernameLabel.text = "\(object.first_name) \(object.last_name )"
        }
        let date = Date(timeIntervalSince1970: TimeInterval(object.lastseen) ?? 0)
        self.lblLastSeen.text = Date().timeAgo(from: date)//setTimestamp(epochTime: object.lastseen)//""//object[""]
    }
    
}

func setTimestamp(epochTime: String) -> String {
    let currentDate = Date()
    let epochDate = Date(timeIntervalSince1970: TimeInterval(epochTime) ?? 0)
    let calendar = Calendar.current

    let currentDay = calendar.component(.day, from: currentDate)
    let currentYear = calendar.component(.year, from: currentDate)
    let currentHour = calendar.component(.hour, from: currentDate)
    let currentMinutes = calendar.component(.minute, from: currentDate)
    let currentSeconds = calendar.component(.second, from: currentDate)

    let epochDay = calendar.component(.day, from: epochDate)
    let epochMonth = calendar.component(.month, from: epochDate)
    let epochYear = calendar.component(.year, from: epochDate)
    let epochHour = calendar.component(.hour, from: epochDate)
    let epochMinutes = calendar.component(.minute, from: epochDate)
    let epochSeconds = calendar.component(.second, from: epochDate)

    if (currentDay - epochDay < 30) {
        if (currentDay == epochDay) {
            if (currentHour - epochHour == 0) {
                if (currentMinutes - epochMinutes == 0) {
                    if (currentSeconds - epochSeconds <= 1) {
                        return String(currentSeconds - epochSeconds) + " second ago"
                    } else {
                        return String(currentSeconds - epochSeconds) + " seconds ago"
                    }
                } else if (currentMinutes - epochMinutes <= 1) {
                    return String(currentMinutes - epochMinutes) + " minute ago"
                } else {
                    return String(currentMinutes - epochMinutes) + " minutes ago"
                }
            } else if (currentHour - epochHour <= 1) {
                return String(currentHour - epochHour) + " hour ago"
            } else {
                return String(currentHour - epochHour) + " hours ago"
            }
        } else if (currentDay - epochDay <= 1) {
            return String(currentDay - epochDay) + " day ago"
        } else {
            return String(currentDay - epochDay) + " days ago"
        }
    } else {
        return String(epochDay) + " " + getMonthNameFromInt(month: epochMonth) + " " + String(epochYear)
    }
}

func getMonthNameFromInt(month: Int) -> String {
    switch month {
    case 1:
        return "Jan"
    case 2:
        return "Feb"
    case 3:
        return "Mar"
    case 4:
        return "Apr"
    case 5:
        return "May"
    case 6:
        return "Jun"
    case 7:
        return "Jul"
    case 8:
        return "Aug"
    case 9:
        return "Sept"
    case 10:
        return "Oct"
    case 11:
        return "Nov"
    case 12:
        return "Dec"
    default:
        return ""
    }
}
