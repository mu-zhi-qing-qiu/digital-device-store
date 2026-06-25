package com.example.store.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.store.entity.Review;
import com.example.store.mapper.ReviewMapper;
import com.example.store.service.ReviewService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ReviewServiceImpl extends ServiceImpl<ReviewMapper, Review> implements ReviewService {

    @Override
    public List<Review> listByProduct(Long productId) {
        return lambdaQuery().eq(Review::getProductId, productId).list();
    }
}
