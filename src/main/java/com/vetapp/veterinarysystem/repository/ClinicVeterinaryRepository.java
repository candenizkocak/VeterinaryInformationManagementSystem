package com.vetapp.veterinarysystem.repository;

import com.vetapp.veterinarysystem.model.Clinic;
import com.vetapp.veterinarysystem.model.ClinicVeterinary;
import com.vetapp.veterinarysystem.model.Veterinary;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ClinicVeterinaryRepository extends JpaRepository<ClinicVeterinary, Long> {
    List<ClinicVeterinary> findByClinic(Clinic clinic);
    void deleteByClinicAndVeterinary(Clinic clinic, Veterinary veterinary);

    List<ClinicVeterinary> findByVeterinary(Veterinary veterinary);

    // YENİ VE DAHA ROBUST SORGUNUZ:
    // Bu sorgu, ClinicVeterinary tablosu üzerinden klinik ID'sine göre filtreleme yapar.
    // Ancak, direkt olarak Veterinary entity'lerini ve onların User ilişkilerini (JOIN FETCH v.user) yükler.
    // DISTINCT anahtar kelimesi, bir veterinerin bir kliniğe birden fazla kez atanması durumunda
    // tekrarlanan veteriner kayıtlarını engeller.
    @Query("SELECT DISTINCT v FROM Veterinary v JOIN v.clinicVeterinaries cv JOIN FETCH v.user WHERE cv.clinic.clinicId = :clinicId")
    List<Veterinary> findVeterinariesByClinicId(@Param("clinicId") Long clinicId);
}