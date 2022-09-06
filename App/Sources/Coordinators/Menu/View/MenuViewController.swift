import JamitFoundation
import UIKit

final class MenuViewController: CofuViewController<MenuViewModel> {
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var headerBackgroundView: UIView = {
        let view: UIView = .instantiate()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var headerTitleLabel: Label = {
        let label: Label = .instantiate()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var headerImageView: UIImageView = {
        let imageView: UIImageView = .instantiate()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var tableView: UITableView = {
        let tableView: UITableView = .instantiate()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator: UIActivityIndicatorView = .instantiate()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    var style: MenuViewStyle = .default {
        didSet { didChangeStyle() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        didChangeStyle()
    }

    override func setup() {
        [
            headerBackgroundView,
            tableView
        ].forEach(view.addSubview)

        tableView.register(cellOfType: MenuItemTableViewCell.self)
        tableView.register(headerFooterViewOfType: SeparatorHeaderFooterView.self)
        tableView.contentInset = .init(top: 20, left: 0, bottom: 0, right: 0)

        headerBackgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        headerBackgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        headerBackgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true

        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: headerBackgroundView.bottomAnchor).isActive = true

        setupHeaderView()
    }

    override func didChangeModel() {
        super.didChangeModel()

        activityIndicator.isHidden = !model.isLoading
        headerImageView.isHidden = model.headerImage == nil
        headerImageView.image = model.headerImage
        headerTitleLabel.text = model.headerTitle

        tableView.reloadData()
    }

    private func setupHeaderView() {
        headerBackgroundView.addSubview(headerStackView)
        [
            headerImageView,
            headerTitleLabel
        ].forEach(headerStackView.addArrangedSubview)

        headerStackView.trailingAnchor.constraint(equalTo: headerBackgroundView.trailingAnchor, constant: -16).isActive = true
        headerStackView.leadingAnchor.constraint(equalTo: headerBackgroundView.leadingAnchor, constant: 16).isActive = true
        headerStackView.bottomAnchor.constraint(equalTo: headerBackgroundView.bottomAnchor, constant: -28).isActive = true
        headerStackView.topAnchor.constraint(equalTo: headerBackgroundView.layoutMarginsGuide.topAnchor, constant: 20).isActive = true
        headerStackView.topAnchor.constraint(greaterThanOrEqualTo: headerBackgroundView.topAnchor, constant: 20).isActive = true

        headerImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        headerImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
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
