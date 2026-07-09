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

        List<Evaluation> allEval;
        if (currentUser != null) {
            allEval = evalDAO.getAllEvaluationsWithLikeStatus(currentUser.getId());
        } else {
            allEval = evalDAO.getAllEvaluationsBySort("newest");
        }

        if ("highest".equals(sortBy)) {
            allEval.sort((a, b) -> {
                double aa = (a.getTasteScore() + a.getPriceScore() + a.getServiceScore()) / 3.0;
                double bb = (b.getTasteScore() + b.getPriceScore() + b.getServiceScore()) / 3.0;
                return Double.compare(bb, aa);
            });
        } else if ("most_liked".equals(sortBy)) {
            allEval.sort((a, b) -> Integer.compare(b.getLikeCount(), a.getLikeCount()));
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

        if (keyword != null && !keyword.isEmpty()) {
            String kw = keyword.toLowerCase(Locale.ROOT);
            List<Evaluation> filtered = new ArrayList<>();
            for (Evaluation e : allEval) {
                if (containsIgnoreCase(e.getDishName(), kw)
                        || containsIgnoreCase(e.getContent(), kw)
                        || containsIgnoreCase(e.getRestaurantName(), kw)) {
                    filtered.add(e);
                }
            }
            allEval = filtered;
        }

        if (minScore > 0) {
            List<Evaluation> filtered = new ArrayList<>();
            for (Evaluation e : allEval) {
                double avg = (e.getTasteScore() + e.getPriceScore() + e.getServiceScore()) / 3.0;
                if (avg >= minScore) {
                    filtered.add(e);
                }
            }
            allEval = filtered;
        }

        int totalCount = allEval.size();
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);
        if (totalPages < 1) totalPages = 1;
        if (page < 1) page = 1;
        if (page > totalPages) page = totalPages;

        int from = (page - 1) * pageSize;
        int to = Math.min(from + pageSize, totalCount);
        List<Evaluation> pageList = totalCount > 0 ? allEval.subList(from, to) : new ArrayList<>();

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
