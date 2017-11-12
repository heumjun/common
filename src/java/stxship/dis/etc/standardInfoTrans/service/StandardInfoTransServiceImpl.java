package stxship.dis.etc.standardInfoTrans.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.View;

import com.stx.common.interfaces.DBConnect;
import com.stx.common.library.ListSet;

import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.FileDownLoad;
import stxship.dis.etc.standardInfoTrans.dao.StandardInfoTransDAO;

/**
 * @파일명 : StandardInfoTransServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 *     <pre>
 * StandardInfoTrans에서 사용되는 서비스
 *     </pre>
 */
@Service("standardInfoTransService")
public class StandardInfoTransServiceImpl extends CommonServiceImpl implements StandardInfoTransService {

	@Resource(name = "standardInfoTransDAO")
	private StandardInfoTransDAO standardInfoTransDAO;

	/**
	 * @메소드명 : getGridData
	 * @날짜 : 2016. 4. 14.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 기준 정보 등록요청 리스트를 취득(PLM세션에서 리스트를 구하기 위해 재정의)
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	@Override
	public List<Map<String, Object>> getGridData(Map<String, Object> map) {
		String mapperSql = map.get(DisConstants.MAPPER_NAME) + DisConstants.MAPPER_SEPARATION
				+ DisConstants.MAPPER_GET_LIST;
		return standardInfoTransDAO.selectList(mapperSql, map);
	}

	/**
	 * @메소드명 : getGridListSize
	 * @날짜 : 2016. 4. 14.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 기준 정보 등록요청 리스트 카운트를 취득(PLM세션에서 리스트를 구하기 위해 재정의)
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	@Override
	public Object getGridListSize(Map<String, Object> map) {
		String mapperSql = map.get(DisConstants.MAPPER_NAME) + DisConstants.MAPPER_SEPARATION
				+ DisConstants.MEPPER_GET_TOTAL_RECORD;
		return standardInfoTransDAO.selectOne(mapperSql, map);
	}

	/**
	 * @메소드명 : standardInfoTransDbList
	 * @날짜 : 2016. 4. 14.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 *　기준정보 데이터 리스트를 취득(PLM 세션)
	 * p_process를 맵퍼정보로 활용(리스트 정보)
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> standardInfoTransDbList(CommandMap commandMap) throws Exception {
		return standardInfoTransDAO.selectList("standardInfoTransDbList." + commandMap.get("p_process"),
				commandMap.getMap());
	}

	/**
	 * @메소드명 : standardInfoTransDbData
	 * @날짜 : 2016. 4. 14.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 기준정보 데이터 를 취득(PLM 세션)
	 * p_process를 맵퍼정보로 활용(리스트정보가 이닐때)
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> standardInfoTransDbData(CommandMap commandMap) throws Exception {
		return standardInfoTransDAO.selectOne("standardInfoTransDbData." + commandMap.get("p_process"),
				commandMap.getMap());
	}

	/**
	 * @메소드명 : itemreceive
	 * @날짜 : 2016. 4. 14.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 접수(글쓰기->접수, 임시저장->접수)
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> itemreceive(CommandMap commandMap) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();

		String list_id = "";
		// 접수 list 가져오기
		List<Map<String, Object>> chmResultList = DisJsonUtil.toList(commandMap.get("chmResultList"));
		List<Map<String, Object>> refUserResultList = DisJsonUtil.toList(commandMap.get("refUserResultList"));
		list_id = commandMap.get("list_id") == null ? "" : commandMap.get("list_id").toString();
		String list_type = commandMap.get("list_type") == null ? "" : commandMap.get("list_type").toString();
		// 처음 입력시 list_id 값을 받아서 stx_tbc_info_list
		if (list_id.equals("")) {
			// list_id 얻어오기
			list_id = standardInfoTransDAO.selectOne("standardInfoTransDbData.getListId", commandMap.getMap());
			commandMap.put("list_id", list_id);
		}
		// stx_tbc_info_list insert
		insertInfoList(commandMap);
		// catalog 등록시
		if (list_type.equals("01")) {
			// stx_tbc_info_list_catalog insert
			for (int i = 0; i < chmResultList.size(); i++) {
				Map<String, Object> rowData = chmResultList.get(i);
				rowData.put("list_id", list_id);
				String rowid = rowData.get("id") == null ? "" : rowData.get("id").toString();
				if (rowid.equals("")) {
					standardInfoTransDAO.insert("saveStandardInfoTrans.insertInfoListCatalog", rowData);
				} else {
					standardInfoTransDAO.update("saveStandardInfoTrans.updateInfoCatalog", rowData);
				}
			}
		}
		// item 등록 시
		else if (list_type.equals("02")) {
			// stx_tbc_info_list_catalog insert
			for (int i = 0; i < chmResultList.size(); i++) {
				Map<String, Object> rowData = chmResultList.get(i);
				rowData.put("list_id", list_id);
				String rowid = rowData.get("id") == null ? "" : rowData.get("id").toString();
				if (rowid.equals("")) {
					standardInfoTransDAO.insert("saveStandardInfoTrans.insertInfoListItem", rowData);
				} else {
					standardInfoTransDAO.insert("saveStandardInfoTrans.updateInfoItem", rowData);
				}
			}
		}

		// stx_tbc_info_list_approval insert 설계 조달 영업별로 row 하나씩 insert (최대
		// 5개 부서)
		String grantor_dept0 = commandMap.get("grantor_dept0") == null ? ""
				: commandMap.get("grantor_dept0").toString();
		String grantor_dept1 = commandMap.get("grantor_dept1") == null ? ""
				: commandMap.get("grantor_dept1").toString();
		String grantor_dept2 = commandMap.get("grantor_dept2") == null ? ""
				: commandMap.get("grantor_dept2").toString();
		String grantor_dept3 = commandMap.get("grantor_dept3") == null ? ""
				: commandMap.get("grantor_dept3").toString();
		String grantor_dept4 = commandMap.get("grantor_dept4") == null ? ""
				: commandMap.get("grantor_dept4").toString();
		commandMap.put("confirm_type", "01");
		commandMap.put("confirm_flag", "N");
		if (!grantor_dept0.equals("")) {
			commandMap.put("aprove_type", grantor_dept0);
			commandMap.put("aprove_emp_no", commandMap.get("grantor_emp0"));
			commandMap.put("aprove_comment", commandMap.get("grantor_comment0"));
			insertListApproval(commandMap);
		}
		if (!grantor_dept1.equals("")) {
			commandMap.put("aprove_type", grantor_dept1);
			commandMap.put("aprove_emp_no", commandMap.get("grantor_emp1"));
			commandMap.put("aprove_comment", commandMap.get("grantor_comment1"));
			insertListApproval(commandMap);
		}

		if (!grantor_dept2.equals("")) {
			commandMap.put("aprove_type", grantor_dept2);
			commandMap.put("aprove_emp_no", commandMap.get("grantor_emp2"));
			commandMap.put("aprove_comment", commandMap.get("grantor_comment2"));
			insertListApproval(commandMap);
		}

		if (!grantor_dept3.equals("")) {
			commandMap.put("aprove_type", grantor_dept3);
			commandMap.put("aprove_emp_no", commandMap.get("grantor_emp3"));
			commandMap.put("aprove_comment", commandMap.get("grantor_comment3"));
			insertListApproval(commandMap);
		}
		if (!grantor_dept4.equals("")) {
			commandMap.put("aprove_type", grantor_dept4);
			commandMap.put("aprove_emp_no", commandMap.get("grantor_emp4"));
			commandMap.put("aprove_comment", commandMap.get("grantor_comment4"));
			insertListApproval(commandMap);
		}
		// 관련자 insert
		for (int i = 0; i < refUserResultList.size(); i++) {
			Map<String, Object> rowData = refUserResultList.get(i);
			rowData.put("list_id", list_id);
			rowData.put("user_id", commandMap.get("user_id"));
			insertRefUser(rowData);
		}

		Map<String, Object> listDetail = selectDetail(commandMap);
		resultMap.put(DisConstants.RESULT_MASAGE_KEY, "접수 완료");
		resultMap.put(DisConstants.RESULT_KEY, DisConstants.RESULT_SUCCESS);
		resultMap.put("list_id", list_id);
		resultMap.put("list_type", listDetail.get("list_type"));
		resultMap.put("list_type_desc", listDetail.get("list_type_desc"));
		resultMap.put("list_status", listDetail.get("list_status"));
		resultMap.put("list_status_desc", listDetail.get("list_status_desc"));
		resultMap.put("request_date", listDetail.get("request_date"));
		// 메일보내기
		stxDisItemMailing(list_id, "approve");
		return resultMap;
	}

	/**
	 * @메소드명 : selectListApproval
	 * @날짜 : 2016. 4. 14.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * list_approval 상태 가져오기
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectListApproval(CommandMap commandMap) throws Exception {
		return standardInfoTransDAO.selectOne("standardInfoTransDbData.selectListApproval", commandMap.getMap());
	}

	/**
	 * @메소드명 : selectDetail
	 * @날짜 : 2016. 4. 14.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 기준정보 상세정보 가지오기
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectDetail(CommandMap commandMap) throws Exception {
		return standardInfoTransDAO.selectOne("standardInfoTransDbData.selectDetail", commandMap.getMap());
	}

	/**
	 * @메소드명 : updateInfoListPromote
	 * @날짜 : 2016. 4. 14.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 기준정보 상태 변경
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public int updateInfoListPromote(CommandMap commandMap) throws Exception {
		int result = standardInfoTransDAO.update("saveStandardInfoTrans.updateInfoListPromote", commandMap.getMap());
		return result;
	}

	/**
	 * @메소드명 : stxDisItemMailing
	 * @날짜 : 2016. 4. 14.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 *  메일 프로시저 호출
	 *     </pre>
	 * 
	 * @param conn
	 * @param list_id
	 * @param gubun
	 * @return
	 * @throws Exception
	 */
	public void stxDisItemMailing(String list_id, String gubun) throws Exception {

		Map<String, String> param = new HashMap<String, String>();
		param.put("p_list_id", list_id);
		if (gubun.equals("approve")) {
			standardInfoTransDAO.selectOne("saveStandardInfoTrans.stxDisItemMailing", param);
		} else {
			standardInfoTransDAO.selectOne("saveStandardInfoTrans.stxDisItemMailingRe", param);
		}
		if (param.get("p_error_code") != null) {
			new DisException("메일전송실패 : " + param.get("p_error_msg") + "");
		}
	}

