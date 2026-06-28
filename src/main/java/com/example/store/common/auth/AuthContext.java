package com.example.store.common.auth;

import com.example.store.entity.User;

public final class AuthContext {

    private static final ThreadLocal<User> CURRENT_USER = new ThreadLocal<>();

    private AuthContext() {
    }

    public static void set(User user) {
        CURRENT_USER.set(user);
    }

    public static User get() {
        return CURRENT_USER.get();
    }

    public static Long userId() {
        User user = get();
        return user == null ? null : user.getId();
    }

    public static boolean isAdmin() {
        User user = get();
        return user != null && Integer.valueOf(1).equals(user.getRole());
    }

    public static void clear() {
        CURRENT_USER.remove();
    }
}
