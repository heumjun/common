/***********************************************
*@DESCRIPTION				: Dwg
*@AUTHOR (MODIFIER)			: Kim dong hyoek
*@FILENAME					: TbcDwgMain.java
*@CREATE DATE				: 2014-08-12
***********************************************/
package com.stx.tbc.service;

import java.io.PrintWriter;
import java.net.URLEncoder;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import com.stx.common.library.RequestBox;
import com.stx.common.service.BService;
import com.stx.common.service.ServiceForward;
import com.stx.common.util.JsonUtil;
import com.stx.common.util.SessionUtil;


public class TbcItemTransService extends BService
{	
	public ServiceForward forwardPage(HttpServletRequest request, HttpServletResponse response, ArrayList ar, RequestBox box) throws Exception 
	{

		//Context context = null;
		//context = Framework.getFrameContext(request.getSession());
		PrintWriter out	=	response.getWriter();
		String userId =request.getParameter("userId");
		String sQueryType = box.getString("p_queryType");
		String p_process  = box.getString("p_process");
		
		
		//if(box.getSession("UserId").equals("")){
		//	SessionUtil.setUserSession(box);
		//}
		
		ServiceForward forward = new ServiceForward();
		//현재 날짜를 기준으로 7일 뒤 날짜 받아오기
        if(p_process.equals("selectWeekList")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //메인 화면 조회 클릭 시 
        else if(p_process.equals("list")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //글쓰기 or row 더블 클릭 시
        else if(p_process.equals("modifyView")){
        	String list_status_desc = box.getString("list_status_desc");
        	list_status_desc = URLEncoder.encode(list_status_desc,"UTF-8");
        	box.put("list_status_desc", list_status_desc);
        	forward.setRedirect(false);
	        forward.setForward(true);
	        forward.setPath("/WEB-INF/jsp/tbc/tbc_ItemTransModifyView.jsp");
	        //forward.setPath("/WEB-INF/jsp/tbc/tbc_ItemTransModifyView.jsp");
        }
        //main 화면 콤보박스 세팅
        else if(p_process.equals("selectListType")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //신규 catalog 임시저장 시  
        else if(p_process.equals("temporarystorage")){
        	//MultipartRequest mr = new MultipartRequest(request,"utf-8");
        	
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //검토자 콤보박스 세팅
        else if(p_process.equals("selectApproverList")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //검토자 콤보박스 세팅
        else if(p_process.equals("selectApproverListId")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        
        //main에서 row 더블 클릭시 list_id 검색
        else if(p_process.equals("selectDetail")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //main에서 row 더블 클릭시 list_id의 catalogList 검색
        else if(p_process.equals("selectCatalogList")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
//      main에서 row 더블 클릭시 list_id의 itemList 검색
        else if(p_process.equals("selectItemList")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //catalog의 접수 버튼 클릭시 
        else if(p_process.equals("itemreceive")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //승인 버튼 클릭 시 
        else if(p_process.equals("updateInfoList")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //검토자 부서 list 가져오기
        else if(p_process.equals("selectApproveListDept")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //승인 list 가져오기
        else if(p_process.equals("selectConfirmList")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        else if(p_process.equals("selectApproveListDeptComment")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //반려
        else if(p_process.equals("updateReturn")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //철회
        else if(p_process.equals("updateRetract")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //REF_USER SELECT
        else if(p_process.equals("selectRefUser")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //SELECT ADMIN_USER
        else if(p_process.equals("selectAdminUser")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //file upload 팝업창 띄우기
        else if(p_process.equals("itemPopupUpload")){
        	forward.setRedirect(false);
	        forward.setForward(true);
	        forward.setPath("/WEB-INF/jsp/tbc/tbc_ItemPopupDoc.jsp");
        }
        //취소 버튼
        else if(p_process.equals("btnCancel")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //Doc List 조회
        else if(p_process.equals("selectDocList")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //첨부 파일 삭제
        else if(p_process.equals("deleteDocList")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //관리자 삭제
        else if(p_process.equals("AdminDelete")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //유저 팝업
        else if(p_process.equals("userSearch")){
        	forward.setRedirect(false);
	        forward.setForward(true);
	        forward.setPath("/WEB-INF/jsp/tbc/tbc_ItemTransUserSearch.jsp");
        }
        //UserSearch 팝업창 List
        else if(p_process.equals("userSearchList")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //첨부파일 다운로드 jsp
        else if(p_process.equals("fileDownload")){
        	forward.setRedirect(false);
	        forward.setForward(true);
	        forward.setPath("/WEB-INF/jsp/tbc/tbc_ItemTransFileDownload.jsp");
        }
        //접속자가 검토자인지 체크
        else if(p_process.equals("selectGrantorChk")){
        	String rtnStr = JsonUtil.jsonToString(ar).toString();
			out.print(rtnStr);
			forward.setRedirect(false);
			forward.setForward(false);
        }
        //초기 화면
        else{
        	SessionUtil.setUserSession(box);
	        forward.setRedirect(false);
	        forward.setForward(true);
	        forward.setPath("/WEB-INF/jsp/tbc/tbc_ItemTrans.jsp");
        }
		return forward;
	}
}