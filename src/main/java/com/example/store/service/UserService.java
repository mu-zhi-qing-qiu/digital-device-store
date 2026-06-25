package com.example.store.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.example.store.entity.User;

/**
 * 用户 Service
 * 继承 IService 后即拥有 save / getById / page / removeById 等通用方法，
 * 这里只声明额外的业务方法（注册、登录）。
 */
public interface UserService extends IService<User> {

    /** 注册 */
    User register(User user);

    /** 登录 */
    User login(String username, String password);
}
