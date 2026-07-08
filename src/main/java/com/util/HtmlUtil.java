package com.util;

/**
 * HTML 安全工具
 * 防止 XSS 攻击，对输出到 HTML 的文本进行转义
 */
public class HtmlUtil {

    /**
     * 转义 HTML 特殊字符，防止 XSS
     */
    public static String escape(String input) {
        if (input == null || input.isEmpty()) return "";
        StringBuilder sb = new StringBuilder(input.length() + 16);
        for (int i = 0; i < input.length(); i++) {
            char c = input.charAt(i);
            switch (c) {
                case '&':  sb.append("&amp;"); break;
                case '"':  sb.append("&quot;"); break;
                case '<':  sb.append("&lt;"); break;
                case '>':  sb.append("&gt;"); break;
                case '\'': sb.append("&#39;"); break;
                default:   sb.append(c);
            }
        }
        return sb.toString();
    }
}
