package com.example.store.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.store.common.exception.BizException;
import com.example.store.entity.Cart;
import com.example.store.entity.CartItem;
import com.example.store.entity.Order;
import com.example.store.entity.OrderItem;
import com.example.store.entity.Product;
import com.example.store.mapper.CartItemMapper;
import com.example.store.mapper.CartMapper;
import com.example.store.mapper.OrderItemMapper;
import com.example.store.mapper.OrderMapper;
import com.example.store.service.OrderService;
import com.example.store.service.ProductService;
import com.example.store.vo.OrderItemVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class OrderServiceImpl extends ServiceImpl<OrderMapper, Order> implements OrderService {

    private final OrderItemMapper orderItemMapper;
    private final CartMapper cartMapper;
    private final CartItemMapper cartItemMapper;
    private final ProductService productService;

    @Override
    @Transactional
    public Order placeOrder(Long userId, List<OrderItem> items) {
        if (items == null || items.isEmpty()) {
            throw new BizException("订单项不能为空");
        }
        for (OrderItem item : items) {
            if (item.getProductId() == null || item.getQuantity() == null || item.getQuantity() <= 0) {
                throw new BizException(400, "订单商品和数量不能为空，且数量必须大于 0");
            }
        }
        Map<Long, Integer> quantityByProductId = items.stream()
                .collect(Collectors.toMap(OrderItem::getProductId, OrderItem::getQuantity, Integer::sum));
        List<Long> productIds = quantityByProductId.keySet().stream().toList();
        Map<Long, Product> productMap = productService.listByIds(productIds).stream()
                .collect(Collectors.toMap(Product::getId, p -> p));

        BigDecimal total = BigDecimal.ZERO;
        for (Map.Entry<Long, Integer> entry : quantityByProductId.entrySet()) {
            Product product = productMap.get(entry.getKey());
            if (product == null) {
                throw new BizException("商品不存在: " + entry.getKey());
            }
            int quantity = entry.getValue();
            boolean deducted = productService.lambdaUpdate()
                    .eq(Product::getId, product.getId())
                    .ge(Product::getStock, quantity)
                    .setSql("stock = stock - " + quantity)
                    .update();
            if (!deducted) {
                throw new BizException("商品库存不足: " + product.getName());
            }
            total = total.add(product.getPrice().multiply(BigDecimal.valueOf(quantity)));
        }
        Order order = new Order();
        order.setUserId(userId);
        order.setTotalAmount(total);
        order.setStatus(0);
        order.setCreatedTime(LocalDateTime.now());
        save(order);
        quantityByProductId.forEach((productId, quantity) -> {
            Product product = productMap.get(productId);
            OrderItem item = new OrderItem();
            item.setOrderId(order.getId());
            item.setProductId(productId);
            item.setQuantity(quantity);
            item.setPurchasePrice(product.getPrice());
            orderItemMapper.insert(item);
        });
        clearPurchasedCartItems(userId, productIds);
        return order;
    }

    @Override
    public Page<Order> listByUser(Long userId, Integer pageNum, Integer pageSize) {
        return lambdaQuery().eq(Order::getUserId, userId)
                .orderByDesc(Order::getCreatedTime)
                .page(new Page<>(pageNum, pageSize));
    }

    @Override
    public Page<Order> pageAll(Integer pageNum, Integer pageSize) {
        return lambdaQuery()
                .orderByDesc(Order::getCreatedTime)
                .page(new Page<>(pageNum, pageSize));
    }

    @Override
    public List<OrderItemVO> getOrderItems(Long orderId) {
        return orderItemMapper.selectWithProductByOrderId(orderId);
    }

    private void clearPurchasedCartItems(Long userId, List<Long> productIds) {
        Cart cart = cartMapper.selectOne(new LambdaQueryWrapper<Cart>()
                .eq(Cart::getUserId, userId));
        if (cart == null) {
            return;
        }
        cartItemMapper.delete(new LambdaQueryWrapper<CartItem>()
                .eq(CartItem::getCartId, cart.getId())
                .in(CartItem::getProductId, productIds));
    }
}
