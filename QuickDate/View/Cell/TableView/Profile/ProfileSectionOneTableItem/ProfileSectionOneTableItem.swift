//
//  ProfileSectionOneTableItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun All rights reserved.
//

import UIKit
import Async
import QuickDateSDK

protocol ProfileHeaderSectionDelegate {
    func likeBtnAction(_ sender: UIButton)
    func onVisitBtnAction(_ sender: UIButton)
    func settingsBtnAction(_ sender: UIButton)
    func editButtonAction(_ sender: UIButton)
    func onBtnShare(_ sender: UIButton)
}

class ProfileSectionOneTableItem: UITableViewCell {
    
    @IBOutlet weak var waveView: UIView!
    @IBOutlet weak var boostImage: UIImageView!
    @IBOutlet weak var lblVisit: UILabel!
    @IBOutlet weak var lblLike: UILabel!
    @IBOutlet weak var verifiedIcon: UIImageView!
    @IBOutlet weak var boostMeTimerLabel: UILabel!
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var backImage: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var boostMeButton: UIButton!
    @IBOutlet weak var editButtonView: UIView!
    @IBOutlet weak var lblUserAddress: UILabel!
    
    var vc: ProfileVC?
    var delegate: ProfileHeaderSectionDelegate?
    private let imagePickerController = UIImagePickerController()
    
    // MARK: - Properties
    private let userSettings = AppInstance.shared.userProfileSettings
    private let appNavigator: AppNavigator = .shared
    var seconds = 240
    var timer = Timer()
    var isTimerRunning = false
    var progress: CGFloat = 0.0
    
    var waterWaveView: WaterWaveView = {
        let waveView = WaterWaveView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        return waveView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configView()
        backImage.addShadow()
    }
    
    @IBAction func onBtnVisit(_ sender: UIButton) {
        self.delegate?.onVisitBtnAction(sender)
    }
    
    @IBAction func settingsButtonAction(_ sender: UIButton) {
        self.delegate?.settingsBtnAction(sender)
    }
    
    @IBAction func editButtonAction(_ sender: UIButton) {
        self.delegate?.editButtonAction(sender)
    }
    
    @IBAction func boostMeButtonAction(_ sender: UIButton) {
        self.boostPopularity(type: "boost")
    }
    
    @IBAction func onBtnShare(_ sender: UIButton) {
        self.delegate?.onBtnShare(sender)
    }
    
    @IBAction func onBtnLike(_ sender: UIButton) {
        self.delegate?.likeBtnAction(sender)
    }
    
