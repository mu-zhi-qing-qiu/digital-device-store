package com.example.store.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.store.common.exception.BizException;
import com.example.store.entity.Cart;
import com.example.store.entity.CartItem;
import com.example.store.mapper.CartItemMapper;
import com.example.store.mapper.CartMapper;
import com.example.store.service.CartService;
import com.example.store.vo.CartItemVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CartServiceImpl extends ServiceImpl<CartItemMapper, CartItem> implements CartService {

    private final CartMapper cartMapper;

    private Long getOrCreateCart(Long userId) {
        Cart cart = cartMapper.selectOne(
                new LambdaQueryWrapper<Cart>().eq(Cart::getUserId, userId));
        if (cart == null) {
            cart = new Cart();
            cart.setUserId(userId);
            cartMapper.insert(cart);
        }
        return cart.getId();
    }

    @Override
    public List<CartItemVO> getCartItems(Long userId) {
        return baseMapper.selectWithProductByUserId(userId);
    }

    @Override
    public void addOrUpdate(Long userId, Long productId, Integer quantity) {
        Long cartId = getOrCreateCart(userId);
        CartItem existing = lambdaQuery()
                .eq(CartItem::getCartId, cartId)
                .eq(CartItem::getProductId, productId).one();
        if (existing != null) {
            existing.setQuantity(existing.getQuantity() + quantity);
            updateById(existing);
        } else {
            CartItem item = new CartItem();
            item.setCartId(cartId);
            item.setProductId(productId);
            item.setQuantity(quantity);
            save(item);
        }
    }

    @Override
    public void removeItem(Long userId, Long cartItemId) {
        CartItem item = getById(cartItemId);
        if (item == null || !item.getCartId().equals(getOrCreateCart(userId))) {
            throw new BizException("购物车项不存在");
        }
        removeById(cartItemId);
    }
}
