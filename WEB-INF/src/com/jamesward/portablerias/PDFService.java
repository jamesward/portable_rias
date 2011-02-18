package com.jamesward.portablerias;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;

import org.w3c.dom.Document;

import flex.acrobat.pdf.XFAHelper;
import flex.messaging.FlexContext;
import flex.messaging.FlexSession;
import flex.messaging.util.UUIDUtils;

public class PDFService
{
    public PDFService()
    {
    }

    public Object generatePDF(Document dataset) throws IOException
    {
     	
        // Open shell PDF
        String source = FlexContext.getServletContext().getRealPath("/WEB-INF/pdfgen/dashboard.pdf");
        XFAHelper helper = new XFAHelper();
        helper.open(source);

        // Import XFA dataset
        helper.importDataset(dataset);

        // Save new PDF as a byte array in the current session
        byte[] bytes = helper.saveToByteArray();
        String uuid = UUIDUtils.createUUID();
        FlexSession session = FlexContext.getFlexSession();
        session.setAttribute(uuid, bytes);

        // Close any resources
        helper.close();

        HttpServletRequest req = FlexContext.getHttpRequest();
        String contextRoot = "/";
        if (req != null)
            contextRoot = req.getContextPath();

        String r = contextRoot + "/dynamic-pdf?id=" + uuid + "&;jsessionid=" + session.getId();
        System.out.println(r);
        return r;
    }
}
