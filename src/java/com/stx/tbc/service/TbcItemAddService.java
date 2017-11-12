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


public class TbcItemAddService extends AService
{	
	protected ServiceForward forwardPage(HttpServletRequest request, HttpServletResponse response, ArrayList ar, RequestBox box) throws Exception 
	{
		// TODO Auto-generated method stub
		
		
		FactoryDAO factory = new DaoCreator();
		Idao dao = factory.create("TBC_COMMONDAO");
		
		ArrayList MasterList = dao.selectDB("getMaster", box);
		
		if(MasterList.size() > 0){
			DataBox dbox = (DataBox)MasterList.get(0);
			box.put("p_master", dbox.getString("d_delegateprojectno"));
		}
		ServiceForward forward = new ServiceForward();
        forward.setRedirect(false);
        forward.setForward(true);
        forward.setPath("/WEB-INF/jsp/tbc/tbc_ItemAddMain.jsp");
        
		return forward;
	}
}