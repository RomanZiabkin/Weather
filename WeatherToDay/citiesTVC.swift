//
//  citiesTVC.swift
//  WeatherToDay
//
//  Created by Roman Ziabkin on 16.11.2022.
//

import UIKit
import Alamofire
import SwiftyJSON

class citiesTVC: UITableViewController {
    
    @IBOutlet weak var cityTableView: UITableView!
    
    var cityName = ""
    
    struct Cities {
        var cityName = ""
        var cityTemp = 0.0
    }
    
    var cityTempArray: [Cities] = []
    
    func currentWeather(city: String) {
        let url = "http://api.weatherapi.com/v1/current.json?key=f0e9aa77ba19409b95b83625221611&q=\(city)"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let name = json["location"]["name"].stringValue
                let temp = json["current"]["temp_c"].doubleValue
                self.cityTempArray.append(Cities(cityName: name, cityTemp: temp))
                self.cityTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func addCityAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Добавить", message: "Введите название города", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Moscow"
        }
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        let newCityAction = UIAlertAction(title: "Добавить", style: .default) { (action) in
            let name = alert.textFields![0].text
            self.currentWeather(city: name!)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(newCityAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityTableView.delegate = self
        cityTableView.dataSource = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityTempArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! citiesNameCell
        
        cell.cityName.text = cityTempArray[indexPath.row].cityName
        cell.cityTemp.text = String(cityTempArray[indexPath.row].cityTemp)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cityName = cityTempArray[indexPath.row].cityName
        performSegue(withIdentifier: "detailVC", sender: self)
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
