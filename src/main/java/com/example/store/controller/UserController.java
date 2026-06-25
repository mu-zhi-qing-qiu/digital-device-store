package com.example.store.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.store.common.Result;
import com.example.store.dto.LoginRequest;
import com.example.store.entity.User;
import com.example.store.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

/**
 * 用户接口
 * 这是其余模块（商品、订单等）可以照搬的标准模板：
 * Controller -> Service(IService) -> Mapper(BaseMapper) -> 实体
 */
@RestController
@RequestMapping("/api/user")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    /** 注册 */
    @PostMapping("/register")
    public Result<User> register(@RequestBody User user) {
        return Result.success(userService.register(user));
    }

    /** 登录 */
    @PostMapping("/login")
    public Result<User> login(@Valid @RequestBody LoginRequest req) {
        return Result.success(userService.login(req.username(), req.password()));
    }

    /** 分页查询用户列表 */
    @GetMapping("/page")
    public Result<Page<User>> page(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {
        Page<User> page = userService.page(new Page<>(pageNum, pageSize));
        page.getRecords().forEach(u -> u.setPassword(null));
        return Result.success(page);
    }

    /** 根据 ID 查询用户 */
    @GetMapping("/{id}")
    public Result<User> getById(@PathVariable Long id) {
        User user = userService.getById(id);
        if (user != null) {
            user.setPassword(null);
        }
        return Result.success(user);
    }

    /** 更新用户 */
    @PutMapping
    public Result<Void> update(@RequestBody User user) {
        userService.updateById(user);
        return Result.success();
    }

    /** 删除用户 */
    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        userService.removeById(id);
        return Result.success();
    }
}
