package com.example.store.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.example.store.entity.Order;
import com.example.store.entity.OrderItem;
import com.example.store.vo.OrderItemVO;

import java.util.List;

public interface OrderService extends IService<Order> {
    Order placeOrder(Long userId, List<OrderItem> items);
    Page<Order> listByUser(Long userId, Integer pageNum, Integer pageSize);
    Page<Order> pageAll(Integer pageNum, Integer pageSize);
    /** 查询订单明细（含商品名称） */
    List<OrderItemVO> getOrderItems(Long orderId);
}
