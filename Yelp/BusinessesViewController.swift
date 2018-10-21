
import UIKit

class BusinessesViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var businesses: [Business]!
    var searchBar : UISearchBar!
    var businessesNamesOriginal : [String] = []
    var businessesNames : [String] = [] //holds updated names from search
    var businessesUpdated: [Business]! = [] //holds updates businesses from search

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        //Creating search bar
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
        
        //Places search bar on the top
        navigationItem.titleView = searchBar
        

        
        Business.searchWithTerm(term: "Thai", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
                self.businesses = businesses
                self.tableView.reloadData()
                if let businesses = businesses {
                    for business in businesses {
                        print(business.name!)
                        print(business.address!)
                        self.businessesNames.append(business.name!)
                        self.businessesNamesOriginal.append(business.name!)
                    }
                    self.businessesUpdated = self.businesses
                    self.tableView.reloadData()
                }
            
            }
        )
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm(term: "Restaurants", sort: .distance, categories: ["asianfusion", "burgers"]) { (businesses, error) in
                self.businesses = businesses
                 for business in self.businesses {
                     print(business.name!)
                     print(business.address!)
                 }
         }
         */
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businessesNames.count
        }
        else {
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        
        cell.business = businessesUpdated[indexPath.row]
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //holds list of business names that matches our search
        businessesNames = searchText.isEmpty ? businessesNamesOriginal:businessesNames.filter{(item: String) -> Bool in
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        if searchText.isEmpty {
            businessesUpdated = self.businesses
        }
        else {
            var i  = 0
            //Delete businesses that dont match our search return from the temp business array
            for business in businessesUpdated {
                if(!businessesNames.contains(business.name!)) {
                    businessesUpdated.remove(at: i)
                    i = i - 1
                }
                i = i + 1
            }
        }
        tableView.reloadData()
    }
    
    
    //Hide keyboard
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    
    
    
}
