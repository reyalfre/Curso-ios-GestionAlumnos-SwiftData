//
//  Estudiante.swift
//  Curso-ios-GestionAlumnos-SwiftData
//
//  Created by Equipo 8 on 23/2/26.
//


import SwiftData
import SwiftUI

@Model
class Estudiante {
    var id: UUID
    var nombre: String
    var email: String
    var fechaNacimiento: Date

    // Relación 1 a muchos: Un estudiante puede tener múltiple matrículas (0..N)
    @Relationship(deleteRule: .cascade)  //Si se borra el estudiante se borran sus matrículas
    var matriculas: [Matricula]?

    var cursos: [Curso] {
        return matriculas?.compactMap {
            $0.curso
        } ?? []
    }

    init(nombre: String, email: String, fechaNacimiento: Date) {
        self.id = UUID()
        self.nombre = nombre
        self.email = email
        self.fechaNacimiento = fechaNacimiento
        // TODO: self.matriculas = []
    }
    // TODO: Cursos
}