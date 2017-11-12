
package com.stx.tbc.service;

import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.oreilly.servlet.MultipartRequest;
import com.stx.common.library.DataBox;
import com.stx.common.library.RequestBox;
import com.stx.common.service.AService;
import com.stx.common.service.ServiceForward;
import com.stx.common.util.FileScanner;
import com.stx.tbc.dao.factory.Idao;
import com.stxdis.util.constant.DISConstants;

public class TbcPendingManagerAddWorkingExcelImportService extends AService
{	
	protected ServiceForward forwardPage(HttpServletRequest request, HttpServletResponse response, ArrayList ar, RequestBox box) throws Exception 
	{
		// TODO Auto-generated method stub
		
		//파일 사이즈 15MB 로 제한.
		int sizeLimit = 1024*1024*15;

		ArrayList ar1 = new ArrayList();
		
		try{
			
			String vTempDir = (request.getSession().getServletContext().getRealPath("/")).replace("\\", "/") + DISConstants.EXCEL;
		    //file 읽기		    
			MultipartRequest multi = new MultipartRequest(request, vTempDir, sizeLimit, "euc-kr");	
			String fileName = multi.getFilesystemName("fileName") == null ? "" : multi.getFilesystemName("fileName");
			String fileType = multi.getContentType("fileName") == null ? "" : multi.getContentType("fileName");
			
		    //file 읽기 끝
		    //엑셀 읽기
			ArrayList list = FileScanner.excelToDataObj_poi(vTempDir+"\\"+fileName, 1, true, 0, 0);
			
		    System.out.println("읽기 성공");
		    //리스트를 box에 넣는다.
		    box.put("insertList",list);
		    box.put("p_process",multi.getParameter("p_process"));
		    
		    System.out.println("list");
		    // insertBB 호출
		    
		    Idao dao = super.createDAO(multi.getParameter("p_daoName"));
		    boolean rtn = dao.insertDB(multi.getParameter("p_process"), box);
			
			DataBox hm = new DataBox("Tran_Insert_Result") ;
			hm.put("result", (rtn ? "success" : "fail"));
			if(rtn){
				hm.put("Result_Msg",box.getStringDefault("successMsg",""));
			}else{
				hm.put("Result_Msg",box.getStringDefault("errorMsg","") );
			}
			ar1.add(hm);
		    
		}catch(Exception e){
			System.out.println(e.getMessage());
			e.getStackTrace();
		}
		
		PrintWriter out = response.getWriter();
		
		//Json으로  변환
		StringBuffer rtnString = jsonToString(ar1);
		out.println(rtnString);
			
		ServiceForward forward = new ServiceForward();
        forward.setRedirect(false);
        forward.setForward(false);
        
        return forward;
	}
}


