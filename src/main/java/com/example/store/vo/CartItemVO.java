package com.example.store.vo;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class CartItemVO {
    private Long id;
    private Long cartId;
    private Long productId;
    private Integer quantity;
    private String productName;
    private BigDecimal price;
    private String brand;
    private String imageUrl;
}
