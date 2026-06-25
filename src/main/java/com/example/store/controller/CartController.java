package com.example.store.controller;

import com.example.store.common.Result;
import com.example.store.entity.CartItem;
import com.example.store.service.CartService;
import com.example.store.vo.CartItemVO;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/cart")
@RequiredArgsConstructor
public class CartController {

    private final CartService cartService;

    /** 查询购物车 */
    @GetMapping("/{userId}")
    public Result<List<CartItemVO>> list(@PathVariable Long userId) {
        return Result.success(cartService.getCartItems(userId));
    }

    /** 加入购物车 */
    @PostMapping
    public Result<Void> add(@RequestBody CartRequest req) {
        cartService.addOrUpdate(req.getUserId(), req.getProductId(), req.getQuantity());
        return Result.success();
    }

    /** 删除购物车项 */
    @DeleteMapping("/{userId}/{cartItemId}")
    public Result<Void> remove(@PathVariable Long userId, @PathVariable Long cartItemId) {
        cartService.removeItem(userId, cartItemId);
        return Result.success();
    }

    @Data
    public static class CartRequest {
        private Long userId;
        private Long productId;
        private Integer quantity;
    }
}
