//
//  MatriculasViewModel.swift
//  Curso-ios-GestionAlumnos-SwiftData
//
//  Created by Equipo 8 on 20/2/26.
//

import SwiftData
import SwiftUI

@Observable
class MatriculasViewModel {
    var todasLasMatriculas: [Matricula] = []
    var matriculasAprobadas: [Matricula] = []
    var matriculasDeAlumno: [Matricula] = []

    private var context: ModelContext

    init(context: ModelContext) {
        self.context = context
        cargarDatos()
    }
    func cargarDatos(nombreAlumno: String? = nil) {
        do {
            let descriptorTodas = FetchDescriptor<Matricula>(
                sortBy: [SortDescriptor(\.fechaMatricula, order: .reverse)]
            )
            todasLasMatriculas = try context.fetch(descriptorTodas)
            
            let filtroAprobadas = #Predicate<Matricula> {
                matricula in (matricula.calificacion ?? 0.0) >= 5.0
            }
            let descriptorAprobadas = FetchDescriptor<Matricula>(
                predicate: filtroAprobadas, sortBy: [SortDescriptor(\.fechaMatricula, order: .reverse)])
            matriculasAprobadas = try context.fetch(descriptorAprobadas)
            
        } catch {
            print("Error cargando matrículas: \(error)")
        }
    }
}
