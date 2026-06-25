package com.example.store.service.impl;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.store.common.exception.BizException;
import com.example.store.entity.Order;
import com.example.store.entity.OrderItem;
import com.example.store.entity.Product;
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
    private final ProductService productService;

    @Override
    @Transactional
    public Order placeOrder(Long userId, List<OrderItem> items) {
        if (items == null || items.isEmpty()) {
            throw new BizException("订单项不能为空");
        }
        // 批量查询商品，避免 N+1
        List<Long> productIds = items.stream().map(OrderItem::getProductId).toList();
        Map<Long, Product> productMap = productService.listByIds(productIds).stream()
                .collect(Collectors.toMap(Product::getId, p -> p));

        BigDecimal total = BigDecimal.ZERO;
        for (OrderItem item : items) {
            Product product = productMap.get(item.getProductId());
            if (product == null) throw new BizException("商品不存在: " + item.getProductId());
            if (product.getStock() < item.getQuantity()) throw new BizException("商品库存不足: " + product.getName());
            item.setPurchasePrice(product.getPrice());
            total = total.add(product.getPrice().multiply(BigDecimal.valueOf(item.getQuantity())));
            product.setStock(product.getStock() - item.getQuantity());
            productService.updateById(product);
        }
        Order order = new Order();
        order.setUserId(userId);
        order.setTotalAmount(total);
        order.setStatus(0);
        order.setCreatedTime(LocalDateTime.now());
        save(order);
        items.forEach(item -> {
            item.setOrderId(order.getId());
            orderItemMapper.insert(item);
        });
        return order;
    }

    @Override
    public Page<Order> listByUser(Long userId, Integer pageNum, Integer pageSize) {
        return lambdaQuery().eq(Order::getUserId, userId)
                .orderByDesc(Order::getCreatedTime)
                .page(new Page<>(pageNum, pageSize));
    }

    @Override
    public List<OrderItemVO> getOrderItems(Long orderId) {
        return orderItemMapper.selectWithProductByOrderId(orderId);
    }
}
