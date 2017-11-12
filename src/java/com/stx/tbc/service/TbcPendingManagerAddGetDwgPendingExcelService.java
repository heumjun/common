package com.stx.tbc.service;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.stx.common.library.RequestBox;
import com.stx.common.service.AService;

import com.stx.common.service.ServiceForward;
import com.stx.common.util.ExcelPrintUtil;

public class TbcPendingManagerAddGetDwgPendingExcelService extends AService
{	
	public ServiceForward forwardPage(HttpServletRequest request, HttpServletResponse response, ArrayList ar, RequestBox box) throws Exception 
	{
		// TODO Auto-generated method stub

		String FileName = box.getString("p_filename");
		ExcelPrintUtil.getCode(response, FileName);	
		
		request.setAttribute("dwgPdList", ar);
		request.setAttribute("dwgPdListSize", Integer.toString(ar.size()));
		
        ServiceForward forward = new ServiceForward();
        forward.setRedirect(false);
        forward.setForward(true);
        
        forward.setPath("/WEB-INF/jsp/tbc/tbc_PendingManagerAddGetDwgPending_Excel.jsp");
        
		return forward;
	}
}