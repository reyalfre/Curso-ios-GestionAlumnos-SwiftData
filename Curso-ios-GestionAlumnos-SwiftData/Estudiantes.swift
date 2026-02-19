//
//  Estudiantes.swift
//  Curso-ios-GestionAlumnos-SwiftData
//
//  Created by Equipo 8 on 18/2/26.
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

@Model
class Curso {
    var id: UUID
    var codigo: String
    var nombre: String
    var creditos: Int
    var profesor: String

    //Relación 1 a muchos: Un curso puede tener MÚLTIPLES matrículas
    @Relationship(deleteRule: .nullify)  // Si borramos el curso, las matrículas se quedan sin curso
    var matriculas: [Matricula]?

    //Relación muchos a muchos: Un curso tiene muchos estudiantes y los estudiantes se matriculan en muchos cursos.
    var estudiantes: [Estudiante] {
        return matriculas?.compactMap { $0.estudiante } ?? []
    }

    init(codigo: String, nombre: String, creditos: Int, profesor: String) {
        self.id = UUID()
        self.codigo = codigo
        self.nombre = nombre
        self.creditos = creditos
        self.profesor = profesor
    }
}
@Model
class Matricula {
    var id: UUID
    var fechaMatricula: Date
    var calificacion: Double?
    var semestre: String

    //Relación muchos a 1:
    //-Un estudiante puede tener varia matrícula
    //-cada matrícula pertenece a un estudiante.
    var estudiante: Estudiante?

    //Relación muchos a 1: cada matrícula es para 1 curso
    var curso: Curso?

    init(
        estudiante: Estudiante? = nil,
        curso: Curso? = nil,
        semestre: String,
        calificacion: Double? = nil
    ) {

        self.id = UUID()
        self.fechaMatricula = Date()
        self.semestre = semestre
        self.calificacion = calificacion
        self.estudiante = estudiante
        self.curso = curso
    }
    /*
    func crearDatosEjemplo(container: ModelContainer) {
     let context = ModelContext(container)

     let estudiante1 = Estudiante(
         nombre: "Ana García",
         email: "ana.garcia@uni.edu",
         fechaNacimiento: Calendar.current.date(
             from: DateComponents(year: 1990, month: 1, day: 15)
         )!
     )
     let estudiante2 = Estudiante(
         nombre: "Carlos Pérez",
         email: "carlos.perez@uni.edu",
         fechaNacimiento: Calendar.current.date(
             from: DateComponents(year: 2000, month: 2, day: 11)
         )!
     )

     let curso1 = Curso(
         codigo: "CAL01",
         nombre: "Cálculo 1",
         creditos: 4,
         profesor: "Sr. Gómez"
     )

     let curso2 = Curso(
         codigo: "SWF1",
         nombre: "Cálculo I",
         creditos: 4,
         profesor: "Sr. Gómez"
     )
     let matricula1 = Matricula(
         estudiante: estudiante1,
         curso: curso1,
         semestre: "2026-1",
         calificacion: 8.5
     )
     let matricula2 = Matricula(
         estudiante: estudiante1,
         curso: curso2,
         semestre: "2026-1"
     )
     let matricula3 = Matricula(
         estudiante: estudiante2,
         curso: curso1,
         semestre: "2025-1",
         calificacion: 3
     )
    }
     */
     
}
