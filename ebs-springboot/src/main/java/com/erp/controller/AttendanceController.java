package com.erp.controller;

import com.erp.common.ICommonController;
import com.erp.model.Attendance;
import com.erp.repository.AttendanceRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/attendance")
public class AttendanceController implements ICommonController<Attendance> {

	@Autowired
	private AttendanceRepository attendanceRepository;

	@Override
	@GetMapping
	public List<Attendance> getAll() {
		return attendanceRepository.findAll();
	}

	@Override
	@GetMapping("/{id}")
	public ResponseEntity<Attendance> getById(@PathVariable(value = "id") Long attendanceId) {
		Attendance attendance = attendanceRepository.getById(attendanceId);
		return ResponseEntity.ok().body(attendance);
	}

	@Override
	@PostMapping
	public Attendance save(@Validated @RequestBody Attendance attendance) {
		return attendanceRepository.save(attendance);
	}

	@PostMapping("/bulk")
	public List<Attendance> saveAll(@RequestBody List<Attendance> attendances) {
		return attendanceRepository.saveAll(attendances);
	}

	@Override
	@PutMapping("/{id}")
	public ResponseEntity<Attendance> update(@PathVariable(value = "id") Long attendanceId,
			@Validated @RequestBody Attendance attendanceDetails) {
		Attendance attendance = attendanceRepository.getById(attendanceId);

		attendance.setAttendanceCode(attendanceDetails.getAttendanceCode());
		attendance.setEmployeeCode(attendanceDetails.getEmployeeCode());
		attendance.setEmployeeName(attendanceDetails.getEmployeeName());
		attendance.setDate(attendanceDetails.getDate());
		attendance.setInTime(attendanceDetails.getInTime());
		attendance.setOutTime(attendanceDetails.getOutTime());
		attendance.setStatus(attendanceDetails.getStatus());

		final Attendance updatedAttendance = attendanceRepository.save(attendance);
		return ResponseEntity.ok(updatedAttendance);
	}

	@Override
	@DeleteMapping("/{id}")
	public Map<String, Boolean> delete(@PathVariable(value = "id") Long attendanceId) {
		Attendance attendance = attendanceRepository.getById(attendanceId);
		attendanceRepository.delete(attendance);
		Map<String, Boolean> response = new HashMap<>();
		response.put("deleted", Boolean.TRUE);
		return response;
	}

	@GetMapping("/absent-count/{employeeCode}")
	public ResponseEntity<Map<String, Integer>> getAbsentCount(@PathVariable Long employeeCode) {
		List<Attendance> attendances = attendanceRepository.findByEmployeeCode(employeeCode);

		int absentCount = 0;
		int lateCount = 0;

		for (Attendance att : attendances) {
			if ("Absent".equals(att.getStatus())) {
				absentCount++;
			} else if ("Late".equals(att.getStatus())) {
				lateCount++;
			}
		}

		absentCount += lateCount / 3;

		Map<String, Integer> response = new HashMap<>();
		response.put("absentCount", absentCount);
		return ResponseEntity.ok(response);
	}
}
