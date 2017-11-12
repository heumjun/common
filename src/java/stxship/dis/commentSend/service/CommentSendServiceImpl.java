package stxship.dis.commentSend.service;

import java.io.File;
import java.io.FileInputStream;
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
import stxship.dis.commentSend.dao.CommentSendDAO;
import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.DisPageUtil;
import stxship.dis.common.util.DisStringUtil;
import stxship.dis.common.util.FileDownLoad;
import stxship.dis.common.util.GenericExcelView;

@Service("CommentSendService")
public class CommentSendServiceImpl extends CommonServiceImpl implements CommentSendService {

	@Resource(name = "CommentSendDAO")
	private CommentSendDAO commentSendDAO;
	
	/**
	 * @메소드명 : commentSendList
	 * @날짜 : 2017. 06. 12.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *		그리드 메인 리스트 (페이징 처리)
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> commentSendList(CommandMap commandMap) throws Exception {

		// 리스트를 취득한다.
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		
		Map<String, Object> resultData = commentSendDAO.commentSendList(commandMap.getMap());
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

	/**
	 * @메소드명 : commentSendGetFormName
	 * @날짜 : 2017. 07. 04.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		FORM NAME을 가져옴
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	public Map<String, Object> commentSendGetFormName(CommandMap commandMap) throws Exception {
		Object formName = commentSendDAO.commentSendGetFormName(commandMap.getMap()); 
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("formName", formName);
		return result;
	}
	
	/**
	 * @메소드명 : commentSendSave
	 * @날짜 : 2017. 06. 14.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		COMMENT 발신문서 요청 SAVE
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> commentSendSave(CommandMap commandMap) throws Exception {
		
		String sErrMsg = "";
		String sErrCode = "";

		// 그리드 리스트에서 받아옴
		List<Map<String, Object>> commentSendSaveList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());

		try {
			for (Map<String, Object> rowData : commentSendSaveList) {
				Map<String, Object> pkgParam = new HashMap<String, Object>();

				// commandMap에 있는 행을 'p_'를 붙혀서 pkgParam에 넣는다.
				for (String key : rowData.keySet()) {
					pkgParam.put("p_" + key, rowData.get(key));
				}

				// 필요한 값 셋팅
				pkgParam.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				
				// 프로시저는 넘겨준 MAP에 결과가 리턴된다.
				commentSendDAO.commentSendSave(pkgParam);

				// 프로시저 결과 받음
				sErrMsg = DisStringUtil.nullString(pkgParam.get("p_error_msg"));
				sErrCode = DisStringUtil.nullString(pkgParam.get("p_error_code"));
				
				if (!"".equals(sErrMsg)) {
					throw new DisException(sErrMsg);
				}
				
				// 첨부파일 있는경우 첨부파일 테이블에 Insert 
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
						pkgParam.put("p_document_id", "");
						
						commentSendDAO.commentSendAttachSaveAction(pkgParam);
						
						// 프로시저 결과 받음
						sErrMsg = DisStringUtil.nullString(pkgParam.get("p_error_msg"));
						sErrCode = DisStringUtil.nullString(pkgParam.get("p_error_code"));
						
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
					pkgParam.put("p_document_id", "");
							
					commentSendDAO.commentSendAttachSaveAction(pkgParam);
					
					// 프로시저 결과 받음
					sErrMsg = DisStringUtil.nullString(pkgParam.get("p_error_msg"));
					sErrCode = DisStringUtil.nullString(pkgParam.get("p_error_code"));
					
					if (!"".equals(sErrMsg)) {
						throw new DisException(sErrMsg);
					}
				}
				if (!"".equals(sErrMsg)) {
					System.out.println("sErrCode >>> " + sErrCode);
					throw new DisException(sErrMsg);
				}
			}
			// 여기까지 Exception 없으면 성공 메시지
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));
			commandMap.put(DisConstants.RESULT_KEY, DisConstants.RESULT_SUCCESS);
			
		} catch (Exception e) {
			e.printStackTrace();
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, e.getLocalizedMessage());
			commandMap.put(DisConstants.RESULT_KEY, DisConstants.RESULT_FAIL);
		}

		// 3. 결과 리턴
		return commandMap.getMap();
	}
	
	/**
	 * @메소드명 : popUpCommentSendDwgNoList
	 * @날짜 : 2017. 07. 13.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		SUB 도면번호 등록 팝업 창 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> popUpCommentSendDwgNoList(CommandMap commandMap) throws Exception {

		// 리스트를 취득한다.
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		
		Map<String, Object> resultData = commentSendDAO.popUpCommentSendDwgNoList(commandMap.getMap());
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
	 * @메소드명 : popUpCommentSendDwgNoSave
	 * @날짜 : 2017. 07. 14.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		SUB 도면번호 등록 팝업 창 SAVE
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> popUpCommentSendDwgNoSave(CommandMap commandMap) throws Exception {
		
		String sErrMsg = "";
		String sErrCode = "";

		// 그리드 리스트에서 받아옴
		List<Map<String, Object>> commentSendSaveList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());

		try {
			for (Map<String, Object> rowData : commentSendSaveList) {
				Map<String, Object> pkgParam = new HashMap<String, Object>();

				// commandMap에 있는 행을 'p_'를 붙혀서 pkgParam에 넣는다.
				for (String key : rowData.keySet()) {
					pkgParam.put("p_" + key, rowData.get(key));
				}

				// 필요한 값 셋팅
				pkgParam.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				pkgParam.put("p_send_id", commandMap.get("p_send_id"));
				pkgParam.put("p_dept_code", commandMap.get("p_dept_code"));
				
				// 프로시저는 넘겨준 MAP에 결과가 리턴된다.
				commentSendDAO.popUpCommentSendDwgNoSave(pkgParam);

				// 프로시저 결과 받음
				sErrMsg = DisStringUtil.nullString(pkgParam.get("p_error_msg"));
				sErrCode = DisStringUtil.nullString(pkgParam.get("p_error_code"));
				
				if (!"".equals(sErrMsg)) {
					System.out.println("sErrCode >>> " + sErrCode);
					throw new DisException(sErrMsg);
				}
			}
			// 여기까지 Exception 없으면 성공 메시지
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));
			commandMap.put(DisConstants.RESULT_KEY, DisConstants.RESULT_SUCCESS);
			
		} catch (Exception e) {
			e.printStackTrace();
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, e.getLocalizedMessage());
			commandMap.put(DisConstants.RESULT_KEY, DisConstants.RESULT_FAIL);
		}

		// 3. 결과 리턴
		return commandMap.getMap();
	}
	
	/**
	 * @메소드명 : popupCommentSendGridDwgNo
	 * @날짜 : 2017. 06. 12.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		그리드 내에 DWG NO. 콤보박스
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	public List<Map<String, Object>> popupCommentSendGridDwgNo(CommandMap commandMap) {
		return commentSendDAO.popupCommentSendGridDwgNo(commandMap.getMap());
	}
	
	/**
	 * @메소드명 : popupCommentSendGridDwgNoAppSubmit
	 * @날짜 : 2017. 08. 11.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		그리드 내에 DWG NO. 콤보박스 - Change (app Submit No)
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	public List<Map<String, Object>> popupCommentSendGridDwgNoAppSubmit(CommandMap commandMap) {
		return commentSendDAO.popupCommentSendGridDwgNoAppSubmit(commandMap.getMap());
	}
	
	/**
	 * @메소드명 : popUpCommentSendAttachList
	 * @날짜 : 2017. 07. 05.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		업로드 된 문서 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> popUpCommentSendAttachList(CommandMap commandMap) throws Exception {
		
		Map<String, Object> resultData = commentSendDAO.popUpCommentSendAttachList(commandMap.getMap());
		List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("p_refer");
		
		// 결과값 생성
		Map<String, Object> result = new HashMap<String, Object>();
		result.put(DisConstants.GRID_RESULT_DATA, listData);

		return result;
	}
	
	/**
	 * @메소드명 : commentSendFileView
	 * @날짜 : 2017. 07. 05.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		업로드 된 문서 다운로드
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	public View commentSendFileView(CommandMap commandMap, Map<String, Object> modelMap) {
		Map<String, Object> rs = commentSendDAO.commentSendFileView(commandMap);
		modelMap.put("data", (byte[]) rs.get("BLOBDATA"));
		modelMap.put("contentType", "application/octet-stream;");
		modelMap.put("filename", (String) rs.get("FILENAME"));
		return new FileDownLoad();
	}
	
	/**
	 * @메소드명 : commentSendFileDelete
	 * @날짜 : 2017. 07. 06.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		업로드 된 문서 삭제
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> commentSendFileDelete(CommandMap commandMap) throws Exception {
		try {
			// 프로시저는 넘겨준 MAP에 결과가 리턴된다.
			int result = commentSendDAO.commentSendFileDelete(commandMap.getMap());
			// 여기까지 Exception 없으면 성공 메시지
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));
			commandMap.put(DisConstants.RESULT_KEY, DisConstants.RESULT_SUCCESS);
		} catch (Exception e) {
			e.printStackTrace();
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, e.getLocalizedMessage());
			commandMap.put(DisConstants.RESULT_KEY, DisConstants.RESULT_FAIL);
		}
		// 3. 결과 리턴
		return commandMap.getMap();
	}
	
	/**
	 * @메소드명 : commentSendRequest
	 * @날짜 : 2017. 06. 14.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		COMMENT 발신문서 승인요청 로직
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> commentSendRequest(CommandMap commandMap) throws Exception {
		
		String sErrMsg = "";
		String sErrCode = "";

		commandMap.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		String[] send_id_array = commandMap.get("send_id_array").toString().split(",");
		
		//승인자 고정을 위한 유저테이블 업데이트
		commandMap.put("p_receipt_user_id", commandMap.get("p_confirm_user_id"));
		commentSendDAO.commentConfirmUserUpdateAction(commandMap.getMap());
		
				
		// 메일전송_1. HEAD INSERT
		commentSendDAO.commentSendHeadInsert(commandMap.getMap());
		
		try {
			for (String vSendId : send_id_array) {
				Map<String, Object> pkgParam = new HashMap<String, Object>();
				
				// 필요한 값 셋팅
				pkgParam.put("p_mail_id", commandMap.get("p_mail_id"));
				pkgParam.put("p_confirm_user_id", commandMap.get("p_confirm_user_id"));
				pkgParam.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				pkgParam.put("p_send_id", vSendId);

				// 메일전송_2. LIST INSERT
				commentSendDAO.commentSendListInsert(pkgParam);
			}
			
			// 메일전송_3. 상태업데이트 및 최종 메일전송
			commentSendDAO.commentSendRequestMail(commandMap.getMap());

			// 프로시저 결과 받음
			sErrMsg = DisStringUtil.nullString(commandMap.get("p_error_msg"));
			sErrCode = DisStringUtil.nullString(commandMap.get("p_error_code"));
			
			if (!"".equals(sErrMsg)) {
				System.out.println("sErrCode >>> " + sErrCode);
				throw new DisException(sErrMsg);
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
	 * @메소드명 : commentSendGridProject
	 * @날짜 : 2017. 06. 12.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		그리드 내에 PROJECT 콤보박스
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	public List<Map<String, Object>> commentSendGridProject(CommandMap commandMap) {
		return commentSendDAO.commentSendGridProject(commandMap.getMap());
	}
	
	/**
	 * @메소드명 : commentSendGridOcType
	 * @날짜 : 2017. 06. 12.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		그리드 내에 OC TYPE 콤보박스
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	public List<Map<String, Object>> commentSendGridOcType(CommandMap commandMap) {
		return commentSendDAO.commentSendGridOcType(commandMap.getMap());
	}
	
	/**
	 * @메소드명 : commentSendGridReqUser
	 * @날짜 : 2017. 06. 12.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		그리드 내에 발송자 콤보박스
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	public List<Map<String, Object>> commentSendGridReqUser(CommandMap commandMap) {
		return commentSendDAO.commentSendGridReqUser(commandMap.getMap());
	}
	
	/**
	 * @메소드명 : commentSendExcelExport
	 * @날짜 : 2016. 07. 01.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		메인 엑셀 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public View commentSendExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
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
				colName.add(new String(p_col_name.getBytes("ISO_8859_1"),"UTF-8"));
			}

			// 리스트를 취득한다.
			Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
			Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);

			//Excel출력 페이지는 단일 페이지=1, 출력은 9999999건까지 제약조건
			curPageNo = "1"; 
			pageSize = "999999";
			
			commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
			commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
			
			Map<String, Object> resultData = commentSendDAO.commentSendList(commandMap.getMap());
			List<Map<String, Object>> itemList = (List<Map<String, Object>>)resultData.get("p_refer");
			
			
			for (Map<String, Object> rowData : itemList) {
				List<String> row = new ArrayList<String>();

				// 데이터 네임을 이용해서 리스트에서 뽑아냄.
				for (String p_data_name : p_data_names) {
					if(p_data_name.equals("send_type")){
						if(rowData.get(p_data_name).equals("O")){
							row.add("OWNER");
						}else if(rowData.get(p_data_name).equals("C")){
							row.add("CLASS");
						}
					}
					else{
						row.add(DisStringUtil.nullString(rowData.get(p_data_name)));
					}
				}
				colValue.add(row);
			}

			modelMap.put("excelName", "commentSendExcelExport");
			modelMap.put("colName", colName);
			modelMap.put("colValue", colValue);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return new GenericExcelView();
	}
	
	
	/**
	 * @메소드명 : commentSendAdminList
	 * @날짜 : 2017. 06. 19.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		COMMENT 발신승인 조회
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> commentSendAdminList(CommandMap commandMap) throws Exception {

		// 리스트를 취득한다.
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		
		Map<String, Object> resultData = commentSendDAO.commentSendAdminList(commandMap.getMap());
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
	
	/**
	 * @메소드명 : commentSendAdminApply
	 * @날짜 : 2017. 06. 19.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		COMMENT ADMIN 발신문서 승인/반려
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> commentSendAdminApply(CommandMap commandMap) throws Exception {
		
		String sErrMsg = "";
		String sErrCode = "";

		commandMap.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		String[] send_id_array = commandMap.get("send_id_array").toString().split(",");
		
		// 메일전송_1. HEAD INSERT
		commentSendDAO.commentSendApplyHeadInsert(commandMap.getMap());
		
		try {
			for (String vSendId : send_id_array) {
				Map<String, Object> pkgParam = new HashMap<String, Object>();
				
				// 필요한 값 셋팅
				pkgParam.put("p_mail_id", commandMap.get("p_mail_id"));
				pkgParam.put("p_confirm_user_id", commandMap.get("p_confirm_user_id"));
				pkgParam.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				pkgParam.put("p_send_id", vSendId);
				pkgParam.put("p_mail_type", commandMap.get("p_mail_type"));

				// 메일전송_2. LIST INSERT, 승인일경우 공정 업데이트
				commentSendDAO.commentSendApplyListInsert(pkgParam);
			}
			
			// 메일전송_3. 상태업데이트 및 최종 메일전송
			commentSendDAO.commentSendApplyMail(commandMap.getMap());

			// 프로시저 결과 받음
			sErrMsg = DisStringUtil.nullString(commandMap.get("p_error_msg"));
			sErrCode = DisStringUtil.nullString(commandMap.get("p_error_code"));
			
			if (!"".equals(sErrMsg)) {
				System.out.println("sErrCode >>> " + sErrCode);
				throw new DisException(sErrMsg);
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
	 * @메소드명	: commentRequestDeptSelectBoxDataList
	 * @날짜		: 2017. 6. 14.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 *	commentRequest 발신파트 SelectBoxDataList
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public String commentRequestDeptSelectBoxDataList(CommandMap commandMap) throws Exception {

		// p_query를 이용하여 셀렉트 박스 내용 받음.
		List<Map<String, Object>> list = commentSendDAO.commentRequestDeptSelectBoxDataList(commandMap.getMap());

		String rtnString = "<option value=\"ALL\">ALL</option>";

		for (Map<String, Object> rowData : list) {
			rtnString += "<option value=\"" + DisStringUtil.nullString(rowData.get("value")) + "\""
					+ DisStringUtil.nullString(rowData.get("selected")) 
					+ " name=\"" + DisStringUtil.nullString(rowData.get("ATTR")) + "\">" 
					+ rowData.get("text") + "</option>";
		}

		return URLEncoder.encode(rtnString, "UTF-8");
	}
}
