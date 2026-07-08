package com.servlet;

import com.dao.SysLogDAO;
import com.dao.WishDAO;
import com.entity.User;
import com.entity.WishItem;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/WishActionServlet")
public class WishActionServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        User currentUser = (User) request.getSession().getAttribute("loginUser");
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        WishDAO wishDAO = new WishDAO();
        if (!wishDAO.isTableReady()) {
            response.sendRedirect("WishListServlet?setup=1");
            return;
        }

        String action = request.getParameter("action");
        if ("add".equals(action)) {
            addWish(request, currentUser, wishDAO);
            response.sendRedirect(resolveBack(request, "added"));
            return;
        }

        int id = parseInt(request.getParameter("id"), 0);
        if (id > 0) {
            if ("done".equals(action)) {
                wishDAO.updateStatus(id, currentUser.getId(), 1);
            } else if ("reopen".equals(action)) {
                wishDAO.updateStatus(id, currentUser.getId(), 0);
            } else if ("delete".equals(action)) {
                wishDAO.delete(id, currentUser.getId());
            }
        }
        response.sendRedirect("WishListServlet?msg=updated");
    }

    private void addWish(HttpServletRequest request, User user, WishDAO wishDAO) {
        String dishName = request.getParameter("dishName");
        if (dishName == null || dishName.trim().isEmpty()) return;

        WishItem item = new WishItem();
        item.setUserId(user.getId());
        item.setRestaurantId(parseInt(request.getParameter("restaurantId"), 0));
        item.setDishName(dishName.trim());
        item.setNote(trimToNull(request.getParameter("note")));
        if (wishDAO.add(item)) {
            new SysLogDAO().insertLog(user.getUsername(), "想吃清单", "新增想吃：" + dishName.trim());
        }
    }

    private String resolveBack(HttpServletRequest request, String msg) {
        String source = request.getParameter("source");
        if ("compass".equals(source)) {
            return "TasteCompassServlet?wish=" + msg;
        }
        if ("profile".equals(source)) {
            return "TasteProfileServlet?wish=" + msg;
        }
        return "WishListServlet?msg=" + msg;
    }

    private int parseInt(String value, int defaultValue) {
        try { return Integer.parseInt(value); } catch (Exception e) { return defaultValue; }
    }

    private String trimToNull(String value) {
        if (value == null) return null;
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}
