package com.example.store.dto;

import com.example.store.entity.User;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class AuthResponse {
    private User user;
    private String token;
}
