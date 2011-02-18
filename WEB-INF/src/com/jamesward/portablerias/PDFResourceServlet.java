package com.jamesward.portablerias;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class PDFResourceServlet extends HttpServlet
{
	private static final long serialVersionUID = 8178787853519803189L;

	protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException
    {
        doPost(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException
    {
        String id = (String)req.getParameter("id");
        if (id != null)
        {
            HttpSession session = req.getSession(true);
            try
            {
                byte[] bytes = (byte[])session.getAttribute(id);

                if (bytes != null)
                {
                    res.setContentType("application/pdf");
                    res.setContentLength(bytes.length);
                    res.getOutputStream().write(bytes);
                }
                else
                {
                    res.setStatus(404);
                }
            }
            catch (Throwable t)
            {
                System.err.println(t.getMessage());
            }
        }
    }
}
