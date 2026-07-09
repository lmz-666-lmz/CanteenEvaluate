package com.servlet;

import com.dao.EvaluationDAO;
import com.dao.RestaurantDAO;
import com.entity.Evaluation;
import com.entity.Restaurant;
import com.entity.User;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLDecoder;
import java.util.*;

@WebServlet("/AllEvaluateServlet")
public class AllEvaluateServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        RestaurantDAO restDAO = new RestaurantDAO();
        EvaluationDAO evalDAO = new EvaluationDAO();

        List<Restaurant> restList = restDAO.getAllRestaurants();

        String sortBy = request.getParameter("sort");
        if (sortBy == null) sortBy = "newest";

        String filterRest = request.getParameter("restaurant");
        if (filterRest != null && !filterRest.isEmpty()) {
            try { filterRest = URLDecoder.decode(filterRest, "UTF-8"); } catch (Exception ignored) {}
        }

        String keyword = request.getParameter("keyword");
        if (keyword != null) keyword = keyword.trim();

        double minScore = 0;
        String minScoreParam = request.getParameter("minScore");
        if (minScoreParam != null && !minScoreParam.isEmpty()) {
            try {
                minScore = Double.parseDouble(minScoreParam);
            } catch (NumberFormatException ignored) {}
        }

        int page = 1;
        int pageSize = 9;
        try {
            String p = request.getParameter("page");
            if (p != null && !p.isEmpty()) page = Integer.parseInt(p);
            String ps = request.getParameter("pageSize");
            if (ps != null && !ps.isEmpty()) pageSize = Integer.parseInt(ps);
        } catch (NumberFormatException ignored) {}

        User currentUser = (User) request.getSession().getAttribute("loginUser");

        // v1.1: Use SQL-based search for better performance with keyword / minScore / sort
        boolean useSqlSearch = (keyword != null && !keyword.isEmpty()) || minScore > 0
                               || "highest".equals(sortBy) || "most_liked".equals(sortBy);

        List<Evaluation> pageList;
        int totalCount;

        if (useSqlSearch) {
            // 使用 SQL 端搜索 + 排序 + 分页
            Integer userId = currentUser != null ? currentUser.getId() : null;
            List<Evaluation> allEvaluations = evalDAO.searchEvaluations(
                    keyword, minScore, sortBy, 1, Integer.MAX_VALUE, userId);

            // 餐厅名过滤仍在内存中做（SQL 端拿的是 restaurant_id）
            if (filterRest != null && !filterRest.isEmpty()) {
                List<Evaluation> filtered = new ArrayList<>();
                for (Evaluation e : allEvaluations) {
                    if (filterRest.equals(e.getRestaurantName())) {
                        filtered.add(e);
                    }
                }
                allEvaluations = filtered;
            }

            totalCount = allEvaluations.size();
            int totalPagesCalc = (int) Math.ceil((double) totalCount / pageSize);
            if (totalPagesCalc < 1) totalPagesCalc = 1;
            if (page < 1) page = 1;
            if (page > totalPagesCalc) page = totalPagesCalc;

            int from = (page - 1) * pageSize;
            int to = Math.min(from + pageSize, totalCount);
            pageList = totalCount > 0 ? allEvaluations.subList(from, to) : new ArrayList<>();
        } else {
            // 原来逻辑：加载全部 + 内存筛选
            List<Evaluation> allEval;
            if (currentUser != null) {
                allEval = evalDAO.getAllEvaluationsWithLikeStatus(currentUser.getId());
            } else {
                allEval = evalDAO.getAllEvaluationsBySort("newest");
            }

            if (filterRest != null && !filterRest.isEmpty()) {
                List<Evaluation> filtered = new ArrayList<>();
                for (Evaluation e : allEval) {
                    if (filterRest.equals(e.getRestaurantName())) {
                        filtered.add(e);
                    }
                }
                allEval = filtered;
            }

            totalCount = allEval.size();
            int totalPagesCalc = (int) Math.ceil((double) totalCount / pageSize);
            if (totalPagesCalc < 1) totalPagesCalc = 1;
            if (page < 1) page = 1;
            if (page > totalPagesCalc) page = totalPagesCalc;

            int from = (page - 1) * pageSize;
            int to = Math.min(from + pageSize, totalCount);
            pageList = totalCount > 0 ? allEval.subList(from, to) : new ArrayList<>();
        }

        int totalPages = (int) Math.ceil((double) totalCount / pageSize);
        if (totalPages < 1) totalPages = 1;

        request.setAttribute("restaurantList", restList);
        request.setAttribute("evalPageList", pageList);
        request.setAttribute("currentSort", sortBy);
        request.setAttribute("filterRest", filterRest);
        request.setAttribute("keyword", keyword);
        request.setAttribute("minScore", minScoreParam != null ? minScoreParam : "");
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCount", totalCount);

        try {
            request.getRequestDispatcher("allEvaluate.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private boolean containsIgnoreCase(String text, String keyword) {
        return text != null && text.toLowerCase(Locale.ROOT).contains(keyword);
    }
}
