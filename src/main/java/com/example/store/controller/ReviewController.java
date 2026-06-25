package com.example.store.controller;

import com.example.store.common.Result;
import com.example.store.entity.Review;
import com.example.store.service.ReviewService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/review")
@RequiredArgsConstructor
public class ReviewController {

    private final ReviewService reviewService;

    /** 查询商品评论 */
    @GetMapping("/product/{productId}")
    public Result<List<Review>> listByProduct(@PathVariable Long productId) {
        return Result.success(reviewService.listByProduct(productId));
    }

    /** 提交评论 */
    @PostMapping
    public Result<Void> add(@RequestBody Review review) {
        reviewService.save(review);
        return Result.success();
    }

    /** 删除评论（管理端） */
    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        reviewService.removeById(id);
        return Result.success();
    }
}
