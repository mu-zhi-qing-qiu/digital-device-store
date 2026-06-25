package com.example.store.common.exception;

import lombok.Getter;

/**
 * 业务异常：service 层校验失败时抛出，由全局异常处理器统一转换为 Result
 */
@Getter
public class BizException extends RuntimeException {

    private final Integer code;

    public BizException(String message) {
        super(message);
        this.code = 500;
    }

    public BizException(Integer code, String message) {
        super(message);
        this.code = code;
    }
}
