//
//  EventDetailsVC.swift
//  Riada
//
//  Created by Guaire94 on 18/09/2021.
//

import UIKit
import Firebase

protocol MyProfileVCDelegate: AnyObject {
    func didUpdateAvatar()
}

class MyProfileVC: UIViewController {
    
    //MARK: - Constant
    enum Constants {
        static let identifier: String = "MyProfileVC"
        fileprivate static let bottomContentInset: CGFloat = 8.0
        fileprivate static let imageContentType = "image/jpeg"
    }
    
    //MARK: - IBOutlet
    @IBOutlet weak private var nickNameLabel: UILabel!
    @IBOutlet private weak var avatarPicker: ImagePicker!
    @IBOutlet weak private var segmentControl: CustomSegmentedControl!
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var actionButton: UIButton!
    
    //MARK: - Properties
    weak var delegate: MyProfileVCDelegate?
    private var sections = MProfileSection.toDisplay()
    private var currentSection = MProfileSection.organizer {
        didSet {
            updateActionButton()
            events = []
            syncEventsIfNeeded()
        }
    }
    private var events: [RelatedEvent] = [] {
        didSet {
            sortEventByDate()
        }
    }

    private var eventsByDate: [(date: Date, events: [RelatedEvent])] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        syncEventsIfNeeded()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == EventDetailsAsParticipantVC.Constants.identifier {
            guard let vc = segue.destination as? EventDetailsAsParticipantVC,
                  let tuple = sender as? (event: Event, organizer: Organizer) else {
                return
            }
            vc.event = tuple.event
            vc.organizer = tuple.organizer
        } else if segue.identifier == EventDetailsAsOrganizerVC.Constants.identifier {
            guard let vc = segue.destination as? EventDetailsAsOrganizerVC,
                  let event = sender as? Event else {
                return
            }
            vc.event = event
        } else if segue.identifier == OrganizeEventVC.Constants.identifier {
            guard let vc = segue.destination as? OrganizeEventVC else { return }
            vc.delegate = self
        }
    }
        
    //MARK: - Privates
    private func setUpView() {
        avatarPicker.parentViewController = self
        avatarPicker.delegate = self
        setUpUserInformation()
        setUpSegmentControl()
        setUpTableView()
    }
    
    private func setUpUserInformation() {
        guard let user = ManagerUser.shared.user else { return }
        
        nickNameLabel.text = user.nickName
        if let avatar = user.avatar, let url = URL(string: avatar) {
            avatarPicker.loadImage(from: url)
        } else {
            avatarPicker.setDefaultAvatar()
        }
    }
    
    private func setUpSegmentControl() {
        segmentControl.delegate = self
        segmentControl.setButtonTitles(buttonTitles: sections.map({ $0.title }))
     }
    
    private func setUpTableView() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Constants.bottomContentInset, right: 0)
        tableView.register(SectionCell.Constants.nib,
                                forHeaderFooterViewReuseIdentifier: SectionCell.Constants.identifier)
        
        for section in sections {
            tableView.register(section.cellNib, forCellReuseIdentifier: section.cellIdentifier)
        }
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func syncEventsIfNeeded() {
        switch currentSection {
        case .organizer:
            ServiceUser.getOrganizeEvents(delegate: self)
        case .participate:
            ServiceUser.getParticipateEvents(delegate: self)
        default:
            tableView.reloadData()
        }
    }
    
    private func shareEvent(event: Event) {
        HelperDynamicLink.generateEventDetails(event: event, completion: { url in
            guard let url = url else { return }
            DispatchQueue.main.async {
                let activityViewController = UIActivityViewController(activityItems : [url], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                
                self.present(activityViewController, animated: true, completion: nil)
            }
        })
    }
    
    private func updateActionButton() {
        switch currentSection {
        case .organizer:
            actionButton.isHidden = false
            actionButton.setImage(UIImage(named: "add"), for: .normal)
        case .participate:
            actionButton.isHidden = true
            actionButton.setImage(nil, for: .normal)
        case .informations:
            actionButton.isHidden = false
            actionButton.setImage(UIImage(named: "save"), for: .normal)
        }
    }
    
    private func sortEventByDate() {
        var sortedEvent: [(date: Date, events: [RelatedEvent])] = []
        let dict = Dictionary(grouping: events, by: { $0.date })
        let sortedKeys = Array(dict.keys).sorted(by: { $0.compare($1) == .orderedDescending })
        
        for key in sortedKeys {
            if let events = dict[key] {
                sortedEvent.append((date: key.dateValue(), events: events))
            }
        }
        self.eventsByDate = sortedEvent
    }
        
    private func upload(image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid,
            let scaledImage = image.scaledToSafeUploadSize,
            let data = scaledImage.jpegData(compressionQuality: Config.jpegCompressionQuality) else {
                completion(nil)
                return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = Constants.imageContentType
        
        FStorageReference.user(userId: userId).putData(data, metadata: metadata) { meta, error in
            FStorageReference.user(userId: userId).downloadURL { url, _ in
                completion(url)
            }
        }
    }
}

// MARK: - IBAction
extension MyProfileVC: ServiceUserEventsDelegate  {
    func dataAdded(event: RelatedEvent) {
        events.append(event)
    }
    
    func dataModified(event: RelatedEvent) {
        guard let index = events.firstIndex(where: { $0.id == event.id }) else { return }
        events[index] = event
    }
    
    func dataRemoved(event: RelatedEvent) {
        guard let index = events.firstIndex(where: { $0.id == event.id }) else { return }
        events.remove(at: index)
    }
    
    func didFinishLoading() {}
}

// MARK: - CustomSegmentedControlDelegate
extension MyProfileVC: CustomSegmentedControlDelegate {
    
    func change(to index: Int) {
        guard let section = MProfileSection(rawValue: index) else { return }
        currentSection = section
    }
}

// MARK: - UITableViewDataSource
extension MyProfileVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch currentSection {
        case .organizer:
            if eventsByDate.isEmpty {
                tableView.setEmptyMessage(L10N.profile.organizerEmptyPlaceHolder)
            } else {
                tableView.restore()
            }
            return eventsByDate.count
        case .participate:
            if eventsByDate.isEmpty {
                tableView.setEmptyMessage(L10N.profile.participateEmptyPlaceHolder)
            } else {
                tableView.restore()
            }
            return eventsByDate.count
        case .informations:
            tableView.restore()
            return 1
        }
    }
        
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        currentSection.sectionHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch currentSection {
        case .organizer, .participate:
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionCell.Constants.identifier) as? SectionCell else { return nil }
            header.setUp(desc: eventsByDate[section].date.sectionDesc)
            return header
        case .informations:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentSection {
        case .organizer, .participate:
            return eventsByDate[section].events.count
        case .informations:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        currentSection.cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch currentSection {
        case .organizer, .participate:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: currentSection.cellIdentifier, for: indexPath) as? RelatedEventCell else {
                return UITableViewCell()
            }
            let event = eventsByDate[indexPath.section].events[indexPath.row]
            cell.setUp(event: event, isOrganizer: currentSection == MProfileSection.organizer)
            return cell
        case .informations:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: currentSection.cellIdentifier, for: indexPath) as? InformationsCell else {
                return UITableViewCell()
            }
            cell.setUp(delegate: self)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension MyProfileVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch currentSection {
        case .organizer:
            let relatedEvent = eventsByDate[indexPath.section].events[indexPath.row]
            guard let eventId = relatedEvent.id else { return }
            ServiceEvent.getEventDetails(eventId: eventId) { event in
                guard let event = event else { return }
                HelperTracking.track(item: .myProfileOrganizerEventDetails)
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: EventDetailsAsOrganizerVC.Constants.identifier, sender: event)
                }
            }
        case .participate:
            let relatedEvent = eventsByDate[indexPath.section].events[indexPath.row]
            
            guard let cell = tableView.cellForRow(at: indexPath) as? RelatedEventCell,
                  let eventId = relatedEvent.id,
                  let organizer = cell.organizer else {
                      return
            }
            ServiceEvent.getEventDetails(eventId: eventId) { event in
                guard let event = event else { return }
                HelperTracking.track(item: .myProfileParticipateEventDetails)
                DispatchQueue.main.async {
                    let tuple = (event: event, organizer: organizer)
                    self.performSegue(withIdentifier: EventDetailsAsParticipantVC.Constants.identifier, sender: tuple)
                }
            }
        case .informations:
            break
        }
    }
}


