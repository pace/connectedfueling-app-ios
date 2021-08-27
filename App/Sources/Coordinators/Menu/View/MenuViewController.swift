import JamitFoundation
import UIKit

final class MenuViewController: StatefulViewController<MenuViewModel> {
    @IBOutlet private var headerBackgroundView: UIView!
    @IBOutlet private var headerTitleLabel: Label!
    @IBOutlet private var headerImageView: UIImageView!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    var style: MenuViewStyle = .default {
        didSet { didChangeStyle() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.register(cellOfType: MenuItemTableViewCell.self)
        tableView.register(headerFooterViewOfType: SeparatorHeaderFooterView.self)
        tableView.contentInset = .init(top: 20, left: 0, bottom: 0, right: 0)
        didChangeStyle()
    }

    override func didChangeModel() {
        super.didChangeModel()

        activityIndicator.isHidden = !model.isLoading
        headerImageView.isHidden = model.headerImage == nil
        headerImageView.image = model.headerImage
        headerTitleLabel.text = model.headerTitle

        tableView.reloadData()
    }

    private func didChangeStyle() {
        headerBackgroundView.backgroundColor = style.headerBackground
        headerTitleLabel.style = style.headerTitleStyle
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return model.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.sections[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeue(cellOfType: MenuItemTableViewCell.self, for: indexPath) { indexPath in
            return model.sections[indexPath.section].items[indexPath.row]
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section > 0 else { return nil }

        return tableView.dequeue(headerFooterViewOfType: SeparatorHeaderFooterView.self)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section > 0 else { return .zero }

        return 40
    }
}
