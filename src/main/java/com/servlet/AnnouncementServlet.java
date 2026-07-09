package com.servlet;

import com.dao.AnnouncementDAO;
import com.entity.Announcement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/AnnouncementServlet")
public class AnnouncementServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        AnnouncementDAO dao = new AnnouncementDAO();
        List<Announcement> list = dao.getActiveAnnouncements();
        request.setAttribute("announcements", list);
        request.getRequestDispatcher("/announcement.jsp").forward(request, response);
    }
}
