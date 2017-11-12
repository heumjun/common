package com.stx.tbc.service;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.stx.common.library.RequestBox;
import com.stx.common.service.AService;

import com.stx.common.service.ServiceForward;
import com.stx.common.util.ExcelPrintUtil;

public class TbcItemTransExcelPrintService extends AService
{	
	public ServiceForward forwardPage(HttpServletRequest request, HttpServletResponse response, ArrayList ar, RequestBox box) throws Exception 
	{
		// TODO Auto-generated method stub
		String FileName = box.getString("p_filename");
		String p_process  = box.getString("p_process");
		ExcelPrintUtil.getCode(response, FileName);	
		
        request.setAttribute("mainList", ar);
		request.setAttribute("mainListSize", Integer.toString(ar.size()));
		
        ServiceForward forward = new ServiceForward();
        forward.setRedirect(false);
        forward.setForward(true);
        if(p_process.equals("catalogExcelPrint")){
        	forward.setPath("/WEB-INF/jsp/tbc/tbc_ItemTransExcel.jsp");
        }
        else if(p_process.equals("itemExcelPrint")){
        	forward.setPath("/WEB-INF/jsp/tbc/tbc_ItemTransItemExcel.jsp");
        }
        else if(p_process.equals("mainListExport")){
        	forward.setPath("/WEB-INF/jsp/tbc/tbc_ItemTransMainListExcel.jsp");
        }
		return forward;
	}
}