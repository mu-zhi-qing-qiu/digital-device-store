package com.example.store.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.store.entity.OrderItem;
import com.example.store.vo.OrderItemVO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface OrderItemMapper extends BaseMapper<OrderItem> {
    List<OrderItemVO> selectWithProductByOrderId(@Param("orderId") Long orderId);
}
