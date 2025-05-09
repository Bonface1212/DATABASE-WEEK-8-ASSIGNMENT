USE clinic_bookingdb;

-- Create Specializations table
CREATE TABLE Specializations (
    specialization_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- Create Patients table
CREATE TABLE Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    contact_info VARCHAR(150) NOT NULL
);

-- Create Doctors table
CREATE TABLE Doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    specialization_id INT NOT NULL,
    contact_info VARCHAR(150),
    FOREIGN KEY (specialization_id) REFERENCES Specializations(specialization_id)
);

-- Create Appointments table
CREATE TABLE Appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    status ENUM('Scheduled', 'Completed', 'Cancelled') DEFAULT 'Scheduled',
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- Create Treatments table
CREATE TABLE Treatments (
    treatment_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    description TEXT NOT NULL,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);

-- Create Prescriptions table
CREATE TABLE Prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    treatment_id INT NOT NULL,
    medication VARCHAR(100) NOT NULL,
    dosage VARCHAR(50) NOT NULL,
    duration VARCHAR(50) NOT NULL,
    FOREIGN KEY (treatment_id) REFERENCES Treatments(treatment_id)
);

-- Create Payments table
CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATE NOT NULL,
    payment_method ENUM('Cash', 'Card', 'Insurance', 'Mobile Money') NOT NULL,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);

-- Insert sample data into Specializations
INSERT INTO Specializations (name) VALUES
('Cardiology'), ('Dermatology'), ('Pediatrics'), ('Orthopedics');

-- Insert sample data into Patients
INSERT INTO Patients (full_name, date_of_birth, gender, contact_info) VALUES
('John Doe', '1985-05-20', 'Male', 'john.doe@gmail.com'),
('Jane Smith', '1992-11-14', 'Female', 'jane.smith@gmail.com'),
('Mike Brown', '2001-03-10', 'Male', 'mike.brown@gmail.com');

-- Insert sample data into Doctors
INSERT INTO Doctors (full_name, specialization_id, contact_info) VALUES
('Dr. Alice Johnson', 1, 'alice.johnson@clinic.com'),
('Dr. Bob Lee', 2, 'bob.lee@clinic.com'),
('Dr. Clara Adams', 3, 'clara.adams@clinic.com');

-- Insert sample data into Appointments
INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status) VALUES
(1, 1, '2025-05-10 09:00:00', 'Scheduled'),
(2, 2, '2025-05-11 14:00:00', 'Completed'),
(3, 3, '2025-05-12 11:30:00', 'Cancelled');

-- Insert sample data into Treatments
INSERT INTO Treatments (appointment_id, description) VALUES
(2, 'Skin rash treatment and topical cream recommendation');

-- Insert sample data into Prescriptions
INSERT INTO Prescriptions (treatment_id, medication, dosage, duration) VALUES
(1, 'Hydrocortisone Cream', 'Apply twice daily', '7 days');

-- Insert sample data into Payments
INSERT INTO Payments (appointment_id, amount, payment_date, payment_method) VALUES
(2, 75.00, '2025-05-11', 'Card');

 -- Get all upcoming appointments
SELECT a.appointment_id, p.full_name AS patient, d.full_name AS doctor, a.appointment_date
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id
WHERE a.status = 'Scheduled';

-- Get treatment and prescription details for a completed appointment
SELECT t.description, pr.medication, pr.dosage, pr.duration
FROM Treatments t
JOIN Prescriptions pr ON t.treatment_id = pr.treatment_id
JOIN Appointments a ON t.appointment_id = a.appointment_id
WHERE a.status = 'Completed';

-- Total payments made per payment method
SELECT payment_method, SUM(amount) AS total_collected
FROM Payments
GROUP BY payment_method;

-- List of doctors and their specializations
SELECT d.full_name, s.name AS specialization
FROM Doctors d
JOIN Specializations s ON d.specialization_id = s.specialization_id;

-- Number of appointments per doctor
SELECT d.full_name, COUNT(a.appointment_id) AS total_appointments
FROM Doctors d
LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.full_name;