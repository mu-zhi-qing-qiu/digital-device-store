package com.example.store.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.example.store.entity.Review;

import java.util.List;

public interface ReviewService extends IService<Review> {
    List<Review> listByProduct(Long productId);
}
