package com.example.store.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.store.common.Result;
import com.example.store.entity.Order;
import com.example.store.entity.OrderItem;
import com.example.store.service.OrderService;
import com.example.store.vo.OrderItemVO;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/order")
@RequiredArgsConstructor
public class OrderController {

    private final OrderService orderService;

    /** 提交订单 */
    @PostMapping
    public Result<Order> place(@RequestBody PlaceOrderRequest req) {
        return Result.success(orderService.placeOrder(req.getUserId(), req.getItems()));
    }

    /** 分页查询用户订单 */
    @GetMapping("/{userId}")
    public Result<Page<Order>> list(
            @PathVariable Long userId,
            @RequestParam(defaultValue = "1")  Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {
        return Result.success(orderService.listByUser(userId, pageNum, pageSize));
    }

    /** 查询订单明细（含商品名称） */
    @GetMapping("/{orderId}/items")
    public Result<List<OrderItemVO>> items(@PathVariable Long orderId) {
        return Result.success(orderService.getOrderItems(orderId));
    }

    /** 更新订单状态（管理端） */
    @PutMapping("/status")
    public Result<Void> updateStatus(@RequestBody Order order) {
        orderService.updateById(order);
        return Result.success();
    }

    @Data
    public static class PlaceOrderRequest {
        private Long userId;
        private List<OrderItem> items;
    }
}
