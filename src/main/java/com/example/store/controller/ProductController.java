package com.example.store.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.store.common.Result;
import com.example.store.entity.Product;
import com.example.store.entity.ProductImage;
import com.example.store.service.ProductService;
import com.example.store.service.ProductImageService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/product")
@RequiredArgsConstructor
public class ProductController {

    private final ProductService productService;
    private final ProductImageService productImageService;

    /** 分页搜索商品（可按分类、关键词过滤） */
    @GetMapping
    public Result<Page<Product>> list(
            @RequestParam(defaultValue = "1")  Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false)    Long categoryId,
            @RequestParam(required = false)    String keyword) {
        return Result.success(productService.search(pageNum, pageSize, categoryId, keyword));
    }

    /** 商品详情（含图片列表） */
    @GetMapping("/{id}")
    public Result<Product> getById(@PathVariable Long id) {
        return Result.success(productService.getById(id));
    }

    /** 获取商品图片 */
    @GetMapping("/{id}/images")
    public Result<List<ProductImage>> getImages(@PathVariable Long id) {
        return Result.success(productImageService.listByProduct(id));
    }

    @PostMapping
    public Result<Void> add(@RequestBody Product product) {
        productService.save(product);
        return Result.success();
    }

    @PutMapping
    public Result<Void> update(@RequestBody Product product) {
        productService.updateById(product);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        productService.removeById(id);
        return Result.success();
    }
}
