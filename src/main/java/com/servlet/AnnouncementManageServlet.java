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

/**
 * 公告管理 Servlet
 * GET: 显示公告列表（分页+搜索）
 * POST: 新增/编辑/删除公告
 */
@WebServlet("/admin/AnnouncementManageServlet")
public class AnnouncementManageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        AnnouncementDAO dao = new AnnouncementDAO();

        if ("edit".equals(action)) {
            // 编辑模式：查询单个公告
            int id = Integer.parseInt(request.getParameter("id"));
            Announcement ann = dao.findById(id);
            request.setAttribute("editAnnouncement", ann);
        } else if ("delete".equals(action)) {
            // 删除公告
            int id = Integer.parseInt(request.getParameter("id"));
            dao.delete(id);
            response.sendRedirect(request.getContextPath() + "/admin/AnnouncementManageServlet");
            return;
        } else if ("toggle".equals(action)) {
            // 切换显示/隐藏
            int id = Integer.parseInt(request.getParameter("id"));
            Announcement ann = dao.findById(id);
            if (ann != null) {
                ann.setIsActive(ann.getIsActive() == 1 ? 0 : 1);
                dao.update(ann);
            }
            response.sendRedirect(request.getContextPath() + "/admin/AnnouncementManageServlet");
            return;
        }

        // 分页参数
        int page = 1;
        int pageSize = com.dao.ConfigDAO.getInt("page_size", 10);
        String pageParam = request.getParameter("page");
        String pageSizeParam = request.getParameter("pageSize");
        if (pageParam != null && !pageParam.isEmpty()) page = Integer.parseInt(pageParam);
        if (pageSizeParam != null && !pageSizeParam.isEmpty()) pageSize = Integer.parseInt(pageSizeParam);

        String keyword = request.getParameter("keyword");

        List<Announcement> list = dao.findByPage(page, pageSize, keyword);
        int totalCount = dao.getCount(keyword);
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);

        request.setAttribute("announcementList", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("keyword", keyword);

        request.getRequestDispatcher("/admin/announcementManage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        AnnouncementDAO dao = new AnnouncementDAO();

        if ("save".equals(action)) {
            String idStr = request.getParameter("id");
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            int isActive = Integer.parseInt(request.getParameter("isActive") != null ? request.getParameter("isActive") : "1");
            int sortOrder = Integer.parseInt(request.getParameter("sortOrder") != null ? request.getParameter("sortOrder") : "0");

            Announcement ann = new Announcement();
            ann.setTitle(title);
            ann.setContent(content);
            ann.setIsActive(isActive);
            ann.setSortOrder(sortOrder);

            if (idStr != null && !idStr.isEmpty()) {
                ann.setId(Integer.parseInt(idStr));
                dao.update(ann);
            } else {
                dao.add(ann);
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/AnnouncementManageServlet");
    }
}
