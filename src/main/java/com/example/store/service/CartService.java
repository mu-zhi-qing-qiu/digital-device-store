package com.example.store.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.example.store.entity.CartItem;
import com.example.store.vo.CartItemVO;

import java.util.List;

public interface CartService extends IService<CartItem> {
    /** 获取用户购物车列表（含商品信息） */
    List<CartItemVO> getCartItems(Long userId);
    /** 加入购物车或修改数量 */
    void addOrUpdate(Long userId, Long productId, Integer quantity);
    /** 删除购物车项 */
    void removeItem(Long userId, Long cartItemId);
}
