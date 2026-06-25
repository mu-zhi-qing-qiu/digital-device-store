package com.example.store.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.store.entity.Category;
import com.example.store.mapper.CategoryMapper;
import com.example.store.service.CategoryService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CategoryServiceImpl extends ServiceImpl<CategoryMapper, Category> implements CategoryService {

    @Override
    public List<Category> listByParent(Long parentId) {
        if (parentId == null) {
            return lambdaQuery().isNull(Category::getParentId).list();
        }
        return lambdaQuery().eq(Category::getParentId, parentId).list();
    }
}
