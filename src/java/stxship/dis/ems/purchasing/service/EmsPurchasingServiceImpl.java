package stxship.dis.ems.purchasing.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.apache.log4j.Logger;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.View;

import net.sf.json.JSONArray;
import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.util.DisEGDecrypt;
import stxship.dis.common.util.DisExcelUtil;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.DisStringUtil;
import stxship.dis.common.util.FileDownLoad;
import stxship.dis.common.util.GenericExcelView;
import stxship.dis.ems.common.dao.EmsCommonDAO;
import stxship.dis.ems.common.service.EmsCommonServiceImpl;
import stxship.dis.ems.purchasing.dao.EmsPurchasingDAO;

@Service("emsPurchasingService")
public class EmsPurchasingServiceImpl extends EmsCommonServiceImpl implements EmsPurchasingService {
	Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "emsPurchasingDAO")
	private EmsPurchasingDAO emsPurchasingDAO;

	@Resource(name = "emsCommonDAO")
	private EmsCommonDAO emsCommonDAO;

	/**
	 * @메소드명 : emsPurchasingGetDeptList
	 * @날짜 : 2016. 03. 01.
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
	public List<Map<String, Object>> emsPurchasingSelectBoxDept(CommandMap commandMap) {
		return emsPurchasingDAO.emsPurchasingSelectBoxDept(commandMap.getMap());
	}

	/**
	 * @메소드명 : emsPurchasingAddSelectBoxPjt
	 * @날짜 : 2016. 03. 04.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 추가 버튼 팝업창 : 조회조건 선종 SelectBox 리스트 불러옴
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public List<Map<String, Object>> emsPurchasingAddSelectBoxPjt(CommandMap commandMap) {
		return emsPurchasingDAO.emsPurchasingAddSelectBoxPjt(commandMap.getMap());
	}

	/**
	 * @메소드명 : popUpPurchasingFosSelectBoxCauseDept
	 * @날짜 : 2016. 03. 10.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 추가 버튼 팝업창 : POS그리드 내 원인부서 SelectBox 리스트 불러옴
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public List<Map<String, Object>> popUpPurchasingFosSelectBoxCauseDept(CommandMap commandMap) {
		return emsPurchasingDAO.popUpPurchasingFosSelectBoxCauseDept(commandMap.getMap());
	}

	/**
	 * @메소드명 : popUpPurchasingFosSelectBoxPosType
	 * @날짜 : 2016. 03. 10.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 추가 버튼 팝업창 : POS그리드 내 항목 SelectBox 리스트 불러옴
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public List<Map<String, Object>> popUpPurchasingFosSelectBoxPosType(CommandMap commandMap) {
		return emsPurchasingDAO.popUpPurchasingFosSelectBoxPosType(commandMap.getMap());
	}

	/**
	 * @메소드명 : popUpPurchasingPosUploadFile
	 * @날짜 : 2016. 03. 10.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 추가 버튼 팝업창 - UPLOAD 버튼 팝업창 : 등록한 파일 업로드
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> popUpPurchasingPosUploadFile(HttpServletRequest request, CommandMap commandMap,
			HttpServletResponse response) throws Exception {

		// 결과값 최초
		int result = 0;

		// 파일 객체 호출
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
		Object pos_file = multipartRequest.getFile("p_pos_file");

		// 파일 정보
		String fileName = ((MultipartFile) pos_file).getOriginalFilename();
		String fileType = ((MultipartFile) pos_file).getContentType();
		long fileSize = ((MultipartFile) pos_file).getSize();

		//파일 복호화
		File DecryptFile = null; 
		DecryptFile = DisEGDecrypt.createDecryptFile((MultipartFile) pos_file);
		
		FileInputStream input = new FileInputStream(DecryptFile);
		MultipartFile multipartFile = new MockMultipartFile("fileItem",
				DecryptFile.getName(), fileType, IOUtils.toByteArray(input));
		input.close();
		
		// SELECT 결과 값
		String ProjectId = "";
		String EquipName = "";

		// 프로시져 OUT 결과 값
		String file_id = "";
		String reviewId = "";

		// 프로시져 에러 체크 결과 값
		String sErrMsg = "";
		String sErrCode = "";

		// UPLOAD 파일 사이즈 제한
		int sizeLimit = 10 * 1024 * 1024;

		// 파라미터 값
		String sMaster = (String) commandMap.get("p_master");
		String sDwg_no = (String) commandMap.get("p_dwg_no");
		String sReason = (String) commandMap.get("p_reason");
		String loginId = (String) commandMap.get("loginId");

		// PROJECT ID를 받아옴
		ProjectId = emsPurchasingDAO.posSelectProjectId(commandMap.getMap());

		// EQUIP NAME을 받아옴
		EquipName = emsPurchasingDAO.posSelectEquipName(commandMap.getMap());

		try {

			if ("".equals(fileName)) {
				throw new DisException("파일명이 존재하지 않습니다.");
				
			}
			if ("".equals(EquipName)) {
				throw new DisException("기자재명이 없습니다.");
			}
			if (fileSize > sizeLimit) {
				throw new DisException("용량 제한으로 인해 실패하였습니다.\\n파일 용량을 10MB 이하로 줄여서 업로드 해주십시오.");
			}

			// 호선, ITEM_ID를 인자로 주어 구매담당자 ID를 받아옴.
			Map<String, Object> rowData1 = new HashMap<>();
			rowData1.put("p_access_id", "");
			rowData1.put("p_access_flag", "1");
			rowData1.put("p_project_id", ProjectId);
			rowData1.put("p_project_no", sMaster);
			rowData1.put("p_equipment_name", EquipName);
			rowData1.put("p_doc_type_code", "90");
			rowData1.put("p_file_content_type", "application/pdf");
			rowData1.put("p_file_name", fileName);
			// rowData1.put("p_blob", "EMPTY_BLOB()");
			rowData1.put("p_remark", sReason);
			rowData1.put("p_plm_user_id", loginId);
			rowData1.put("p_user_id", "");
			rowData1.put("p_login_id", "");
			rowData1.put("p_system", "EMS");
			emsPurchasingDAO.posGetFileId(rowData1);

			// 에러 체크
			sErrMsg = DisStringUtil.nullString(rowData1.get("o_errbuff"));
			sErrCode = DisStringUtil.nullString(rowData1.get("o_retcode"));

			file_id = DisStringUtil.nullString(rowData1.get("o_file_id"));

			// 오류가 있으면 스탑
			if (!"".equals(sErrCode)) {
				throw new DisException(sErrMsg);
			}

			// 파일 업로드
			Map<String, Object> rowData2 = new HashMap<String, Object>();
			rowData2.put("p_file_id", file_id);
			//rowData2.put("p_file_Byte", ((MultipartFile) pos_file).getBytes()); //실제 파일 객체
			rowData2.put("p_file_Byte", multipartFile.getBytes()); //실제 파일 객체
			result = emsPurchasingDAO.posUploadFile(rowData2);

			if (result == 0) {
				throw new DisException("파일 업로드에 실패했습니다.");
			}

			// 사양검토 INSERT
			Map<String, Object> rowData3 = new HashMap<>();
			rowData3.put("p_project_id", ProjectId);
			rowData3.put("p_project_no", sMaster);
			rowData3.put("p_equipment_name", EquipName);
			rowData3.put("p_vendor_site_id", "");
			rowData3.put("p_vendor_site_name", "");
			rowData3.put("p_act_from", "설계");
			rowData3.put("p_act_to", "조달");
			rowData3.put("p_dwg_no", sDwg_no);
			// rowData3.put("p_act_date", sysdate);
			rowData3.put("p_act_comment", "POS");
			rowData3.put("p_act_currency", "");
			rowData3.put("p_act_price", "");
			rowData3.put("p_complete_flag", "10");
			rowData3.put("p_plm_user_id", loginId);
			rowData3.put("p_user_id", "");
			rowData3.put("p_login_id", "");
			rowData3.put("p_system", "EMS");
			emsPurchasingDAO.posInsertRow(rowData3);

			// 에러 체크
			sErrMsg = DisStringUtil.nullString(rowData3.get("o_errbuff"));
			sErrCode = DisStringUtil.nullString(rowData3.get("o_retcode"));

			reviewId = DisStringUtil.nullString(rowData3.get("o_spec_review_id"));

			// 오류가 있으면 스탑
			if (!"".equals(sErrCode)) {
				throw new DisException(sErrMsg);
			}

			// 선택한 첨부파일 목록 INSERT
			Map<String, Object> rowData4 = new HashMap<>();
			rowData4.put("p_spec_review_id", reviewId);
			rowData4.put("p_file_id", file_id);
			rowData4.put("p_plm_user_id", loginId);
			rowData4.put("p_user_id", "");
			rowData4.put("p_login_id", "");
			rowData4.put("p_system", "EMS");
			emsPurchasingDAO.posInsertSelectedFile(rowData4);

			// 에러 체크
			sErrMsg = DisStringUtil.nullString(rowData4.get("o_errbuff"));
			sErrCode = DisStringUtil.nullString(rowData4.get("o_retcode"));

			// 오류가 있으면 스탑
			if (!"".equals(sErrCode)) {
				throw new DisException(sErrMsg);
			}

			String message = "파일 업로드에 성공하였습니다.";

			StringBuffer sb = new StringBuffer();
			sb.append("<script type=\"text/javascript\" >");
			sb.append("alert('" + message + "');");
			sb.append("opener.$('.warningArea').show();");
			sb.append("opener.$('#p_file_id').val(" + file_id + ");");
			sb.append("window.close();");
			sb.append("</script>");

			response.setContentType("text/html;charset=UTF-8");
			response.getWriter().println(sb);

		} catch (Exception e) {
			e.printStackTrace();
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, e.getLocalizedMessage());
			
			String message = e.getLocalizedMessage();

			StringBuffer sb = new StringBuffer();
			sb.append("<script type=\"text/javascript\" >");
			sb.append("alert('" + message + "');");
			sb.append("opener.$('.warningArea').show();");
			sb.append("opener.$('#p_file_id').val(" + file_id + ");");
			sb.append("window.close();");
			sb.append("</script>");

			response.setContentType("text/html;charset=UTF-8");
			response.getWriter().println(sb);
			
		}
		return null;
	}

	/**
	 * @메소드명 : popUpPurchasingPosApplyFile
	 * @날짜 : 2016. 03. 10.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 추가 버튼 팝업창 : 파일 업로드 후 APPLY
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> popUpPurchasingPosApplyFile(HttpServletRequest request, CommandMap commandMap)
			throws Exception {

		String process = (String) commandMap.get("p_process");

		// 프로시져 에러 체크 결과 값
		String sErrMsg = "";
		String sErrCode = "";

		String mailFlag = "";
		String purNoStr = "";
		String p_pos_rev = "";

		// Purchsing Add Insert 및 POS 개정 추가인 경우
		if (process.equals("insertPosRevision")) {
			Map<String, Object> rowData1 = new HashMap<>();
			rowData1.put("p_master", commandMap.get("p_master"));
			rowData1.put("p_dwg_no", commandMap.get("p_dwg_no_input"));
			rowData1.put("p_pos_type", commandMap.get("p_pos_type"));
			rowData1.put("p_cause_dept", commandMap.get("p_cause_dept"));
			rowData1.put("p_is_cost", commandMap.get("p_is_cost"));
			rowData1.put("p_extra_cost", commandMap.get("p_extra_cost"));
			rowData1.put("p_user_id", commandMap.get("loginId"));
			rowData1.put("p_pur_no", 0);
			rowData1.put("p_file_id", commandMap.get("p_file_id"));
			emsPurchasingDAO.insertPosRevision(rowData1);

			sErrMsg = DisStringUtil.nullString(rowData1.get("p_err_msg"));
			// sErrCode = DisStringUtil.nullString(rowData1.get("p_err_code"));
			p_pos_rev = DisStringUtil.nullString(rowData1.get("p_pos_rev"));
			// 오류가 있으면 스탑
			if (!"".equals(sErrMsg)) {
				throw new DisException(sErrMsg);
			}
			// 본물량이 아니고 비용이 발생 안되는 경우 메일 발송
			// 아이템 추가와 삭제 때는 메일 발송 안함.(단순 pos 변경때만)
			if (!commandMap.get("p_pos_type").equals("A") && commandMap.get("p_is_cost").equals("N")
					&& !commandMap.get("p_busi_type").equals("A") && !commandMap.get("p_busi_type").equals("D")) {
				mailFlag = "Y";
			}

			// POS 개정 메일 발송
			if (mailFlag.equals("Y") && !p_pos_rev.equals("")) {
				// 사용자 정보를 가져옴
				Map<String, Object> rowData2 = new HashMap<>();
				rowData2.put("emp_no", commandMap.get("loginId"));
				Map<String, Object> userInfo = emsPurchasingDAO.requestSelectUserInfo(rowData2);

				// Pur_No 를 가져옴, String 형으로 변경
				commandMap.put("p_state", "S");
				List<Map<String, Object>> purNo = getPurNo(commandMap.getMap());
				for (int i = 0; i < purNo.size(); i++) {
					if (i != 0)
						purNoStr += ",";
					purNoStr += purNo.get(i).get("ems_pur_no");
				}

				// 조달 담당자 정보를 가져옴
				List<Map<String, Object>> buyer = getBuyer(commandMap.getMap());

				// 메일 전송
				for (int i = 0; i < buyer.size(); i++) {
					Map<String, Object> rowData = new HashMap<>();
					rowData.put("p_emspurno", purNoStr);
					rowData.put("p_master", commandMap.get("p_master"));
					rowData.put("p_dwg_no", commandMap.get("p_dwg_no"));
					rowData.put("p_reason", "");
					rowData.put("p_flag", "승인");
					rowData.put("p_action", "required");
					rowData.put("p_from", userInfo.get("ep_mail") + "@onestx.com");
					rowData.put("p_to", buyer.get(i).get("ep_mail"));
					rowData.put("p_from_dept", userInfo.get("dept_name"));
					rowData.put("p_from_name", userInfo.get("user_name"));

					emsCommonDAO.sendEmail(rowData);

					sErrMsg = DisStringUtil.nullString(rowData.get("errbuf"));
					sErrCode = DisStringUtil.nullString(rowData.get("retcode"));

					// 오류가 있으면 스탑
					if (!"".equals(sErrCode)) {
						throw new DisException(sErrMsg);
						
					}
				}
			}
			
			//Purchsing Add Insert 인 경우에만 실행
			if ("A".equals(commandMap.get("p_busi_type"))){
				String sProject = "";

				String[] ar_item_code = commandMap.get("p_l_item_code").toString().split(",");
				String[] ar_ea = commandMap.get("p_l_ea").toString().split(",");
				String[] ar_dwg_no = commandMap.get("p_l_dwg_no").toString().split(",");
				String[] ar_project = commandMap.get("p_project").toString().split(",");

				String p_ship_kind = commandMap.get("p_ship_kind") != null ? (String) commandMap.get("p_ship_kind") : "";
				int p_pos_rev_add = Integer.parseInt(p_pos_rev);
				Map<String, Object> map = new HashMap<String, Object>();
				for (int i = 0; i < ar_item_code.length; i++) {
					for (int j = 0; j < ar_project.length; j++) {
						sProject = ar_project[j];
						map.put("p_project_no", sProject);
						map.put("p_dwg_no", ar_dwg_no[i]);
						map.put("p_item_code", ar_item_code[i]);

						String vExistYn = emsPurchasingDAO.selectOne("emsPurchasingMain.getPurchasingExistYn", map);

						if (vExistYn.equals("N")) {
							throw new DisException("이미 해당 아이템이 존재합니다. 삭제 및 승인완료 이후 진행하십시오.");
						}

						map.put("p_ship_kind", p_ship_kind);
						map.put("sProject", sProject);
						map.put("ar_dwg_no", ar_dwg_no[i]);
						map.put("ar_ea", ar_ea[i]);
						map.put("UserId", commandMap.get("loginId"));
						map.put("p_pos_rev", p_pos_rev_add);
						map.put("ar_item_code", ar_item_code[i]);
						emsPurchasingDAO.insert("emsPurchasingMain.insertPurchasingAdd", map);
					}
				}
			}

		}
		// Pos 개정 Delete, Insert (pur_no 기준)
		else if (process.equals("insertPosRevisionPurNo")) {

			String[] pur_no = commandMap.get("p_pur_no").toString().replaceAll(",,", "").split(",");

			for (int i = 0; i < pur_no.length; i++) {
				Map<String, Object> rowData1 = new HashMap<>();
				rowData1.put("p_master", commandMap.get("p_master"));
				rowData1.put("p_dwg_no", commandMap.get("p_dwg_no_input"));
				rowData1.put("p_pos_type", commandMap.get("p_pos_type"));
				rowData1.put("p_cause_dept", commandMap.get("p_cause_dept"));
				rowData1.put("p_is_cost", commandMap.get("p_is_cost"));
				rowData1.put("p_extra_cost", commandMap.get("p_extra_cost"));
				rowData1.put("p_user_id", commandMap.get("loginId"));
				rowData1.put("p_pur_no", pur_no[i]);
				rowData1.put("p_file_id", commandMap.get("p_file_id"));
				emsPurchasingDAO.insertPosRevisionPurNo(rowData1);

				sErrMsg = DisStringUtil.nullString(rowData1.get("errbuf"));
				// sErrCode = DisStringUtil.nullString(rowData1.get("retcode"));

				p_pos_rev = DisStringUtil.nullString(rowData1.get("p_pos_rev"));

				// 본물량이 아니고 비용이 발생 안되는 경우 메일 발송
				// 아이템 추가와 삭제 때는 메일 발송 안함.(단순 pos 변경때만)
				if (!commandMap.get("p_pos_type").equals("A") && commandMap.get("p_is_cost").equals("N")
						&& !commandMap.get("p_busi_type").equals("A") && !commandMap.get("p_busi_type").equals("D")) {
					mailFlag = "Y";
				}

				// POS 개정 메일 발송
				if (mailFlag.equals("Y") && !p_pos_rev.equals("")) {
					// 사용자 정보를 가져옴
					Map<String, Object> rowData2 = new HashMap<>();
					rowData2.put("emp_no", commandMap.get("loginId"));
					Map<String, Object> userInfo = emsPurchasingDAO.requestSelectUserInfo(rowData2);

					// Pur_No 를 가져옴, String 형으로 변경
					List<Map<String, Object>> purNo = getPurNo(commandMap.getMap());
					for (int j = 0; j < purNo.size(); j++) {
						if (j != 0)
							purNoStr += ",";
						purNoStr += purNo.get(j).get("ems_pur_no");
					}

					// 조달 담당자 정보를 가져옴
					List<Map<String, Object>> buyer = getBuyer(commandMap.getMap());

					// 메일 전송
					for (int k = 0; k < buyer.size(); k++) {
						Map<String, Object> rowData = new HashMap<>();
						rowData.put("p_emspurno", purNoStr);
						rowData.put("p_master", commandMap.get("p_master"));
						rowData.put("p_dwg_no", commandMap.get("p_dwg_no"));
						rowData.put("p_reason", "");
						rowData.put("p_flag", "승인");
						rowData.put("p_action", "required");
						rowData.put("p_from", userInfo.get("ep_mail") + "@onestx.com");
						rowData.put("p_to", buyer.get(k).get("d_ep_mail"));
						rowData.put("p_from_dept", userInfo.get("dept_name"));
						rowData.put("p_from_name", userInfo.get("user_name"));

						emsCommonDAO.sendEmail(rowData);

						sErrMsg = DisStringUtil.nullString(rowData.get("errbuf"));
						// sErrCode =
						// DisStringUtil.nullString(rowData.get("retcode"));
					}
				}
			}

		} else if (process.equals("insertPurchasingAdd")) {
			
		}
		// 여기까지 Exception 없으면 성공 메시지
		// 결과값에 따른 메시지를 담아 전송
		Map<String, Object> result = DisMessageUtil.getResultObjMessage(DisConstants.RESULT_SUCCESS);

		return result;
	}

	/**
	 * @메소드명 : popUpPurchasingPosApprove
	 * @날짜 : 2016. 04. 07.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 추가 버튼 팝업창 : POS승인
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	public Map<String, Object> popUpPurchasingPosApprove(HttpServletRequest request, CommandMap commandMap) throws Exception {
		
		int result = 0;
		
		result = emsPurchasingDAO.popUpPurchasingPosApprove(commandMap.getMap());
		
		// 실패의 경우
		if (result == 0) {
			throw new DisException("POS승인요청에 실패했습니다.");
		}
		
		// 여기까지 Exception 없으면 성공 메시지
		Map<String, Object> resultMsg = DisMessageUtil.getResultObjMessage(DisConstants.RESULT_SUCCESS);
		return resultMsg;
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
	public View popUpPurchasingPosDownloadFile(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		Map<String, Object> rs = emsPurchasingDAO.popUpPurchasingPosDownloadFile(commandMap.getMap());

		modelMap.put("data", (byte[]) rs.get("file_blob"));
		modelMap.put("filename", (String) rs.get("file_name"));
		return new FileDownLoad();
	}

	/**
	 * @메소드명 : emsPurchasingDeleteA
	 * @날짜 : 2016. 03. 15.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 삭제 버튼
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> emsPurchasingDeleteA(CommandMap commandMap) throws Exception {

		int result = 0;

		String[] pur_no = commandMap.get("p_ems_pur_no").toString().replaceAll(",,", "").split(",");

		// 삭제
		for (int i = 0; i < pur_no.length; i++) {
			Map<String, Object> rowData = new HashMap<>();
			rowData.put("pur_no", pur_no[i]);
			result += emsPurchasingDAO.emsPurchasingDeleteA(rowData);
		}

		// 실패의 경우
		if (result == 0) {
			throw new DisException("승인요청에 실패했습니다.");
		}

		// 여기까지 Exception 없으면 성공 메시지
		Map<String, Object> resultMsg = DisMessageUtil.getResultObjMessage(DisConstants.RESULT_SUCCESS);
		return resultMsg;
	}

	/**
	 * @메소드명 : emsPurchasingDeleteS
	 * @날짜 : 2016. 04. 01.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 상태 'S' 삭제 시 실행
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> emsPurchasingDeleteS(CommandMap commandMap) throws Exception {
		int result = 0;

		String[] pur_no = commandMap.get("p_ems_pur_no").toString().replaceAll(",,", "").split(",");

		// 삭제
		for (int i = 0; i < pur_no.length; i++) {
			Map<String, Object> rowData = new HashMap<>();
			rowData.put("p_remark", commandMap.get("p_remark"));
			rowData.put("loginId", commandMap.get("loginId"));
			rowData.put("pur_no", pur_no[i]);
			result = emsPurchasingDAO.emsPurchasingDeleteS(rowData);
			
			if (result == 0) {
				throw new DisException("승인요청에 실패했습니다.");
			}
		}

		// 여기까지 Exception 없으면 성공 메시지
		Map<String, Object> resultMsg = DisMessageUtil.getResultObjMessage(DisConstants.RESULT_SUCCESS);
		return resultMsg;
	}
	
	/**
	 * @메소드명 : popUpPurchasingRequestListTeamLeader
	 * @날짜 : 2016. 03. 14.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 승인요청 버튼 팝업창 : 팀장 리스트 불러옴
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public List<Map<String, Object>> popUpPurchasingRequestListTeamLeader(CommandMap commandMap) {
		return emsPurchasingDAO.popUpPurchasingRequestListTeamLeader(commandMap.getMap());
	}

	/**
	 * @메소드명 : popUpPurchasingRequestListPartLeader
	 * @날짜 : 2016. 03. 14.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 승인요청 버튼 팝업창 : 파트장 리스트 불러옴
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public List<Map<String, Object>> popUpPurchasingRequestListPartLeader(CommandMap commandMap) {
		return emsPurchasingDAO.popUpPurchasingRequestListPartLeader(commandMap.getMap());
	}

	/**
	 * @메소드명 : popUpPurchasingRequestApply
	 * @날짜 : 2016. 03. 14.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 승인요청 버튼 팝업창 : APPLY 버튼을 클릭하여 승인을 요청
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> popUpPurchasingRequestApply(CommandMap commandMap) throws Exception {

		String sErrMsg = "";
		// String sErrCode = "";

		int result = 0;
		String purNoStr = "";

		// 사용자 정보를 가져옴
		Map<String, Object> rowData1 = new HashMap<>();
		rowData1.put("emp_no", commandMap.get("loginId"));
		Map<String, Object> userInfo = emsPurchasingDAO.requestSelectUserInfo(rowData1);

		// 결재자 정보를 가져옴
		Map<String, Object> rowData2 = new HashMap<>();
		rowData2.put("emp_no", commandMap.get("p_approver"));
		Map<String, Object> approvalInfo = emsPurchasingDAO.requestSelectUserInfo(rowData2);

		// Pur_No 를 가져옴, String 형으로 변경
		commandMap.put("p_state", "A,D");
		List<Map<String, Object>> purNo = getPurNo(commandMap.getMap());
		for (int i = 0; i < purNo.size(); i++) {
			if (i != 0)
				purNoStr += ",";
			purNoStr += purNo.get(i).get("ems_pur_no");
		}

		// 승인 요청 업데이트
		String dwgArray[] = commandMap.get("p_dwg_no").toString().split(",");
		for (int i = 0; i < dwgArray.length; i++) {
			Map<String, Object> rowData = new HashMap<>();
			rowData.put("p_pr_state", commandMap.get("p_pr_state"));
			rowData.put("p_approver", commandMap.get("p_approver"));
			rowData.put("loginId", commandMap.get("loginId"));
			rowData.put("p_master", commandMap.get("p_master"));
			rowData.put("p_dwg_no", dwgArray[i]);

			result += emsPurchasingDAO.requestApply(rowData);
		}

		if (result == 0) {
			throw new DisException("승인요청에 실패했습니다.");
		}

		if (result > 0) {
			// 성공시 메일 발송
			Map<String, Object> rowData = new HashMap<>();
			rowData.put("p_emspurno", purNoStr);
			rowData.put("p_master", commandMap.get("p_master"));
			rowData.put("p_dwg_no", commandMap.get("p_dwg_no"));
			rowData.put("p_reason", "");
			rowData.put("p_flag", "승인");
			rowData.put("p_action", "required");
			rowData.put("p_from", userInfo.get("ep_mail") + "@onestx.com");
			rowData.put("p_to", approvalInfo.get("ep_mail") + "@onestx.com");
			rowData.put("p_from_dept", userInfo.get("dept_name"));
			rowData.put("p_from_name", userInfo.get("user_name"));

			emsPurchasingDAO.requestApplyEmail(rowData);

			sErrMsg = DisStringUtil.nullString(rowData.get("errbuf"));
			// sErrCode = DisStringUtil.nullString(rowData.get("retcode"));

			// 오류가 있으면 스탑
			if (!"".equals(sErrMsg)) {
				throw new DisException(sErrMsg);
			}

		}

		// 여기까지 Exception 없으면 성공 메시지
		Map<String, Object> resultMsg = DisMessageUtil.getResultObjMessage(DisConstants.RESULT_SUCCESS);
		return resultMsg;
	}

	/**
	 * @메소드명 : popUpPurchasingRestore
	 * @날짜 : 2016. 03. 16.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * A복원 버튼을 실행하여 상태를 변경
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	public Map<String, Object> popUpPurchasingRestore(HttpServletRequest request, CommandMap commandMap)
			throws Exception {

		int result = 0;
		Map<String, Object> rowData = new HashMap<>();

		String emsPurNoArray[] = commandMap.get("p_ems_pur_no").toString().split(",");
		rowData.put("emsPurNoArray", emsPurNoArray);

		result = emsPurchasingDAO.restoreStateA(rowData);

		if (result == 0) {
			throw new DisException("A복원에 실패했습니다.");
		}

		// 여기까지 Exception 없으면 성공 메시지
		Map<String, Object> resultMsg = DisMessageUtil.getResultObjMessage(DisConstants.RESULT_SUCCESS);
		return resultMsg;
	}

	/**
	 * @메소드명 : popUpPurchasingSpecObtainList
	 * @날짜 : 2016. 04. 01.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 사양 버튼 팝업창 : 조달 그리드 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	public List<Map<String, Object>> popUpPurchasingSpecObtainList(HttpServletRequest request, CommandMap commandMap) throws Exception {
		List<Map<String, Object>> result = emsPurchasingDAO.popUpPurchasingSpecObtainList(commandMap.getMap());
		return result;
	}
	
	/**
	 * @메소드명 : popUpPurchasingSpecPlanList
	 * @날짜 : 2016. 04. 01.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 사양 버튼 팝업창 : 설계 그리드 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	public List<Map<String, Object>> popUpPurchasingSpecPlanList(HttpServletRequest request, CommandMap commandMap) throws Exception {
		List<Map<String, Object>> result = emsPurchasingDAO.popUpPurchasingSpecPlanList(commandMap.getMap());
		return result;
	}
	
	/**
	 * @메소드명 : getSelectBoxVenderName
	 * @날짜 : 2016. 04. 01.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 사양 버튼 팝업창 : 그리드 내 업체명 SELECT BOX
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	public List<Map<String, Object>> getSelectBoxVenderName(HttpServletRequest request, CommandMap commandMap) throws Exception {
		List<Map<String, Object>> result = emsPurchasingDAO.getSelectBoxVenderName(commandMap.getMap());
		return result;
	}
	
	/**
	 * @메소드명 : popUpPurchasingSpecApply
	 * @날짜 : 2016. 04. 04.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 사양 버튼 팝업창 : 적용 기능
	 * 
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> popUpPurchasingSpecApply(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		
		String sErrMsg = "";
		String reviewId = "";
		
		List<Map<String, Object>> gridData = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST));
		
		for (int i=0; i<gridData.size(); i++) {
			Map<String, Object> rowData = new HashMap<>();
			rowData.put("p_master", commandMap.get("p_master"));
			rowData.put("p_dwg_no", commandMap.get("p_dwg_no"));
			rowData.put("files", gridData.get(i).get("files"));
			rowData.put("act_comment", gridData.get(i).get("act_comment"));
			rowData.put("vendor_site_name", gridData.get(i).get("vendor_site_name"));
			
			//SPEC 데이터를 가져옴
			Map<String, Object> selectSpec = emsPurchasingDAO.popUpPurchasingSpecApply(rowData);
			
			selectSpec.put("p_act_from", "설계");
			selectSpec.put("p_act_to", "조달");
			selectSpec.put("p_dwg_no", commandMap.get("p_dwg_no"));
			selectSpec.put("p_act_comment", gridData.get(i).get("act_comment"));
			selectSpec.put("p_act_currency", "");
			selectSpec.put("p_act_price", "");
			selectSpec.put("p_complete_flag", gridData.get(i).get("complete_flag"));
			selectSpec.put("p_plm_user_id", commandMap.get("loginId"));
			selectSpec.put("p_user_id", "");
			selectSpec.put("p_login_id", "");
			selectSpec.put("p_system", "EMS");
			
			//SPEC 사양 검토
			emsPurchasingDAO.insertSpecRow(selectSpec);
			
			sErrMsg = DisStringUtil.nullString(selectSpec.get("o_errbuff"));

			// 오류가 있으면 스탑
			if (!"".equals(sErrMsg)) {
				throw new DisException(sErrMsg);
			}
			
			reviewId =  selectSpec.get("o_spec_review_id") + "";
			String files[] = gridData.get(i).get("files").toString().split(",");
			
			for (int j=0; j<files.length; j++) {
				Map<String, Object> rowData2 = new HashMap<>();
				rowData2.put("p_spec_review_id", reviewId);
				rowData2.put("projecp_file_idt_no", files[j]);
				rowData2.put("p_plm_user_id", commandMap.get("loginId"));
				rowData2.put("p_user_id", "");
				rowData2.put("p_login_id", "");
				rowData2.put("p_system", "EMS");
				
				//선택 파일리스트 INSERT
				emsPurchasingDAO.insertSpecFile(rowData2);
			}
		}
		
		// 유저 정보를 가져옴
		commandMap.put("emp_no", commandMap.get("loginId"));
		Map<String, Object> userInfo = emsPurchasingDAO.requestSelectUserInfo(commandMap.getMap());
		
		// 조달 담당자 정보를 가져옴
		commandMap.put("p_item_code", "");
		commandMap.put("p_pur_no", "");
		List<Map<String, Object>> buyer = getBuyer(commandMap.getMap());
		
		// 2017.10.16 주세훈 차장 요청으로 인해 S1763 호선에 대하여 메일을 보내지 않도록 함 
		if( !commandMap.get("p_master").equals("S1763") ){
		
			// 메일 전송
			for (int i = 0; i < buyer.size(); i++) {
				Map<String, Object> rowData = new HashMap<>();
				rowData.put("p_emspurno", "");
				rowData.put("p_master", commandMap.get("p_master"));
				rowData.put("p_dwg_no", commandMap.get("p_dwg_no"));
				rowData.put("p_reason", "");
				rowData.put("p_flag", "");
				rowData.put("p_action", "spec_complete");
				rowData.put("p_from", userInfo.get("ep_mail") + "@onestx.com");
				rowData.put("p_to", buyer.get(i).get("ep_mail"));
				rowData.put("p_from_dept", userInfo.get("dept_name"));
				rowData.put("p_from_name", userInfo.get("user_name"));
	
				emsCommonDAO.sendEmail(rowData);
	
				sErrMsg = DisStringUtil.nullString(rowData.get("errbuf"));
	
				// 오류가 있으면 스탑
				if (!"".equals(sErrMsg)) {
					throw new DisException(sErrMsg);
				}
			}
			
		}
		// 여기까지 Exception 없으면 성공 메시지
		Map<String, Object> resultMsg = DisMessageUtil.getResultObjMessage(DisConstants.RESULT_SUCCESS);
		return resultMsg;
	}
	
	
	/**
	 * @메소드명 : popUpPurchasingSpecUploadFile
	 * @날짜 : 2016. 04. 01.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 추가 버튼 팝업창 - UPLOAD 버튼 팝업창 : 등록한 파일 업로드
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> popUpPurchasingSpecUploadFile(HttpServletRequest request, CommandMap commandMap, HttpServletResponse response) throws Exception {

		// 결과값 최초
		int result = 0;

		// SELECT 결과 값
		String ProjectId = "";
		String EquipName = "";

		// 프로시져 OUT 결과 값
		String file_id = "";
		String reviewId = "";

		// 프로시져 에러 체크 결과 값
		String sErrMsg = "";
		String sErrCode = "";

		// UPLOAD 파일 사이즈 제한
		int sizeLimit = 10 * 1024 * 1024;

		// 파라미터 값
		String sMaster = (String) commandMap.get("p_master");
		String sDwg_no = (String) commandMap.get("p_dwg_no");
		String loginId = (String) commandMap.get("loginId");
		String sReason = "";
		String row_id = (String) commandMap.get("p_row_id");
		
		String file_id_list = "";
		int rowCnt = Integer.parseInt( (String) commandMap.get("rowCnt") );
		

		// PROJECT ID를 받아옴
		ProjectId = emsPurchasingDAO.posSelectProjectId(commandMap.getMap());

		// EQUIP NAME을 받아옴
		EquipName = emsPurchasingDAO.posSelectEquipName(commandMap.getMap());
		
		try {
			
		
			for (int i=0; i<rowCnt; i++) {
				
				String p_tech_spec = "p_tech_spec_" + i;
				String message = "";
				
				
				// 파일 객체 호출
				MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
				Object spec_file = multipartRequest.getFile(p_tech_spec);
	
				// 파일 정보
				String fileName = ((MultipartFile) spec_file).getOriginalFilename();
				long fileSize = ((MultipartFile) spec_file).getSize();	
				String fileType = ((MultipartFile) spec_file).getContentType();
				
				//파일 복호화
				File DecryptFile = null; 
				DecryptFile = DisEGDecrypt.createDecryptFile((MultipartFile) spec_file);
				
				FileInputStream input = new FileInputStream(DecryptFile);
				MultipartFile multipartFile = new MockMultipartFile("fileItem",
						DecryptFile.getName(), fileType, IOUtils.toByteArray(input));
				input.close();
				
				
				if ("".equals(fileName)) {
					throw new DisException("파일명이 존재하지 않습니다.");
				}
				if ("".equals(EquipName)) {
					throw new DisException("기자재명이 없습니다.");
				}
				if (fileSize > sizeLimit) {
					throw new DisException("용량 제한으로 인해 실패하였습니다.\\n파일 용량을 10MB 이하로 줄여서 업로드 해주십시오.");
				}
				
				// 호선, ITEM_ID를 인자로 주어 구매담당자 ID를 받아옴.
				Map<String, Object> rowData1 = new HashMap<>();
				rowData1.put("p_access_id", "");
				rowData1.put("p_access_flag", "1");
				rowData1.put("p_project_id", ProjectId);
				rowData1.put("p_project_no", sMaster);
				rowData1.put("p_equipment_name", EquipName);
				rowData1.put("p_doc_type_code", "100");
				rowData1.put("p_file_content_type", "application/pdf");
				rowData1.put("p_file_name", fileName);
				// rowData1.put("p_blob", "EMPTY_BLOB()");
				rowData1.put("p_remark", sReason);
				rowData1.put("p_plm_user_id", loginId);
				rowData1.put("p_user_id", "");
				rowData1.put("p_login_id", "");
				rowData1.put("p_system", "EMS");
				emsPurchasingDAO.posGetFileId(rowData1);
				
				// 에러 체크
				sErrMsg = DisStringUtil.nullString(rowData1.get("o_errbuff"));
				sErrCode = DisStringUtil.nullString(rowData1.get("o_retcode"));
	
				file_id = DisStringUtil.nullString(rowData1.get("o_file_id"));
	
				if (file_id_list != "") file_id_list += ",";
				file_id_list += file_id;
				
				// 오류가 있으면 스탑
				if (!"".equals(sErrCode)) {
					throw new DisException(sErrMsg);
				}
	
				// 파일 업로드
				Map<String, Object> rowData2 = new HashMap<String, Object>();
				rowData2.put("p_file_id", file_id);
				rowData2.put("p_file_Byte", multipartFile.getBytes()); //실제 파일 객체
				result = emsPurchasingDAO.posUploadFile(rowData2);
	
				if (result == 0) {
					throw new DisException("파일 업로드에 실패했습니다.");
				}
				
				DisEGDecrypt.deleteDecryptFile(DecryptFile);
			}
			String message = "파일 업로드에 성공하였습니다.";
	
			StringBuffer sb = new StringBuffer();
			sb.append("<script type=\"text/javascript\" >");
			sb.append("alert('" + message + "');");
			/*sb.append("opener.$('#p_file_id_list').val(" + file_id_list + ");");
			sb.append("opener.$('#p_row_id').val(" + row_id + ");");*/
			sb.append("opener.fileUpload(\"" + file_id_list + "\",\"" + row_id + "\");");
			sb.append("window.close();");
			sb.append("</script>");
			
			response.setContentType("text/html;charset=UTF-8");
			response.getWriter().println(sb);
		} catch (Exception e) {
			
			e.printStackTrace();
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, e.getLocalizedMessage());
			
			String message = e.getLocalizedMessage();

			StringBuffer sb = new StringBuffer();
			sb.append("<script type=\"text/javascript\" >");
			sb.append("alert('" + message + "');");
			sb.append("opener.$('#p_file_id').val(" + file_id + ");");
			sb.append("window.close();");
			sb.append("</script>");
			
			response.setContentType("text/html;charset=UTF-8");
			response.getWriter().println(sb);
		}
		
		return null;
	}
	
	/**
	 * @메소드명 : emsPurchasingExcelExport
	 * @날짜 : 2015. 03. 16.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 엑셀 출력을 실행
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public View emsPurchasingExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {

		// COLNAME 설정
		List<String> colName = new ArrayList<String>();
		colName.add("STATE");
		colName.add("MASTER");
		colName.add("PROJECT");
		colName.add("DWG NO");
		colName.add("DWG DESCRIPTION");
		colName.add("ITEM CODE");
		colName.add("ITEM DESCRIPTION");
		colName.add("EA");
		colName.add("부서");
		colName.add("DP담당자");
		colName.add("결재자");
		colName.add("조달담당자");
		colName.add("PR_NO");
		colName.add("사양");
		colName.add("PO");
		colName.add("업체명");
		colName.add("BOM");
		colName.add("POS");		
		colName.add("PR발행계획일자");
		colName.add("PR생성일자");
		colName.add("PR승인일자");
		colName.add("PO행계획일자");
		colName.add("PO승인일자");
		colName.add("승인도 접수일자");

		// COLVALUE 설정
		List<List<String>> colValue = new ArrayList<List<String>>();

		List<Map<String, Object>> list = emsPurchasingDAO.emsPurchasingExcelExport(commandMap.getMap());

		for (Map<String, Object> rowData : list) {
			// Map을 리스트로 변경
			List<String> row = new ArrayList<String>();

			row.add((String) rowData.get("STATUS"));
			row.add((String) rowData.get("MASTER"));
			row.add((String) rowData.get("PROJECT"));
			row.add((String) rowData.get("DWG_NO"));
			row.add((String) rowData.get("DWG_DESC"));
			row.add((String) rowData.get("ITEM_CODE"));
			row.add((String) rowData.get("ITEM_DESC"));
			row.add((String) String.valueOf(rowData.get("EA")));
			row.add((String) rowData.get("DEPT_NAME"));
			row.add((String) rowData.get("DP_USER_NAME"));
			row.add((String) rowData.get("APPROVED_BY"));
			row.add((String) rowData.get("OBTAIN_BY"));
			row.add((String) rowData.get("PR_NO"));
			row.add((String) rowData.get("SPEC_STATE"));
			row.add((String) rowData.get("PO_STATE"));
			row.add((String) rowData.get("CORP_NAME"));
			row.add((String) rowData.get("BOM_STATE"));
			row.add((String) rowData.get("POS"));
			row.add((String) rowData.get("PR_PLAN_DATE"));
			row.add((String) rowData.get("CREATION_DATE"));
			row.add((String) rowData.get("PR_APPLY_DATE"));
			row.add((String) rowData.get("PO_PLAN_DATE"));
			row.add((String) rowData.get("PO_AP_DATE"));
			row.add((String) rowData.get("RECEIVE_ACT_DATE"));

			colValue.add(row);
		}		

		modelMap.put("excelName", "EmsPurchasing");
		modelMap.put("colName", colName);
		modelMap.put("colValue", colValue);
		return new GenericExcelView();

	}

	/**
	 * @메소드명 : purchasingAddExcelList
	 * @날짜 : 2016. 3. 24.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 엑셀 Import list 취득
	 *     </pre>
	 * 
	 * @param file
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> purchasingAddExcelList(CommonsMultipartFile file, CommandMap commandMap, HttpServletResponse response) throws Exception {
		
		//파일 복호화
		File DecryptFile = null; 
		DecryptFile = DisEGDecrypt.createDecryptFile(file);
		
		FileInputStream tempFile = new FileInputStream(DecryptFile);
		
		Workbook workbook = WorkbookFactory.create(tempFile);
		Sheet sheet = workbook.getSheetAt(0);
		Iterator<Row> rowIterator = sheet.iterator();
		List<Object> uploadList = new ArrayList<Object>();
		while (rowIterator.hasNext()) {
			Row row = rowIterator.next();
			// 첫번째는 컬럼 정보
			if (row.getRowNum() != 0) {
				if (row.getCell(0) == null) {
					break;
				}
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("p_ship_kind", commandMap.get("p_ship_kind")+"");
				map.put("vDwgNo", row.getCell(0) == null ? "" : DisExcelUtil.getCellValue(row.getCell(0))+"");
				map.put("vItemCode", row.getCell(1) == null ? "" : DisExcelUtil.getCellValue(row.getCell(1))+"");
				map.put("vEa", row.getCell(2) == null ? "" : DisExcelUtil.getCellValue(row.getCell(2))+"");
				uploadList.add(emsPurchasingDAO.selectOne("popUpPurchasingExcelImport.select", map));
			}
		}
		
		//복화화된 파일 삭제
		DisEGDecrypt.deleteDecryptFile(DecryptFile);
		
		String jsonStr = JSONArray.fromObject(uploadList).toString();
		
		
		String message = "파일 업로드에 성공하였습니다.";
		
		StringBuffer sb = new StringBuffer();
		sb.append("<script type=\"text/javascript\" >");
		sb.append("alert('" + message + "');");
		sb.append("opener.setGridExcel('" + jsonStr + "');");
		sb.append("window.close();");
		sb.append("</script>");

		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().println(sb);
		
		return null;
	}
	
	/**
	 * @메소드명 : emsPurchasingDPExcelExport
	 * @날짜 : 2016. 03. 26.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * DP 팝업창 : 엑셀 출력을 실행
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public View emsPurchasingDPExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {

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
			colName.add(p_col_name);
		}

		List<Map<String, Object>> list = emsPurchasingDAO.emsPurchasingDPExcelExport(commandMap.getMap());

		for (Map<String, Object> rowData : list) {

			List<String> row = new ArrayList<String>();

			// 데이터 네임을 이용해서 리스트에서 뽑아냄.
			for (String p_data_name : p_data_names) {
				row.add(DisStringUtil.nullString(rowData.get(p_data_name)));
			}
			colValue.add(row);

		}
		modelMap.put("excelName", "EmsPurchasingDP");
		modelMap.put("colName", colName);
		modelMap.put("colValue", colValue);
		return new GenericExcelView();

	}

}
