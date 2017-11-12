package com.stx.tbc.service;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.stx.common.library.DataBox;
import com.stx.common.library.RequestBox;
import com.stx.common.service.AService;
import com.stx.common.service.ServiceForward;

public class TbcItemAddManagerTransferBodyService extends AService
{	
	protected ServiceForward forwardPage(HttpServletRequest request, HttpServletResponse response, ArrayList ar, RequestBox box) throws Exception 
	{
		// TODO Auto-generated method stub
		
		request.setAttribute("list", ar);
		request.setAttribute("listSize", Integer.toString(ar.size()));
		
		ServiceForward forward = new ServiceForward();
        forward.setRedirect(false);
        forward.setForward(true);
        
        String p_item_type_cd = box.getString("p_item_type_cd");
        
        forward.setPath("/WEB-INF/jsp/tbc/tbc_ItemAddTransfer_"+p_item_type_cd+"_Body.jsp");
		
        return forward;
	}
}