    func setupWaveView() {
        waveView.addSubview(waterWaveView)
        waterWaveView.waveHeight = 1
        waterWaveView.progress = 0.0
        self.waveView.isHidden = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let imageOneTapped = UITapGestureRecognizer(target: self, action:  #selector (self.ImageView1Tapped(_:)))
        self.avatarImage.addGestureRecognizer(imageOneTapped)
        self.requestLocationServiceAccess()
        self.setupWaveView()
        self.progress = 1.0/CGFloat(self.seconds)
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds -= 1
        print(progress)
        self.waterWaveView.progress += progress
        self.boostMeTimerLabel.text = timeString(time: TimeInterval(seconds))
        if self.seconds == 0 {
            self.timer.invalidate()
            self.boostImage.image = UIImage(named: "ic_boost_edit_profile")
            self.boostMeTimerLabel.isHidden = true
            self.waveView.isHidden = true
            self.boostMeButton.isEnabled = true
            self.seconds = 240
            self.waterWaveView.progress = 0
            self.waterWaveView.stopWaveAnimation()
            self.progress = 1.0/CGFloat(self.seconds)
        }else{
            self.boostMeButton.isEnabled = false
        }
    }
    func timeString(time:TimeInterval) -> String {
        _ = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i",minutes, seconds)
    }
    
    @objc func ImageView1Tapped(_ sender:UITapGestureRecognizer) {
        Logger.verbose("Tapped ")
        let alert = UIAlertController(title: "", message: NSLocalizedString("Select Source", comment: "Select Source"), preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: NSLocalizedString("Camera", comment: "Camera"), style: .default) { (action) in
            self.imagePickerController.delegate = self
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .camera
            self.vc?.present(self.imagePickerController, animated: true, completion: nil)
        }
        let gallery = UIAlertAction(title:NSLocalizedString("Gallery", comment: "Gallery") , style: .default) { (action) in
            self.imagePickerController.delegate = self
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .photoLibrary
            self.vc?.present(self.imagePickerController, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .destructive, handler: nil)
        alert.addAction(camera)
        alert.addAction(gallery)
        alert.addAction(cancel)
        vc?.present(alert, animated: true, completion: nil)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Methods
    func configView() {
        boostMeButton.circleView()
        avatarImage.circleView()
        editButtonView.circleView()
        vc?.viewDidLayoutSubviews()
    }
    
    func requestLocationServiceAccess() {
        AppLocationManager.shared.requestLocationServiceIfNeed(force: false) { (granted) in
            if granted {
                self.startLocationUpdate()
            } else {
            }
        }
    }
    
    func startLocationUpdate() {
        AppLocationManager.shared.startLocationUpdate { (currentLocation) in
            GetMapAddress.getAddress(selectedLat: currentLocation.latitude, selectedLon: currentLocation.longitude) { stAddress in
                self.lblUserAddress.text = stAddress
            }
        }
    }
    
    func configData() {
        let url = URL(string: userSettings?.avatar ?? "")
        avatarImage.sd_setImage(with: url, placeholderImage: R.image.no_profile_image())
        usernameLabel.text = userSettings?.full_name ?? ""
        self.verifiedIcon.isHidden = !(userSettings?.verified ?? false)
        let likesCount = userSettings?.likes_count
        let visitCount = userSettings?.visits_count
        self.lblLike.text = "\(likesCount ?? 0) \(NSLocalizedString("Likes", comment: "Likes"))"
        self.lblVisit.text = "\(visitCount ?? 0) \(NSLocalizedString("Visits", comment: "Visits"))"        
    }
}

//MARK: - UIImage Picker Delegate and Navigation Delegate Methods -
extension ProfileSectionOneTableItem: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.avatarImage.image = image
        self.vc?.dismiss(animated: true, completion: nil)
        self.updateAvatar(Image: image)
    }
    
    private func updateAvatar(Image:UIImage) {
        if Connectivity.isConnectedToNetwork(){
            self.vc?.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            let avatarImageData = Image.jpegData(compressionQuality: 0.2)
            Async.background({
                UpdateAvatarManager.instance.updateAvatar(AccesToken:accessToken , AvatarData: avatarImageData, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.vc?.dismissProgressDialog {
                                Logger.debug("success = \(success?.data ?? "")")
                                self.vc?.view.makeToast(success?.data ?? "")
                                let appManager: AppManager = .shared
                                appManager.fetchUserProfile()
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.vc?.dismissProgressDialog {
                                Logger.error("sessionError = \(sessionError?.message ?? "")")
                                self.vc?.view.makeToast(sessionError?.message ?? "")
                            }
                        })
                    }else {
                        Async.main({
                            self.vc?.dismissProgressDialog {
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                                self.vc?.view.makeToast(error?.localizedDescription ?? "")
                            }
                        })
                    }
                })
            })
        }else{
            Logger.error("internetErrro = \(InterNetError)")
            self.vc?.view.makeToast(InterNetError)
        }
    }
    
    private func boostPopularity(type: String) {
        if Connectivity.isConnectedToNetwork() {
            self.vc?.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            Async.background({
                PopularityManager.instance.managePopularity(AccessToken: accessToken, Type: type, completionBlock: { (success, sessionError, error) in
                    if success != nil {
                        Async.main({
                            self.vc?.dismissProgressDialog {
                                Logger.debug("userList = \(success?.message ?? "")")
                                self.vc?.view.makeToast(success?.message ?? "")
                                self.boostMeTimerLabel.text = self.timeString(time: TimeInterval(self.seconds))
                                self.boostMeTimerLabel.isHidden = false
                                self.waveView.isHidden = false
                                self.boostImage.image = nil
                                self.runTimer()
                            }
                        })
                    }else if sessionError != nil {
                        Async.main({
                            self.vc?.dismissProgressDialog {
                                self.vc?.navigateToBuyCredit()
                                /*
                                let vc = R.storyboard.credit.buyCreditVC()
                                // vc?.delegate = self
                                vc?.modalTransitionStyle = .coverVertical
                                vc?.modalPresentationStyle = .overFullScreen
                                self.vc?.present(vc!, animated: true, completion: nil)*/
                                Logger.error("sessionError = \(sessionError?.message ?? "")")
                                self.vc?.view.makeToast(sessionError?.message ?? "")
                            }
                        })
                    }else {
                        Async.main({
                            self.vc?.dismissProgressDialog {
                                self.vc?.view.makeToast(error?.localizedDescription ?? "")
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                            }
                        })
                    }
                })
            })
        }else{
            Logger.error("internetError = \(InterNetError)")
            self.vc?.view.makeToast(InterNetError)
        }
    }
}
