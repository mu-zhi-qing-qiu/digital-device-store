package com.example.store.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.store.entity.CartItem;
import com.example.store.vo.CartItemVO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface CartItemMapper extends BaseMapper<CartItem> {
    List<CartItemVO> selectWithProductByUserId(@Param("userId") Long userId);
}
