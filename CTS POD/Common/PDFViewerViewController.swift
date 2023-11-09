
import Foundation
import PDFKit

public class PDFViewerViewController: UIViewController {
    private var pdfView: PDFView = {
        let view = PDFView()
        view.autoScales = true
        view.displayMode = .singlePageContinuous
        view.displayDirection = .vertical
        view.backgroundColor = .white
        return view
    }()
    
    private let data: Data
    
    public init(data: Data) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        super.loadView()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        view.addSubview(pdfView)
        
        pdfView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Document"
        
        let document = PDFDocument(data: data)
        pdfView.document = document
    }
}
