package com.example.store.config;

import com.example.store.common.auth.AuthContext;
import com.example.store.common.auth.TokenService;
import com.example.store.common.exception.BizException;
import com.example.store.entity.User;
import com.example.store.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
@RequiredArgsConstructor
public class AuthInterceptor implements HandlerInterceptor {

    private final TokenService tokenService;
    private final UserService userService;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        String method = request.getMethod();
        String uri = request.getRequestURI();

        if ("OPTIONS".equalsIgnoreCase(method) || isPublicEndpoint(method, uri)) {
            return true;
        }

        User user = currentUser(request);
        AuthContext.set(user);

        if (isAdminEndpoint(method, uri) && !Integer.valueOf(1).equals(user.getRole())) {
            AuthContext.clear();
            throw new BizException(403, "无管理员权限");
        }
        return true;
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {
        AuthContext.clear();
    }

    private User currentUser(HttpServletRequest request) {
        String header = request.getHeader("Authorization");
        if (!StringUtils.hasText(header) || !header.startsWith("Bearer ")) {
            throw new BizException(401, "请先登录");
        }
        Long userId = tokenService.parseUserId(header.substring(7));
        User user = userService.getById(userId);
        if (user == null) {
            throw new BizException(401, "登录用户不存在");
        }
        user.setPassword(null);
        return user;
    }

    private boolean isPublicEndpoint(String method, String uri) {
        if (uri.equals("/api/user/login") || uri.equals("/api/user/register")) {
            return true;
        }
        if ("GET".equalsIgnoreCase(method)) {
            return uri.startsWith("/api/product") || uri.startsWith("/api/category") || uri.startsWith("/api/review/product/");
        }
        return false;
    }

    private boolean isAdminEndpoint(String method, String uri) {
        if (uri.equals("/api/order/admin/page")) {
            return true;
        }
        if (uri.equals("/api/order/status")) {
            return true;
        }
        if (uri.equals("/api/user/page")) {
            return true;
        }
        if (uri.startsWith("/api/user/") && "DELETE".equalsIgnoreCase(method)) {
            return true;
        }
        if (uri.startsWith("/api/product") && !"GET".equalsIgnoreCase(method)) {
            return true;
        }
        if (uri.startsWith("/api/category") && !"GET".equalsIgnoreCase(method)) {
            return true;
        }
        return uri.startsWith("/api/review/") && "DELETE".equalsIgnoreCase(method);
    }
}
