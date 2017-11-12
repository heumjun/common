package stxship.dis.ems.admin.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.View;

import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.DisStringUtil;
import stxship.dis.common.util.FileDownLoad;
import stxship.dis.ems.admin.dao.EmsAdminDAO;
import stxship.dis.ems.common.dao.EmsCommonDAO;
import stxship.dis.ems.common.service.EmsCommonServiceImpl;

@Service("emsAdminService")
public class EmsAdminServiceImpl extends EmsCommonServiceImpl implements EmsAdminService {
	Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "emsAdminDAO")
	private EmsAdminDAO emsAdminDAO;

	@Resource(name = "emsCommonDAO")
	private EmsCommonDAO emsCommonDAO;

	/**
	 * @메소드명 : emsAdminGetDeptList
	 * @날짜 : 2016. 03. 21.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 조회조건 부서 SelectBox 리스트 불러옴
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public List<Map<String, Object>> emsAdminSelectBoxDept(CommandMap commandMap) {
		return emsAdminDAO.emsAdminSelectBoxDept(commandMap.getMap());
	}

	/**
	 * @메소드명 : emsAdminApprove
	 * @날짜 : 2016. 03. 21.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * emsAdmin 선택항목 승인
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> emsAdminApprove(CommandMap commandMap) throws Exception {

		/* 결과 메세지 */
		int result = 0;
		String resultMsg = "";
		Map<String, Object> resultMap = new HashMap<String, Object>();

		// 프로시져 에러 체크 결과 값
		String sErrMsg = "";
		String sErrCode = "";

		String purNoStr = ""; // Pur_No 문자열 변환

		// 사용자 정보를 가져옴
		Map<String, Object> userInfo = getUserInfo(commandMap.getMap()); // getUserInfo() : EmsCommonServiceImpl 로 부터 상속받아 사용

		// Pur_No 를 가져옴, String 형으로 변경
		commandMap.put("p_state", "R,DR");
		List<Map<String, Object>> purNo = getPurNo(commandMap.getMap()); // getPurNo() : EmsCommonServiceImpl 로 부터 상속받아 사용
		for (int i = 0; i < purNo.size(); i++) {
			if (i != 0)
				purNoStr += ",";
			purNoStr += purNo.get(i).get("ems_pur_no");
		}
		
		// 추가 PR 로직
		resultMsg = tranPR(commandMap);
		if( !"".equals(resultMsg) ){
			resultMap.put(DisConstants.RESULT_KEY, DisConstants.RESULT_FAIL);
			resultMap.put(DisConstants.RESULT_MASAGE_KEY, resultMsg);
			return resultMap;
		}

		// 삭제 PR 로직
		resultMsg = deletePR(commandMap);
		if( !"".equals(resultMsg) ){
			resultMap.put(DisConstants.RESULT_KEY, DisConstants.RESULT_FAIL);
			resultMap.put(DisConstants.RESULT_MASAGE_KEY, resultMsg);
			return resultMap;
		}

		// POS Revision 승인 완료 flag 변경
		result = emsAdminDAO.emsAdminUpdateRevision(commandMap.getMap());
		if (result == 0) {
			sErrMsg = "";
			sErrCode = "0";
			throw new DisException("ems.admin.message1");
		}

		// 선택 도면 배열 변환
		String dwgNoArray[] = commandMap.get("p_dwg_no").toString().replaceAll(",,", "").split(",");
		commandMap.put("dwgNoArray", dwgNoArray);

		// 메일링 작업
		// Email List를 가져옴
		List<Map<String, Object>> email_list = emsAdminDAO.emsAdminEmailList(commandMap.getMap());

		// 메일 전송
		for (int i = 0; i < email_list.size(); i++) {
			Map<String, Object> rowData = new HashMap<>();
			rowData.put("p_emspurno", purNoStr);
			rowData.put("p_master", commandMap.get("p_master"));
			rowData.put("p_dwg_no", "");
			rowData.put("p_reason", "");
			rowData.put("p_flag", "승인");
			rowData.put("p_action", "app_rej");
			rowData.put("p_from", userInfo.get("ep_mail") + "@onestx.com");
			rowData.put("p_to", email_list.get(i).get("ep_mail"));
			rowData.put("p_from_dept", userInfo.get("dept_name"));
			rowData.put("p_from_name", userInfo.get("user_name"));

			emsCommonDAO.sendEmail(rowData);

			sErrMsg = DisStringUtil.nullString(rowData.get("errbuf"));
			sErrCode = DisStringUtil.nullString(rowData.get("retcode"));

			// 오류가 있으면 스탑
			if (!"".equals(sErrMsg)) {
				throw new DisException(sErrMsg);
			}
		}

		return DisMessageUtil.getResultObjMessage(DisConstants.RESULT_SUCCESS);
	}

	/**
	 * @메소드명 : tranPR
	 * @날짜 : 2016. 03. 21.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 추가 PR 로직
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public String tranPR(CommandMap commandMap) throws Exception {

		/* 결과 메세지 */
		int result = 0;
		String resultMsg = "";
		
		/* insert_rset1 결과 값 : 체크된 아이템들 맵핑 값 */
		String vProjectNo = "";
		String vDwgNo = "";
		String vBatchId = "";
		
		/* 프로시져 실행 결과*/
		Object pr_no      = "";
		String error_code = "";
		String error_msg  = "";
		

		/* insert_rset2 결과 값 : 해당 호선 도면 기준의 아이템 결과 값 */
		// String vItemCode = "";
		// String vCreatedBy = "";
		String vPersonId = "";
		String vUserId = "";
		String vItemId = "";
		String vUomCd = "";
		String vBuyerId = "";
		String vProjectId = "";
		String vLocationName = "";
		String vEquipDate = "";
		String vTaskId = "";
		String vDeptId = "";
		String vEa = "";
		String vProjectStatusCode = "";


		// 체크 된 아이템들을 그룹핑 하여 도면번호 및 호선으로 맵핑 (도면, 호선) 받아와. 제외대상 : STATE=R인것만.
		// 마스터 + 도면 기준의 호선, 도면
		Object chkbox =  commandMap.get("chkbox");
		if (chkbox instanceof String) {
			commandMap.put("chkbox",new Object[]{chkbox});
		}
		
		List<Map<String, Object>> insert_rset1 = emsAdminDAO.emsAdminInsertRset1(commandMap.getMap());

		for (int i = 0; i < insert_rset1.size(); i++) {
			// insert_rset1 결과값 가져옴
			vProjectNo = insert_rset1.get(i).get("project").toString();
			vDwgNo = insert_rset1.get(i).get("dwg_no").toString();
			vBatchId = insert_rset1.get(i).get("seq").toString();

			Map<String, Object> rowData1 = new HashMap<>();
			rowData1.put("loginId", commandMap.get("loginId"));
			rowData1.put("project", vProjectNo);
			rowData1.put("dwg_no", vDwgNo);

			// 해당 호선 도면 기준의 아이템을 받아온다.
			// 각 INTERFACE에 들어갈 정보 받아옴.
			List<Map<String, Object>> insert_rset2 = emsAdminDAO.emsAdminInsertRset2(rowData1);

			// insert_rset2 가 존재 할때만 실행
			if(insert_rset2.size() > 0) { 
				
				for (int j = 0; j < insert_rset2.size(); j++) {
					/* insert_rset2 결과값 가져옴 */
					// vItemCode = (String)
					// insert_rset2.get(j).get("item_code");
					// vCreatedBy = (String)
					// insert_rset2.get(j).get("created_by");
					vPersonId = (String) insert_rset2.get(j).get("person_id");
					vUserId = (String) insert_rset2.get(j).get("user_id");
					vItemId = (String) insert_rset2.get(j).get("item_id");
					vUomCd = (String) insert_rset2.get(j).get("uom_code");
					vBuyerId = (String) insert_rset2.get(j).get("buyer_id");
					vProjectId = (String) insert_rset2.get(j).get("project_id");
					vLocationName = (String) insert_rset2.get(j).get("location_name");
					vEquipDate = (String) insert_rset2.get(j).get("equip_date");
					vTaskId = (String) insert_rset2.get(j).get("task_id");
					vDeptId = (String) insert_rset2.get(j).get("dept_id");
					vEa = (String) insert_rset2.get(j).get("ea");
					vProjectStatusCode = (String) insert_rset2.get(j).get("project_status_code");

					// Validation 체크 Start //
					if (vPersonId.equals("")) {
						resultMsg = "Not exist Person Id!";
						return resultMsg;
					}
					if (vBuyerId.equals("")) {
						resultMsg = "Not exist Buyer!";
						return resultMsg;
					}
					if (vProjectId.equals("")) {
						resultMsg = "Not exist Project ID!";
						return resultMsg;
					}
					if (vLocationName.equals("")) {
						resultMsg = "Not exist Location Name!";
						return resultMsg;
					}
					if (vEquipDate.equals("")) {
						resultMsg = "Not exist Equip Date!";
						return resultMsg;
					}
					if (vTaskId.equals("")) {
						resultMsg = "Not exist Task id!";
						return resultMsg;
					}
					if (vDeptId.equals("")) {
						resultMsg = "Not exist Dept id!";
						return resultMsg;
					}
					if (vProjectStatusCode.equals("CLOSED")) {
						resultMsg = "호선이 마감되었습니다. 관리자에게 문의바랍니다.";
						return resultMsg;
					}

					Map<String, Object> rowData2 = new HashMap<>();
					rowData2.put("user_id", vUserId);
					rowData2.put("item_id", vItemId);
					rowData2.put("ea", vEa);
					rowData2.put("equip_date", vEquipDate);
					rowData2.put("location_name", vLocationName);
					rowData2.put("person_id", vPersonId);
					rowData2.put("uom_cd", vUomCd);
					rowData2.put("project_id", vProjectId);
					rowData2.put("task_id", vTaskId);
					rowData2.put("person_id", vPersonId);
					rowData2.put("batch_id", vBatchId);
					rowData2.put("dept_id", vDeptId);
					rowData2.put("buyer_id", vBuyerId);
					rowData2.put("project_id", vProjectId);

					// PR TEMP INTERFACE 테이블에 입력.(ITEM 별)
					result = emsAdminDAO.emsAdminInsertRset3(rowData2);
					
					if (result == 0) {
						resultMsg = "PR TEMP INTERFACE 입력에 실패했습니다.";
						return resultMsg;
					}
				}
				
				Map<String, Object> rowData3 = new HashMap<>();
				rowData3.put("p_organization_id", "82");
				rowData3.put("p_batch_id", vBatchId);
				rowData3.put("p_user_id", vUserId);
				rowData3.put("p_source_type_code", "EMS");
				
				//PR IMPORT 프로시져 호출
				emsAdminDAO.emsAdminInsertRset4(rowData3);
				
				pr_no =  rowData3.get("p_pr_no");
				error_code = (String) rowData3.get("p_error_code");
				error_msg = (String) rowData3.get("p_error_msg");
				
				if(  null == pr_no || pr_no.equals("")  ){
					resultMsg = "PR IMPORT 프로시져 호출에 실패했습니다.";
					return resultMsg;
				}
				
				Map<String, Object> rowData4 = new HashMap<>();
				rowData4.put("pr_no", pr_no);
				rowData4.put("loginId", commandMap.get("loginId"));
				rowData4.put("project_id", vProjectNo);
				rowData4.put("dwg_no", vDwgNo);
				
				//승인상태('S')로 변경
				result = emsAdminDAO.emsAdminInsertRset5(rowData4);
				if (result == 0) {
					resultMsg = "승인상태로 변경을 실패했습니다.";
					return resultMsg;
				}
				
			} //insert_rset2 가 존재 할때만 실행 END
			
		}
		return resultMsg;
	}

	/**
	 * @메소드명 : deletePR
	 * @날짜 : 2016. 03. 21.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 삭제 PR 로직
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public String deletePR(CommandMap commandMap) throws Exception {

		/* 결과 메세지 */
		int result = 0;
		String resultMsg = "";

		/* insert_rset1 결과 값 : 체크된 아이템들 맵핑 값 */
		String vProjectNo = "";
		String vDwgNo = "";
		// String vBatchId = "";

		// 체크 된 아이템들을 그룹핑 하여 도면번호 및 호선으로 맵핑 (도면, 호선) 받아와. 제외대상 : STATE=R인것만.
		// 마스터 + 도면 기준의 호선, 도면
		Object chkbox =  commandMap.get("chkbox");
		if (chkbox instanceof String) {
			commandMap.put("chkbox",new Object[]{chkbox});
		}
		
		List<Map<String, Object>> delete_rset1 = emsAdminDAO.emsAdminDeleteRset1(commandMap.getMap());

		for (int i = 0; i < delete_rset1.size(); i++) {
			// insert_rset1 결과값 가져옴
			vProjectNo = delete_rset1.get(i).get("project").toString();
			vDwgNo = delete_rset1.get(i).get("dwg_no").toString();
			// vBatchId = delete_rset1.get(i).get("seq").toString();

			Map<String, Object> rowData1 = new HashMap<>();
			rowData1.put("loginId", commandMap.get("loginId"));
			rowData1.put("project", vProjectNo);
			rowData1.put("dwg_no", vDwgNo);

			// 도면번호, 호선 기준으로 LOOP 실행.
			// 삭제 시작
			result = emsAdminDAO.emsAdminDeleteRset3(rowData1);
			if (result == 0) {
				resultMsg = "PR 삭제를 실패했습니다.";
				return resultMsg;
			}
		}

		return resultMsg;
	}
	
	/**
	 * @메소드명 : emsAdminRefuse
	 * @날짜 : 2016. 03. 21.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * emsAdmin 선택항목 반려
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> emsAdminRefuse(CommandMap commandMap) throws Exception {
		
		/* 결과 메세지 */
		int result = 0;
		
		// 프로시져 에러 체크 결과 값
		String sErrMsg = "";
		String sErrCode = "";
		
		String purNoStr = ""; // Pur_No 문자열 변환
		String dwgNoStr = ""; // dwg_no 문자열 변환

		// 사용자 정보를 가져옴
		Map<String, Object> userInfo = getUserInfo(commandMap.getMap()); // getUserInfo() : EmsCommonServiceImpl 로 부터 상속받아 사용

		/* Pur_No 를 가져옴, String 형으로 변경 */
		commandMap.put("p_state", "R,DR");
		List<Map<String, Object>> purNo = getPurNo(commandMap.getMap()); // getPurNo() : EmsCommonServiceImpl 로 부터 상속받아 사용
		for (int i = 0; i < purNo.size(); i++) {
			if (i != 0) purNoStr += ",";
			purNoStr += purNo.get(i).get("ems_pur_no");
		}
		
		/* 가져온 도면번호를 배열 형으로 변경 */
		String dwgNoArray[] = commandMap.get("p_dwg_no").toString().replaceAll(",,", "").split(",");
		commandMap.put("dwgNoArray", dwgNoArray);
		
		/* 반려 상태값 변경('A') */
		for (int i=0; i<dwgNoArray.length; i++){
			Map<String, Object> rowData = new HashMap<String, Object>();
			rowData.put("loginId", commandMap.get("loginId"));
			rowData.put("p_master", commandMap.get("p_master"));
			rowData.put("p_dwg_no", dwgNoArray[i]);
			result = emsAdminDAO.statusChangeA(rowData);

		}
		
		/* 먼저 메일 보낼 사람 추출 및 메일 전송 */
		List<Map<String, Object>> rset1 = emsAdminDAO.emsAdminRefuseRset1(commandMap.getMap());
		for (int i=0; i<rset1.size(); i++){
			// 개인별 도면번호 추출
			Map<String, Object> rowData1 = new HashMap<String, Object>();
			rowData1.put("p_master", commandMap.get("p_master"));
			rowData1.put("dwgNoArray", commandMap.get("dwgNoArray"));
			rowData1.put("first_user", rset1.get(i).get("first_user"));
			List<Map<String, Object>> rset2 = emsAdminDAO.emsAdminRefuseRset2(rowData1);
			
			// 결과 값 문자열로 변환
			for (int j=0; j<rset2.size(); j++) {
				if (j != 0) dwgNoStr += ",";
				dwgNoStr += rset2.get(i).get("dwg_no");
			}
			
			// 받는사람 메일 주소를 가져옴
			Map<String, Object> rowData2 = new HashMap<String, Object>();
			rowData2.put("loginId", rset1.get(i).get("first_user"));
			Map<String, Object> userEmail = getUserInfo(rowData2); // getUserInfo() : EmsCommonServiceImpl 로 부터 상속받아 사용
			
			
			// 메일전송
			Map<String, Object> rowData3 = new HashMap<>();
			rowData3.put("p_emspurno", purNoStr);
			rowData3.put("p_master", commandMap.get("p_master"));
			rowData3.put("p_dwg_no", dwgNoStr);
			rowData3.put("p_reason", "");
			rowData3.put("p_flag", "반려");
			rowData3.put("p_action", "app_rej");
			rowData3.put("p_from", userInfo.get("ep_mail") + "@onestx.com");
			rowData3.put("p_to", userEmail.get("ep_mail") + "@onestx.com");
			rowData3.put("p_from_dept", userInfo.get("dept_name"));
			rowData3.put("p_from_name", userInfo.get("user_name"));

			emsCommonDAO.sendEmail(rowData3);

			sErrMsg = DisStringUtil.nullString(rowData3.get("errbuf"));
			sErrCode = DisStringUtil.nullString(rowData3.get("retcode"));

			// 오류가 있으면 스탑
			if (!"".equals(sErrMsg)) {
				throw new DisException(sErrMsg);
			}
		}
		return DisMessageUtil.getResultObjMessage(DisConstants.RESULT_SUCCESS);
	}
	
	/**
	 * @메소드명 : posDownloadFile
	 * @날짜 : 2016. 03. 10.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 추가 버튼 팝업창 : 파일 다운로드
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	public View popUpAdminSpecDownloadFile(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		Map<String, Object> rs = emsAdminDAO.popUpAdminSpecDownloadFile(commandMap.getMap());

		modelMap.put("data", (byte[]) rs.get("file_blob"));
		modelMap.put("filename", (String) rs.get("file_name"));
		return new FileDownLoad();
	}
}
