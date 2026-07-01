package com.example.store.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.store.entity.Product;
import com.example.store.mapper.ProductMapper;
import com.example.store.service.ProductService;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
public class ProductServiceImpl extends ServiceImpl<ProductMapper, Product> implements ProductService {

    @Override
    public Page<Product> search(Integer pageNum, Integer pageSize, Long categoryId, String keyword) {
        LambdaQueryWrapper<Product> wrapper = new LambdaQueryWrapper<Product>()
                .eq(categoryId != null, Product::getCategoryId, categoryId);
        if (StringUtils.hasText(keyword)) {
            // 走 product.name 的 FULLTEXT(ngram) 索引；BOOLEAN 模式下用短语匹配，
            // 行为接近原来的 LIKE '%关键词%' 子串检索。{0} 由 MyBatis-Plus 参数化，避免注入。
            String phrase = "\"" + keyword.replace("\"", " ") + "\"";
            wrapper.apply("MATCH(`name`) AGAINST({0} IN BOOLEAN MODE)", phrase);
        }
        return page(new Page<>(pageNum, pageSize), wrapper);
    }
}
