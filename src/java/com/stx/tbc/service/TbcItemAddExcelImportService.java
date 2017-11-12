package com.stx.tbc.service;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import com.oreilly.servlet.MultipartRequest;
import com.stx.common.library.RequestBox;
import com.stx.common.service.AService;
import com.stx.common.service.ServiceForward;
import com.stx.common.util.FileScanner;
import com.stxdis.util.constant.DISConstants;


public class TbcItemAddExcelImportService extends AService
{	
	protected ServiceForward forwardPage(HttpServletRequest request, HttpServletResponse response, ArrayList ar, RequestBox box) throws Exception 
	{
		// TODO Auto-generated method stub
		String p_item_type_cd = box.getString("p_item_type_cd");
		
		//���� ������ 15MB �� ����.
		int sizeLimit = 1024*1024*15;
		
		//���� ROw ���ѿ� �ʿ��� �Ķ����--
		int p_serisecnt = box.getInt("p_seriescnt");
		int p_limitcnt = box.getInt("p_limitcnt");
		//---------------------------
		
		try{

//			matrix.db.Context context = null;
//			context = Framework.getFrameContext(request.getSession());
			
			String vTempDir = (request.getSession().getServletContext().getRealPath("/")).replace("\\", "/") + DISConstants.EXCEL;
			
			String vMsg = "";
		    //file �б�
			
			MultipartRequest multi = new MultipartRequest(request, vTempDir, sizeLimit, "euc-kr");	
			String fileName = multi.getFilesystemName("fileName") == null ? "" : multi.getFilesystemName("fileName");
			String fileType = multi.getContentType("fileName") == null ? "" : multi.getContentType("fileName");
			
		    //file �б� ��
			//System.out.println("length()"+multi.getParameter("p_series").length());
		    //���� �б�
		    ArrayList list = FileScanner.excelToDataObj_poi(vTempDir+"\\"+fileName, 1, true, p_limitcnt, p_serisecnt);
		    if(list.size() == 0 ){
		    	vMsg = "�Է� ���� �ִ� Row�� �ʰ��Ͽ����ϴ�.";
		    }
		    ArrayList list2 = new ArrayList();
		    //Seat, Tray�� ��� ǥ��ǰ�� ���翩�θ� �ľ��Ͽ� ǥ��ǰ�̶�� �÷��� ����� ���� �־��ش�.
		    
		    if(p_item_type_cd.equals("SE") || p_item_type_cd.equals("TR")){
			    for(int i=0; i<list.size(); i++){
			    	HashMap hm = (HashMap)list.get(i);
			    	if(!hm.get("column2").toString().equals("")){
				    	if(hm.get("column2").toString().substring(0,1).equals("Z")){
				    		hm.put("isStandard", "N");
				    	}else{
				    		hm.put("isStandard", "Y");
				    	}
			    	}
			    	list2.add(hm);
			    }
			    list = list2;
		    }
		    //����Ʈ�� request�� ����.
		    request.setAttribute("excelList", list);
		    request.setAttribute("excelListSize", Integer.toString(list.size()));
		    request.setAttribute("msg", vMsg);

		}catch(Exception e){
			System.out.println(e.getMessage());
			e.getStackTrace();
		}
		ServiceForward forward = new ServiceForward();
        forward.setRedirect(false);
        forward.setForward(true);
        
        
        forward.setPath("/WEB-INF/jsp/tbc/tbc_ItemAddExcelImport_"+p_item_type_cd+"_Body.jsp");
		return forward;
	}
}


