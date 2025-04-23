

import UIKit

class MovieListViewController: UIViewController {
    
    @IBOutlet weak var MovieListCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    private let emptyStateLabel = UILabel()
    
    private var movies: [Movie] = []
    private var viewModel: MovieListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MovieListViewModel()
        viewModel.delegate = self
        setupViews()
        
        Task {
            await viewModel.fetchMovies()
        }
    }
    
    func setupViews() {
        MovieListCollectionView.dataSource = self
        MovieListCollectionView.delegate = self
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        emptyStateLabel.text = "No results found"
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.isHidden = true
        MovieListCollectionView.register(UINib(nibName: MovieListViewCell.identifier, bundle: .main), forCellWithReuseIdentifier: MovieListViewCell.identifier)
        
    }
    
    
}

extension MovieListViewController:MovieListViewModelDelegate{
    
    func didUpdateState(_ state: MovieListState) {
        DispatchQueue.main.async {
            switch state {
            case .loading:
                self.showLoadingIndicator()
                self.emptyStateLabel.isHidden = true
                self.MovieListCollectionView.isHidden = true
            case .success(let movies):
                self.hideLoadingIndicator()
                self.movies = movies
                self.emptyStateLabel.isHidden = !movies.isEmpty
                self.MovieListCollectionView.isHidden = movies.isEmpty
                self.MovieListCollectionView.reloadData()
            case .empty:
                self.hideLoadingIndicator()
                self.emptyStateLabel.isHidden = false
                self.MovieListCollectionView.isHidden = true
            case .failure(let errorMessage):
                self.hideLoadingIndicator()
                self.emptyStateLabel.text = errorMessage
                self.emptyStateLabel.isHidden = false
                self.MovieListCollectionView.isHidden = true
            default:
                self.hideLoadingIndicator()
                break
            }
        }
        
    }
    
    
}

extension MovieListViewController:UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Task {
            await viewModel.search(query: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        Task {
            await viewModel.fetchMovies()
        }
    }
    
}


extension MovieListViewController:UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return movies.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let minimumInteritemSpacing: CGFloat = 8
        let availableWidth = (UIScreen.main.bounds.width-20) - (padding * 2) - (minimumInteritemSpacing * 2)
        let itemWidth = availableWidth / 3
        return CGSize(width: itemWidth, height: 175)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListViewCell.identifier, for: indexPath as IndexPath) as! MovieListViewCell
        let movie = movies[indexPath.row]
        cell.configure(with: movie)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let selectedMovie = movies[indexPath.item]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
            detailVC.viewModel = MovieDetailViewModel(movie: selectedMovie)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    
    
}
