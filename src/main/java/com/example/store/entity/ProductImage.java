package com.example.store.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.io.Serializable;

@Data
@TableName("product_image")
public class ProductImage implements Serializable {

    @TableId(type = IdType.AUTO)
    private Long id;
    private Long productId;
    private String url;
}
