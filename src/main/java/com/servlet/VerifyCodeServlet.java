package com.servlet;

import javax.imageio.ImageIO;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.Random;

/**
 * 验证码生成 Servlet
 * 生成4位随机字母数字组合的验证码图片，存入Session供登录校验
 */
@WebServlet("/VerifyCodeServlet")
public class VerifyCodeServlet extends HttpServlet {
    // 验证码字符集，去除易混淆字符 0、1、I、O
    private static final String CODE_CHARS = "23456789ABCDEFGHJKLMNPQRSTUVWXYZ";
    private static final int CODE_LENGTH = 4;
    private static final int IMG_WIDTH = 120;
    private static final int IMG_HEIGHT = 38;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // 设置响应类型为JPEG图片
        response.setContentType("image/jpeg");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Cache-Control", "no-cache");
        response.setDateHeader("Expires", 0);

        // 创建内存图片缓冲区
        BufferedImage image = new BufferedImage(IMG_WIDTH, IMG_HEIGHT, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = image.createGraphics();

        // 绘制白色背景
        g.setColor(Color.WHITE);
        g.fillRect(0, 0, IMG_WIDTH, IMG_HEIGHT);

        // 绘制浅色边框
        g.setColor(new Color(204, 204, 204));
        g.drawRect(0, 0, IMG_WIDTH - 1, IMG_HEIGHT - 1);

        Random random = new Random();
        StringBuilder code = new StringBuilder();
        g.setFont(new Font("Arial", Font.BOLD, 24));

        // 逐位绘制验证码字符
        for (int i = 0; i < CODE_LENGTH; i++) {
            char c = CODE_CHARS.charAt(random.nextInt(CODE_CHARS.length()));
            code.append(c);
            // 随机颜色
            g.setColor(new Color(random.nextInt(150), random.nextInt(150), random.nextInt(150)));
            // 绘制字符，带随机垂直偏移
            g.drawString(String.valueOf(c), 25 * i + 15, 28 + random.nextInt(6) - 3);
        }

        // 绘制干扰线
        g.setColor(new Color(220, 220, 220));
        for (int i = 0; i < 8; i++) {
            g.drawLine(random.nextInt(IMG_WIDTH), random.nextInt(IMG_HEIGHT),
                    random.nextInt(IMG_WIDTH), random.nextInt(IMG_HEIGHT));
        }

        // 存入Session
        request.getSession().setAttribute("verifyCode", code.toString());
        g.dispose();

        // 输出图片
        ImageIO.write(image, "JPEG", response.getOutputStream());
    }
}
