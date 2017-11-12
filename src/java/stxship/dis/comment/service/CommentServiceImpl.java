package stxship.dis.comment.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.activation.MimetypesFileTypeMap;
import javax.annotation.Resource;

import org.apache.commons.io.IOUtils;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.View;

import stxship.dis.comment.dao.CommentDAO;
import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisEGDecrypt;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.DisPageUtil;
import stxship.dis.common.util.DisStringUtil;
import stxship.dis.common.util.FileDownLoad;
import stxship.dis.common.util.FileScanner;
import stxship.dis.common.util.GenericExcelView;
import stxship.dis.common.util.GenericExcelView5;

@Service("CommentService")
public class CommentServiceImpl extends CommonServiceImpl implements CommentService {

	@Resource(name = "CommentDAO")
	private CommentDAO commentDAO;
	
	//**************************************************************************
	// commentReceipt(수신문서) MAIN METHOD START 
	//**************************************************************************
	/**
	 * @메소드명	: commentReceiptTeamSelectBoxDataList
	 * @날짜		: 2017. 6. 14.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * 		<pre>
	 *			commentReceipt 담당팀 SelectBoxDataList
	 * 		</pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public String commentReceiptTeamSelectBoxDataList(CommandMap commandMap) throws Exception {

		List<Map<String, Object>> list = commentDAO.commentReceiptTeamSelectBoxDataList(commandMap.getMap());

		String rtnString = "";
		String vType = DisStringUtil.nullString(commandMap.get("sb_type"));

		// 첫 optison 선택 파라미터
		if (vType.equals("all")) {
			rtnString = "<option value=\"ALL\">ALL</option>";
		} else if (vType.equals("sel")) {
			rtnString = "<option value=\"\">선택</option>";
		}

		for (Map<String, Object> rowData : list) {
			rtnString += "<option value=\"" + DisStringUtil.nullString(rowData.get("sb_value")) + "\""
					+ DisStringUtil.nullString(rowData.get("sb_selected")) 
					+ " name=\"" + DisStringUtil.nullString(rowData.get("ATTR")) + "\">" 
					+ rowData.get("sb_name") + "</option>";
		}

		return URLEncoder.encode(rtnString, "UTF-8");
	}
	
	/**
	 * 
	 * @메소드명	: commentReceiptDeptSelectBoxDataList
	 * @날짜		: 2017. 6. 14.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * 		<pre>
	 *			commentReceipt 담당부서 SelectBoxDataList
	 * 		</pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public String commentReceiptDeptSelectBoxDataList(CommandMap commandMap) throws Exception {

		// p_query를 이용하여 셀렉트 박스 내용 받음.
		List<Map<String, Object>> list = commentDAO.commentReceiptDeptSelectBoxDataList(commandMap.getMap());

		String rtnString = "";
		String vType = DisStringUtil.nullString(commandMap.get("sb_type"));

		// 첫 optison 선택 파라미터
		if (vType.equals("all")) {
			rtnString = "<option value=\"ALL\">ALL</option>";
		} else if (vType.equals("sel")) {
			rtnString = "<option value=\"\">선택</option>";
		}

		for (Map<String, Object> rowData : list) {
			rtnString += "<option value=\"" + DisStringUtil.nullString(rowData.get("sb_value")) + "\""
					+ DisStringUtil.nullString(rowData.get("sb_selected")) 
					+ " name=\"" + DisStringUtil.nullString(rowData.get("ATTR")) + "\">" 
					+ rowData.get("sb_name") + "</option>";
		}

		return URLEncoder.encode(rtnString, "UTF-8");
	}
	
	/**
	 * 
	 * @메소드명	: commentReceiptList
	 * @날짜		: 2017. 6. 14.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * 		<pre>
	 *			메인 리스트 호출
	 * 		</pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> commentReceiptList(CommandMap commandMap) throws Exception {

		// 리스트를 취득한다.
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		
		Map<String, Object> resultData = commentDAO.commentReceiptList(commandMap.getMap());
		List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("p_refer");
		
		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = listData.size();
		int cnt = listData.size();
		if(cnt > 0){
			listRowCnt = listData.get(0).get("ALL_CNT") == null ? "" : listData.get(0).get("ALL_CNT").toString();
		}
		
		// 라스트 페이지를 구한다.
		Object lastPageCnt = "page>total";
		lastPageCnt = DisPageUtil.getPageCount(commandMap.get(DisConstants.SET_DB_PAGE_SIZE), listRowCnt);

		// 결과값 생성
		Map<String, Object> result = new HashMap<String, Object>();
		result.put(DisConstants.GRID_RESULT_CUR_PAGE, curPageNo);
		result.put(DisConstants.GRID_RESULT_LAST_PAGE, lastPageCnt);
		result.put(DisConstants.GRID_RESULT_RECORDS_CNT, listRowCnt);
		result.put(DisConstants.GRID_RESULT_DATA, listData);

		return result;
	}
	
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> commentReceiptDeleteAction(CommandMap commandMap) throws Exception {
		// 그리드 리스트에서 받아옴
		List<Map<String, Object>> commentReceiptDeleteList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());

		String sErrorMsg = "";
		String sErrCode = "";

		try {
			for (Map<String, Object> rowData : commentReceiptDeleteList) {
				
				Map<String, Object> pkgParam = new HashMap<String, Object>();

				// commandMap에 있는 행을 'p_'를 붙혀서 pkgParam에 넣는다.
				for (String key : rowData.keySet()) {
					pkgParam.put("p_" + key, rowData.get(key));
				}
				
				// 프로시저는 넘겨준 MAP에 결과가 리턴된다.
				commentDAO.commentReceiptDeleteAction(pkgParam);
				
				// 프로시저 결과 받음
				sErrorMsg = DisStringUtil.nullString(pkgParam.get("p_error_msg"));
				sErrCode = DisStringUtil.nullString(pkgParam.get("p_error_code"));

				// 오류가 있으면 스탑
				if (!"".equals(sErrorMsg)) {
					throw new DisException(sErrorMsg);
				}
				
			}

			// 여기까지 Exception 없으면 성공 메시지
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));

		} catch (Exception e) {
			System.out.println(sErrCode);
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, sErrorMsg);
		}

		// 3. 결과 리턴
		return commandMap.getMap();
	}
	
	/**
	 * 
	 * @메소드명	: commentReceiptFileDownload
	 * @날짜		: 2017. 6. 14.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * 	<pre>
	 *		commentReceiptList Row 첨부파일 다운로드
	 * 	</pre>
	 * @param commandMap
	 * @param modelMap
	 * @return
	 */
	@Override
	public View commentReceiptFileDownload(CommandMap commandMap, Map<String, Object> modelMap) {
		
		Map<String, Object> rs = commentDAO.commentReceiptFileDownload(commandMap);
		
		modelMap.put("data", (byte[]) rs.get("DOCUMENT_DATA"));
		modelMap.put("contentType", "application/octet-stream;");
		modelMap.put("filename", (String) rs.get("DOCUMENT_NAME"));
		
		return new FileDownLoad();
	}
	