	/**
	 * @메소드명 : deleteListApproval
	 * @날짜 : 2016. 4. 14.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * stx_tbc_info_list_approval에 FEEDBACK 데이터는 지우고 접수 데이터는
	   CONFIRM_FLAG 와 CONFIRM_DATE 를 초기화 한다
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public int deleteListApproval(CommandMap commandMap) throws Exception {
		int result = standardInfoTransDAO.delete("saveStandardInfoTrans.deleteListApproval", commandMap.getMap());
		result = standardInfoTransDAO.update("saveStandardInfoTrans.updateListApproval", commandMap.getMap());
		return result;
	}
	/*
	 * public Map<String, Object> selectChkApproval(CommandMap commandMap)
	 * throws Exception { return standardInfoTransDAO.selectOne(
	 * "standardInfoTransDbData.selectChkApproval",commandMap.getMap()); }
	 */

	/**
	 * @메소드명 : adminDelete
	 * @날짜 : 2016. 4. 14.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 관리자가 list_id를 기준으로 전부 삭제한다
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> adminDelete(CommandMap commandMap) throws Exception {
		String list_type = commandMap.get("list_type") == null ? "" : commandMap.get("list_type").toString();

		// list_id를 기준으로 전부 삭제한다
		// stx_tbc_info_list where list_id
		standardInfoTransDAO.delete("saveStandardInfoTrans.deleteStxTbcInfoList", commandMap.getMap());
		if (list_type.equals("01")) {
			// stx_tbc_info_list_catalog where list_id
			standardInfoTransDAO.delete("saveStandardInfoTrans.deleteStxTbcInfoListCatalog", commandMap.getMap());
		} else if (list_type.equals("02")) {
			// stx_tbc_info_list_item where list_id
			standardInfoTransDAO.delete("saveStandardInfoTrans.deleteStxTbcInfoListItem", commandMap.getMap());
		}
		// 첨부 문서 삭제
		standardInfoTransDAO.delete("saveStandardInfoTrans.deleteStxTbcInfoDocAll", commandMap.getMap());
		// 관련자 삭제
		standardInfoTransDAO.delete("saveStandardInfoTrans.deleteStxTbcInfoListRefUser", commandMap.getMap());

		// STX_TBC_INFO_LIST_APPROVAL_HIS insert confirm_type = 04
		standardInfoTransDAO.insert("saveStandardInfoTrans.insertStxTbcInfoListApprovalHis", commandMap.getMap());

		return DisMessageUtil.getResultObjMessage(DisConstants.RESULT_SUCCESS);
	}

	/**
	 * @메소드명 : deleteDocument
	 * @날짜 : 2016. 4. 14.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 첨부파일 삭제 버튼 클릭 시
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> deleteDocument(CommandMap commandMap) throws Exception {

		List<Map<String, Object>> chmResultList = DisJsonUtil.toList(commandMap.get("chmResultList"));
		for (int i = 0; i < chmResultList.size(); i++) {
			Map<String, Object> rowData = chmResultList.get(i);
			rowData.put("list_id", commandMap.get("list_id"));
			standardInfoTransDAO.delete("saveStandardInfoTrans.deleteStxTbcInfoDoc", rowData);

		}
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put(DisConstants.RESULT_MASAGE_KEY, "첨부파일 삭제 성공");
		resultMap.put(DisConstants.RESULT_KEY, DisConstants.RESULT_SUCCESS);

		return resultMap;
	}

	/**
	 * @메소드명 : deleteDoc
	 * @날짜 : 2016. 4. 14.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 취소 버튼 눌렀을 때
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> deleteDoc(CommandMap commandMap) throws Exception {

		// list_id의 상태값 가져오기
		Map<String, Object> infoList = new HashMap<String, Object>();
		infoList = standardInfoTransDAO.selectOne("standardInfoTransDbData.selectInfoList", commandMap.getMap());
		// list_status가 없다면 저장한 상태가 아니기 때문에 첨부한 문서를 다 지운다.
		Map<String, Object> resultMap = new HashMap<String, Object>();
		if (infoList == null) {
			standardInfoTransDAO.delete("saveStandardInfoTrans.deleteStxTbcInfoDocAll", commandMap.getMap());

			resultMap.put(DisConstants.RESULT_MASAGE_KEY, "첨부파일 삭제성공");
			resultMap.put(DisConstants.RESULT_KEY, DisConstants.RESULT_SUCCESS);
		}
		// list_status 가 있다면 저장한 상태이므로 목록으로 돌아간다.
		else {
			resultMap.put(DisConstants.RESULT_MASAGE_KEY, "목록으로 돌아가기");
			resultMap.put(DisConstants.RESULT_KEY, DisConstants.RESULT_SUCCESS);
		}

		return resultMap;
	}

	/**
	 * @메소드명 : updateRetract
	 * @날짜 : 2016. 4. 14.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 *     철회
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> updateRetract(CommandMap commandMap) throws Exception {

		// list_id의 상태값 가져오기
		Map<String, Object> infoList = standardInfoTransDAO.selectOne("standardInfoTransDbData.selectInfoList",
				commandMap.getMap());
		String list_status = infoList.get("list_status") == null ? "" : infoList.get("list_status").toString();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		if (list_status.equals("03")) {
			resultMap.put(DisConstants.RESULT_MASAGE_KEY, "검토중 문서는 회수할 수 없습니다");
			resultMap.put(DisConstants.RESULT_KEY, DisConstants.RESULT_FAIL);
		} else {
			// 임시저장 상태로 update 쳐준다.
			commandMap.put("list_status", "01");
			updateInfoListPromote(commandMap);

			resultMap.put(DisConstants.RESULT_MASAGE_KEY, "철회 완료");
			resultMap.put(DisConstants.RESULT_KEY, DisConstants.RESULT_SUCCESS);
		}
		return resultMap;
	}

	/**
	 * @메소드명 : updateReturn
	 * @날짜 : 2016. 4. 14.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 *     반려
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> updateReturn(CommandMap commandMap) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();

		String list_id = commandMap.get("list_id") == null ? "" : commandMap.get("list_id").toString();
		String grantor_emp0 = commandMap.get("grantor_emp0") == null ? "" : commandMap.get("grantor_emp0").toString();
		String grantor_emp1 = commandMap.get("grantor_emp1") == null ? "" : commandMap.get("grantor_emp1").toString();
		String grantor_emp2 = commandMap.get("grantor_emp2") == null ? "" : commandMap.get("grantor_emp2").toString();
		String grantor_emp3 = commandMap.get("grantor_emp3") == null ? "" : commandMap.get("grantor_emp3").toString();
		String grantor_emp4 = commandMap.get("grantor_emp4") == null ? "" : commandMap.get("grantor_emp4").toString();
		String user_id = commandMap.get("user_id") == null ? "" : commandMap.get("user_id").toString();

		// list_id의 상태값 가져오기
		Map<String, Object> infoList = standardInfoTransDAO.selectOne("standardInfoTransDbData.selectInfoList",
				commandMap.getMap());
		String list_status = infoList.get("list_status") == null ? "" : infoList.get("list_status").toString();
		if (list_status.equals("05")) {
			resultMap.put(DisConstants.RESULT_MASAGE_KEY, "검토 완료된 문서는 반려할 수 없습니다");
			resultMap.put(DisConstants.RESULT_KEY, DisConstants.RESULT_FAIL);
		} else if (list_status.equals("06")) {
			resultMap.put(DisConstants.RESULT_MASAGE_KEY, "완료된 문서는 반려할 수 없습니다");
			resultMap.put(DisConstants.RESULT_KEY, DisConstants.RESULT_FAIL);
		} else {
			// 반려 시 stx_tbc_info_list_approval confirm_type =
			// '03'(반려),confirm_flag = 'Y' last_updated_date,last_updated_by
			// where list_id,confirm_emp_no = user_id
			commandMap.put("confirm_type", "03");// 반려상태
			if (grantor_emp0.equals(user_id)) {
				String grantor_comment0 = commandMap.get("grantor_comment0") == null ? ""
						: commandMap.get("grantor_comment0").toString();
				commandMap.put("aprove_comment", grantor_comment0);
				updateListApproval(commandMap);
			} else if (grantor_emp1.equals(user_id)) {
				String grantor_comment1 = commandMap.get("grantor_comment1") == null ? ""
						: commandMap.get("grantor_comment1").toString();
				commandMap.put("aprove_comment", grantor_comment1);
				updateListApproval(commandMap);
			} else if (grantor_emp2.equals(user_id)) {
				String grantor_comment2 = commandMap.get("grantor_comment2") == null ? ""
						: commandMap.get("grantor_comment2").toString();
				commandMap.put("aprove_comment", grantor_comment2);
				updateListApproval(commandMap);
			} else if (grantor_emp3.equals(user_id)) {
				String grantor_comment3 = commandMap.get("grantor_comment3") == null ? ""
						: commandMap.get("grantor_comment3").toString();
				commandMap.put("aprove_comment", grantor_comment3);
				updateListApproval(commandMap);
			} else if (grantor_emp4.equals(user_id)) {
				String grantor_comment4 = commandMap.get("grantor_comment4") == null ? ""
						: commandMap.get("grantor_comment4").toString();
				commandMap.put("aprove_comment", grantor_comment4);
				updateListApproval(commandMap);
			}

			// 반려 history에 insert한다 (STX_TBC_INFO_LIST_APPROVAL_HIS)
			// 반려할때 승인 테이블에서 반려history에 inset해준다
			standardInfoTransDAO.insert("saveStandardInfoTrans.insertSelectLIST_APPROVAL_HIS", commandMap.getMap());

			// stx_tbc_info_list_approval에 FEEDBACK 데이터는 지우고 접수 데이터는
			// CONFIRM_FLAG 와 CONFIRM_DATE 를 초기화 한다
			deleteListApproval(commandMap);

			// 임시저장 상태로 update 쳐준다.
			commandMap.put("list_status", "01");
			updateInfoListPromote(commandMap);

			resultMap.put(DisConstants.RESULT_MASAGE_KEY, "반려 완료");
			resultMap.put(DisConstants.RESULT_KEY, DisConstants.RESULT_SUCCESS);
			// 메일보내기

			stxDisItemMailing(list_id, "return");

		}

		return resultMap;
	}

	// 승인시
	public Map<String, Object> updateInfoList(CommandMap commandMap) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> temp = new HashMap<String, Object>();
		Connection connPLM = null;
		connPLM = DBConnect.getDBConnection("DIS");
		connPLM.setAutoCommit(false);
		PreparedStatement pstmt = null;
		String list_id = "";
		try {
			list_id = commandMap.get("list_id") == null ? "" : commandMap.get("list_id").toString();
			String list_status = commandMap.get("list_status") == null ? "" : commandMap.get("list_status").toString();
			String grantor_emp0 = commandMap.get("grantor_emp0") == null ? ""
					: commandMap.get("grantor_emp0").toString();
			String grantor_emp1 = commandMap.get("grantor_emp1") == null ? ""
					: commandMap.get("grantor_emp1").toString();
			String grantor_emp2 = commandMap.get("grantor_emp2") == null ? ""
					: commandMap.get("grantor_emp2").toString();
			String grantor_emp3 = commandMap.get("grantor_emp3") == null ? ""
					: commandMap.get("grantor_emp3").toString();
			String grantor_emp4 = commandMap.get("grantor_emp4") == null ? ""
					: commandMap.get("grantor_emp4").toString();
			String user_id = commandMap.get("user_id") == null ? "" : commandMap.get("user_id").toString();
			String aprove_comment = commandMap.get("aprove_comment") == null ? ""
					: commandMap.get("aprove_comment").toString();
			String admin_chk = commandMap.get("admin_chk") == null ? "" : commandMap.get("admin_chk").toString();
			String list_type = commandMap.get("list_type") == null ? "" : commandMap.get("list_type").toString();
			List<Map<String, Object>> chmResultList = DisJsonUtil.toList(commandMap.get("chmResultList"));
			List<Map<String, Object>> refUserResultList = DisJsonUtil.toList(commandMap.get("refUserResultList"));

			commandMap.put("confirm_type", "02");
			commandMap.put("confirm_flag", "Y");
			commandMap.put("list_status", list_status);
			// ADMIN 유저가 승인 했을 경우 STX_TBC_INFO_LIST_APPROVAL UPDATE
			if (admin_chk.equals("Y")) {
				StringBuffer adminUpdate = new StringBuffer();
				adminUpdate.append("UPDATE  STX_DIS_INFO_LIST_APPROVAL		\n");
				adminUpdate.append("  SET  									\n");
				adminUpdate.append("	   CONFIRM_FLAG		= 'Y'			\n");
				adminUpdate.append("	  ,LAST_UPDATE_DATE = SYSDATE		\n");
				adminUpdate.append("	  ,LAST_UPDATED_BY  = '" + user_id + "'	\n");
				adminUpdate.append("	  ,CONFIRM_COMMENT  = '" + aprove_comment + "'	\n");
				adminUpdate.append("WHERE  LIST_ID = " + list_id + "			\n");
				adminUpdate.append("  AND  process_type = '02'				\n");
				pstmt = connPLM.prepareStatement(adminUpdate.toString());
				pstmt.executeUpdate();
			} else {

				// 승인 시 approval confirm_flag Y로 업데이트
				if (grantor_emp0.equals(user_id)) {
					commandMap.put("aprove_type", commandMap.get("grantor_dept0"));
					commandMap.put("aprove_emp_no", commandMap.get("grantor_emp0"));
					commandMap.put("aprove_comment", commandMap.get("grantor_comment0"));
					insertListApproval(commandMap);
				} else if (grantor_emp1.equals(user_id)) {
					commandMap.put("aprove_type", commandMap.get("grantor_dept1"));
					commandMap.put("aprove_emp_no", commandMap.get("grantor_emp1"));
					commandMap.put("aprove_comment", commandMap.get("grantor_comment1"));
					insertListApproval(commandMap);
				} else if (grantor_emp2.equals(user_id)) {
					commandMap.put("aprove_type", commandMap.get("grantor_dept2"));
					commandMap.put("aprove_emp_no", commandMap.get("grantor_emp2"));
					commandMap.put("aprove_comment", commandMap.get("grantor_comment2"));
					insertListApproval(commandMap);
				} else if (grantor_emp3.equals(user_id)) {
					commandMap.put("aprove_type", commandMap.get("grantor_dept3"));
					commandMap.put("aprove_emp_no", commandMap.get("grantor_emp3"));
					commandMap.put("aprove_comment", commandMap.get("grantor_comment3"));
					insertListApproval(commandMap);
				} else if (grantor_emp4.equals(user_id)) {
					commandMap.put("aprove_type", commandMap.get("grantor_dept4"));
					commandMap.put("aprove_emp_no", commandMap.get("grantor_emp4"));
					commandMap.put("aprove_comment", commandMap.get("grantor_comment4"));
					insertListApproval(commandMap);
				}
			}

			// ADMIN 일 경우 STX_TBC_INFO_LIST_HIS에 기존에 있던 정보를 INSERT 해준다
			if (admin_chk.equals("Y")) {
				insertInfoListHis(commandMap);
				// ADMIN일 경우 CATALOG,ITEM,관련자 UPDATE쳐준다
				for (int i = 0; i < chmResultList.size(); i++) {
					Map<String, Object> rowData = chmResultList.get(i);
					rowData.put("list_id", list_id);
					String rowid = rowData.get("id") == null ? "" : rowData.get("id").toString();
					if (!rowid.equals("")) {
						// CATALOG 신규 등록일 경우
						if (list_type.equals("01")) {
							standardInfoTransDAO.update("saveStandardInfoTrans.updateInfoCatalog", rowData);
						} else if (list_status.equals("02")) {
							standardInfoTransDAO.insert("saveStandardInfoTrans.updateInfoItem", rowData);
						}
					}
				} // end of for
					// 관련자 UPDATE
				for (int i = 0; i < refUserResultList.size(); i++) {
					Map<String, Object> rowData = refUserResultList.get(i);
					rowData.put("list_id", list_id);
					rowData.put("user_id", commandMap.get("user_id"));
					insertRefUser(rowData);
				}
			} // end of if(admin)
			else {
				if (list_status.equals("02") || list_status.equals("03")) {
					// CATALOG,ITEM,관련자 UPDATE쳐준다 (검토자가 수정할수 있음)
					for (int i = 0; i < chmResultList.size(); i++) {
						Map<String, Object> rowData = chmResultList.get(i);
						rowData.put("list_id", list_id);
						String rowid = rowData.get("id") == null ? "" : rowData.get("id").toString();
						if (!rowid.equals("")) {
							// CATALOG 신규 등록일 경우
							if (list_type.equals("01")) {
								standardInfoTransDAO.update("saveStandardInfoTrans.updateInfoCatalog", rowData);
							} else if (list_status.equals("02")) {
								standardInfoTransDAO.insert("saveStandardInfoTrans.updateInfoItem", rowData);
							}
						}

					} // end of for
				}
			}

			// 승인 시 list_approval 상태 가져오기
			temp = selectListApproval(commandMap);

			String attribute_01 = "";
			String confirm_flag_cnt = "";
			if (temp != null) {
				attribute_01 = temp.get("attribute_01").toString();
				// list_status = temp.get("list_status").toString();
				confirm_flag_cnt = temp.get("cnt").toString();
				// 상태가 접수중일 경우
				if (list_status.equals("02")) {
					// 승인안한 사람이 있을 경우
					if (!confirm_flag_cnt.equals("0")) {
						// 상태를 검토중으로 넘겨준다
						commandMap.put("list_status", "03");
						updateInfoListPromote(commandMap);

						resultMap.put(DisConstants.RESULT_MASAGE_KEY, "승인 완료");
						resultMap.put(DisConstants.RESULT_KEY, DisConstants.RESULT_SUCCESS);
						connPLM.commit();
					}
					// N FLAG가 없을경우는 모두다 승인한 경우기 때문에 LIST_TYPE의 ATTR1의 값에 따라서 상태
					// 이동 ex(CATALOG는 04번 , ITEM은 05번 , 기준정보는 05번)
					else {

						commandMap.put("list_status", attribute_01);
						updateInfoListPromote(commandMap);
						// 다음단계가 feedback인 경우 feedback으로 설정된 인원 insert
						if (attribute_01.equals("04")) {

							insertlistApprovalFeedback(connPLM, commandMap);
						}

						resultMap.put(DisConstants.RESULT_MASAGE_KEY, "승인 완료");
						resultMap.put(DisConstants.RESULT_KEY, DisConstants.RESULT_SUCCESS);
						connPLM.commit();

						// 피드백 상태로 넘어갔을때 메일보내기
						if (list_type.equals("01")) {
							stxDisItemMailing(list_id, "approve");
						}
					}

				}
				// 상태가 검토중일 경우
				else if (list_status.equals("03")) {
					// 모두가 승인 했을 경우
					if (confirm_flag_cnt.equals("0")) {
						commandMap.put("list_status", attribute_01);
						updateInfoListPromote(commandMap);
						// 다음단계가 feedback인 경우 feedback으로 설정된 인원 insert
						if (attribute_01.equals("04")) {
							insertlistApprovalFeedback(connPLM, commandMap);
						}
						resultMap.put(DisConstants.RESULT_MASAGE_KEY, "승인 완료");
						resultMap.put(DisConstants.RESULT_KEY, DisConstants.RESULT_SUCCESS);
						connPLM.commit();

						if (list_type.equals("01")) {
							// 피드백 상태로 넘어갔을때 메일보내기
							stxDisItemMailing(list_id, "approve");
						}
					} else {
						resultMap.put(DisConstants.RESULT_MASAGE_KEY, "타 승인자 대기중");
						resultMap.put(DisConstants.RESULT_KEY, DisConstants.RESULT_SUCCESS);
					}

				}
				// 상태가 feedback일 경우
				else if (list_status.equals("04")) {
					commandMap.put("aprove_type", "04"); // 자동승인
					commandMap.put("aprove_emp_no", user_id);
					commandMap.put("aprove_comment", "FEEDBACK 강제 승인");
					commandMap.put("list_status", "05");
					insertListApproval(commandMap);
					updateInfoListPromote(commandMap);

					resultMap.put(DisConstants.RESULT_MASAGE_KEY, "승인 완료");
					resultMap.put(DisConstants.RESULT_KEY, DisConstants.RESULT_SUCCESS);
					connPLM.commit();
				}
				// 상태가 검토완료일 경우
				else if (list_status.equals("05")) {
					commandMap.put("list_status", "06");
					updateInfoListPromote(commandMap);

					resultMap.put(DisConstants.RESULT_MASAGE_KEY, "승인 완료");
					resultMap.put(DisConstants.RESULT_KEY, DisConstants.RESULT_SUCCESS);
					connPLM.commit();

					// 등록완료시 메일보내기
					stxDisItemMailing(list_id, "approve");
				}

			}
			// 게시물이 없습니다.
			else {
				resultMap.put(DisConstants.RESULT_MASAGE_KEY, "게시물이 삭제되었습니다.");
				resultMap.put(DisConstants.RESULT_KEY, DisConstants.RESULT_FAIL);
				connPLM.rollback();
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			resultMap.put(DisConstants.RESULT_MASAGE_KEY, "시스템 내부 오류");
			resultMap.put(DisConstants.RESULT_KEY, DisConstants.RESULT_FAIL);
			connPLM.rollback();
		}

		return resultMap;
	}

	/**
	 * @메소드명 : insertRefUser
	 * @날짜 : 2016. 4. 14.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 접수 관련자 insertRefUser 프로시져 호출
	 *     </pre>
	 * 
	 * @param rowData
	 * @throws Exception
	 */
	public void insertRefUser(Map<String, Object> rowData) throws Exception {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("p_list_id", rowData.get("list_id"));
		param.put("p_print_user_id", rowData.get("print_user_id"));
		param.put("p_user_id", rowData.get("user_id"));
		standardInfoTransDAO.selectOne("saveStandardInfoTrans.insertRefUser", param);
		if (param.get("p_error_code") != null) {
			new DisException("관련자 등록 프로시져 실패 : " + param.get("p_error_msg") + "");
		}
	}

