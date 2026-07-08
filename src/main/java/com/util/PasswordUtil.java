package com.util;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.KeySpec;
import java.util.Base64;

/**
 * 密码安全工具类
 * 使用 PBKDF2WithHmacSHA256 算法进行密码哈希
 * 每次生成随机的16字节盐值，迭代10000次
 *
 * 存储格式: salt_base64$hash_base64
 * 验证时从存储中解析盐值重新计算比对
 */
public class PasswordUtil {

    private static final String ALGORITHM = "PBKDF2WithHmacSHA256";
    private static final int ITERATIONS = 10000;
    private static final int KEY_LENGTH = 256;
    private static final int SALT_LENGTH = 16;
    private static final SecureRandom RANDOM = new SecureRandom();

    /**
     * 对明文密码进行哈希
     * @param plainPassword 明文密码
     * @return 格式: salt$hash (Base64编码)
     */
    public static String hash(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty()) {
            throw new IllegalArgumentException("密码不能为空");
        }

        byte[] salt = new byte[SALT_LENGTH];
        RANDOM.nextBytes(salt);

        byte[] hash = computeHash(plainPassword, salt);

        String saltBase64 = Base64.getEncoder().encodeToString(salt);
        String hashBase64 = Base64.getEncoder().encodeToString(hash);

        return saltBase64 + "$" + hashBase64;
    }

    /**
     * 验证明文密码是否与存储的哈希值匹配
     * @param plainPassword 用户输入的明文密码
     * @param storedHash    数据库中存储的哈希值 (salt$hash 格式)
     * @return true=匹配, false=不匹配
     */
    public static boolean verify(String plainPassword, String storedHash) {
        if (plainPassword == null || storedHash == null || storedHash.isEmpty()) {
            return false;
        }

        // 兼容旧版明文密码（升级过渡期）
        if (!storedHash.contains("$")) {
            return plainPassword.equals(storedHash);
        }

        String[] parts = storedHash.split("\\$", 2);
        if (parts.length != 2) {
            return false;
        }

        try {
            byte[] salt = Base64.getDecoder().decode(parts[0]);
            byte[] hash = computeHash(plainPassword, salt);
            String newHashBase64 = Base64.getEncoder().encodeToString(hash);
            return newHashBase64.equals(parts[1]);
        } catch (IllegalArgumentException e) {
            return false;
        }
    }

    /**
     * 判断存储的密码是否已经是新格式（哈希过的）
     */
    public static boolean isHashed(String storedPassword) {
        return storedPassword != null && storedPassword.contains("$");
    }

    /**
     * 使用 PBKDF2 计算哈希
     */
    private static byte[] computeHash(String password, byte[] salt) {
        KeySpec spec = new PBEKeySpec(password.toCharArray(), salt, ITERATIONS, KEY_LENGTH);
        try {
            SecretKeyFactory factory = SecretKeyFactory.getInstance(ALGORITHM);
            return factory.generateSecret(spec).getEncoded();
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            throw new RuntimeException("密码哈希计算失败", e);
        }
    }
}
