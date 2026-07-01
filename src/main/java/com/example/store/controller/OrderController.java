package com.example.store.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.store.common.auth.AuthContext;
import com.example.store.common.Result;
import com.example.store.common.exception.BizException;
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
        return Result.success(orderService.placeOrder(AuthContext.userId(), req.getItems()));
    }

    /** 分页查询用户订单 */
    @GetMapping
    public Result<Page<Order>> list(
            @RequestParam(defaultValue = "1")  Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {
        return Result.success(orderService.listByUser(AuthContext.userId(), pageNum, pageSize));
    }

    /** 管理端分页查询全部订单 */
    @GetMapping("/admin/page")
    public Result<Page<Order>> page(
            @RequestParam(defaultValue = "1")  Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {
        return Result.success(orderService.pageAll(pageNum, pageSize));
    }

    /** 查询订单明细（含商品名称） */
    @GetMapping("/{orderId}/items")
    public Result<List<OrderItemVO>> items(@PathVariable Long orderId) {
        Order order = orderService.getById(orderId);
        if (order == null) {
            throw new BizException("订单不存在");
        }
        if (!AuthContext.isAdmin() && !order.getUserId().equals(AuthContext.userId())) {
            throw new BizException(403, "无权查看其他用户订单");
        }
        return Result.success(orderService.getOrderItems(orderId));
    }

    /** 支付订单（用户支付本人订单：待付款 -> 已付款） */
    @PostMapping("/{orderId}/pay")
    public Result<Void> pay(@PathVariable Long orderId) {
        orderService.payOrder(AuthContext.userId(), orderId);
        return Result.success();
    }

    /** 更新订单状态（管理端） */
    @PutMapping("/status")
    public Result<Void> updateStatus(@RequestBody Order order) {
        orderService.updateById(order);
        return Result.success();
    }

    @Data
    public static class PlaceOrderRequest {
        private List<OrderItem> items;
    }
}