	/**
	 * @메소드명 : insertListApproval
	 * @날짜 : 2016. 4. 14.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * stx_tbc_info_list_approval insert 설계 조달 영업별로 row 하나씩 insert
	 *     </pre>
	 * 
	 * @param commandMap
	 * @throws Exception
	 */
	public void insertListApproval(CommandMap commandMap) throws Exception {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("p_list_id", commandMap.get("list_id"));
		param.put("p_list_status", commandMap.get("list_status"));
		param.put("p_confirm_type", commandMap.get("confirm_type"));
		param.put("p_aprove_type", commandMap.get("aprove_type"));
		param.put("p_aprove_emp_no", commandMap.get("aprove_emp_no"));
		param.put("p_aprove_comment", commandMap.get("aprove_comment"));
		param.put("p_confirm_flag", commandMap.get("confirm_flag"));
		param.put("p_user_id", commandMap.get("user_id"));
		standardInfoTransDAO.selectOne("saveStandardInfoTrans.insertListApproval", param);
		if (param.get("p_error_code") != null) {
			new DisException("Approval 등록 프로시져 실패 : " + param.get("p_error_msg") + "");
		}
	}

	// 임시저장
	public Map<String, Object> tbcTemporaryStorage(CommandMap commandMap) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Connection connPLM = null;
		connPLM = DBConnect.getDBConnection("DIS");
		connPLM.setAutoCommit(false);

