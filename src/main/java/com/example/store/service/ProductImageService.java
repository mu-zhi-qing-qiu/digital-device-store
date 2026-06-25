package com.example.store.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.example.store.entity.ProductImage;

import java.util.List;

public interface ProductImageService extends IService<ProductImage> {
    List<ProductImage> listByProduct(Long productId);
}
