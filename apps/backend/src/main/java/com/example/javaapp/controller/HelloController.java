package com.example.javaapp.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@CrossOrigin(origins = {"http://localhost:5173", "http://localhost:3000"})
@RestController
@RequestMapping("/api")
public class HelloController {

    @GetMapping("/hello")
    public ResponseEntity<Map<String, String>> hello(@RequestParam(name = "name", defaultValue = "World") String name) {
        return ResponseEntity.ok(Map.of("message", "Hello, " + name + "!"));
    }

    @GetMapping("/add")
    public ResponseEntity<Map<String, Object>> add(
            @RequestParam(name = "a") int a,
            @RequestParam(name = "b") int b) {
        int sum = a + b;
        return ResponseEntity.ok(Map.of(
                "a", a,
                "b", b,
                "sum", sum
        ));
    }
}
