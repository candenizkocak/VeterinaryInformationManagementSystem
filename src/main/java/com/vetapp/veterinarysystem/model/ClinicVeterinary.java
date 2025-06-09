package com.vetapp.veterinarysystem.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "ClinicVeterinaries")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ClinicVeterinary {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "ClinicID", nullable = false)
    @ToString.Exclude // <--- Eklendi
    private Clinic clinic;

    @ManyToOne
    @JoinColumn(name = "VeterinaryID", nullable = false)
    @ToString.Exclude // <--- Eklendi
    private Veterinary veterinary;
}

/**
Bu sınıf, klinik ve veteriner arasındaki çoktan çoğa (many-to-many) ilişkiyi yönetmek için ara tabloyu temsil eder.

🔁 Eğer Clinic ve Veterinary sınıflarında da bu ilişkiyi ters tarafta göstermek istersen, @OneToMany(mappedBy = "...") anotasyonları da eklenebilir.
*/


/* Önceki kodlar:

        package com.vetapp.veterinarysystem.model;

import jakarta.persistence.*;
        import lombok.*;

@Entity
@Table(name = "ClinicVeterinaries")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ClinicVeterinary {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "ClinicID", nullable = false)
    private Clinic clinic;

    @ManyToOne
    @JoinColumn(name = "VeterinaryID", nullable = false)
    private Veterinary veterinary;
}

/**
 Bu sınıf, klinik ve veteriner arasındaki çoktan çoğa (many-to-many) ilişkiyi yönetmek için ara tabloyu temsil eder.

 🔁 Eğer Clinic ve Veterinary sınıflarında da bu ilişkiyi ters tarafta göstermek istersen, @OneToMany(mappedBy = "...") anotasyonları da eklenebilir.
 */