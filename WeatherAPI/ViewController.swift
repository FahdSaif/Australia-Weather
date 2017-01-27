//
//  ViewController.swift
//  WeatherAPI
//
//  Created by Fahd on 23/01/2017.
//  Copyright © 2017 Fahd. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    //spinner
    var spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    var loadingView: UIView = UIView()
    
    //spinner
    
    @IBOutlet weak var MyTableref: UITableView!
    var dictcitytemp = [String: Double]()
    var mydictonary=[String:AnyObject]()
    var actorsarray=[String:AnyObject]()
    var mysweat:[Weathertype]=[]
    var globCityname=""
    var globcitycount:Int=0
    //var arrayofobjects=[]()
    var temperature:Double=0.0
    var city:String=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.MyTableref.dataSource=self
        self.MyTableref.delegate=self
        
        //Fahd: Calling the function to get JSON Data from OpenweatherAPI
        self.singlehit()
    }//end of view did load
    
    
    func singlehit()
    {
        
        showActivityIndicator()
        
        //faHD: hITTING THE api
        Alamofire.request("http://api.openweathermap.org/data/2.5/group?id=4163971,2147714,2174003&APPID=34605ed001ce1c650df89137aebc58f8").responseJSON { response in
            self.hideActivityIndicator()
            if let JSON = response.result.value {
                //print("JSON: \(JSON)")
                
                let result=response.result
                if let dict=result.value as? Dictionary<String,AnyObject>
                {
                    if let citycount=dict["cnt"] as? Int{
                        self.globcitycount=citycount
                        print("singlehit self.globcitycount\(self.globcitycount)")
                    }else{
                        self.globcitycount=0
                    }
                    
                    if let listvar=dict["list"] as? NSArray{
                        //print("singlehit all ok")
                        //print(listvar[0])
                        for myiterator in 0..<listvar.count{
                            if let firstele=listvar[myiterator] as? Dictionary<String,AnyObject>{
                                if let mainfromfirstele=firstele["main"]
                                {
                                    
                                    if let cityname=firstele["name"] as? String
                                    {
                                        self.globCityname=cityname
                                        print(cityname)
                                    }
                                    
                                    
                                    print("all super ok")
                                    let w=Weathertype(dict: mainfromfirstele as! Dictionary<String,AnyObject>, cityname: self.globCityname,itemsequence:3,iwasclicked:0)
                                    
                                    self.mysweat.append(w)
                                    
                                    //print(mainfromfirstele)
                                }
                                
                                
                                
                            }
                        }
                        self.MyTableref.reloadData()
                        
                                            }
                }
            }
            
        }
        
    }
    
    
    //spinner start
    func showActivityIndicator() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // in half a second...            self.loadingView = UIView()
            self.loadingView.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
            self.loadingView.center = self.view.center
            self.loadingView.backgroundColor = UIColor.brown
            self.loadingView.alpha = 0.7
            self.loadingView.clipsToBounds = true
            self.loadingView.layer.cornerRadius = 10
            
            self.spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            self.spinner.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
            self.spinner.center = CGPoint(x:self.loadingView.bounds.size.width / 2, y:self.loadingView.bounds.size.height / 2)
            
            self.loadingView.addSubview(self.spinner)
            self.view.addSubview(self.loadingView)
            self.spinner.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.spinner.stopAnimating()
            self.loadingView.removeFromSuperview()
        }
    }
    
    //spinner end
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mysweat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MyTableref.dequeueReusableCell(withIdentifier: "mycellidentifier") as? MyCustomCell
        cell?.lblcityname.text=mysweat[indexPath.row].cityname
        cell?.lbltemperature.text=String(mysweat[indexPath.row].temp)
        //print(dictcitytemp)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("clicked cell")
        //print("indexPath.row is \(indexPath.row)")
        mysweat[indexPath.row].iwasclicked=1
        
        performSegue(withIdentifier: "myseguedetail", sender: mysweat)
        
        //print(mysweat[indexPath.row].cityname)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print("prepare for segue method is called")
        
        if segue.identifier=="myseguedetail"
        {
            let destinationviewcontroller = segue.destination as? DetailViewController
            destinationviewcontroller?.localdetailweather=(sender as? [Weathertype])!
            
            //destinationviewcontroller?.another=sender
            //print("all ok")
        }
        
    }
    
}
