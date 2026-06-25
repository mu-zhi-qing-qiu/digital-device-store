package com.example.store.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.store.entity.User;

/**
 * 用户 Mapper
 * 继承 BaseMapper 后即拥有单表的增删改查能力，无需写任何 SQL。
 * 需要自定义复杂 SQL 时，可在此声明方法并在 resources/mapper/UserMapper.xml 中实现。
 */
public interface UserMapper extends BaseMapper<User> {
}
