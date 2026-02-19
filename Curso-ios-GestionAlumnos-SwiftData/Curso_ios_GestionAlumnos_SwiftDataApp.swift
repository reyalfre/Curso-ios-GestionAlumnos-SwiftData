//
//  Curso_ios_GestionAlumnos_SwiftDataApp.swift
//  Curso-ios-GestionAlumnos-SwiftData
//
//  Created by Equipo 8 on 18/2/26.
//

import SwiftUI
import SwiftData
@main
struct Curso_ios_GestionAlumnos_SwiftDataApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Estudiante.self, Curso.self, Matricula.self])
    }
}
