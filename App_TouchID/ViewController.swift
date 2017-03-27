//
//  ViewController.swift
//  App_TouchID
//
//  Created by Jorge Moñiz on 27/3/17.
//  Copyright © 2017 jorgemoniz. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    //MARK: - Variables locales
    var customTouchID = LAContext()
    var messageData = "Necesito saber si eres tú"
    var nombre = "Jorge"
    
    var alertVC = UIAlertController(title: "", message: "", preferredStyle: .alert)
    
    var alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    
    //MARK: - IBOutlets
    @IBOutlet weak var myMomentoAutenticacion: UILabel!
    @IBOutlet weak var myComentarioAutenticacion: UILabel!
    
    //MARK: - IBActions
    
    @IBAction func desbloqueoTouchIDACTION(_ sender: Any) {
        
        myMomentoAutenticacion.text = "Autenticando"
        
        var touchErrorID : NSError?
        
        // Comprobamos si podemos acceder a la autenticación local del dispositivo
        // Pasamos un puntero a posibles errores.
        
        if customTouchID.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &touchErrorID) {
        
            // Comprobar la respuesta de esa autenticación
            
            customTouchID.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                                         localizedReason: messageData,
                                         reply: { (exito, error) in
                                            
                                            if exito {
                                                self.myMomentoAutenticacion.text = "TouchID realizado con éxito"
                                                self.myComentarioAutenticacion.text = "Has logrado demostrar que eres tú"
                                                self.alertVC.title = "Autenticación realizada con éxito."
                                                self.alertVC.message = "Sé que eres tu \(self.nombre)"
                                            } else {
                                                self.myMomentoAutenticacion.text = "TouchID 'NO' realizado"
                                                self.myComentarioAutenticacion.text = "'No' has logrado demostrar que eres tú"
                                                self.alertVC.title = "La autenticación ha fallado."
                                                
                                                switch error!._code {
                                                case LAError.Code.authenticationFailed.rawValue:
                                                    self.alertVC.message = "Fallo en la autenticación."
                                                case LAError.Code.userCancel.rawValue:
                                                    self.alertVC.message = "El usuario ha cancelado la autenticación."
                                                case LAError.Code.systemCancel.rawValue:
                                                    self.alertVC.message = "El sistema ha cancelado la autenticación."
                                                case LAError.Code.userFallback.rawValue:
                                                    self.alertVC.message = "Es necesario que ingrese su contraseña."
                                                default:
                                                    self.alertVC.message = "Algo ha salido mal."
                                                }
                                                self.present(self.alertVC, animated: true, completion: { 
                                                    self.myComentarioAutenticacion.text = self.messageData
                                                })
                                            }
            })
            
        } else {
            self.myMomentoAutenticacion.text = "La autenticación local ha fallado"
            self.alertVC.title = "Ooops!"
            
            switch touchErrorID!.code {
            case LAError.Code.touchIDNotAvailable.rawValue:
                self.alertVC.message = "El Touch ID no está disponible en su dispositivo."
            case LAError.Code.touchIDNotEnrolled.rawValue:
                self.alertVC.message = "No tienes huellas registradas."
            case LAError.Code.passcodeNotSet.rawValue:
                self.alertVC.message = "No hay contraseña asignada."
            default:
                self.alertVC.message = "Algo ha ido mal en la autenticación local."
            }
            self.present(alertVC, animated: true, completion: { 
                self.myComentarioAutenticacion.text = self.alertVC.message
            })
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
