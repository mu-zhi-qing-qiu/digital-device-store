package com.example.store.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.example.store.entity.Product;

public interface ProductService extends IService<Product> {
    /** 按分类和关键词分页查询 */
    Page<Product> search(Integer pageNum, Integer pageSize, Long categoryId, String keyword);
}
