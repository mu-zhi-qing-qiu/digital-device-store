package com.example.store.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("`order`")   // order 是 MySQL 保留字，需加反引号
public class Order implements Serializable {

    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private BigDecimal totalAmount;
    /** 0-待付款 1-已付款 2-已发货 3-已完成 4-已取消 */
    private Integer status;
    private LocalDateTime createdTime;
}