	/**
	 * 
	 * @메소드명	: popUpReceiptTeamList
	 * @날짜		: 2017. 6. 19.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * 		<pre>
	 *			메인화면에서 선택된 1개의 Row를 부서지정 선택 팝업창으로 넘겨준다.
	 * 		</pre>
	 * @param commandMap
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	@Override
	public Map<String, Object> popUpReceiptTeamList(CommandMap commandMap) throws UnsupportedEncodingException {
		
		// 리스트를 취득한다.
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		
		List<Map<String, Object>> listData = commentDAO.popUpReceiptTeamList(commandMap.getMap());
		
		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = listData.size();
		// 라스트 페이지를 구한다.
		Object lastPageCnt = "page>total";
		if (!DisConstants.NO.equals(commandMap.get(DisConstants.IS_PAGING))) {
			lastPageCnt = DisPageUtil.getPageCount(pageSize, listRowCnt);
		}
		
		// 결과값 생성
		Map<String, Object> result = new HashMap<String, Object>();
		result.put(DisConstants.GRID_RESULT_CUR_PAGE, curPageNo);
		result.put(DisConstants.GRID_RESULT_LAST_PAGE, lastPageCnt);
		result.put(DisConstants.GRID_RESULT_RECORDS_CNT, listRowCnt);
		result.put(DisConstants.GRID_RESULT_DATA, listData);
		
		return result;
	}
	
	/**
	 * 
	 * @메소드명	: commentReceiptGridTeamList
	 * @날짜		: 2017. 6. 19.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * 		<pre>
	 *			부서지정 팝업 내 그리드에서 담당팀 SelectBox 리스트
	 * 		</pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> commentReceiptGridTeamList(CommandMap commandMap) throws Exception {
			return commentDAO.commentReceiptGridTeamList(commandMap.getMap());
	}
	
	/**
	 * 
	 * @메소드명	: commentReceiptTeamApplyAction
	 * @날짜		: 2017. 6. 19.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * 		<pre>
	 *			부서지정 팝업에서 부서지정 후 Apply Action
	 * 		</pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> commentReceiptTeamApplyAction(CommandMap commandMap) throws Exception {
		// 그리드 리스트에서 받아옴
		List<Map<String, Object>> commentReceiptTeamWorkList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());

		String sErrorMsg = "";
		String sErrCode = "";

		try {
			for (Map<String, Object> rowData : commentReceiptTeamWorkList) {
				
				Map<String, Object> pkgParam = new HashMap<String, Object>();

				// commandMap에 있는 행을 'p_'를 붙혀서 pkgParam에 넣는다.
				for (String key : rowData.keySet()) {
					pkgParam.put("p_" + key, rowData.get(key));
				}

				// 필요한 값 셋팅
				pkgParam.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				
				String oper = (String) pkgParam.get("p_oper");
				
				// 프로시저는 넘겨준 MAP에 결과가 리턴된다.
				if(oper.equals("D")) {
					commentDAO.commentReceiptTeamDeleteAction(pkgParam);
					
					// 프로시저 결과 받음
					sErrorMsg = DisStringUtil.nullString(pkgParam.get("p_error_msg"));
					sErrCode = DisStringUtil.nullString(pkgParam.get("p_error_code"));

					// 오류가 있으면 스탑
					if (!"".equals(sErrorMsg)) {
						throw new DisException(sErrorMsg);
					}
					
				} else if(oper.equals("I")) {
					commentDAO.commentReceiptTeamInsertAction(pkgParam);
					
					// 프로시저 결과 받음
					sErrorMsg = DisStringUtil.nullString(pkgParam.get("p_error_msg"));
					sErrCode = DisStringUtil.nullString(pkgParam.get("p_error_code"));

					// 오류가 있으면 스탑
					if (!"".equals(sErrorMsg)) {
						throw new DisException(sErrorMsg);
					}
				}
				
			}

			// 여기까지 Exception 없으면 성공 메시지
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));

		} catch (Exception e) {
			System.out.println(sErrCode);
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, sErrorMsg);
		}

		// 3. 결과 리턴
		return commandMap.getMap();
	}
	
	/**
	 * 
	 * @메소드명	: popUpReceiptUserIdList
	 * @날짜		: 2017. 6. 19.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * 		<pre>
	 *			메인화면에서 선택된 1개의 Row를 담당자 선택 팝업창으로 넘겨준다.
	 * 		</pre>
	 * @param commandMap
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	@Override
	public Map<String, Object> popUpReceiptUserIdList(CommandMap commandMap) throws UnsupportedEncodingException {
		
		// 리스트를 취득한다.
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		
		List<Map<String, Object>> listData = new ArrayList<Map<String, Object>>();
		
		if(!commandMap.get("p_arrDistinct").toString().equals("") && commandMap.get("p_arrDistinct").toString() != null) {
			
			for(int i=0; i< commandMap.get("p_arrDistinct").toString().split(",").length; i++) {
				
				Map<String, Object> temp = new HashMap<String, Object>();
				
				String receipt_dept_code = commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[11];
				String receipt_dept_name = URLDecoder.decode(commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[12], "UTF-8");
				String receipt_user_id = commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[13];
				String receipt_user_name = URLDecoder.decode(commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[14], "UTF-8");
				
				if(receipt_dept_code.equals("NULL")) {
					receipt_dept_code = "";
				}
				if(receipt_dept_name.equals("NULL")) {
					receipt_dept_name = "";
				}
				if(receipt_user_id.equals("NULL")) {
					receipt_user_id = "";
				}
				if(receipt_user_name.equals("NULL")) {
					receipt_user_name = "";
				}
				
				temp.put("receipt_id", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[0]);
				temp.put("receipt_detail_id", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[1]);
				temp.put("receipt_no", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[2]);
				temp.put("project_no", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[3]);
				temp.put("doc_type", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[4]);
				temp.put("issuer", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[5]);
				temp.put("subject", URLDecoder.decode(commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[6], "UTF-8") );
				temp.put("issue_date", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[7]);
				temp.put("com_no", URLDecoder.decode(commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[8], "UTF-8") );
				temp.put("receipt_team_code", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[9]);
				temp.put("receipt_team_name", URLDecoder.decode(commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[10], "UTF-8") );
				temp.put("receipt_dept_code", receipt_dept_code );
				temp.put("receipt_dept_name", receipt_dept_name );
				temp.put("receipt_user_id", receipt_user_id );
				temp.put("receipt_user_name", receipt_user_name );
				
				listData.add(temp);
			}
		}
		
		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = listData.size();
		// 라스트 페이지를 구한다.
		Object lastPageCnt = "page>total";
		if (!DisConstants.NO.equals(commandMap.get(DisConstants.IS_PAGING))) {
			lastPageCnt = DisPageUtil.getPageCount(pageSize, listRowCnt);
		}
		
		// 결과값 생성
		Map<String, Object> result = new HashMap<String, Object>();
		result.put(DisConstants.GRID_RESULT_CUR_PAGE, curPageNo);
		result.put(DisConstants.GRID_RESULT_LAST_PAGE, lastPageCnt);
		result.put(DisConstants.GRID_RESULT_RECORDS_CNT, listRowCnt);
		result.put(DisConstants.GRID_RESULT_DATA, listData);
		
		return result;
	}
	
	/**
	 * 
	 * @메소드명	: commentReceiptUserEtcDeptSelectBoxDataList
	 * @날짜		: 2017. 7. 4.
	 * @작성자		: 이상빈
	 * @설명 
	 * 	<pre>
	 *		담당자 팝업 내 그리드에서 담당파트 SelectBox 리스트	
	 * 	</pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public String commentReceiptUserEtcDeptSelectBoxDataList(CommandMap commandMap) throws Exception {

		// p_query를 이용하여 셀렉트 박스 내용 받음.
		List<Map<String, Object>> list = commentDAO.commentReceiptUserEtcDeptSelectBoxDataList(commandMap.getMap());

		String rtnString = "";
		String vType = DisStringUtil.nullString(commandMap.get("sb_type"));

		// 첫 optison 선택 파라미터
		if (vType.equals("all")) {
			rtnString = "<option value=\"ALL\">ALL</option>";
		} else if (vType.equals("sel")) {
			rtnString = "<option value=\"\">선택</option>";
		}

		for (Map<String, Object> rowData : list) {
			rtnString += "<option value=\"" + DisStringUtil.nullString(rowData.get("sb_value")) + "\""
					+ DisStringUtil.nullString(rowData.get("sb_selected")) 
					+ " name=\"" + DisStringUtil.nullString(rowData.get("ATTR")) + "\">" 
					+ rowData.get("sb_name") + "</option>";
		}

		return URLEncoder.encode(rtnString, "UTF-8");
	}
	
	/**
	 * 
	 * @메소드명	: commentReceiptGridDeptList
	 * @날짜		: 2017. 6. 19.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * 		<pre>
	 *			담당자 팝업 내 그리드에서 담당파트 SelectBox 리스트
	 * 		</pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> commentReceiptGridDeptList(CommandMap commandMap) throws Exception {
			return commentDAO.commentReceiptGridDeptList(commandMap.getMap());
	}
	
	/**
	 * 
	 * @메소드명	: commentReceiptGridUserList
	 * @날짜		: 2017. 6. 19.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * 		<pre>
	 *			담당자 팝업 내 그리드에서 담당자 SelectBox 리스트
	 * 		</pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> commentReceiptGridUserList(CommandMap commandMap) throws Exception {
		return commentDAO.commentReceiptGridUserList(commandMap.getMap());
	}
	@Override
	public List<Map<String, Object>> commentReceiptUserList(CommandMap commandMap) throws Exception {
		return commentDAO.commentReceiptUserList(commandMap.getMap());
	}
	
	/**
	 * 
	 * @메소드명	: commentReceiptUserApplyAction
	 * @날짜		: 2017. 6. 19.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * 		<pre>
	 *			담당자 팝업에서 담당자 지정 후 Apply Action
	 * 		</pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> commentReceiptUserApplyAction(CommandMap commandMap) throws Exception {
		// 그리드 리스트에서 받아옴
		List<Map<String, Object>> commentReceiptUserWorkList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());

		String sErrorMsg = "";
		
		String p_etc_user_id = (String) commandMap.get("p_etc_user_id");

		try {
			Map<String, Object> pkgParam2 = new HashMap<String, Object>();
			pkgParam2.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			pkgParam2.put("p_mail_comment", commandMap.get("p_mail_comment") );
			commentDAO.receiptApplyHeadInProc(pkgParam2);
			sErrorMsg = DisStringUtil.nullString(pkgParam2.get("p_error_msg"));
			String p_mail_id = DisStringUtil.nullString(pkgParam2.get("p_mail_id"));
			// 오류가 있으면 스탑
			if (!"".equals(sErrorMsg)) {
				throw new DisException(sErrorMsg);
			}
			
			
			for (Map<String, Object> rowData : commentReceiptUserWorkList) {
				
				Map<String, Object> pkgParam = new HashMap<String, Object>();

				// commandMap에 있는 행을 'p_'를 붙혀서 pkgParam에 넣는다.
				for (String key : rowData.keySet()) {
					pkgParam.put("p_" + key, rowData.get(key));
				}

				// 필요한 값 셋팅
				
				pkgParam.put("p_action_type", rowData.get("oper"));
				pkgParam.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				
				commentDAO.commentReceiptUserApplyAction(pkgParam);
				// 프로시저 결과 받음
				sErrorMsg = DisStringUtil.nullString(pkgParam.get("p_error_msg"));
				String sErrCode = DisStringUtil.nullString(pkgParam.get("p_error_code"));
				
				String p_receipt_detail_id = DisStringUtil.nullString(pkgParam.get("p_receipt_detail_id"));

				// 오류가 있으면 스탑
				if (!"".equals(sErrorMsg)) {
					System.out.println(sErrCode);
					throw new DisException(sErrorMsg);
				}
				
				
				
				Map<String, Object> pkgParam3 = new HashMap<String, Object>();

				// commandMap에 있는 행을 'p_'를 붙혀서 pkgParam에 넣는다.
				for (String key : rowData.keySet()) {
					pkgParam3.put("p_" + key, rowData.get(key));
				}
				
				pkgParam3.put( "p_receipt_detail_id", p_receipt_detail_id ); 
				
				pkgParam3.put( "p_mail_id", p_mail_id );
				pkgParam3.put( "p_list_id", pkgParam3.get("p_receipt_detail_id") );
				pkgParam3.put( "p_team_code", pkgParam3.get("p_receipt_team_code") );
				pkgParam3.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				commentDAO.receiptApplyListInProc(pkgParam3);
				sErrorMsg = DisStringUtil.nullString(pkgParam2.get("p_error_msg"));
				// 오류가 있으면 스탑
				if (!"".equals(sErrorMsg)) {
					throw new DisException(sErrorMsg);
				}
				
				/////////////////// 저장
				
			}
			
			/*for (Map<String, Object> rowData : commentReceiptUserWorkList) {
				
				
				
			}*/
			
