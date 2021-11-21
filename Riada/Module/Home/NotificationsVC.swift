//
//  NotificationsVC.swift
//  Riada
//
//  Created by Guaire94 on 19/11/2021.
//

import UIKit

protocol NotificationsVCDelegate: AnyObject {
    func didTapNotification(deeplink: String)
}

class NotificationsVC: UIViewController {
    
    //MARK: - Constant
    enum Constants {
        static let identifier = "NotificationsVC"
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var notificationsTableView: UITableView!
    @IBOutlet weak private var loaderView: UIView!

    // MARK: - Properties
    weak var delegate: NotificationsVCDelegate?
    private var notifications: [Notification] = []

    private var notificationsByDate: [(date: Date, notifications: [Notification])] = [] {
        didSet {
            DispatchQueue.main.async {
                self.notificationsTableView.reloadData()
            }
        }
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        syncNotifications()
    }
    
    // MARK: - Privates
    private func setUpView() {
        HelperTracking.track(item: .notifications)
        
        titleLabel.text = L10N.notifications.title
        
        setupTableView()
    }

    private func setupTableView() {
        notificationsTableView.register(NotificationCell.Constants.nib,
                           forCellReuseIdentifier: NotificationCell.Constants.identifier)
        notificationsTableView.register(SectionCell.Constants.nib,
                           forHeaderFooterViewReuseIdentifier: SectionCell.Constants.identifier)
        notificationsTableView.dataSource = self
        notificationsTableView.delegate = self
    }
    
    private func syncNotifications() {
        loaderView.isHidden = false
        ServiceUser.getNotifications(delegate: self)
    }
    
    private func sortNotificationsByDate() {
        var sortedNotifications: [(date: Date, notifications: [Notification])] = []
        let dict = Dictionary(grouping: notifications, by: { $0.createdDate.dateValue().onlyDate })
        let sortedKeys = Array(dict.keys).sorted(by: { $0.compare($1) == .orderedDescending })
        
        for key in sortedKeys {
            if let notifications = dict[key]?.sorted(by: { $0.createdDate.compare($1.createdDate) == .orderedDescending }) {
                sortedNotifications.append((date: key, notifications: notifications))
            }
        }
        self.notificationsByDate = sortedNotifications
    }
}

// MARK: - IBAction
extension NotificationsVC: ServiceUserNotificationDelegate  {
    func dataAdded(notification: Notification) {
        notifications.append(notification)
    }
    
    func dataModified(notification: Notification) {
        guard let index = notifications.firstIndex(where: { $0.id == notification.id }) else { return }
        notifications[index] = notification
    }
    
    func dataRemoved(notification: Notification) {
        guard let index = notifications.firstIndex(where: { $0.id == notification.id }) else { return }
        notifications.remove(at: index)
    }
    
    func didFinishLoading() {
        loaderView.isHidden = true
        sortNotificationsByDate()
    }
}

// MARK: - IBAction
private extension NotificationsVC {

    @IBAction func backToggle(_ sender: Any) {
        dismiss(animated: true)
    }
}


// MARK: - UITableViewDataSource
extension NotificationsVC: UITableViewDataSource {
        
    func numberOfSections(in tableView: UITableView) -> Int {
        if notificationsByDate.isEmpty {
            tableView.setEmptyMessage(L10N.notifications.emptyPlaceHolder)
        } else {
            tableView.restore()
        }
        return notificationsByDate.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        SectionCell.Constants.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionCell.Constants.identifier) as? SectionCell else { return nil }
        header.setUp(desc: notificationsByDate[section].date.sectionDesc)
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notificationsByDate[section].notifications.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        NotificationCell.Constants.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.Constants.identifier, for: indexPath)
        guard let cell = reusableCell as? NotificationCell else {
            return UITableViewCell()
        }
        let notification = notificationsByDate[indexPath.section].notifications[indexPath.row]
        cell.setUp(notification: notification)
        return cell
    }
}


// MARK: - UITableViewDelegate
extension NotificationsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = notificationsByDate[indexPath.section].notifications[indexPath.row]
        guard let deeplink = notification.deeplink else { return }
        dismiss(animated: true) {
            self.delegate?.didTapNotification(deeplink: deeplink)
        }
    }
}
