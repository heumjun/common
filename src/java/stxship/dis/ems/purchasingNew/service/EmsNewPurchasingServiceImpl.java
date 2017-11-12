package stxship.dis.ems.purchasingNew.service;

import java.io.File;
import java.io.FileInputStream;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.ArrayUtils;
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

import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.util.DisEGDecrypt;
import stxship.dis.common.util.DisExcelUtil;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.DisPageUtil;
import stxship.dis.common.util.DisStringUtil;
import stxship.dis.common.util.FileDownLoad;
import stxship.dis.common.util.GenericExcelView;
import stxship.dis.ems.common.dao.EmsCommonDAO;
import stxship.dis.ems.common.service.EmsCommonServiceImpl;
import stxship.dis.ems.purchasingNew.dao.EmsNewPurchasingDAO;

@Service("emsNewPurchasingService")
public class EmsNewPurchasingServiceImpl extends EmsCommonServiceImpl implements EmsNewPurchasingService {
	Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "emsNewPurchasingDAO")
	private EmsNewPurchasingDAO emsNewPurchasingDAO;

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
		return emsNewPurchasingDAO.emsPurchasingSelectBoxDept(commandMap.getMap());
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
		return emsNewPurchasingDAO.emsPurchasingAddSelectBoxPjt(commandMap.getMap());
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
		return emsNewPurchasingDAO.popUpPurchasingFosSelectBoxCauseDept(commandMap.getMap());
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
		return emsNewPurchasingDAO.popUpPurchasingFosSelectBoxPosType(commandMap.getMap());
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
		long fileSize = ((MultipartFile) pos_file).getSize();	
		String fileType = ((MultipartFile) pos_file).getContentType();
		
		String fileContentType = getFileContentType(fileType);
		
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
		ProjectId = emsNewPurchasingDAO.posSelectProjectId(commandMap.getMap());

		// EQUIP NAME을 받아옴
		EquipName = emsNewPurchasingDAO.posSelectEquipName(commandMap.getMap());

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
			rowData1.put("p_file_content_type", fileContentType);
			rowData1.put("p_file_name", fileName);
			// rowData1.put("p_blob", "EMPTY_BLOB()");
			rowData1.put("p_remark", sReason);
			rowData1.put("p_plm_user_id", loginId);
			rowData1.put("p_user_id", "");
			rowData1.put("p_login_id", "");
			rowData1.put("p_system", "EMS");
			emsNewPurchasingDAO.posGetFileId(rowData1);

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
			rowData2.put("p_file_Byte", multipartFile.getBytes()); //실제 파일 객체
			result = emsNewPurchasingDAO.posUploadFile(rowData2);

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
			emsNewPurchasingDAO.posInsertRow(rowData3);

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
			emsNewPurchasingDAO.posInsertSelectedFile(rowData4);

			// 에러 체크
			sErrMsg = DisStringUtil.nullString(rowData4.get("o_errbuff"));
			sErrCode = DisStringUtil.nullString(rowData4.get("o_retcode"));

			// 오류가 있으면 스탑
			if (!"".equals(sErrCode)) {
				throw new DisException(sErrMsg);
			}

			String message = "파일 업로드에 성공하였습니다.";
			DisEGDecrypt.deleteDecryptFile(DecryptFile);
			
			Map<String, Object> returnMap = DisMessageUtil.getResultObjMessage(DisConstants.RESULT_SUCCESS);
			returnMap.put("msg", message);
			returnMap.put("file_id",file_id);
			return returnMap;
		} catch (Exception e) {
			e.printStackTrace();
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, e.getLocalizedMessage());
			
			String message = e.getLocalizedMessage();
			Map<String, Object> returnMap = DisMessageUtil.getResultObjMessage(DisConstants.RESULT_FAIL);
			returnMap.put("msg", message);
			returnMap.put("file_id",file_id);
			return returnMap;
		}
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
		Map<String, Object> rs = emsNewPurchasingDAO.popUpPurchasingPosDownloadFile(commandMap.getMap());

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
			result += emsNewPurchasingDAO.emsPurchasingDeleteA(rowData);
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
	 * @메소드명 : purchasingRequestApply
	 * @날짜 : 2017. 04. 05.
	 * @작성자 : 조중호
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
	@SuppressWarnings("unchecked")
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> purchasingRequestApply(CommandMap commandMap) throws Exception {
		Map<String, Object> crtMap = commandMap.getMap();
		Map<String, Object> instMap = (Map<String, Object>) ((HashMap<String, Object>)commandMap.getMap()).clone();
		Map<String, Object> mailMap = (Map<String, Object>) ((HashMap<String, Object>)commandMap.getMap()).clone();
		
		int result = 0;
		
		result = emsNewPurchasingDAO.emsPurchasingReqCrtProc(crtMap); 
		
		if(result == 0) throw new DisException("승인요청에 실패했습니다.\nErrorMsg:"+crtMap.get("p_error_msg"));
		
		String[] ems_pur_no = ((String)commandMap.get("ems_pur_no")).split(","); 
		
		for(String ems_pur_no_each : ems_pur_no){
			result = 0;
			instMap.put("p_mail_seq_id", crtMap.get("p_mail_seq_id"));
			instMap.put("p_ems_pur_no", ems_pur_no_each);
			
			result = emsNewPurchasingDAO.emsPurchasingInstProc(instMap);
			
			if(result == 0) throw new DisException("승인요청에 실패했습니다.\nErrorMsg:"+instMap.get("p_error_msg"));
		}
		
		result = 0;
		mailMap.put("p_mail_seq_id", crtMap.get("p_mail_seq_id"));
		result = emsNewPurchasingDAO.emsPurchasingMailProc(mailMap);
		if(result == 0) throw new DisException("승인요청에 실패했습니다.\nErrorMsg:"+instMap.get("p_error_msg"));

		// 여기까지 Exception 없으면 성공 메시지
		Map<String, Object> resultMsg = DisMessageUtil.getResultObjMessage(DisConstants.RESULT_SUCCESS);
		return resultMsg;
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
			Map<String,Object> row = gridData.get(i);
			row.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			emsNewPurchasingDAO.emsPurchasingSpecApply(row);
			sErrMsg = DisStringUtil.nullString(row.get("p_error_msg"));

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
		ProjectId = emsNewPurchasingDAO.posSelectProjectId(commandMap.getMap());

		// EQUIP NAME을 받아옴
		EquipName = emsNewPurchasingDAO.posSelectEquipName(commandMap.getMap());
		
		for (int i=0; i<rowCnt; i++) {
			
			String p_tech_spec = "p_tech_spec_" + i;
			
			// 파일 객체 호출
			MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
			Object spec_file = multipartRequest.getFile(p_tech_spec);

			// 파일 정보
			String fileName = ((MultipartFile) spec_file).getOriginalFilename();
			long fileSize = ((MultipartFile) spec_file).getSize();	
			String fileType = ((MultipartFile) spec_file).getContentType();
			
			String fileContentType = getFileContentType(fileType);

			
			//파일 복호화
			File DecryptFile = null; 
			DecryptFile = DisEGDecrypt.createDecryptFile((MultipartFile) spec_file);
			
			FileInputStream input = new FileInputStream(DecryptFile);
			MultipartFile multipartFile = new MockMultipartFile("fileItem",
					DecryptFile.getName(), fileType, IOUtils.toByteArray(input));
			input.close();
			/*MultipartFile multipartFile = ((MultipartFile) spec_file);*/
			
			if ("".equals(fileName)) {
				throw new DisException("파일명이 존재하지 않습니다.");
			}
			if ("".equals(EquipName)) {
				throw new DisException("기자재명이 없습니다.");
			}
			if (fileSize > sizeLimit) {
				throw new DisException("용량 제한으로 인해 실패하였습니다. 파일 용량을 10MB 이하로 줄여서 업로드 해주십시오.");
			}
			
			
			
			// 호선, ITEM_ID를 인자로 주어 구매담당자 ID를 받아옴.
			Map<String, Object> rowData1 = new HashMap<>();
			rowData1.put("p_access_id", "");
			rowData1.put("p_access_flag", "1");
			rowData1.put("p_project_id", ProjectId);
			rowData1.put("p_project_no", sMaster);
			rowData1.put("p_equipment_name", EquipName);
			rowData1.put("p_doc_type_code", "100");
			rowData1.put("p_file_content_type", fileContentType);
			/*rowData1.put("p_file_content_type", "application/pdf");*/
			rowData1.put("p_file_name", fileName);
			// rowData1.put("p_blob", "EMPTY_BLOB()");
			rowData1.put("p_remark", sReason);
			rowData1.put("p_plm_user_id", loginId);
			rowData1.put("p_user_id", "");
			rowData1.put("p_login_id", "");
			rowData1.put("p_system", "EMS");
			emsNewPurchasingDAO.posGetFileId(rowData1);
			
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
			result = emsNewPurchasingDAO.posUploadFile(rowData2);

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
		// 그리드에서 받아온 엑셀 헤더를 설정한다.
		String[] p_col_names = commandMap.get("p_col_name").toString().split(",");

		// COLVALUE 설정
		List<List<String>> colValue = new ArrayList<List<String>>();
		// 그리드에서 받아온 데이터 네임을 배열로 설정
		String[] p_data_names = commandMap.get("p_data_name").toString().split(",");
		
		//표시 불가처리 colname
		String[] p_not_display_col_name = commandMap.get("p_not_display_col_name").toString().split(",");
		//표시 불가처리 value name
		String[] p_not_display_data_name = commandMap.get("p_not_display_data_name").toString().split(",");

		// 그리드의 헤더를 콜네임으로 설정
		for (String p_col_name : p_col_names) {
			if(ArrayUtils.indexOf(p_not_display_col_name, p_col_name) > -1){
				continue;
			}
			colName.add(p_col_name);
		}

		Map<String, Object> list = emsNewPurchasingDAO.emsPurchasingExcelExport(commandMap.getMap());
		List<Map<String, Object>> listData = (List<Map<String, Object>>)list.get("p_refer");

		for (Map<String, Object> rowData : listData) {

			List<String> row = new ArrayList<String>();

			// 데이터 네임을 이용해서 리스트에서 뽑아냄.
			for (String p_data_name : p_data_names) {
				if(ArrayUtils.indexOf(p_not_display_data_name, p_data_name) > -1){
					continue;
				}
				row.add(DisStringUtil.nullString(rowData.get(p_data_name)));
			}
			colValue.add(row);

		}
		if("ADD".equals(commandMap.get("type"))){
			modelMap.put("excelName", "EmsPurchasing_ADD");	
		} else {
			modelMap.put("excelName", "EmsPurchasing");
		}
		
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
				map.put("item_code", row.getCell(0) == null ? "" : DisExcelUtil.getCellValue(row.getCell(0))+"");
				map.put("item_desc", row.getCell(1) == null ? "" : DisExcelUtil.getCellValue(row.getCell(1))+"");
				map.put("ea", row.getCell(2) == null ? "" : DisExcelUtil.getCellValue(row.getCell(2))+"");
				map.put("location_no", row.getCell(3) == null ? "" : DisExcelUtil.getCellValue(row.getCell(3))+"");
				map.put("stage_no", row.getCell(4) == null ? "" : DisExcelUtil.getCellValue(row.getCell(4))+"");
				map.put("supply_type", row.getCell(5) == null ? "" : DisExcelUtil.getCellValue(row.getCell(5))+"");
				uploadList.add(map);
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
	 * 
	 * @메소드명	: selectEmsPurchasingMainList
	 * @날짜		: 2017. 3. 31.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * EMS MainGrid Search
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> selectEmsPurchasingMainList(CommandMap commandMap) throws Exception {
		// 리스트를 취득한다.
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		
		Map<String, Object> resultData = emsNewPurchasingDAO.selectEmsPurchasingMainList(commandMap.getMap());
		List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("p_refer");

		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = 0;
		if(listData.size() > 0) {
			listRowCnt = listData.size();
			listRowCnt = listData.get(0).get("ALL_CNT").toString();
		}
		
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
		result.put("totalCnt", listRowCnt);

		return result;
	}
	
	/**
	 * 
	 * @메소드명	: selectAutoCompleteDwgNoList
	 * @날짜		: 2017. 4. 3.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * ems 도면 자동완성
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	public String selectAutoCompleteDwgNoList(CommandMap commandMap) {
		List<Map<String, Object>> list = emsNewPurchasingDAO.emsDwgNoList(commandMap.getMap());
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
	 * @메소드명	: getEmsApprovedBoxDataList
	 * @날짜		: 2017. 4. 4.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * ems용 승인자 목록
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public String getEmsApprovedBoxDataList(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> list = emsNewPurchasingDAO.selectEmsApprovedBoxDataList(commandMap.getMap());

		String rtnString = "";
		String vType = DisStringUtil.nullString(commandMap.get("sb_type"));

		rtnString = "<option value=\"ALL\">ALL</option>";

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
	 * @메소드명	: selectPosChk
	 * @날짜		: 2017. 4. 5.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * POS전 검색 조건에서 project 및 dwg_no 체크
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String,Object> selectPosChk(CommandMap commandMap) throws Exception {
		return emsNewPurchasingDAO.selectPosChk(commandMap.getMap());
	}
	
	/**
	 * 
	 * @메소드명	: emsPurchasingPosList
	 * @날짜		: 2017. 4. 6.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *	EMS Purchasing Pos List
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> selectEmsPurchasingPosList(CommandMap commandMap) throws Exception {
		// 리스트를 취득한다.
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		
		Map<String, Object> resultData = emsNewPurchasingDAO.selectEmsPurchasingPosList(commandMap.getMap());
		List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("p_refer");

		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = 0;
		if(listData.size() > 0) {
			listRowCnt = listData.size();
			listRowCnt = listData.get(0).get("ALL_CNT").toString();
		}
		
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
		result.put("totalCnt", listRowCnt);

		return result;
	}
	/**
	 * 
	 * @메소드명	: makePosTempList
	 * @날짜		: 2017. 4. 10.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *	POS항목 호출시 기본적인 임시 정보 생성 
	 * </pre>
	 * @param commandMap
	 * @return mailSeq
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> makePosTempList(CommandMap commandMap) throws Exception {
		
		int result = 0;
		
		String[] ems_pur_no = ((String)commandMap.get("p_ems_pur_no")).split(",");
		
		for(String ems_pur_no_each : ems_pur_no){
			if(ems_pur_no_each == "") continue;
			result = 0;
			commandMap.put("p_ems_pur_no", ems_pur_no_each);
			
			result = emsNewPurchasingDAO.emsPurchasingPosChkProc(commandMap.getMap());
			
			if(result == 0) throw new DisException("POS호출에 실패했습니다.\nErrorMsg:"+commandMap.get("p_error_msg"));
		}
		// 여기까지 Exception 없으면 성공 메시지
		return	commandMap.getMap();
	}
	/**
	 * 
	 * @메소드명	: popUpPurchasingPosInsert
	 * @날짜		: 2017. 4. 11.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> popUpPurchasingPosInsert(CommandMap commandMap)throws Exception {
		List<Map<String, Object>> itemList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST));
		int result = 0;
		Map<String,Object> callbackM = null;
		for (Map<String, Object> rowData : itemList) {
			rowData.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			rowData.put("p_session_id", commandMap.get("p_session_id"));
			rowData.put("p_callback", DisStringUtil.nullString(commandMap.get("p_callback")));
			if (DisConstants.UPDATE.equals(rowData.get(DisConstants.FROM_GRID_OPER)) || DisConstants.INSERT.equals(rowData.get(DisConstants.FROM_GRID_OPER)))
			{
				result = emsNewPurchasingDAO.emsPurchasingPosInsertProc(rowData);
				if(!DisStringUtil.isNullString(String.valueOf(commandMap.get("p_callback")))){
					callbackM = rowData;
				}
			}

			if (result == 0 || !"S".equals(rowData.get("p_error_code"))) {
				throw new DisException("POS호출에 실패했습니다.\nErrorMsg:"+rowData.get("p_error_msg"));
			}
		}
		if(callbackM != null){
			Map<String,String> returnMap = DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
			returnMap.put("p_callbackmsg", String.valueOf(callbackM.get("p_callbackmsg")));
			return returnMap;
		} else {
			return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);	
		}
	}
	
	/**
	 * 
	 * @메소드명	: selectEmsPurchasingAddFisrtList
	 * @날짜		: 2017. 4. 13.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *EMS ADD MAIN First LIST
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> selectEmsPurchasingAddFisrtList(CommandMap commandMap) throws Exception {
		// 리스트를 취득한다.
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		
		Map<String, Object> resultData = emsNewPurchasingDAO.selectEmsPurchasingAddFisrtList(commandMap.getMap());
		List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("p_refer");

		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = 0;
		if(listData.size() > 0) {
			listRowCnt = listData.size();
			listRowCnt = listData.get(0).get("ALL_CNT").toString();
		}
		
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
		result.put("totalCnt", listRowCnt);

		return result;
	}
	
	/**
	 * 
	 * @메소드명	: makePurTempList
	 * @날짜		: 2017. 4. 14.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *	makeAddTmp
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> makePurTempList(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> itemList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST));
		int result = 0;
		
		result = emsNewPurchasingDAO.emsPurchasingAddTempDeleteProc(commandMap);
		if (result == 0) {
			throw new DisException("POS호출에 실패했습니다.\nErrorMsg:"+commandMap.get("p_error_msg"));
		}
		
		for (Map<String, Object> rowData : itemList) {
			rowData.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			rowData.put("p_session_id", commandMap.get("p_session_id"));
			rowData.put("p_work_flag", commandMap.get("p_work_flag"));
			rowData.put("p_project", commandMap.get("p_series"));
			rowData.put("p_master", commandMap.get("p_master"));
			
			
			result = emsNewPurchasingDAO.emsPurchasingAddTempInsertProc(rowData);
			if (result == 0) {
				throw new DisException("POS호출에 실패했습니다.\nErrorMsg:"+rowData.get("p_error_msg"));
			}
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);	
	}

	@Override
	public Map<String, Object> selectEmsPurchasingAddSecondList(CommandMap commandMap) throws Exception {
		// 리스트를 취득한다.
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		
		Map<String, Object> resultData = emsNewPurchasingDAO.selectEmsPurchasingAddSecondList(commandMap.getMap());
		List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("p_refer");

		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = 0;
		if(listData.size() > 0) {
			listRowCnt = listData.size();
			listRowCnt = listData.get(0).get("ALL_CNT").toString();
		}
		
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
		result.put("totalCnt", listRowCnt);

		return result;
	}
	
	/**
	 * 
	 * @메소드명	: popUpEmsPurchasingAddApply
	 * @날짜		: 2017. 4. 14.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *	Add Apply
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> popUpEmsPurchasingAddApply(CommandMap commandMap)throws Exception {
		List<Map<String, Object>> itemList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST));
		int result = 0;
		for (Map<String, Object> rowData : itemList) {
			rowData.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			rowData.put("p_session_id", commandMap.get("p_session_id"));
			
			result = emsNewPurchasingDAO.emsPurchasingPosApplyProc(rowData);

			if (result == 0 || !"S".equals(rowData.get("p_error_code"))) {
				throw new DisException("POS호출에 실패했습니다.\nErrorMsg:"+rowData.get("p_error_msg"));
			}
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);	
	}
	
	/**
	 * 
	 * @메소드명	: popUpPurchasingAddInstallTime
	 * @날짜		: 2017. 4. 17.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 설치 시점 리스트 박스
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@Override
	public List<Map<String, Object>> popUpPurchasingAddInstallTime(CommandMap commandMap) {
		return emsNewPurchasingDAO.popUpPurchasingAddInstallTime(commandMap.getMap());
	}
	
	/**
	 * 
	 * @메소드명	: popUpPurchasingAddInstallPosition
	 * @날짜		: 2017. 4. 17.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 설치 위치 리스트 박스
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@Override
	public List<Map<String, Object>> popUpPurchasingAddInstallLocation(CommandMap commandMap) {
		return emsNewPurchasingDAO.popUpPurchasingAddInstallLocation(commandMap.getMap());
	}
	
	/**
	 * 
	 * @메소드명	: selectDeleteChk
	 * @날짜		: 2017. 4. 18.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * delete before check
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> selectDeleteChk(CommandMap commandMap) throws Exception {
		int result = 0;
		
		String[] ems_pur_no = ((String)commandMap.get("p_ems_pur_no")).split(",");
		
		for(String ems_pur_no_each : ems_pur_no){
			if(ems_pur_no_each == "") continue;
			result = 0;
			commandMap.put("p_ems_pur_no", ems_pur_no_each);
			
			result = emsNewPurchasingDAO.emsPurchasingDelInstTempProc(commandMap.getMap());
			
			if(result == 0) throw new DisException("Delete항목 확인에 실패했습니다.\nErrorMsg:"+commandMap.get("p_error_msg"));
		}
		result = emsNewPurchasingDAO.emsPurchasingDelChkTempProc(commandMap.getMap());
		if(result == 0) throw new DisException("Delete항목 확인에 실패했습니다.\nErrorMsg:"+commandMap.get("p_error_msg"));
		// 여기까지 Exception 없으면 성공 메시지
		return	commandMap.getMap();
	}

	@Override
	public Map<String, Object> selectEmsPurchasingDeleteList(CommandMap commandMap) {
		// 리스트를 취득한다.
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		
		Map<String, Object> resultData = emsNewPurchasingDAO.selectEmsPurchasingDeleteList(commandMap.getMap());
		List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("p_refer");

		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = 0;
		if(listData.size() > 0) {
			listRowCnt = listData.size();
			listRowCnt = listData.get(0).get("ALL_CNT").toString();
		}
		
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
		result.put("totalCnt", listRowCnt);

		return result;
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> popUpEmsPurchasingDeleteApply(CommandMap commandMap) throws Exception {
		int result = 0;
		
		result = emsNewPurchasingDAO.emsPurchasingDeleteApply(commandMap.getMap());
		
		if (result == 0 || !"S".equals(commandMap.get("p_error_code"))) {
			throw new DisException("POS호출에 실패했습니다.\nErrorMsg:"+commandMap.get("p_error_msg"));
		}
		
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}
	
	/**
	 * 
	 * @메소드명	: selectEmsPurchasingModifyFirstList
	 * @날짜		: 2017. 4. 19.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *	modify first grid load data
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> selectEmsPurchasingModifyFirstList(CommandMap commandMap) throws Exception {
		// 리스트를 취득한다.
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		
		Map<String, Object> resultData = emsNewPurchasingDAO.selectEmsPurchasingModifyFirstList(commandMap.getMap());
		List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("p_refer");

		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = 0;
		if(listData.size() > 0) {
			listRowCnt = listData.size();
			listRowCnt = listData.get(0).get("ALL_CNT").toString();
		}
		
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
		result.put("totalCnt", listRowCnt);

		return result;
	}
	
	/**
	 * 
	 * @메소드명	: makeModifyTempList
	 * @날짜		: 2017. 4. 19.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * Modify Temp list make
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> makeModifyTempList(CommandMap commandMap) throws Exception 
	{
		int result = 0;
		
		String[] ems_pur_no = ((String)commandMap.get("p_ems_pur_no")).split(",");
		
		for(String ems_pur_no_each : ems_pur_no){
			if(ems_pur_no_each == "") continue;
			result = 0;
			commandMap.put("p_ems_pur_no", ems_pur_no_each);
			
			result = emsNewPurchasingDAO.emsPurchasingModifyTempInstProc(commandMap.getMap());
			
			if(result == 0) throw new DisException("수정팝업호출에 실패했습니다.\nErrorMsg:"+commandMap.get("p_error_msg"));
		}
		// 여기까지 Exception 없으면 성공 메시지
		return	commandMap.getMap();
	}

	@Override
	public Map<String, Object> selectEmsPurchasingModifySecondList(CommandMap commandMap) throws Exception {
		// 리스트를 취득한다.
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		
		Map<String, Object> resultData = emsNewPurchasingDAO.selectEmsPurchasingModifySecondList(commandMap.getMap());
		List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("p_refer");

		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = 0;
		if(listData.size() > 0) {
			listRowCnt = listData.size();
			listRowCnt = listData.get(0).get("ALL_CNT").toString();
		}
		
		// 라스트 페이지를 구한다.
		Object lastPageCnt = "page>total";
		if (!DisConstants.NO.equals(commandMap.get(DisConstants.IS_PAGING))) {
			lastPageCnt = DisPageUtil.getPageCount(pageSize, listRowCnt);
		}

		// 결과값 생성
		Map<String, Object> resultList = new HashMap<String, Object>();
		resultList.put(DisConstants.GRID_RESULT_CUR_PAGE, curPageNo);
		resultList.put(DisConstants.GRID_RESULT_LAST_PAGE, lastPageCnt);
		resultList.put(DisConstants.GRID_RESULT_RECORDS_CNT, listRowCnt);
		resultList.put(DisConstants.GRID_RESULT_DATA, listData);
		resultList.put("totalCnt", listRowCnt);

		return resultList;
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> selectEmsPurchasingModifyChkList(CommandMap commandMap) throws Exception 
	{
		List<Map<String, Object>> itemList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST));
		int result = 0;
		
		result = emsNewPurchasingDAO.emsPurchasingModifyTempDeleteProc(commandMap.getMap());
		if (result == 0) {
			throw new DisException("Modify호출에 실패했습니다.\nErrorMsg:"+commandMap.get("p_error_msg"));
		}
		
		for (Map<String, Object> rowData : itemList) {
			rowData.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			rowData.put("p_work_key", commandMap.get("p_work_key"));
			result = emsNewPurchasingDAO.emsPurchasingModifySecondTempInstProc(rowData);
			if (result == 0) {
				throw new DisException("Modify호출에 실패했습니다.\nErrorMsg:"+rowData.get("p_error_msg"));
			}
		}
		
		result = emsNewPurchasingDAO.emsPurchasingModifySecondChkProc(commandMap.getMap());
		if (result == 0) {
			throw new DisException("Modify호출에 실패했습니다.\nErrorMsg:"+commandMap.get("p_error_msg"));
		}
		
		return commandMap.getMap();
	}
	
	/**
	 * 
	 * @메소드명	: popUpEmsPurchasingAddApply
	 * @날짜		: 2017. 4. 14.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *	Add Apply
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> popUpEmsPurchasingModifyApply(CommandMap commandMap)throws Exception {
		List<Map<String, Object>> itemList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST));
		int result = 0;
		for (Map<String, Object> rowData : itemList) {
			rowData.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			rowData.put("p_work_key", commandMap.get("p_work_key"));
			
			result = emsNewPurchasingDAO.emsPurchasingPosModifyApplyProc(rowData);

			if (result == 0 || !"S".equals(rowData.get("p_error_code"))) {
				throw new DisException("POS호출에 실패했습니다.\nErrorMsg:"+rowData.get("p_error_msg"));
			}
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);	
	}
	/**
	 * 
	 * @메소드명	: popUpPurchasingSpecList
	 * @날짜		: 2017. 4. 25.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *
	 * </pre>
	 * @param request
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> popUpPurchasingSpecList(HttpServletRequest request, CommandMap commandMap) throws Exception {
		
		// 리스트를 취득한다.
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		
		Map<String, Object> resultData = emsNewPurchasingDAO.popUpPurchasingSpecList(commandMap.getMap());
		List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("p_refer");

		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = 0;
		if(listData.size() > 0) {
			listRowCnt = listData.size();
			listRowCnt = listData.get(0).get("ALL_CNT").toString();
		}
		
		// 라스트 페이지를 구한다.
		Object lastPageCnt = "page>total";
		if (!DisConstants.NO.equals(commandMap.get(DisConstants.IS_PAGING))) {
			lastPageCnt = DisPageUtil.getPageCount(pageSize, listRowCnt);
		}

		// 결과값 생성
		Map<String, Object> resultList = new HashMap<String, Object>();
		resultList.put(DisConstants.GRID_RESULT_CUR_PAGE, curPageNo);
		resultList.put(DisConstants.GRID_RESULT_LAST_PAGE, lastPageCnt);
		resultList.put(DisConstants.GRID_RESULT_RECORDS_CNT, listRowCnt);
		resultList.put(DisConstants.GRID_RESULT_DATA, listData);
		resultList.put("totalCnt", listRowCnt);
		return resultList;
	}
	
	public String getFileContentType(String fileType){
		if (fileType.equals("hwp")){
			return "application/x-hwp";
		} else if (fileType.equals("pdf")){
			return "application/pdf";
		} else if (fileType.equals("ppt") || fileType.equals("pptx")){
			return "application/vnd.ms-powerpoint";
		} else if (fileType.equals("doc") || fileType.equals("docx")){
			return "application/msword";
		} else if (fileType.equals("xls") || fileType.equals("xlsx")){
			return "application/vnd.ms-excel";
		} else {
			return "application/octet-stream";
		}
	}

	@Override
	public List<Map<String, Object>> popUpPurchasingSpecDownList(CommandMap commandMap) {
		return emsNewPurchasingDAO.selectEmsPurchasingSpecDownList(commandMap.getMap());
	}
}