			// 참조메일
			Map<String, Object> pkgParam4 = new HashMap<String, Object>();
			if(!p_etc_user_id.equals("")) {
				pkgParam4.put( "p_mail_id", p_mail_id );
				pkgParam4.put("p_etc_user_id", commandMap.get("p_etc_user_id") );
				pkgParam4.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				commentDAO.receiptApplyEtcInProc(pkgParam4);
				sErrorMsg = DisStringUtil.nullString(pkgParam4.get("p_error_msg"));
				// 오류가 있으면 스탑
				if (!"".equals(sErrorMsg)) {
					throw new DisException(sErrorMsg);
				}
			}
			
			// 메일 Send
			Map<String, Object> pkgParam5 = new HashMap<String, Object>();
			pkgParam5.put( "p_mail_id", p_mail_id );
			commentDAO.mailSendProc(pkgParam5);
			sErrorMsg = DisStringUtil.nullString(pkgParam5.get("p_error_msg"));
			// 오류가 있으면 스탑
			if (!"".equals(sErrorMsg)) {
				throw new DisException(sErrorMsg);
			}

			// 여기까지 Exception 없으면 성공 메시지
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));

		} catch (Exception e) {
			e.printStackTrace();
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, e.getLocalizedMessage());
		}

		// 3. 결과 리턴
		return commandMap.getMap();
	}
	
	/**
	 * 
	 * @메소드명	: popUpReceiptDwgList
	 * @날짜		: 2017. 6. 19.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * 		<pre>
	 *			메인화면에서 선택된 1개의 Row를 도면 선택 팝업창으로 넘겨준다.
	 * 		</pre>
	 * @param commandMap
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	@Override
	public Map<String, Object> popUpReceiptDwgList(CommandMap commandMap) throws UnsupportedEncodingException {
		
		// 리스트를 취득한다.
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		
		List<Map<String, Object>> listData = new ArrayList<Map<String, Object>>();
		
		if(!commandMap.get("p_arrDistinct").toString().equals("") && commandMap.get("p_arrDistinct").toString() != null) {
			
			for(int i=0; i< commandMap.get("p_arrDistinct").toString().split(",").length; i++) {
				
				Map<String, Object> temp = new HashMap<String, Object>();
				
				String receipt_dept_code = commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[11];
				String receipt_dept_name = URLDecoder.decode(commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[12], "UTF-8");
				String receipt_user_id = commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[13];
				String receipt_user_name = URLDecoder.decode(commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[14], "UTF-8");
				//String dwgNo = commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[15];
				
				if(receipt_dept_code.equals("NULL")) {
					receipt_dept_code = "";
				}
				if(receipt_dept_name.equals("NULL")) {
					receipt_dept_name = "";
				}
				if(receipt_user_id.equals("NULL")) {
					receipt_user_id = "";
				}
				if(receipt_user_name.equals("NULL")) {
					receipt_user_name = "";
				}
				/*if(dwgNo.equals("NULL")) {
					dwgNo = "";
				}*/
				
				temp.put("receipt_detail_id", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[0]);
				temp.put("receipt_id", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[1]);
				temp.put("receipt_no", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[2]);
				temp.put("project_no", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[3]);
				temp.put("doc_type", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[4]);
				temp.put("issuer", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[5]);
				temp.put("subject", URLDecoder.decode(commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[6], "UTF-8") );
				temp.put("issue_date", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[7]);
				temp.put("com_no", URLDecoder.decode(commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[8], "UTF-8") );
				temp.put("receipt_team_code", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[9]);
				temp.put("receipt_team_name", URLDecoder.decode(commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[10], "UTF-8") );
				temp.put("receipt_dept_code", receipt_dept_code );
				temp.put("receipt_dept_name", receipt_dept_name );
				temp.put("receipt_user_id", receipt_user_id );
				temp.put("receipt_user_name", receipt_user_name );
				//temp.put("dwg_no", dwgNo );
				
				listData.add(temp);
			}
		}
		
		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = listData.size();
		// 라스트 페이지를 구한다.
		Object lastPageCnt = "page>total";
		if (!DisConstants.NO.equals(commandMap.get(DisConstants.IS_PAGING))) {
			lastPageCnt = DisPageUtil.getPageCount(pageSize, listRowCnt);
		}
		
		// 결과값 생성
		Map<String, Object> result = new HashMap<String, Object>();
		result.put(DisConstants.GRID_RESULT_CUR_PAGE, curPageNo);
		result.put(DisConstants.GRID_RESULT_LAST_PAGE, lastPageCnt);
		result.put(DisConstants.GRID_RESULT_RECORDS_CNT, listRowCnt);
		result.put(DisConstants.GRID_RESULT_DATA, listData);
		
		return result;
	}
	
	/**
	 * 
	 * @메소드명	: commentReceiptDwgApplyAction
	 * @날짜		: 2017. 6. 19.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * 		<pre>
	 *			도면 팝업에서 도면 지정 후 Apply Action(Update)
	 * 		</pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> commentReceiptDwgApplyAction(CommandMap commandMap) throws Exception {
		// 그리드 리스트에서 받아옴
		List<Map<String, Object>> commentReceiptUserWorkList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());

		String sErrorMsg = "";

		try {
			for (Map<String, Object> rowData : commentReceiptUserWorkList) {
				
				Map<String, Object> pkgParam = new HashMap<String, Object>();

				// commandMap에 있는 행을 'p_'를 붙혀서 pkgParam에 넣는다.
				for (String key : rowData.keySet()) {
					pkgParam.put("p_" + key, rowData.get(key));
				}

				// 필요한 값 셋팅
				pkgParam.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				pkgParam.put("p_action_type", rowData.get("oper"));
				
				commentDAO.commentReceiptDwgApplyAction(pkgParam);

				// 프로시저 결과 받음
				sErrorMsg = DisStringUtil.nullString(pkgParam.get("p_error_msg"));
				String sErrCode = DisStringUtil.nullString(pkgParam.get("p_error_code"));

				// 오류가 있으면 스탑
				if (!"".equals(sErrorMsg)) {
					System.out.println(sErrCode);
					throw new DisException(sErrorMsg);
				}
			}

			// 여기까지 Exception 없으면 성공 메시지
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));

		} catch (Exception e) {
			e.printStackTrace();
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, e.getLocalizedMessage());
		}

		// 3. 결과 리턴
		return commandMap.getMap();
	}
	
	/**
	 * 
	 * @메소드명	: commentReceiptExcelExport
	 * @날짜		: 2017. 7. 4.
	 * @작성자		: 이상빈
	 * @설명 
	 * 	<pre>
	 *		commentReceipt 엑셀 다운로드	
	 * 	</pre>
	 * @param commandMap
	 * @param modelMap
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@Override
	public View commentReceiptExcelExport(CommandMap commandMap, Map<String, Object> modelMap) {
		
		try {
			// COLNAME 설정
			List<String> colName = new ArrayList<String>();
			// 그리드에서 받아온 엑셀 헤더를 설정한다.
			String[] p_col_names = commandMap.get("p_col_name").toString().split(",");
			// COLVALUE 설정
			List<List<String>> colValue = new ArrayList<List<String>>();
			// 그리드에서 받아온 데이터 네임을 배열로 설정
			String[] p_data_names = commandMap.get("p_data_name").toString().split(",");
			
			// 그리드의 헤더를 콜네임으로 설정
			for (String p_col_name : p_col_names) {
				//colName.add(new String(p_col_name.getBytes("ISO_8859_1"),"UTF-8"));
				colName.add(new String(p_col_name.getBytes("utf-8"),"utf-8"));
			}
	
			// 리스트를 취득한다.
			Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
			Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);

			//Excel출력 페이지는 단일 페이지=1, 출력은 9999999건까지 제약조건
			curPageNo = "1"; 
			pageSize = "999999";
			
			commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
			commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
			
			Map<String, Object> resultData = commentDAO.commentReceiptList(commandMap.getMap());
			List<Map<String, Object>> itemList = (List<Map<String, Object>>)resultData.get("p_refer");
			
			for (Map<String, Object> rowData : itemList) {
				List<String> row = new ArrayList<String>();
				
				// 데이터 네임을 이용해서 리스트에서 뽑아냄.
				for (String p_data_name : p_data_names) {
					row.add(DisStringUtil.nullString(rowData.get(p_data_name)));
				}
				colValue.add(row);
			}
			
			modelMap.put("excelName", commandMap.get(DisConstants.MAPPER_NAME));
			modelMap.put("colName", colName);
			modelMap.put("colValue", colValue);
			
		}  catch (Exception e) {
			e.printStackTrace();
		}
		return new GenericExcelView();
	}
	//**************************************************************************
	// commentReceipt(수신문서) MAIN METHOD END
	//**************************************************************************
	
	
	//**************************************************************************
	// commentReceipt(수신문서) ADD Method START
	//**************************************************************************
	/**
	 * 
	 * @메소드명	: commentReceiptProjectNoList
	 * @날짜		: 2017. 7. 4.
	 * @작성자		: 이상빈
	 * @설명 
	 * 	<pre>
	 *		commentReceipt ADD - Grid 내 프로젝트 자동완성	
	 * 	</pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public String commentReceiptProjectNoList(CommandMap commandMap) throws Exception {
		commandMap.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		
		List<Map<String, Object>> list = commentDAO.commentReceiptProjectNoList(commandMap.getMap());
		
		String rtnString = "";

		for (Map<String, Object> map : list) {
			if (!rtnString.equals("")) {
				rtnString += "|";
			}
			rtnString += map.get("value").toString();
		}

		return rtnString;
		
	}
	
	/**
	 * 
	 * @메소드명	: commentReceiptDwgNoList
	 * @날짜		: 2017. 6. 14.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * 		<pre>
	 *			commentReceipt ADD 부서에 따른 도면 리스트
	 * 		</pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> commentReceiptDwgNoList(CommandMap commandMap) throws Exception {
		commandMap.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		
		return commentDAO.commentReceiptDwgNoList(commandMap.getMap());
	}
	
	/**
	 * 
	 * @메소드명	: commentReceiptAddValidationCheck
	 * @날짜		: 2017. 6. 14.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * 		<pre>
	 *			commentReceipt ADD NEXT ACTION
	 * 		</pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> commentReceiptAddValidationCheck(CommandMap commandMap) throws Exception {

		// 그리드 리스트에서 받아옴
		List<Map<String, Object>> commentReceiptAddList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());

		String sErrorMsg = "";
		String sWorkKey = Long.toString(System.currentTimeMillis());
		String uploadDir = "";
		
		try {
			for (Map<String, Object> rowData : commentReceiptAddList) {
				
				Map<String, Object> pkgParam = new HashMap<String, Object>();

				// commandMap에 있는 행을 'p_'를 붙혀서 pkgParam에 넣는다.
				for (String key : rowData.keySet()) {
					pkgParam.put("p_" + key, rowData.get(key));
				}
				
				uploadDir = DisMessageUtil.getMessage("decrypt.path") + rowData.get("dec_document_name");
				File file = new File(uploadDir);
				String fileType = new MimetypesFileTypeMap().getContentType(file);
				
				FileInputStream input = new FileInputStream(file);
				MultipartFile multipartFile = new MockMultipartFile("fileItem", file.getName(), fileType, IOUtils.toByteArray(input));
				input.close();
				
				/*if(rowData.get("dwg_no").equals("") && rowData.get("p_dwg_no") == null) {
					pkgParam.put("p_dwg_no", "N/A");
				}*/
				
				pkgParam.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				pkgParam.put("p_work_key", sWorkKey);
				pkgParam.put("p_document_name", rowData.get("document_name"));
				pkgParam.put("p_document_data", multipartFile.getBytes());
				pkgParam.put("p_dept_type",	commandMap.get("p_dept_type"));
				
				// 프로시저는 넘겨준 MAP에 결과가 리턴된다.
				commentDAO.commentReceiptAddInsert(pkgParam);

				// 프로시저 결과 받음
				sErrorMsg = DisStringUtil.nullString(pkgParam.get("p_error_msg"));
				String sErrCode = DisStringUtil.nullString(pkgParam.get("p_error_code"));

				// 오류가 있으면 스탑
				if (!"".equals(sErrorMsg)) {
					System.out.println("sErrCode >>> " + sErrCode);
					throw new DisException(sErrorMsg);
				}
				
				// 첨부가 되고 나면 삭제
				//File delfile = new File(uploadDir);
				//DisEGDecrypt.deleteDecryptFile(delfile);
				
			}

			// 2. Validation 체크 프로시저 호출
			// 키 값이 되는 user_id와 work_key를 넣어준다.
			commandMap.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			commandMap.put("p_work_key", sWorkKey);
			
			sErrorMsg = DisStringUtil.nullString(commandMap.get("p_error_msg"));
			String sErrCode = DisStringUtil.nullString(commandMap.get("p_error_code"));
			String receipt_no = DisStringUtil.nullString(commandMap.get("p_receipt_no"));
			String receipt_id = DisStringUtil.nullString(commandMap.get("p_receipt_id"));
			
			commandMap.put("receipt_no", receipt_no);
			commandMap.put("receipt_id", receipt_id);
			
			// 오류가 있으면 스탑
			if (!"".equals(sErrorMsg)) {
				System.out.println("sErrCode >>> " + sErrCode);
				throw new DisException(sErrorMsg);
			}

			// 여기까지 Exception 없으면 성공 메시지
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));

		} catch (Exception e) {
			e.printStackTrace();
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, e.getLocalizedMessage());
		}

		// 3. 결과 리턴
		return commandMap.getMap();
	}
	
	/**
	 * 
	 * @메소드명	: commentReceiptWorkValidationList
	 * @날짜		: 2017. 6. 14.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * 		<pre>
	 *			commentReceipt ADD NEXT ACTION 이후 데이터 리스트
	 * 		</pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> commentReceiptWorkValidationList(CommandMap commandMap) throws Exception {

		String sErrorMsg = "";
		// 리스트를 취득한다.
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		
		// 페이지 전처리
		commandMap.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		
		// 결과값 생성
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			Map<String, Object> resultData = commentDAO.commentReceiptWorkValidationList(commandMap.getMap());
			List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("p_refer");
			
			// 프로시저 결과 받음
			sErrorMsg = DisStringUtil.nullString(resultData.get("p_error_msg"));
			// 오류가 있으면 스탑
			if (!"".equals(sErrorMsg)) {
				throw new DisException(sErrorMsg);
			}
			
			// 리스트 총 사이즈를 구한다.
			Object listRowCnt = listData.size();
			if (!DisConstants.NO.equals(commandMap.get(DisConstants.IS_PAGING))) {
			}
			// 라스트 페이지를 구한다.
			Object lastPageCnt = "page>total";
			if (!DisConstants.NO.equals(commandMap.get(DisConstants.IS_PAGING))) {
				lastPageCnt = DisPageUtil.getPageCount(commandMap.get(DisConstants.SET_DB_PAGE_SIZE), listRowCnt);
			}

			result.put(DisConstants.GRID_RESULT_CUR_PAGE, curPageNo);
			result.put(DisConstants.GRID_RESULT_LAST_PAGE, lastPageCnt);
			result.put(DisConstants.GRID_RESULT_RECORDS_CNT, listRowCnt);
			result.put(DisConstants.GRID_RESULT_DATA, listData);
			result.put(DisConstants.RESULT_MASAGE_KEY, sErrorMsg);
			
			// 여기까지 Exception 없으면 성공 메시지
			result.put(DisConstants.RESULT_MASAGE_KEY, "");
			
			// 첨부가 되고 나면 삭제
			/*String uploadDir = DisMessageUtil.getMessage("decrypt.path") + rowData.get("dec_document_name");
			
			File delfile = new File(uploadDir);
			DisEGDecrypt.deleteDecryptFile(delfile);*/

		} catch(Exception e) {
			result.put(DisConstants.RESULT_MASAGE_KEY, sErrorMsg);
		}
		
		return result;
	}
	
	/**
	 * 
	 * @메소드명	: commentReceiptAddApplyAction
	 * @날짜		: 2017. 6. 14.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * 		<pre>
	 *			commentReceipt ADD Apply ACTION
	 * 		</pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> commentReceiptAddApplyAction(CommandMap commandMap) throws Exception {
		// 1. 모든 리스트 STX_DIS_HEAD에 입력
		String sErrorMsg = "";
		String sErrCode = "";

		try {
			// 키 값이 되는 user_id와 work_key를 넣어준다.
			// WORK KEY COMMANDMAP에 들어가있음.
			commandMap.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			
			commentDAO.commentReceiptAddApplyAction(commandMap.getMap());

			sErrorMsg = DisStringUtil.nullString(commandMap.get("p_error_msg"));
			sErrCode = DisStringUtil.nullString(commandMap.get("p_error_code"));

			// 오류가 있으면 스탑
			if (!"".equals(sErrorMsg)) {
				throw new DisException(sErrorMsg);
			}

			// 여기까지 Exception 없으면 성공 메시지
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));

		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("sErrCode >>> " + sErrCode);
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, e.getLocalizedMessage());
		}

		// 3. 결과 리턴
		return commandMap.getMap();
	}
	
	/**
	 * 
	 * @메소드명	: commentReceiptAttachFileAction
	 * @날짜		: 2017. 6. 14.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * 		<pre>
	 *			commentReceipt ADD 그리드 row에 파일첨부 반영
	 * 		</pre>
	 * @param file
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> commentReceiptAttachFileAction(MultipartFile file, CommandMap commandMap) throws Exception {
		
		//파일 복호화
		File DecryptFile = null; 
		DecryptFile = DisEGDecrypt.createDecryptFile(file);
		commandMap.put("document_name", file.getOriginalFilename());
		commandMap.put("dec_document_name", DecryptFile.getName());
		
		return commandMap.getMap();
	}
	
	/**
	 * 
	 * @메소드명	: commentReceiptExcelImportAction
	 * @날짜		: 2017. 6. 14.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * 		<pre>
	 *			commentReceipt ADD EXCEL IMPORT ACTION
	 * 		</pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> commentReceiptExcelImportAction(CommandMap commandMap) throws Exception {
		return FileScanner.DecryptExcelToList((File) commandMap.get("file"), 1, true, 0);
		//암호화 복호화 파일업로드 적용 해지
		//return FileScanner.excelToList((MultipartFile) commandMap.get("file"), 1, true, 0);
	}
	//**************************************************************************
	// commentReceipt(수신문서) ADD Method END
	//**************************************************************************
	
	
	
	//**************************************************************************
	//comment Main Method START
	//**************************************************************************
	/**
	 * 
	 * @메소드명	: commentAutoCompleteDwgNoList
	 * @날짜		: 2017. 7. 4.
	 * @작성자		: 이상빈
	 * @설명 
	 * 	<pre>
	 *		COMMENT 화면 - 도면번호 목록 자동완성	
	 * 	</pre>
	 * @param commandMap
	 * @return
	 */
	public String commentAutoCompleteDwgNoList(CommandMap commandMap) {
		List<Map<String, Object>> list = commentDAO.commentAutoCompleteDwgNoList(commandMap.getMap());
		String rtnString = "";

		for (Map<String, Object> map : list) {
			if (!rtnString.equals("")) {
				rtnString += "|";
			}
			rtnString += map.get("object").toString();
		}

		return rtnString;
	}
	
	/**
	 * 
	 * @메소드명	: commentList
	 * @날짜		: 2017. 6. 14.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * 		<pre>
	 *			메인 리스트 호출
	 * 		</pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> commentList(CommandMap commandMap) throws Exception {

		// 리스트를 취득한다.
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		
		Map<String, Object> resultData = commentDAO.commentList(commandMap.getMap());
		List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("p_refer");
		
		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = listData.size();
		
		// 라스트 페이지를 구한다.
		Object lastPageCnt = "page>total";
		lastPageCnt = DisPageUtil.getPageCount(commandMap.get(DisConstants.SET_DB_PAGE_SIZE), listRowCnt);

		// 결과값 생성
		Map<String, Object> result = new HashMap<String, Object>();
		result.put(DisConstants.GRID_RESULT_CUR_PAGE, curPageNo);
		result.put(DisConstants.GRID_RESULT_LAST_PAGE, lastPageCnt);
		result.put(DisConstants.GRID_RESULT_RECORDS_CNT, listRowCnt);
		result.put(DisConstants.GRID_RESULT_DATA, listData);
		

		return result;
	}
	
	/**
	 * 
	 * @메소드명	: commentReceiptNoList
	 * @날짜		: 2017. 7. 4.
	 * @작성자		: 이상빈
	 * @설명 
	 * 	<pre>
	 *		COMMENT 메인 수신NO 리스트	
	 * 	</pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> commentReceiptNoList(CommandMap commandMap) throws Exception {
		commandMap.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		
		return commentDAO.commentReceiptNoList(commandMap.getMap());
	}

	/**
	 * 
	 * @메소드명	: commentMainSaveAction
	 * @날짜		: 2017. 7. 4.
	 * @작성자		: 이상빈
	 * @설명 
	 * 	<pre>
	 *		COMMENT 메인 저장		
	 * 	</pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> commentMainSaveAction(CommandMap commandMap) throws Exception {
		
		String sErrMsg = "";
		String sErrCode = "";

		// 그리드 리스트에서 받아옴
		List<Map<String, Object>> commentMainSaveList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());

		try {
			for (Map<String, Object> rowData : commentMainSaveList) {
				Map<String, Object> pkgParam = new HashMap<String, Object>();

				// commandMap에 있는 행을 'p_'를 붙혀서 pkgParam에 넣는다.
				for (String key : rowData.keySet()) {
					pkgParam.put("p_" + key, rowData.get(key));
				}

				// 필요한 값 셋팅
				pkgParam.put("p_project_no", commandMap.get("p_project_no") );
				pkgParam.put("p_dwg_no", 	commandMap.get("p_dwg_no") );
				pkgParam.put("p_issuer", 	commandMap.get("p_issuer") );
				pkgParam.put("p_user_id", 	commandMap.get(DisConstants.SET_DB_LOGIN_ID));

				//상태값이 초기일때는 Defualt : N(notice)
				if( pkgParam.get("p_status").equals("") ) {
					pkgParam.put("p_status", "O");
				}
				
				// 프로시저는 넘겨준 MAP에 결과가 리턴된다.
				commentDAO.commentMainSaveAction(pkgParam);
				
				// 프로시저 결과 받음
				sErrMsg = DisStringUtil.nullString(commandMap.get("p_error_msg"));
				sErrCode = DisStringUtil.nullString(commandMap.get("p_error_code"));
				
				if (!"".equals(sErrMsg)) {
					System.out.println(sErrCode);
					throw new DisException(sErrMsg);
				}
				
				//첨부파일 있는경우 첨부파일 테이블에 Insert 
				String dec_sub_att = (String) pkgParam.get("p_dec_sub_att");
				String[] arr_dec_sub_att = new String[]{};
				String dec_sub_att_name = (String) pkgParam.get("p_dec_sub_att_name");
				String[] arr_dec_sub_att_name = new String[]{};
				
				if(dec_sub_att.indexOf("@") > -1) {
					
					arr_dec_sub_att = dec_sub_att.split("@");
					arr_dec_sub_att_name = dec_sub_att_name.split("@");
					
					for(int i=0; i<arr_dec_sub_att.length; i++) {
						
						//File을 읽어들여서 MultipartFile로 변경
						String uploadDir = DisMessageUtil.getMessage("decrypt.path") + arr_dec_sub_att[i];
						File file = new File(uploadDir);
						String fileType = new MimetypesFileTypeMap().getContentType(file);
						
						FileInputStream input = new FileInputStream(file);
						MultipartFile multipartFile = new MockMultipartFile("fileItem", file.getName(), fileType, IOUtils.toByteArray(input));
						input.close();
						
						pkgParam.put("p_document_name", arr_dec_sub_att_name[i]);
						pkgParam.put("p_document_data", multipartFile.getBytes());
						
						commentDAO.commentMainAttachSaveAction(pkgParam);
						
						// 프로시저 결과 받음
						sErrMsg = DisStringUtil.nullString(commandMap.get("p_error_msg"));
						sErrCode = DisStringUtil.nullString(commandMap.get("p_error_code"));
						
						if (!"".equals(sErrMsg)) {
							throw new DisException(sErrMsg);
						}
					}
				} else if (dec_sub_att != "") {
					//File을 읽어들여서 MultipartFile로 변경
					String uploadDir = DisMessageUtil.getMessage("decrypt.path") + dec_sub_att;
					File file = new File(uploadDir);
					String fileType = new MimetypesFileTypeMap().getContentType(file);
					
					FileInputStream input = new FileInputStream(file);
					MultipartFile multipartFile = new MockMultipartFile("fileItem", file.getName(), fileType, IOUtils.toByteArray(input));
					input.close();
					
					pkgParam.put("p_document_name", dec_sub_att_name);
					pkgParam.put("p_document_data", multipartFile.getBytes());
					
					commentDAO.commentMainAttachSaveAction(pkgParam);
					
					// 프로시저 결과 받음
					sErrMsg = DisStringUtil.nullString(commandMap.get("p_error_msg"));
					sErrCode = DisStringUtil.nullString(commandMap.get("p_error_code"));
					
					DisEGDecrypt.deleteDecryptFile(file);
					
					if (!"".equals(sErrMsg)) {
						throw new DisException(sErrMsg);
					}
				}
				
			}

			// 여기까지 Exception 없으면 성공 메시지
			
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));

		} catch (Exception e) {
			e.printStackTrace();
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, e.getLocalizedMessage());
		}

		// 3. 결과 리턴
		return commandMap.getMap();
	}
	
	/**
	 * 
	 * @메소드명	: commentPCFExcelExport
	 * @날짜		: 2017. 7. 4.
	 * @작성자		: 이상빈
	 * @설명 
	 * 	<pre>
	 *		COMMENT PCF 다운로드	
	 * 	</pre>
	 * @param commandMap
	 * @param modelMap
	 * @return
	 */
	@Override
	public View commentPCFExcelExport(CommandMap commandMap, Map<String, Object> modelMap) {
		
		try {
			
			String p_pcf_admin_page = (String) commandMap.get("p_pcf_admin_page");
			if(p_pcf_admin_page.equals("Y")) {
				commandMap.put("p_project_no", commandMap.get("project_no"));
				commandMap.put("p_dwg_no", commandMap.get("dwg_no"));
				commandMap.put("p_issuer", commandMap.get("issuer"));
			}
			
			Map<String, Object> pcfHeader = commentDAO.pcfHeader(commandMap.getMap());
			
			List<Map<String, Object>> pcfHistoryList = new ArrayList<Map<String,Object>>();
			List<Map<String, Object>> tempPcfHistoryList = commentDAO.pcfHistoryList(commandMap.getMap());
			Map<String, Object> pcfHistory = new HashMap<String, Object>();
			
			pcfHistory.put("COM_NO", "");
			pcfHistory.put("ISSUE_DATE", "");
			pcfHistory.put("BUILDER_REF_NO", "");
			pcfHistory.put("BUILDER_DATE", "");
			pcfHistoryList.add(pcfHistory);
			pcfHistoryList.add(pcfHistory);
			pcfHistoryList.add(pcfHistory);
			pcfHistoryList.add(pcfHistory);
			
			for(Map<String, Object> temp : tempPcfHistoryList) {
				pcfHistoryList.add(temp);
			}
			
			List<Map<String, Object>> pcfHeaderList = commentDAO.pcfHeaderList(commandMap.getMap());
			List<Map<String, Object>> pcfSubList = commentDAO.pcfSubList(commandMap.getMap());

			modelMap.put("excelName", commandMap.get(DisConstants.MAPPER_NAME));
			modelMap.put("pcfHeader", pcfHeader);
			modelMap.put("pcfHistoryList", pcfHistoryList);
			modelMap.put("pcfHeaderList", pcfHeaderList);
			modelMap.put("pcfSubList", pcfSubList);
			modelMap.put("commandMap", commandMap);
			
		}  catch (Exception e) {
			e.printStackTrace();
		}
		
		return new GenericExcelView5();
	}

	/**
	 * 
	 * @메소드명	: commentReqeustApplyAction
	 * @날짜		: 2017. 7. 4.
	 * @작성자		: 이상빈
	 * @설명 
	 * 	<pre>
	 *		COMMENT MAIN 승인요청	
	 * 	</pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> commentReqeustApplyAction(CommandMap commandMap) throws Exception {
		
		String sErrMsg = "";
		String sErrCode = "";
		
		try {
			commandMap.put("p_user_id", 	commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			
			//승인자 고정을 위한 유저테이블 업데이트
			commentDAO.commentConfirmUserUpdateAction(commandMap.getMap());
			
			commentDAO.commentReqeustApplyAction(commandMap.getMap());
			
			// 프로시저 결과 받음
			sErrMsg = DisStringUtil.nullString(commandMap.get("p_error_msg"));
			sErrCode = DisStringUtil.nullString(commandMap.get("p_error_code"));
			
			if (!"".equals(sErrMsg)) {
				System.out.println(sErrCode);
				throw new DisException(sErrMsg);
			}
			
			// 여기까지 Exception 없으면 성공 메시지
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));
		} catch(Exception e) {
			e.printStackTrace();
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, e.getLocalizedMessage());
		}
		
		// 3. 결과 리턴
		return commandMap.getMap();
	}
	
	/**
	 * 
	 * @메소드명	: commentRefNoList
	 * @날짜		: 2017. 7. 4.
	 * @작성자		: 이상빈
	 * @설명 
	 * 	<pre>
	 *		COMMENT 화면 - 그리드 내 발신번호 목록	
	 * 	</pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> commentRefNoList(CommandMap commandMap) throws Exception {
		return commentDAO.commentRefNoList(commandMap.getMap());
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> popUpCommentCommentAttachList(CommandMap commandMap) throws Exception {
		
		Map<String, Object> resultData = commentDAO.popUpCommentCommentAttachList(commandMap.getMap());
		List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("p_refer");
		
		// 결과값 생성
		Map<String, Object> result = new HashMap<String, Object>();
		result.put(DisConstants.GRID_RESULT_DATA, listData);

		return result;
	}
	//**************************************************************************
	//comment Main Method END
	//**************************************************************************
	
	
	
	//**************************************************************************
	// comment 승인 Method START
	//**************************************************************************
	/**
	 * 
	 * @메소드명	: commentAdminMaList
	 * @날짜		: 2017. 7. 4.
	 * @작성자		: 이상빈
	 * @설명 
	 * 	<pre>
	 *		COMMENT 승인화면 - 왼쪽 그리드 목록	
	 * 	</pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> commentAdminMaList(CommandMap commandMap) throws Exception {

		// 리스트를 취득한다.
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		
		Map<String, Object> resultData = commentDAO.commentAdminMaList(commandMap.getMap());
		List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("p_refer");
		
		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = listData.size();
		
		// 라스트 페이지를 구한다.
		Object lastPageCnt = "page>total";
		lastPageCnt = DisPageUtil.getPageCount(commandMap.get(DisConstants.SET_DB_PAGE_SIZE), listRowCnt);

		// 결과값 생성
		Map<String, Object> result = new HashMap<String, Object>();
		result.put(DisConstants.GRID_RESULT_CUR_PAGE, curPageNo);
		result.put(DisConstants.GRID_RESULT_LAST_PAGE, lastPageCnt);
		result.put(DisConstants.GRID_RESULT_RECORDS_CNT, listRowCnt);
		result.put(DisConstants.GRID_RESULT_DATA, listData);

		return result;
	}
	
	/**
	 * 
	 * @메소드명	: commentAdminDeList
	 * @날짜		: 2017. 7. 4.
	 * @작성자		: 이상빈
	 * @설명 
	 * 	<pre>
	 *		COMMENT 승인화면 - 오른쪽 그리드 목록	
	 * 	</pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> commentAdminDeList(CommandMap commandMap) throws Exception {

		// 리스트를 취득한다.
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		
		commandMap.put("p_project_no", commandMap.get("project_no"));
		commandMap.put("p_dwg_no", commandMap.get("dwg_no"));
		commandMap.put("p_issuer", commandMap.get("issuer"));
		
		Map<String, Object> resultData = commentDAO.commentAdminDeList(commandMap.getMap());
		List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("p_refer");
		
		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = listData.size();
		
		// 라스트 페이지를 구한다.
		Object lastPageCnt = "page>total";
		lastPageCnt = DisPageUtil.getPageCount(commandMap.get(DisConstants.SET_DB_PAGE_SIZE), listRowCnt);

		// 결과값 생성
		Map<String, Object> result = new HashMap<String, Object>();
		result.put(DisConstants.GRID_RESULT_CUR_PAGE, curPageNo);
		result.put(DisConstants.GRID_RESULT_LAST_PAGE, lastPageCnt);
		result.put(DisConstants.GRID_RESULT_RECORDS_CNT, listRowCnt);
		result.put(DisConstants.GRID_RESULT_DATA, listData);

		return result;
	}
	
	/**
	 * 
	 * @메소드명	: commentAdminConfirmAction
	 * @날짜		: 2017. 7. 4.
	 * @작성자		: 이상빈
	 * @설명 
	 * 	<pre>
	 *		COMMENT 승인화면 - 승인/반려 ACTION	
	 * 	</pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> commentAdminConfirmAction(CommandMap commandMap) throws Exception {
		// 그리드 리스트에서 받아옴
		List<Map<String, Object>> commentAdminMaList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());

		String sErrorMsg = "";
		String sErrCode = "";

		try {
			for (Map<String, Object> rowData : commentAdminMaList) {
				
				Map<String, Object> pkgParam = new HashMap<String, Object>();

				// commandMap에 있는 행을 'p_'를 붙혀서 pkgParam에 넣는다.
				for (String key : rowData.keySet()) {
					pkgParam.put("p_" + key, rowData.get(key));
				}
				
				String issuer = (String) pkgParam.get("p_issuer");
				if(issuer.equals("OWNER")) {
					issuer = "O";
				} else {
					issuer = "C";
				}
				pkgParam.put("p_issuer", issuer);
				
				// 필요한 값 셋팅
				pkgParam.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				pkgParam.put("p_mail_type", commandMap.get("p_mail_type"));
				pkgParam.put("p_mail_comment", commandMap.get("p_mail_comment"));
				
				
				
				commentDAO.commentAdminConfirmAction(pkgParam);
				
				// 프로시저 결과 받음
				sErrorMsg = DisStringUtil.nullString(pkgParam.get("p_error_msg"));
				sErrCode = DisStringUtil.nullString(pkgParam.get("p_error_code"));

				// 오류가 있으면 스탑
				if (!"".equals(sErrorMsg)) {
					throw new DisException(sErrorMsg);
				}
				
			}

			// 여기까지 Exception 없으면 성공 메시지
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));

		} catch (Exception e) {
			System.out.println(sErrCode);
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, sErrorMsg);
		}

		// 3. 결과 리턴
		return commandMap.getMap();
	}
	//**************************************************************************
	// comment 승인 Method END
	//**************************************************************************
	
	
	
	//**************************************************************************
	// comment 현황 Method START
	//**************************************************************************
	@Override
	public List<Map<String, Object>> commentChartList(CommandMap commandMap) throws Exception {
		return commentDAO.commentChartList(commandMap.getMap());
	}
	
	@Override
	public List<Map<String, Object>> commentChartDetailList(CommandMap commandMap) throws Exception {
		return commentDAO.commentChartDetailList(commandMap.getMap());
	}
	
	@Override
	public String commentSelectBoxTeamList(CommandMap commandMap) throws Exception {

		// p_query를 이용하여 셀렉트 박스 내용 받음.
		List<Map<String, Object>> list = commentDAO.commentSelectBoxTeamList(commandMap.getMap());

		String rtnString = "";
		String vType = DisStringUtil.nullString(commandMap.get("sb_type"));
		
		// 첫 optison 선택 파라미터
		if (vType.equals("all")) {
			rtnString = "<option value=\"ALL\">ALL</option>";
		} else if (vType.equals("sel")) {
			rtnString = "<option value=\"\">선택</option>";
		}

		for (Map<String, Object> rowData : list) {
			rtnString += "<option value=\"" + DisStringUtil.nullString(rowData.get("sb_value")) + "\""
					+ DisStringUtil.nullString(rowData.get("sb_selected"))  + ">"
					//+ " name=\"" + DisStringUtil.nullString(rowData.get("ATTR")) + "\">" 
					+ rowData.get("sb_name") + "</option>";
		}

		return URLEncoder.encode(rtnString, "UTF-8");
	}
	
	@Override
	public String commentSelectBoxPartList(CommandMap commandMap) throws Exception {

		// p_query를 이용하여 셀렉트 박스 내용 받음.
		List<Map<String, Object>> list = commentDAO.commentSelectBoxPartList(commandMap.getMap());

		String rtnString = "";
		String vType = DisStringUtil.nullString(commandMap.get("sb_type"));
		
		// 첫 optison 선택 파라미터
		if (vType.equals("all")) {
			rtnString = "<option value=\"ALL\">ALL</option>";
		} else if (vType.equals("sel")) {
			rtnString = "<option value=\"\">선택</option>";
		}

		for (Map<String, Object> rowData : list) {
			rtnString += "<option value=\"" + DisStringUtil.nullString(rowData.get("sb_value")) + "\">"
					//+ DisStringUtil.nullString(rowData.get("sb_selected")) 
					//+ " name=\"" + DisStringUtil.nullString(rowData.get("ATTR")) + "\">" 
					+ rowData.get("sb_name") + "</option>";
		}

		return URLEncoder.encode(rtnString, "UTF-8");
	}
	
	@Override
	public String commentSelectBoxUserList(CommandMap commandMap) throws Exception {
		
		// p_query를 이용하여 셀렉트 박스 내용 받음.
		List<Map<String, Object>> list = commentDAO.commentSelectBoxUserList(commandMap.getMap());
		
		String rtnString = "";
		String vType = DisStringUtil.nullString(commandMap.get("sb_type"));
		
		// 첫 optison 선택 파라미터
		if (vType.equals("all")) {
			rtnString = "<option value=\"ALL\">ALL</option>";
		} else if (vType.equals("sel")) {
			rtnString = "<option value=\"\">선택</option>";
		}
		
		for (Map<String, Object> rowData : list) {
			rtnString += "<option value=\"" + DisStringUtil.nullString(rowData.get("sb_value")) + "\">"
					+ rowData.get("sb_name") + "</option>";
		}
		
		return URLEncoder.encode(rtnString, "UTF-8");
	}
	
	//**************************************************************************
	// comment 현황 Method END
	//**************************************************************************
	
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> commentExcelImportAction(CommandMap commandMap) throws Exception {
		
		String sErrorMsg = "";
		String sErrCode = "";
		
		String sWorkKey = Long.toString(System.currentTimeMillis());
		
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		List<Map<String, Object>> listData = new ArrayList<Map<String,Object>>();
		
		list = FileScanner.DecryptExcelToList((File) commandMap.get("file"), 1, true, 0);
		
		try {
		
			for(Map<String, Object> str : list ) {
				
				Map<String, Object> pkgParam = new HashMap<String, Object>();
				
				pkgParam.put("p_work_key", sWorkKey);
				pkgParam.put("p_project_no", commandMap.get("p_project_no"));
				pkgParam.put("p_dwg_no", commandMap.get("p_dwg_no"));
				pkgParam.put("p_issuer", commandMap.get("p_issuer"));
				pkgParam.put("p_receipt_no", commandMap.get("p_receipt_no"));
				pkgParam.put("p_receipt_detail_id", commandMap.get("p_receipt_detail_id"));
				pkgParam.put("p_list_no", str.get("column0"));
				pkgParam.put("p_sub_no", str.get("column1"));
				pkgParam.put("p_sub_title", str.get("column2"));
				pkgParam.put("p_initials", str.get("column3"));
				pkgParam.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				
				commentDAO.commentImportAddProc(pkgParam);
				
				// 프로시저 결과 받음
				sErrorMsg = DisStringUtil.nullString(pkgParam.get("p_error_msg"));
				sErrCode = DisStringUtil.nullString(pkgParam.get("p_error_code"));
				
				// 오류가 있으면 스탑
				if (!"".equals(sErrorMsg)) {
					throw new DisException(sErrorMsg);
				}
			}
			
			Map<String, Object> pkgParam1 = new HashMap<String, Object>();
			pkgParam1.put("p_work_key", sWorkKey);
			
			commentDAO.commentImportValidationProc(pkgParam1);
			
			// 프로시저 결과 받음
			sErrorMsg = DisStringUtil.nullString(pkgParam1.get("p_error_msg"));
			sErrCode = DisStringUtil.nullString(pkgParam1.get("p_error_code"));
			
			// 오류가 있으면 스탑
			if (!"".equals(sErrorMsg)) {
				throw new DisException(sErrorMsg);
			}
			
			Map<String, Object> resultData = commentDAO.commentImportSelectProc(pkgParam1);
			listData = (List<Map<String, Object>>)resultData.get("p_refer");
			
		} catch(Exception e) {
			System.out.println(sErrCode);
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, sErrorMsg);
		}
		
		return listData;
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> commentReplyExcelImportAction(CommandMap commandMap) throws Exception {
		
		String sErrorMsg = "";
		String sErrCode = "";
		
		String sWorkKey = Long.toString(System.currentTimeMillis());
		
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		List<Map<String, Object>> listData = new ArrayList<Map<String,Object>>();
		
		list = FileScanner.DecryptExcelToList((File) commandMap.get("file"), 1, true, 0);
		
		try {
		
			for(Map<String, Object> str : list ) {
				
				Map<String, Object> pkgParam = new HashMap<String, Object>();
				
				pkgParam.put("p_work_key", sWorkKey);
				pkgParam.put("p_project_no", commandMap.get("p_project_no"));
				pkgParam.put("p_dwg_no", commandMap.get("p_dwg_no"));
				pkgParam.put("p_issuer", commandMap.get("p_issuer"));
				pkgParam.put("p_receipt_no", commandMap.get("p_receipt_no"));
				pkgParam.put("p_receipt_detail_id", commandMap.get("p_receipt_detail_id"));
				pkgParam.put("p_list_no", str.get("column0"));
				pkgParam.put("p_sub_no", str.get("column1"));
				pkgParam.put("p_builders_reply", str.get("column2"));
				pkgParam.put("p_send_no", str.get("column3"));
				pkgParam.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				
				commentDAO.commentImportAddProc(pkgParam);
				
				// 프로시저 결과 받음
				sErrorMsg = DisStringUtil.nullString(pkgParam.get("p_error_msg"));
				sErrCode = DisStringUtil.nullString(pkgParam.get("p_error_code"));
				
				// 오류가 있으면 스탑
				if (!"".equals(sErrorMsg)) {
					throw new DisException(sErrorMsg);
				}
			}
			
			Map<String, Object> pkgParam1 = new HashMap<String, Object>();
			pkgParam1.put("p_work_key", sWorkKey);
			
			commentDAO.commentReplyImportValidationProc(pkgParam1);
			
			// 프로시저 결과 받음
			sErrorMsg = DisStringUtil.nullString(pkgParam1.get("p_error_msg"));
			sErrCode = DisStringUtil.nullString(pkgParam1.get("p_error_code"));
			
			// 오류가 있으면 스탑
			if (!"".equals(sErrorMsg)) {
				throw new DisException(sErrorMsg);
			}
			
			Map<String, Object> resultData = commentDAO.commentImportSelectProc(pkgParam1);
			listData = (List<Map<String, Object>>)resultData.get("p_refer");
			
		} catch(Exception e) {
			System.out.println(sErrCode);
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, sErrorMsg);
		}
		
		return listData;
	}
	
	public Object commentExcelTeamCode(Map<String, Object> pkgParam) throws Exception {
		Object teamCode = commentDAO.commentExcelTeamCode(pkgParam);
		return teamCode;
	}

	@Override
	public String commentReceiptNoSelectBoxDataList(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> list = commentDAO.commentReceiptNoSelectBoxDataList(commandMap.getMap());

		String rtnString = "";

		for (Map<String, Object> rowData : list) {
			rtnString += "<option value=\"" + DisStringUtil.nullString(rowData.get("sb_value")) + "\""
					+ DisStringUtil.nullString(rowData.get("sb_selected")) 
					+ " name=\"" + DisStringUtil.nullString(rowData.get("RECEIPT_DETAIL_ID")) + "\">" 
					+ rowData.get("sb_name") + "</option>";
		}

		return URLEncoder.encode(rtnString, "UTF-8");
	}
	
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> commentImportConfirmProc(CommandMap commandMap) throws Exception {
		// 그리드 리스트에서 받아옴
		List<Map<String, Object>> commentImportConfirmList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());

		String sErrorMsg = "";
		String sErrCode = "";
		String workKey = "";
		
		try {
			for (Map<String, Object> rowData : commentImportConfirmList) {
				workKey = (String) rowData.get("work_key");
			}
			
			Map<String, Object> pkgParam = new HashMap<String, Object>();
			
			// 필요한 값 셋팅
			pkgParam.put("p_work_key", workKey);
			pkgParam.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			
			commentDAO.commentImportConfirmProc(pkgParam);
			
			// 프로시저 결과 받음
			sErrorMsg = DisStringUtil.nullString(pkgParam.get("p_error_msg"));
			sErrCode = DisStringUtil.nullString(pkgParam.get("p_error_code"));

			// 오류가 있으면 스탑
			if (!"".equals(sErrorMsg)) {
				throw new DisException(sErrorMsg);
			}

			// 여기까지 Exception 없으면 성공 메시지
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));

		} catch (Exception e) {
			System.out.println(sErrCode);
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, sErrorMsg);
		}

		// 3. 결과 리턴
		return commandMap.getMap();
	}
	
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> commentReplyImportConfirmProc(CommandMap commandMap) throws Exception {
		// 그리드 리스트에서 받아옴
		List<Map<String, Object>> commentReplyImportConfirmList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());

		String sErrorMsg = "";
		String sErrCode = "";
		String workKey = "";
		
		try {
			for (Map<String, Object> rowData : commentReplyImportConfirmList) {
				workKey = (String) rowData.get("work_key");
			}
			
			Map<String, Object> pkgParam = new HashMap<String, Object>();
			
			// 필요한 값 셋팅
			pkgParam.put("p_work_key", workKey);
			pkgParam.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			
			commentDAO.commentReplyImportConfirmProc(pkgParam);
			
			// 프로시저 결과 받음
			sErrorMsg = DisStringUtil.nullString(pkgParam.get("p_error_msg"));
			sErrCode = DisStringUtil.nullString(pkgParam.get("p_error_code"));

			// 오류가 있으면 스탑
			if (!"".equals(sErrorMsg)) {
				throw new DisException(sErrorMsg);
			}

			// 여기까지 Exception 없으면 성공 메시지
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));

		} catch (Exception e) {
			System.out.println(sErrCode);
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, sErrorMsg);
		}

		// 3. 결과 리턴
		return commandMap.getMap();
	}
	
}
