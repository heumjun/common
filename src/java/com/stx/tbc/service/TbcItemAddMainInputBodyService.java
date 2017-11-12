package com.stx.tbc.service;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.stx.common.library.DataBox;
import com.stx.common.library.RequestBox;
import com.stx.common.service.AService;
import com.stx.common.service.ServiceForward;
import com.stx.tbc.dao.factory.DaoCreator;
import com.stx.tbc.dao.factory.FactoryDAO;
import com.stx.tbc.dao.factory.Idao;

public class TbcItemAddMainInputBodyService extends AService
{	
	protected ServiceForward forwardPage(HttpServletRequest request, HttpServletResponse response, ArrayList ar, RequestBox box) throws Exception 
	{
		// TODO Auto-generated method stub

		ServiceForward forward = new ServiceForward();
        forward.setRedirect(false);
        forward.setForward(true);
        String p_item_type_cd = box.getString("p_item_type_cd");
        
        forward.setPath("/WEB-INF/jsp/tbc/tbc_ItemAddInput_"+p_item_type_cd+"_Body.jsp");
		
        return forward;
	}
}