		String list_id = "";
		// 임시저장할 list 가져오기
		List<Map<String, Object>> chmResultList = DisJsonUtil.toList(commandMap.get("chmResultList"));
		List<Map<String, Object>> refUserResultList = DisJsonUtil.toList(commandMap.get("refUserResultList"));
		try {
			list_id = commandMap.get("list_id") == null ? "" : commandMap.get("list_id").toString();
			String list_type = commandMap.get("list_type") == null ? "" : commandMap.get("list_type").toString();
			// 처음 입력시 list_id 값을 받아서 stx_tbc_info_list
			if (list_id.equals("")) {
				// list_id 얻어오기
				list_id = standardInfoTransDAO.selectOne("standardInfoTransDbData.getListId", commandMap.getMap());
				commandMap.put("list_id", list_id);
				// stx_tbc_info_list insert
				insertInfoList(commandMap);

			} else {
				insertInfoList(commandMap);
			}
			// catalog 등록시
			if (list_type.equals("01")) {
				// stx_tbc_info_list_catalog insert
				for (int i = 0; i < chmResultList.size(); i++) {
					Map<String, Object> rowData = chmResultList.get(i);
					rowData.put("list_id", list_id);
					String rowid = rowData.get("id") == null ? "" : rowData.get("id").toString();
					if (rowid.equals("")) {
						standardInfoTransDAO.insert("saveStandardInfoTrans.insertInfoListCatalog", rowData);
					} else {
						standardInfoTransDAO.update("saveStandardInfoTrans.updateInfoCatalog", rowData);
					}
				}
			}
			// item 등록 시
			else if (list_type.equals("02")) {
				// stx_tbc_info_list_catalog insert
				for (int i = 0; i < chmResultList.size(); i++) {
					Map<String, Object> rowData = chmResultList.get(i);
					rowData.put("list_id", list_id);
					String rowid = rowData.get("id") == null ? "" : rowData.get("id").toString();
					if (rowid.equals("")) {
						standardInfoTransDAO.insert("saveStandardInfoTrans.insertInfoListItem", rowData);
					} else {
						standardInfoTransDAO.insert("saveStandardInfoTrans.updateInfoItem", rowData);
					}
				}
			}
			// stx_tbc_info_list_approval insert 설계 조달 영업별로 row 하나씩 insert (최대
			// 5개 부서)
			String grantor_dept0 = commandMap.get("grantor_dept0") == null ? ""
					: commandMap.get("grantor_dept0").toString();
			String grantor_dept1 = commandMap.get("grantor_dept1") == null ? ""
					: commandMap.get("grantor_dept1").toString();
			String grantor_dept2 = commandMap.get("grantor_dept2") == null ? ""
					: commandMap.get("grantor_dept2").toString();
			String grantor_dept3 = commandMap.get("grantor_dept3") == null ? ""
					: commandMap.get("grantor_dept3").toString();
			String grantor_dept4 = commandMap.get("grantor_dept4") == null ? ""
					: commandMap.get("grantor_dept4").toString();

			commandMap.put("confirm_type", "01");
			commandMap.put("confirm_flag", "N");
			if (!grantor_dept0.equals("")) {
				commandMap.put("aprove_type", grantor_dept0);
				commandMap.put("aprove_emp_no", commandMap.get("grantor_emp0"));
				commandMap.put("aprove_comment", commandMap.get("grantor_comment0"));
				insertListApproval(commandMap);
			}
			if (!grantor_dept1.equals("")) {
				commandMap.put("aprove_type", grantor_dept1);
				commandMap.put("aprove_emp_no", commandMap.get("grantor_emp1"));
				commandMap.put("aprove_comment", commandMap.get("grantor_comment1"));
				insertListApproval(commandMap);
			}

			if (!grantor_dept2.equals("")) {
				commandMap.put("aprove_type", grantor_dept2);
				commandMap.put("aprove_emp_no", commandMap.get("grantor_emp2"));
				commandMap.put("aprove_comment", commandMap.get("grantor_comment2"));
				insertListApproval(commandMap);
			}

			if (!grantor_dept3.equals("")) {
				commandMap.put("aprove_type", grantor_dept3);
				commandMap.put("aprove_emp_no", commandMap.get("grantor_emp3"));
				commandMap.put("aprove_comment", commandMap.get("grantor_comment3"));
				insertListApproval(commandMap);
			}

			if (!grantor_dept4.equals("")) {
				commandMap.put("aprove_type", grantor_dept4);
				commandMap.put("aprove_emp_no", commandMap.get("grantor_emp4"));
				commandMap.put("aprove_comment", commandMap.get("grantor_comment4"));
				insertListApproval(commandMap);
			}

			// 관련자 insert
			for (int i = 0; i < refUserResultList.size(); i++) {
				Map<String, Object> rowData = refUserResultList.get(i);
				rowData.put("list_id", list_id);
				rowData.put("user_id", commandMap.get("user_id"));
				insertRefUser(rowData);
			}

			Map<String, Object> listDetail = selectDetail(commandMap);
			resultMap.put(DisConstants.RESULT_MASAGE_KEY, "임시저장 완료");
			resultMap.put(DisConstants.RESULT_KEY, DisConstants.RESULT_SUCCESS);
			resultMap.put("list_id", list_id);
			resultMap.put("list_type", listDetail.get("list_type"));
			resultMap.put("list_type_desc", listDetail.get("list_type_desc"));
			resultMap.put("list_status", listDetail.get("list_status"));
			resultMap.put("list_status_desc", listDetail.get("list_status_desc"));
			resultMap.put("request_date", listDetail.get("request_date"));
			connPLM.commit();
		} catch (Exception ex) {
			ex.printStackTrace();
			resultMap.put(DisConstants.RESULT_MASAGE_KEY, "임시저장 실패");
			resultMap.put(DisConstants.RESULT_KEY, DisConstants.RESULT_FAIL);
			connPLM.rollback();
		}

