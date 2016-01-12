//
//  AgregarViewController.swift
//  InventarioDoAppsvfinal
//
//  Created by Gonzalo on 8/01/16.
//  Copyright © 2016 doapps. All rights reserved.
//

import UIKit


@objc protocol AgregarViewControllerDelegate{
    func agregarObjeto(nombre: String, codigo: String, estado: String)
}


class AgregarViewController: UIViewController,UIPickerViewDelegate,UITextFieldDelegate {
    weak var delegate: AgregarViewControllerDelegate?
    @IBOutlet weak var getEstado: UIPickerView!
    @IBOutlet weak var getCodigo: UITextField!
    @IBOutlet weak var getNombre: UITextField!
    
    let estados = ["nuevo","seminuevo","viejo"]
    var tempStatus : String!
    var tempCode : String!
    var tempName : String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getEstado.delegate = self
        tempStatus = estados[0]
    }

    
    //MARK: Metodos del pickerView
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return estados.count
    }
    
    // returns the title of each row
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return estados[row]
    }
    // return the selected item
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tempStatus = estados[row]
    }
    
    
    //MARK: Metodos del textField
    func textFieldDidEndEditing(textField: UITextField) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(textField: UITextField) -> Bool{
        view.endEditing(true)
        return true
    }
    
    //MARK: Metodos del button Done
    @IBAction func guardar(sender: UIBarButtonItem) {
        tempName = getNombre.text
        tempCode = getCodigo.text
        if(tempName.isEmpty || tempCode.isEmpty){
            let alert = UIAlertView(title: "Espera papu", message: "Llena todos los datos", delegate: nil, cancelButtonTitle: "Ok")
            alert.show()
        }
        else{
            delegate?.agregarObjeto(tempName, codigo: tempCode, estado: tempStatus)
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
