
import UIKit
import SDWebImage

class MovieListViewCell: UICollectionViewCell {
    
    static let identifier = "MovieListViewCell"
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releasedateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        releasedateLabel.text = movie.releaseDate

        if let posterPath = movie.posterPath, !posterPath.isEmpty {
            let fullURL = URL(string: API.imageBaseURL + posterPath)
            posterImageView.sd_setImage(with: fullURL, placeholderImage: UIImage(named: "movie_Placeholder"), options: .highPriority)
        } else {
            posterImageView.image = UIImage(named: "movie_Placeholder")
        }
    }
}

