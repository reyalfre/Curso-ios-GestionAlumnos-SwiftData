//
//  ContentView.swift
//  Curso-ios-GestionAlumnos-SwiftData
//
//  Created by Equipo 8 on 18/2/26.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var context
    var body: some View {
        TabView {
            VistaEstudiante()
                .tabItem {
                    Label("Estudiantes", systemImage: "person.3")
                }
            VistaCursos()
                .tabItem {
                    Label("Cursos", systemImage: "book")
                }
            VistaMatriculas(context: context)
                .tabItem {
                    Label("Matrículas", systemImage: "list.bullet.clipboard")
                }
        }
        .padding()
    }
}

struct VistaEstudiante: View {
    @Environment(\.modelContext) private var context
    @Query private var estudiantes: [Estudiante]
    @State private var mostrarNuevoEstudiante = false
    var body: some View {
        NavigationStack {
            List {
                ForEach(estudiantes) {
                    estudiante in
                    NavigationLink(
                        destination: VistaDetalleEstudiante(
                            estudiante: estudiante
                        )
                    ) {
                        VStack(alignment: .leading) {
                            Text(estudiante.nombre)
                                .font(.headline)
                            Text(estudiante.email)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("Cursos: \(estudiante.cursos.count)")
                        }
                    }
                }
                .onDelete {
                    indices in
                    for indice in indices {
                        context.delete(estudiantes[indice])
                    }
                }
            }
            .navigationTitle("Estudiantes")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Agregar") {
                        mostrarNuevoEstudiante.toggle()
                    }
                }
            }
            .sheet(isPresented: $mostrarNuevoEstudiante) {
                VistaNuevoEstudiante(context: context)
            }
        }
    }
}

struct VistaDetalleEstudiante: View {
    let estudiante: Estudiante
    @Environment(\.modelContext) private var context
    @State private var mostrarMatricular = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            //            .navigationTitle("ee")
            VStack(alignment: .leading, spacing: 10) {
                Text(estudiante.nombre)
                    .font(.title)
                Text(estudiante.email)
                    .foregroundStyle(.secondary)
                Text("Nacimiento: \(estudiante.fechaNacimiento, style: .date)")
                    .font(.caption)
            }
            .padding()

            List {
                Section("Cursos matriculados") {
                    if let matriculas = estudiante.matriculas,
                        !matriculas.isEmpty
                    {
                        ForEach(matriculas) {
                            matricula in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(matricula.curso?.nombre ?? "Sin curso")
                                        .font(.headline)
                                    Text("Semestre. \(matricula.semestre)")
                                        .font(.caption)
                                    if let calificacion = matricula.calificacion
                                    {
                                        Text(
                                            "Calificacion: \(calificacion, specifier: "%.2f")"
                                        )
                                        .font(.caption)
                                        .foregroundStyle(
                                            calificacion >= 5.0 ? .green : .red
                                        )
                                    }
                                    Spacer()
                                    Button("Eliminar") {
                                        context.delete(matricula)
                                    }
                                    .buttonStyle(.bordered)
                                    .tint(.red)
                                }
                            }
                        }
                    } else {
                        Text("No tiene cursos matriculados")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            Spacer()
        }
        .navigationTitle("Detalle Estudiante")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Matricular en curso") {
                    mostrarMatricular = true
                }
            }
        }
        .sheet(isPresented: $mostrarMatricular) {
            VistaMatricularEstudiante(estudiante: estudiante)
        }
    }
}

struct VistaMatricularEstudiante: View {
    let estudiante: Estudiante
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @Query private var cursos: [Curso]

    //Necesitamos los cursos en los que no está matriculado

    var cursosNoMatriculados: [Curso] {
        let cursosMatriculados = estudiante.cursos
        return cursos.filter {
            !cursosMatriculados.contains($0)
        }
        //  cursos.filter(\.self.estudiante.isDeleted == nil)
    }
    @State private var cursoSeleccionado: Curso?
    @State private var semestre = "2026-1"
    @State private var calificacion: Double?
    var body: some View {
        NavigationStack {
            Form {
                Picker("Curso", selection: $cursoSeleccionado) {
                    Text("Seleccionar curso")
                        .tag(nil as Curso?)
                    ForEach(cursosNoMatriculados) {
                        curso in
                        Text("\(curso.codigo) - \(curso.nombre)")
                            .tag(curso as Curso?)
                    }
                }
                TextField("Semestre", text: $semestre)

                TextField(
                    "Calificación (opcional)",
                    value: $calificacion,
                    format: .number
                )
                .keyboardType(.decimalPad)
                Section {
                    Button("Matricular") {
                        guard let curso = cursoSeleccionado else {
                            return
                        }
                        let matricula = Matricula(
                            estudiante: estudiante,
                            curso: curso,
                            semestre: semestre,
                            calificacion: calificacion
                        )

                        context.insert(matricula)
                        dismiss()
                    }
                    .disabled(cursoSeleccionado == nil || semestre.isEmpty)
                }
            }
            .navigationTitle("Nueva matrícula")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }

        }
    }
}




#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: Estudiante.self,
        Curso.self,
        Matricula.self,
        configurations: config
    )

    crearDatosEjemplo(container: container)

    return ContentView()
        .modelContainer(container)
}

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

    context.insert(estudiante1)
    context.insert(estudiante2)
    context.insert(curso1)
    context.insert(curso2)
    context.insert(matricula1)
    context.insert(matricula2)
    context.insert(matricula3)

    //Guardar los cambios manualmente (para que funcione en la Preview)
    try? context.save()

}
