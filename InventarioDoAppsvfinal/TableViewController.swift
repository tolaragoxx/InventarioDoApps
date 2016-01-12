//
//  TableViewController.swift
//  InventarioDoAppsvfinal
//
//  Created by Gonzalo on 8/01/16.
//  Copyright © 2016 doapps. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController,UISearchResultsUpdating,AgregarViewControllerDelegate {
    
    var filteredData = [String]()
    var resultControlle = UITableViewController()
    var searchController: UISearchController!
    var data = [NSManagedObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.resultControlle.tableView.delegate = self
        self.resultControlle.tableView.dataSource = self
        self.searchController = UISearchController(searchResultsController: self.resultControlle)
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.tableView.tableHeaderView = self.searchController.searchBar
        definesPresentationContext = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Object")
        do{
            let result = try managedContext.executeFetchRequest(fetchRequest)
            data = result as! [NSManagedObject]
        }catch let error as NSError {
            print("Could not fetch")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let identifier = segue.identifier
        if identifier == "agregarObjeto"{
            let agregarObjetoViewController = segue.destinationViewController as! AgregarViewController
            agregarObjetoViewController.delegate = self
        }
    }
    //Its what return the agregarViewController
    func agregarObjeto(nombre: String, codigo: String, estado: String) {
        saveData(nombre, sku: codigo, state: estado)
        self.tableView.reloadData()
    }
    
    // MARK: Funciones COREDATA
    //Save at database core data
    func saveData(name:String, sku:String, state:String){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Object", inManagedObjectContext: managedContext)
        let object_ = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)

        object_.setValue(name, forKey:"name")
        object_.setValue(sku, forKey:"sku")
        object_.setValue(state, forKey:"state")
        print(data)
        
        do{
            try managedContext.save()
            data.append(object_)
        }catch let error as NSError{
            print("Could not save")
        }
        
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView{
            return data.count
        }else{
            return filteredData.count
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //The color RGB #78A890
        let newColor = UIColor(red: CGFloat(0xC0)/255
            ,green: CGFloat(0xD8)/255
            ,blue: CGFloat(0x90)/255
            ,alpha: 1.0)
        let cell = UITableViewCell()
        
       
        if tableView == self.tableView{
            let name = data[indexPath.row]
            cell.textLabel?.text = "\(name.valueForKey("name") as! String) \(name.valueForKey("sku") as! String) \(name.valueForKey("state") as! String)"
            cell.backgroundColor = newColor
        }else{
            cell.textLabel?.text = filteredData[indexPath.row]
            cell.backgroundColor = newColor
           
        }
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            
            managedContext.deleteObject(data[indexPath.row] as NSManagedObject)
            data.removeAtIndex(indexPath.row)
            do{
                try managedContext.save()
            }catch let error as NSError{
                print("Could not delete")
            }
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }

    
    //MARK: Updating methods
    func updateSearchResultsForSearchController(searchController: UISearchController){
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Object")
        var arrayCode = [String]()
        do{
            let result = try managedContext.executeFetchRequest(fetchRequest)
            if(result.count > 0){
                //var codigo = result[0].valueForKey("sku")
                //arrayCode.append(codigo as! String)
                for (var i = 0; i < result.count; i++) {
                    let codigo = result[i].valueForKey("sku") as! String
                    arrayCode.append(codigo)
                }
            }
        }catch let error as NSError {
            print("Could not fetch")
        }


        self.filteredData = arrayCode.filter{
            (buscar: String) -> Bool in
            if buscar.lowercaseString.containsString(self.searchController.searchBar.text!.lowercaseString){
                return true
            }else{
                return false
            }
        }
        self.resultControlle.tableView.reloadData()
    }
    /*func updateSearchResultsForSearchController(searchController: UISearchController) {
        var request = NSFetchRequest(entityName: "Object")
        filteredTableData.removeAll(keepCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF.infos CONTAINS[c] %@", searchController.searchBar.text)
        let array = (series as NSArray).filteredArrayUsingPredicate(searchPredicate)
        
        for item in array
        {
            let infoString = item.infos
            filteredTableData.append(infoString)
        }
        
        self.tableView.reloadData()
    }*/

}
