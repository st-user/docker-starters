package org.example;

import java.io.IOException;
import java.io.Writer;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Hello world!
 */
@WebServlet("/hello")
public class AppServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {

        RequestDispatcher dispatcher = req.getRequestDispatcher("WEB-INF/jsp/index.jsp");
        dispatcher.forward(req, resp);
    }
}