		return resultMap;
	}

	public int updateInfoItem(Connection conn, Map<String, Object> rowData) throws Exception {
		StringBuffer query = new StringBuffer();
		query.append(" UPDATE stx_dis_info_list_item \n");
		query.append("    SET PART_NO      = '" + rowData.get("part_no") + "' \n");
		query.append("      , DESCRIPTION  = '" + rowData.get("description") + "' \n");
		query.append("      , WEIGHT       = '" + rowData.get("weight") + "'  \n");
		query.append("      , UOM          = '" + rowData.get("uom") + "' \n");
		query.append("      , ATTR00       = '" + rowData.get("attr00") + "' \n");
		query.append("      , ATTR01       = '" + rowData.get("attr01") + "' \n");
		query.append("      , ATTR02       = '" + rowData.get("attr02") + "' \n");
		query.append("      , ATTR03       = '" + rowData.get("attr03") + "' \n");
		query.append("      , ATTR04       = '" + rowData.get("attr04") + "' \n");
		query.append("      , ATTR05       = '" + rowData.get("attr05") + "' \n");
		query.append("      , ATTR06       = '" + rowData.get("attr06") + "' \n");
		query.append("      , ATTR07       = '" + rowData.get("attr07") + "' \n");
		query.append("      , ATTR08       = '" + rowData.get("attr08") + "' \n");
		query.append("      , ATTR09       = '" + rowData.get("attr09") + "' \n");
		query.append("      , ATTR10       = '" + rowData.get("attr10") + "' \n");
		query.append("      , ATTR11       = '" + rowData.get("attr11") + "' \n");
		query.append("      , ATTR12       = '" + rowData.get("attr12") + "' \n");
		query.append("      , ATTR13       = '" + rowData.get("attr13") + "' \n");
		query.append("      , ATTR14       = '" + rowData.get("attr14") + "' \n");
		query.append("      , CABLE_OUTDIA = '" + rowData.get("cable_outdia") + "' \n");
		query.append("      , CABLE_SIZE   = '" + rowData.get("cable_size") + "' \n");
		query.append("      , STXSVR       = '" + rowData.get("stxsvr") + "' \n");
		query.append("      , THINNER_CODE = '" + rowData.get("thinner_code") + "' \n");
		query.append("      , PAINT_CODE   = '" + rowData.get("paint_code") + "' \n");
		query.append("      , CABLE_TYPE   = '" + rowData.get("cable_type") + "' \n");
		query.append("      , CABLE_LENGTH = '" + rowData.get("cable_length") + "' \n");
		query.append("      , STXSTANDARD  = '" + rowData.get("stxstandard") + "' \n");
		query.append("  WHERE 1            = 1  \n");
		query.append("    AND \n");
		query.append("        rowid = '" + rowData.get("id") + "' \n");

		ListSet ls = null;
		PreparedStatement pstmt = null;
		int result = 0;
		try {
			pstmt = conn.prepareStatement(query.toString());
			result = +pstmt.executeUpdate();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (ls != null) {
				try {
					ls.close();
				} catch (Exception e) {
				}
			}
			if (pstmt != null) {
				try {
					pstmt.close();
				} catch (Exception e) {
				}
			}
		}
		return result;
	}

	public int insertInfoListItem(Connection conn, Map<String, Object> rowData) throws Exception {
		StringBuffer query = new StringBuffer();
		query.append(" INSERT \n");
		query.append("   INTO stx_dis_info_list_item \n");
		query.append("        ( \n");
		query.append("                LIST_ID \n");
		query.append("              , PART_NO \n");
		query.append("              , DESCRIPTION \n");
		query.append("              , WEIGHT \n");
		query.append("              , UOM \n");
		query.append("              , ATTR00 \n");
		query.append("              , ATTR01 \n");
		query.append("              , ATTR02 \n");
		query.append("              , ATTR03 \n");
		query.append("              , ATTR04 \n");
		query.append("              , ATTR05 \n");
		query.append("              , ATTR06 \n");
		query.append("              , ATTR07 \n");
		query.append("              , ATTR08 \n");
		query.append("              , ATTR09 \n");
		query.append("              , ATTR10 \n");
		query.append("              , ATTR11 \n");
		query.append("              , ATTR12 \n");
		query.append("              , ATTR13 \n");
		query.append("              , ATTR14 \n");
		query.append("              , CABLE_OUTDIA \n");
		query.append("              , CABLE_SIZE \n");
		query.append("              , STXSVR \n");
		query.append("              , THINNER_CODE \n");
		query.append("              , PAINT_CODE \n");
		query.append("              , CABLE_TYPE \n");
		query.append("              , CABLE_LENGTH \n");
		query.append("              , STXSTANDARD \n");
		query.append("        ) \n");
		query.append("        VALUES \n");
		query.append("        ( \n");
		query.append("                 " + rowData.get("list_id") + " \n");
		query.append("              , '" + rowData.get("part_no") + "' \n");
		query.append("              , '" + rowData.get("description") + "' \n");
		query.append("              , '" + rowData.get("weight") + "' \n");
		query.append("              , '" + rowData.get("uom") + "' \n");
		query.append("              , '" + rowData.get("attr00") + "' \n");
		query.append("              , '" + rowData.get("attr01") + "' \n");
		query.append("              , '" + rowData.get("attr02") + "' \n");
		query.append("              , '" + rowData.get("attr03") + "' \n");
		query.append("              , '" + rowData.get("attr04") + "' \n");
		query.append("              , '" + rowData.get("attr05") + "' \n");
		query.append("              , '" + rowData.get("attr06") + "' \n");
		query.append("              , '" + rowData.get("attr07") + "' \n");
		query.append("              , '" + rowData.get("attr08") + "' \n");
		query.append("              , '" + rowData.get("attr09") + "' \n");
		query.append("              , '" + rowData.get("attr10") + "' \n");
		query.append("              , '" + rowData.get("attr11") + "' \n");
		query.append("              , '" + rowData.get("attr12") + "' \n");
		query.append("              , '" + rowData.get("attr13") + "' \n");
		query.append("              , '" + rowData.get("attr14") + "' \n");
		query.append("              , '" + rowData.get("cable_outdia") + "' \n");
		query.append("              , '" + rowData.get("cable_size") + "' \n");
		query.append("              , '" + rowData.get("stxsvr") + "' \n");
		query.append("              , '" + rowData.get("thinner_code") + "' \n");
		query.append("              , '" + rowData.get("paint_code") + "' \n");
		query.append("              , '" + rowData.get("cable_type") + "' \n");
		query.append("              , '" + rowData.get("cable_length") + "' \n");
		query.append("				, '" + rowData.get("stxstandard") + "'	 \n");
		query.append("        ) \n");

		ListSet ls = null;
		PreparedStatement pstmt = null;
		int result = 0;
		try {
			pstmt = conn.prepareStatement(query.toString());
			result = +pstmt.executeUpdate();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (ls != null) {
				try {
					ls.close();
				} catch (Exception e) {
				}
			}
			if (pstmt != null) {
				try {
					pstmt.close();
				} catch (Exception e) {
				}
			}
		}
		return result;
	}

	// 접수나 검토중상태에서 FEEDBACK 상태로 넘어갈때 LIST_APPROVAL 남기기
	public int insertlistApprovalFeedback(Connection conn,CommandMap commandMap) throws Exception {
		//Connection conn = null;
		//conn = DBConnect.getDBConnection("DIS");
		//conn.setAutoCommit(false);
		String list_id = commandMap.get("list_id") == null ? "" : commandMap.get("list_id").toString();
		String user_id = commandMap.get("user_id") == null ? "" : commandMap.get("user_id").toString();
		String list_type = commandMap.get("list_type") == null ? "" : commandMap.get("list_type").toString();
		StringBuffer query = new StringBuffer();
		query.append(" INSERT \n");
		query.append("   INTO STX_DIS_INFO_LIST_APPROVAL \n");
		query.append("        ( \n");
		query.append("                LIST_ID \n");
		query.append("              , PROCESS_TYPE \n");
		query.append("              , CONFIRM_TYPE \n");
		query.append("              , APROVE_TYPE \n");
		query.append("              , CONFIRM_EMP_NO \n");
		query.append("              , CONFIRM_COMMENT \n");
		query.append("              , CONFIRM_FLAG \n");
		query.append("              , CONFIRM_DATE \n");
		query.append("              , LAST_UPDATE_DATE \n");
		query.append("              , LAST_UPDATED_BY \n");
		query.append("              , CREATION_DATE \n");
		query.append("              , CREATED_BY \n");
		query.append("        ) \n");
		query.append(" SELECT '" + list_id + "' \n");
		query.append("      , '04' \n");
		query.append("      , '01' \n");
		query.append("      , '04' \n");
		query.append("      , APROVE_EMP_NO \n");
		query.append("      , 'FEEDBACK' \n");
		query.append("      , 'N' \n");
		query.append("      , '' \n");
		query.append("      , SYSDATE \n");
		query.append("      , '" + user_id + "' \n");
		query.append("      , SYSDATE \n");
		query.append("      , '" + user_id + "' \n");
		query.append("   FROM STX_DIS_INFO_APPROVAL \n");
		query.append("  WHERE APROVE_SIGN = '03' \n");
		query.append("	  AND list_type	  = '" + list_type + "'	\n");

		ListSet ls = null;
		PreparedStatement pstmt = null;
		int result = 0;
		try {
			pstmt = conn.prepareStatement(query.toString());
			result = +pstmt.executeUpdate();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (ls != null) {
				try {
					ls.close();
				} catch (Exception e) {
				}
			}
			if (pstmt != null) {
				try {
					pstmt.close();
				} catch (Exception e) {
				}
			}
		}

		return result;
	}

	// ADMIN 유저가 승인시 기존에 있던 데이터를 HISTORY 테이블에 넣어준다.
	public int insertInfoListHis(CommandMap commandMap) throws Exception {
		Connection conn = null;
		conn = DBConnect.getDBConnection("DIS");
		conn.setAutoCommit(false);
		String list_id = commandMap.get("list_id") == null ? "" : commandMap.get("list_id").toString();

		StringBuffer query = new StringBuffer();
		query.append(" INSERT \n");
		query.append("   INTO STX_DIS_INFO_LIST_HIS \n");
		query.append("        ( \n");
		query.append("				  UPDATE_DATE			\n");
		query.append("              , LIST_ID \n");
		query.append("              , LIST_TYPE \n");
		query.append("              , LIST_STATUS \n");
		query.append("              , REQUEST_DEPT_CODE \n");
		query.append("              , REQUEST_EMP_NO \n");
		query.append("              , REQUEST_TITLE \n");
		query.append("              , REQUEST_DESC \n");
		query.append("              , REQUEST_DATE \n");
		query.append("              , CONFIRM_DATE \n");
		query.append("              , FEEDBACK_DATE \n");
		query.append("              , COMPLETE_DATE \n");
		query.append("        ) \n");
		query.append(" SELECT SYSDATE \n");
		query.append("      , LIST_ID \n");
		query.append("      , LIST_TYPE \n");
		query.append("      , LIST_STATUS \n");
		query.append("      , REQUEST_DEPT_CODE \n");
		query.append("      , REQUEST_EMP_NO \n");
		query.append("      , REQUEST_TITLE \n");
		query.append("      , REQUEST_DESC \n");
		query.append("      , REQUEST_DATE \n");
		query.append("      , CONFIRM_DATE \n");
		query.append("      , FEEDBACK_DATE \n");
		query.append("      , COMPLETE_DATE \n");
		query.append("   FROM STX_DIS_INFO_LIST \n");
		query.append("  WHERE list_id = '" + list_id + "' \n");

		ListSet ls = null;
		PreparedStatement pstmt = null;
		int result = 0;
		try {
			pstmt = conn.prepareStatement(query.toString());
			result = +pstmt.executeUpdate();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (ls != null) {
				try {
					ls.close();
				} catch (Exception e) {
				}
			}
			if (pstmt != null) {
				try {
					pstmt.close();
				} catch (Exception e) {
				}
			}
		}

		return result;
	}

	public int updateListApproval(CommandMap commandMap) throws Exception {
		Connection conn = null;
		conn = DBConnect.getDBConnection("DIS");
		conn.setAutoCommit(false);
		String user_id = commandMap.get("user_id") == null ? "" : commandMap.get("user_id").toString();
		String aprove_comment = commandMap.get("aprove_comment") == null ? ""
				: commandMap.get("aprove_comment").toString();
		String confirm_type = commandMap.get("confirm_type") == null ? "" : commandMap.get("confirm_type").toString();

		StringBuffer query = new StringBuffer();
		query.append("update  stx_dis_info_list_approval \n");
		query.append("   set  confirm_type = '" + confirm_type + "' \n");
		query.append("		 ,confirm_comment = '" + aprove_comment + "'	\n");
		query.append("		 ,confirm_flag = 'Y'	\n");
		query.append("		 ,confirm_date = sysdate	\n");
		query.append("		 ,last_update_date = sysdate		\n");
		query.append("		 ,last_updated_by = '" + user_id + "'	\n");
		// query.append(" ,request_dept_code = '"+commandMap.get("dept_code")+"'
		// \n");
		// query.append(" ,request_emp_no = '"+commandMap.get("user_id")+"'
		// \n");
		// query.append(" ,request_date = sysdate \n");
		query.append(" where  list_id = '" + commandMap.get("list_id") + "' \n");
		query.append("	 and  confirm_emp_no = '" + user_id + "'	\n");

		ListSet ls = null;
		PreparedStatement pstmt = null;
		int result = 0;
		try {
			pstmt = conn.prepareStatement(query.toString());
			result = +pstmt.executeUpdate();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (ls != null) {
				try {
					ls.close();
				} catch (Exception e) {
				}
			}
			if (pstmt != null) {
				try {
					pstmt.close();
				} catch (Exception e) {
				}
			}
		}

		return result;
	}

	/**
	 * @메소드명 : insertInfoList
	 * @날짜 : 2016. 4. 14.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 *  기준 정보 등록 프로시져 호출
	 *     </pre>
	 * 
	 * @param commandMap
	 * @throws Exception
	 */
	public void insertInfoList(CommandMap commandMap) throws Exception {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("p_list_id", commandMap.get("list_id"));
		param.put("p_list_type", commandMap.get("list_type"));
		param.put("p_list_status", commandMap.get("list_status"));
		param.put("p_dept_code", commandMap.get("dept_code"));
		param.put("p_user_id", commandMap.get("user_id"));
		param.put("p_request_desc", commandMap.get("request_desc"));
		param.put("p_sub_title", commandMap.get("sub_title"));

		standardInfoTransDAO.selectOne("saveStandardInfoTrans.insertInfoList", param);
		if (param.get("p_error_code") != null) {
			new DisException("기준 정보 등록 프로시져 실패 : " + param.get("p_error_msg") + "");
		}
	}

	/**
	 * @메소드명 : itemTransFileUpload
	 * @날짜 : 2016. 4. 14.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Doc 첨부 파일 업로드
	 *     </pre>
	 * 
	 * @param response
	 * @param request
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> itemTransFileUpload(HttpServletResponse response, HttpServletRequest request,
			CommandMap commandMap) throws Exception {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
		Object file1 = multipartRequest.getFile("uploadfile");
		Object file2 = multipartRequest.getFile("uploadfile1");
		Object file3 = multipartRequest.getFile("uploadfile2");
		Object file4 = multipartRequest.getFile("uploadfile3");
		Object file5 = multipartRequest.getFile("uploadfile4");
		String fileName = ((CommonsMultipartFile) file1).getOriginalFilename();
		String fileName1 = ((CommonsMultipartFile) file2).getOriginalFilename();
		String fileName2 = ((CommonsMultipartFile) file3).getOriginalFilename();
		String fileName3 = ((CommonsMultipartFile) file4).getOriginalFilename();
		String fileName4 = ((CommonsMultipartFile) file5).getOriginalFilename();

		int sizeLimit = 5 * 1024 * 1024;

		try {

			// list_id seq 얻어오기
			String list_id = (String) commandMap.get("list_id") == null ? "" : (String) commandMap.get("list_id");
			String document_id = "";
			if (list_id.equals("")) {
				list_id = standardInfoTransDAO.selectOne("saveStandardInfoTrans.selectStxTbcInfoListSeq") + "";
				commandMap.put("list_id", list_id);
			}
			if (!fileName.equals("")) {
				document_id = standardInfoTransDAO.selectOne("saveStandardInfoTrans.selectStxTbcInfoDocSeq") + "";
				commandMap.put("document_id", document_id);
				commandMap.put("fileName", fileName);
				commandMap.put("fileByte", ((CommonsMultipartFile) file1).getBytes());
				int ilen = (int) ((MultipartFile) file1).getSize();

				if (ilen > sizeLimit) {
					StringBuffer sb = new StringBuffer();
					sb.append("<script type=\"text/javascript\" >");
					sb.append("alert('용량 제한으로 인해 실패');");
					sb.append("self.close();");
					sb.append("</script>");
					response.getWriter().println(sb);
					response.getWriter().flush();
					return null;
				} else {
					standardInfoTransDAO.insert("saveStandardInfoTrans.insertDoc", commandMap.getMap());
				}
			}
			if (!fileName1.equals("")) {
				// document_id seq 받아오기
				document_id = standardInfoTransDAO.selectOne("saveStandardInfoTrans.selectStxTbcInfoDocSeq") + "";
				commandMap.put("document_id", document_id);
				commandMap.put("fileName", fileName1);
				commandMap.put("fileByte", ((CommonsMultipartFile) file2).getBytes());
				int ilen = (int) ((MultipartFile) file2).getSize();

				if (ilen > sizeLimit) {
					StringBuffer sb = new StringBuffer();
					sb.append("<script type=\"text/javascript\" >");
					sb.append("alert('용량 제한으로 인해 실패');");
					sb.append("self.close();");
					sb.append("</script>");
					response.getWriter().println(sb);
					response.getWriter().flush();
					return null;
				} else {
					standardInfoTransDAO.insert("saveStandardInfoTrans.insertDoc", commandMap.getMap());
				}
			}
			if (!fileName2.equals("")) {
				// document_id seq 받아오기
				document_id = standardInfoTransDAO.selectOne("saveStandardInfoTrans.selectStxTbcInfoDocSeq") + "";
				commandMap.put("document_id", document_id);
				commandMap.put("fileName", fileName2);
				commandMap.put("fileByte", ((CommonsMultipartFile) file3).getBytes());
				int ilen = (int) ((MultipartFile) file3).getSize();

				if (ilen > sizeLimit) {
					StringBuffer sb = new StringBuffer();
					sb.append("<script type=\"text/javascript\" >");
					sb.append("alert('용량 제한으로 인해 실패');");
					sb.append("self.close();");
					sb.append("</script>");
					response.getWriter().println(sb);
					response.getWriter().flush();
					return null;
				} else {
					standardInfoTransDAO.insert("saveStandardInfoTrans.insertDoc", commandMap.getMap());
				}
			}
			if (!fileName3.equals("")) {
				// document_id seq 받아오기
				document_id = standardInfoTransDAO.selectOne("saveStandardInfoTrans.selectStxTbcInfoDocSeq") + "";
				commandMap.put("document_id", document_id);
				commandMap.put("fileName", fileName3);
				commandMap.put("fileByte", ((CommonsMultipartFile) file4).getBytes());
				int ilen = (int) ((MultipartFile) file4).getSize();
				if (ilen > sizeLimit) {
					StringBuffer sb = new StringBuffer();
					sb.append("<script type=\"text/javascript\" >");
					sb.append("alert('용량 제한으로 인해 실패');");
					sb.append("self.close();");
					sb.append("</script>");
					response.getWriter().println(sb);
					response.getWriter().flush();
					return null;
				} else {
					standardInfoTransDAO.insert("saveStandardInfoTrans.insertDoc", commandMap.getMap());
				}
			}
			if (!fileName4.equals("")) {
				// document_id seq 받아오기
				document_id = standardInfoTransDAO.selectOne("saveStandardInfoTrans.selectStxTbcInfoDocSeq") + "";
				commandMap.put("document_id", document_id);
				commandMap.put("fileName", fileName4);
				commandMap.put("fileByte", ((CommonsMultipartFile) file5).getBytes());
				int ilen = (int) ((MultipartFile) file5).getSize();

				if (ilen > sizeLimit) {
					StringBuffer sb = new StringBuffer();
					sb.append("<script type=\"text/javascript\" >");
					sb.append("alert('용량 제한으로 인해 실패');");
					sb.append("self.close();");
					sb.append("</script>");
					response.getWriter().println(sb);
					response.getWriter().flush();
					return null;
				} else {
					standardInfoTransDAO.insert("saveStandardInfoTrans.insertDoc", commandMap.getMap());
				}
			}

			StringBuffer sb = new StringBuffer();
			sb.append("<script type=\"text/javascript\" >");
			sb.append("opener.fn_setListId(" + list_id + ");");
			sb.append("self.close();");
			sb.append("</script>");
			response.getWriter().println(sb);
			response.getWriter().flush();

		} catch (Exception e) {
			e.printStackTrace();
			StringBuffer sb = new StringBuffer();
			sb.append("<script type=\"text/javascript\" >");
			sb.append("alert('업로드 실패');");
			sb.append("self.close();");
			sb.append("</script>");
			response.getWriter().println(sb);
			response.getWriter().flush();
			return null;
		}
		return null;
	}

	/**
	 * @메소드명 : itemTransDownload
	 * @날짜 : 2016. 4. 18.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 문서첨부 다운로드
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public View itemTransDownload(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		Map<String, Object> rs = standardInfoTransDAO.selectOne("standardInfoTransDbData.itemTransDownload",
				commandMap.getMap());
		modelMap.put("data", (byte[]) rs.get("document_data"));
		modelMap.put("contentType", "application/octet-stream;");
		modelMap.put("filename", (String) rs.get("document_name"));
		return new FileDownLoad();
	}
}
