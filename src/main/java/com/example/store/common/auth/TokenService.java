package com.example.store.common.auth;

import com.example.store.common.exception.BizException;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.Base64;

@Component
public class TokenService {

    private static final String SECRET = "digital-device-store-local-secret";
    private static final long EXPIRE_SECONDS = 7 * 24 * 60 * 60;

    public String createToken(Long userId) {
        long expiresAt = Instant.now().getEpochSecond() + EXPIRE_SECONDS;
        String payload = userId + ":" + expiresAt;
        return base64Url(payload) + "." + sign(payload);
    }

    public Long parseUserId(String token) {
        try {
            if (!StringUtils.hasText(token)) {
                throw new BizException(401, "请先登录");
            }
            String[] parts = token.split("\\.", 2);
            if (parts.length != 2) {
                throw new BizException(401, "登录状态无效");
            }
            String payload = new String(Base64.getUrlDecoder().decode(parts[0]), StandardCharsets.UTF_8);
            if (!sign(payload).equals(parts[1])) {
                throw new BizException(401, "登录状态无效");
            }
            String[] fields = payload.split(":", 2);
            if (fields.length != 2) {
                throw new BizException(401, "登录状态无效");
            }
            long expiresAt = Long.parseLong(fields[1]);
            if (expiresAt < Instant.now().getEpochSecond()) {
                throw new BizException(401, "登录已过期");
            }
            return Long.parseLong(fields[0]);
        } catch (BizException e) {
            throw e;
        } catch (Exception e) {
            throw new BizException(401, "登录状态无效");
        }
    }

    private String base64Url(String value) {
        return Base64.getUrlEncoder().withoutPadding()
                .encodeToString(value.getBytes(StandardCharsets.UTF_8));
    }

    private String sign(String payload) {
        try {
            Mac mac = Mac.getInstance("HmacSHA256");
            mac.init(new SecretKeySpec(SECRET.getBytes(StandardCharsets.UTF_8), "HmacSHA256"));
            return Base64.getUrlEncoder().withoutPadding()
                    .encodeToString(mac.doFinal(payload.getBytes(StandardCharsets.UTF_8)));
        } catch (Exception e) {
            throw new IllegalStateException("Failed to sign token", e);
        }
    }
}
