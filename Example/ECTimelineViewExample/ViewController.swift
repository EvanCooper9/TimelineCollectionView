import ECTimelineView
import UIKit

struct DataModel {
    let index: Int
    let value: String
}

class ViewController: UIViewController {

    // MARK: - Private Properties
    
    private lazy var timelineView: ECTimelineView<DataModel, UICollectionViewCell> = {
        let timelineView = ECTimelineView<DataModel, UICollectionViewCell>()
        timelineView.timelineDataSource = self
        timelineView.translatesAutoresizingMaskIntoConstraints = false
        return timelineView
    }()
    
    private var data = [Int: DataModel]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(timelineView)
        NSLayoutConstraint.activate([
            view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: timelineView.leadingAnchor),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: timelineView.trailingAnchor),
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: timelineView.topAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: timelineView.bottomAnchor)
        ])
    }
}

// MARK: - ECTimelineViewDataSource

extension ViewController: ECTimelineViewDataSource {
    
    func timelineView<T, U: UICollectionViewCell>(_ timelineView: ECTimelineView<T, U>, dataFor index: Int, asyncClosure: @escaping (T?) -> Void) -> T? {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 2) {
            asyncClosure(DataModel(index: index, value: "Async \(index)") as? T)
        }
        
        return DataModel(index: index, value: "\(index)") as? T
    }

    func configure<T, U>(_ cell: U, withData data: T?) where U : UICollectionViewCell {
        guard let data = data as? DataModel else { return }
        cell.subviews.forEach { $0.removeFromSuperview() }
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.text = data.value
        label.translatesAutoresizingMaskIntoConstraints = false
        cell.addSubview(label)
        cell.backgroundColor = data.index % 2 == 0 ? .red : .blue
        NSLayoutConstraint.activate([
            cell.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            cell.centerXAnchor.constraint(equalTo: label.centerXAnchor)
        ])
    }
}
