package com.example.store.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.store.common.exception.BizException;
import com.example.store.entity.User;
import com.example.store.mapper.UserMapper;
import com.example.store.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {

    private final PasswordEncoder passwordEncoder;

    @Override
    public User register(User user) {
        if (lambdaQuery().eq(User::getUsername, user.getUsername()).exists()) {
            throw new BizException("用户名已存在");
        }
        user.setRole(user.getRole() == null ? 0 : user.getRole());
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        save(user);
        user.setPassword(null);
        return user;
    }

    @Override
    public User login(String username, String password) {
        User user = lambdaQuery().eq(User::getUsername, username).one();
        if (user == null || !passwordEncoder.matches(password, user.getPassword())) {
            throw new BizException("用户名或密码错误");
        }
        user.setPassword(null);
        return user;
    }
}
