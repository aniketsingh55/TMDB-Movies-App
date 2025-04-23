

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var releasedateLabel: UILabel!
    
    
    var viewModel: MovieDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateData()
    }

    func populateData() {
        let movie = viewModel.movie
        titleLabel.text = movie.title
        releasedateLabel.text = "Release Date: \(movie.releaseDate)"
        overviewLabel.text = movie.overview
        if let posterPath = movie.posterPath, !posterPath.isEmpty {
            let fullURL = URL(string: API.imageBaseURL + posterPath)
            posterImageView.sd_setImage(with: fullURL, placeholderImage: UIImage(named: "movie_Placeholder"), options: .highPriority)
        } else {
            posterImageView.image = UIImage(named: "movie_Placeholder")
        }
    }

    @IBAction func BackMethod(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