// MARK: - OrganizeEventVCDelegate
extension MyProfileVC: OrganizeEventVCDelegate {

    func didCreateEvent(event: Event) {
        if currentSection == MProfileSection.organizer {
            events = []
            syncEventsIfNeeded()
        }
        shareEvent(event: event)
    }
}

// MARK: - ImagePickerDelegate
extension MyProfileVC: ImagePickerDelegate {
    
    func didUpdateAvatar(image: UIImage) {
        upload(image: image) { url in
            guard let avatarUrl = url?.absoluteString else { return }
            ManagerUser.shared.updateAvatar(avatarUrl: avatarUrl)
            self.delegate?.didUpdateAvatar()
        }
    }
}

// MARK: IBAction
private extension MyProfileVC {
    
    @IBAction func actionToggle(_ sender: Any) {
        switch currentSection {
        case MProfileSection.organizer:
            HelperTracking.track(item: .myProfileOrganizeEvent)
            performSegue(withIdentifier: OrganizeEventVC.Constants.identifier, sender: self)
        case MProfileSection.informations:
            guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? InformationsCell,
                  let nickName = cell.nickName else {
                      return
            }
            HelperTracking.track(item: .myProfileSaveInformation)
            nickNameLabel.text = nickName
            ManagerUser.shared.updateNickName(nickName: nickName)
        default:
            break
        }
    }
        
    @IBAction func backToggle(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension MyProfileVC: UITextFieldDelegate {
        
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}




