package com.example.store.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.store.entity.ProductImage;
import com.example.store.mapper.ProductImageMapper;
import com.example.store.service.ProductImageService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductImageServiceImpl extends ServiceImpl<ProductImageMapper, ProductImage> implements ProductImageService {

    @Override
    public List<ProductImage> listByProduct(Long productId) {
        return lambdaQuery().eq(ProductImage::getProductId, productId).list();
    }
}
