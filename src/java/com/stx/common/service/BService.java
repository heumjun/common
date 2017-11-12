package com.stx.common.service;

import java.io.PrintWriter;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.stx.common.library.DataBox;
import com.stx.common.library.RequestBox;
import com.stx.common.util.SessionUtil;
import com.stx.tbc.dao.factory.DaoCreator;
import com.stx.tbc.dao.factory.FactoryDAO;
import com.stx.tbc.dao.factory.Idao;


public abstract  class BService implements IService
{
	protected Idao createDAO(String daoName)
	{
		FactoryDAO factory = new DaoCreator();
		Idao dao = factory.create(daoName);
		return dao;
	}
	protected ArrayList DBOperation(Idao dao, RequestBox box) throws Exception 
	{
		String vProcess = box.getString("p_process");
		String queryType = box.getString("p_queryType"); 
		if(queryType.equals("select"))
		{		
			ArrayList ar = dao.selectDB(vProcess,box);	
			return ar;
		}
		else if(queryType.equals("insert"))
		{
			boolean rtn= dao.insertDB(vProcess, box);
			ArrayList ar = new ArrayList();
			DataBox hm=new DataBox("Tran_Insert_Result") ;
			hm.put("result", (rtn ? "success" : "fail"));
			if(rtn)
				hm.put("Result_Msg",box.getStringDefault("successMsg",""));
			else
				hm.put("Result_Msg",box.getStringDefault("errorMsg","") );
			
			ar.add(hm);
			return ar;
		}
		else if(queryType.equals("delete"))
		{
			boolean rtn= dao.deleteDB(vProcess, box);
			ArrayList ar = new ArrayList();
			DataBox hm=new DataBox("Tran_Delete_Result") ;
			hm.put("result", (rtn ? "success" : "fail"));
			if(rtn)
				hm.put("Result_Msg",box.getStringDefault("successMsg",""));
			else
				hm.put("Result_Msg",box.getStringDefault("errorMsg","") );
			
			ar.add(hm);
			return ar;
		}
		else if(queryType.equals("update"))
		{
			boolean rtn= dao.updateDB(vProcess, box);
			ArrayList ar = new ArrayList();
			DataBox hm=new DataBox("Tran_Update_Result") ;
			hm.put("result", (rtn ? "success" : "fail"));
			if(rtn)
				hm.put("Result_Msg",box.getStringDefault("successMsg",""));
			else
				hm.put("Result_Msg",box.getStringDefault("errorMsg","") );
			
			ar.add(hm);
			return ar;
		}
		else 
		{
			return null;
		}	
		
	}
	
	protected abstract ServiceForward forwardPage(HttpServletRequest request, HttpServletResponse response,ArrayList ar,RequestBox box)
	throws Exception ;
	
	public ServiceForward execute(HttpServletRequest request, HttpServletResponse response, RequestBox box) throws Exception 
	{
//		 TODO Auto-generated method stub
		
		response.setContentType("text/html;charset=euc-kr");
		String daoName = box.getString("p_daoName");
		ArrayList ar = null;
		
		//DIS 세션의 user_id를 받아서 셋팅 해준다.
		Map smap = (Map)request.getSession().getAttribute("loginUser");
		if(smap != null){
			box.put("DidSsUserId", smap.get("user_id"));
		
			//TBC 세션 유무 파악
			if(!box.getSession("UserId").equals(smap.get("user_id"))){
				SessionUtil.setUserSession(box);
			}
		}
		
		
		//세션 체크
		if (box.getSession("UserId").equals("")){
			return forwardNoSession(request, response, ar, box);
		}else{
			if(!daoName.equals("")){
				ar = DBOperation(createDAO(daoName), box);
			}
			return forwardPage(request, response, ar, box);
		}
	}
	
	
	public ServiceForward forwardNoSession(HttpServletRequest request, HttpServletResponse response, ArrayList ar, RequestBox box) throws Exception 
	{
		// TODO Auto-generated method stub
		PrintWriter out = response.getWriter();
	    
	    String hostname = request.getHeader("Host");
	    
		out.print("<script>;");
		out.print("alert('세션이 종료되었습니다 ');");
		out.print("window.location.replace('http://"+hostname+"/DIS/disLogin.do');");
		out.print("</script>");
		
        ServiceForward forward = new ServiceForward();
        forward.setRedirect(false);
        forward.setForward(false);
        
		return forward;
	}
	
	public StringBuffer jsonToString(ArrayList ar)
	{
		StringBuffer rtnVal = new StringBuffer();

		//String ="[";
		rtnVal.append("[");
		for(int i =0 ; i<ar.size(); i++)
		{
			DataBox dbox =(DataBox) ar.get(i);
			
			Iterator iter = dbox.keySet().iterator();
			rtnVal.append("{");

			while(iter.hasNext())
			{
				String key = (String)iter.next();				
				
				rtnVal.append("\""+key+"\" : \"" + (String)dbox.get(key)+"\"");
				
				if(iter.hasNext())rtnVal.append(", ");
				
			}
			rtnVal.append("}");
			if(i<ar.size()-1)rtnVal.append(",");
			
		}
		rtnVal.append("]");
		
		return rtnVal;
	}
	
	
	
}
