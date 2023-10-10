import JamitFoundation
import UIKit

protocol DashboardViewControllerDelegate: AnyObject {
    func didTriggerRefreshAction(_ completion: @escaping () -> Void)
}

final class DashboardViewController: StatefulViewController<DashboardViewModel> {
    private lazy var tableView: UITableView = .init(frame: .zero, style: .plain)
    private lazy var refreshControl: UIRefreshControl = .instantiate()

    weak var delegate: DashboardViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        let titleView = UIImageView(image: Asset.Images.logo.image)
        titleView.contentMode = .scaleAspectFill
        let titleViewContainer = UIView(frame: .zero)
        titleViewContainer.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.topAnchor.constraint(equalTo: titleViewContainer.topAnchor, constant: 12).isActive = true
        titleViewContainer.leadingAnchor.constraint(equalTo: titleView.leadingAnchor).isActive = true
        titleViewContainer.trailingAnchor.constraint(equalTo: titleView.trailingAnchor).isActive = true
        titleView.bottomAnchor.constraint(equalTo: titleViewContainer.bottomAnchor, constant: -12).isActive = true
        navigationItem.titleView = titleViewContainer

        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = Asset.Colors.background.color
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellOfType: DashboardHeaderTableViewCell.self)
        tableView.register(cellOfType: DashboardItemTableViewCell.self)
        tableView.register(cellOfType: LoadingTableViewCell.self)

        refreshControl.addTarget(self, action: #selector(didTriggerRefreshAction), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }

    override func didChangeModel() {
        super.didChangeModel()

        tableView.reloadData()
    }
}

// MARK: - Actions
extension DashboardViewController {
    @objc
    private func didTriggerRefreshAction() {
        guard let delegate = delegate else {
            refreshControl.endRefreshing()
            return
        }

        delegate.didTriggerRefreshAction { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !model.isLoading, !model.rows.isEmpty else { return 1 }

        return model.rows.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if model.isLoading || model.rows.isEmpty {
            return tableView.bounds.inset(by: tableView.adjustedContentInset).height
        }

        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if model.isLoading {
            return tableView.dequeue(cellOfType: LoadingTableViewCell.self, for: indexPath) { _ in
                return LoadingViewModel(
                    image: nil,
                    title: L10n.Dashboard.LoadingView.title,
                    description: L10n.Dashboard.LoadingView.description
                )
            }
        }

        if model.rows.isEmpty {
            return tableView.dequeue(cellOfType: LoadingTableViewCell.self, for: indexPath) { _ in
                return LoadingViewModel(
                    image: Asset.Images.noResults.image,
                    title: L10n.Dashboard.EmptyView.title,
                    description: L10n.Dashboard.EmptyView.description
                )
            }
        }

        switch model.rows[indexPath.row] {
        case let .header(model):
            return tableView.dequeue(cellOfType: DashboardHeaderTableViewCell.self, for: indexPath) { cell, _ in
                cell.model = model
            }

        case let .item(model):
            return tableView.dequeue(cellOfType: DashboardItemTableViewCell.self, for: indexPath) { cell, _ in
                cell.model = model
            }
        }
    }
}
