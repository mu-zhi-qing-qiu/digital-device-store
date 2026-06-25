package com.example.store.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.example.store.entity.Category;

import java.util.List;

public interface CategoryService extends IService<Category> {
    /** 查询某父分类下的所有子分类 */
    List<Category> listByParent(Long parentId);
}
