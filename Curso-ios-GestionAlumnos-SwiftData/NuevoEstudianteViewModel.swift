//
//  NuevoEstudianteViewModel.swift
//  Curso-ios-GestionAlumnos-SwiftData
//
//  Created by Equipo 8 on 20/2/26.
//

import SwiftData
import SwiftUI

@Observable
class NuevoEstudianteViewModel {
   
    var nombre = ""
    var email = ""
    var fechaNacimiento = Date()

    private var context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    //Validación
    var esValido: Bool {
        !nombre.isEmpty && !email.isEmpty && email.contains("@")
    }
    /*
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z%_.#$&'-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(withObject: email)
    }
     */
    func guardar() {
        let estudiante = Estudiante(
            nombre: nombre,
            email: email,
            fechaNacimiento: fechaNacimiento
        )
        context.insert(estudiante)
    }

}
