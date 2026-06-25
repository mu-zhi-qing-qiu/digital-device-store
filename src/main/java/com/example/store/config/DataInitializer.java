package com.example.store.config;

import com.example.store.entity.User;
import com.example.store.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.ApplicationRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

/**
 * 启动时初始化种子数据（密码经 BCrypt 加密后写入，每次启动幂等）
 */
@Slf4j
@Configuration
@RequiredArgsConstructor
public class DataInitializer {

    private final UserService userService;
    private final PasswordEncoder passwordEncoder;

    @Bean
    public ApplicationRunner seedData() {
        return args -> {
            createUserIfAbsent("admin",    "123456", "13800000000", "admin@store.com",    1);
            createUserIfAbsent("zhangsan", "123456", "13811112222", "zhangsan@qq.com",    0);
        };
    }

    private void createUserIfAbsent(String username, String rawPassword,
                                    String phone, String email, int role) {
        if (userService.lambdaQuery().eq(User::getUsername, username).exists()) {
            return;
        }
        User u = new User();
        u.setUsername(username);
        u.setPassword(passwordEncoder.encode(rawPassword));
        u.setPhone(phone);
        u.setEmail(email);
        u.setRole(role);
        userService.save(u);
        log.info("已初始化用户: {}", username);
    }
}
