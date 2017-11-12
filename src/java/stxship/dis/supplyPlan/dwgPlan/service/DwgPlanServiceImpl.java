package stxship.dis.supplyPlan.dwgPlan.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.View;

import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.DisPageUtil;
import stxship.dis.common.util.GenericExcelView;
import stxship.dis.paint.importPaint.dao.PaintImportPaintDAO;
import stxship.dis.supplyPlan.dwgPlan.dao.DwgPlanDAO;

@Service("dwgPlanService")
public class DwgPlanServiceImpl extends CommonServiceImpl implements DwgPlanService {

	Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name = "dwgPlanDAO")
	private DwgPlanDAO dwgPlanDAO;

	/** 
	 * @메소드명	: setSearchDwgPlanTemp
	 * @날짜		: 2016. 08. 10.
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 조회 조건을 temp 테이블에 입력
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> dwgPlanList(CommandMap commandMap) throws Exception {
		
		//해당 세션 TEMP 테이블 DELETE
		dwgPlanDAO.deletePlanTemp(commandMap.getMap());
		
		StringBuffer sb = new StringBuffer();
		for (int i = 1; i <= 7; i++) {
			int n = (int) (Math.random() * 9) + 1;
			sb.append(n);
		}
		System.out.println(sb.toString());
		
		commandMap.put("i_session_id", sb.toString() );
		
		//해당 세션으로 TEMP 테이블 INSRT
		dwgPlanDAO.insertPlanTemp(commandMap.getMap());
		
		// 리스트를 취득한다.
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		List<Map<String, Object>> listData = getGridData(commandMap.getMap());

		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = listData.size();
//		if (!DisConstants.NO.equals(commandMap.get(DisConstants.IS_PAGING))) {
//			listRowCnt = getGridListSize(commandMap.getMap());
//		}
		// 라스트 페이지를 구한다.
		Object lastPageCnt = "page>total";
//		if (!DisConstants.NO.equals(commandMap.get(DisConstants.IS_PAGING))) {
//			lastPageCnt = DisPageUtil.getPageCount(pageSize, listRowCnt);
//		}

		// 결과값 생성
		Map<String, Object> result = new HashMap<String, Object>();
		result.put(DisConstants.GRID_RESULT_CUR_PAGE, curPageNo);
		result.put(DisConstants.GRID_RESULT_LAST_PAGE, lastPageCnt);
		result.put(DisConstants.GRID_RESULT_RECORDS_CNT, listRowCnt);
		result.put(DisConstants.GRID_RESULT_DATA, listData);

		result.put("resultMsg", DisMessageUtil.getResultObjMessage(DisConstants.RESULT_SUCCESS));

		
		return result;
	}

	/** 
	 * @메소드명	: saveDwgPlan
	 * @날짜		: 2016. 08. 10.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 * PLAN 테이블에 저장
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> saveDwgPlan(CommandMap commandMap) throws Exception {
		
		List<Map<String, Object>> rowData = DisJsonUtil.toList(commandMap.get("chmResultList"));
		for(int i=0; i<rowData.size(); i++){
			rowData.get(i).put("loginId", commandMap.get("loginId"));
			
			//PLAN 테이블에 해당 데이터 여부 확인
//			Map<String, Object> countDwgPlan = dwgPlanDAO.countDwgPlan(rowData.get(i));
//			String cnt = (String) countDwgPlan.get("cnt");
			String cnt = dwgPlanDAO.countDwgPlan(rowData.get(i));
			String result_yn = (String) rowData.get(i).get("result_yn");

			//PLAN 테이블에 해당 데이터 없으면 INSERT
			if("0".equals(cnt)){
				//RESULT 에 체크된경우 사용자가 입력한 실적물량이 저장되도록 한다.
				if("Y".equals(result_yn)){
					dwgPlanDAO.insertDwgPlanResult(rowData.get(i));
				} else {
					dwgPlanDAO.insertDwgPlan(rowData.get(i));
				}
			}
			//PLAN 테이블에 해당 데이터 있으면 UPDATE
			else {
				//RESULT 에 체크된경우 사용자가 입력한 실적물량이 저장되도록 한다.
				if("Y".equals(result_yn)){
					dwgPlanDAO.updateDwgPlanResult(rowData.get(i));
				} else {
					dwgPlanDAO.updateDwgPlan(rowData.get(i));
				}
			}
			
			
		}

		// 여기까지 Exception 없으면 성공 메시지
		Map<String, Object> resultMsg = DisMessageUtil.getResultObjMessage(DisConstants.RESULT_SUCCESS);
		return resultMsg;
	}
	
	/** 
	 * @메소드명	: popUpDwgPlanReasonDetail
	 * @날짜		: 2016. 08. 17.
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 설계계획물량관리 조회
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> popUpDwgPlanReasonDetail(CommandMap commandMap) throws Exception {
		return dwgPlanDAO.popUpDwgPlanReasonDetail(commandMap.getMap());
	}
	
	/** 
	 * @메소드명	: popUpDwgPlanReasonDetail2
	 * @날짜		: 2016. 08. 17.
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 설계계획물량관리 REASON 상세 내역
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> popUpDwgPlanReasonDetail2(CommandMap commandMap) throws Exception {
		return dwgPlanDAO.popUpDwgPlanReasonDetail2(commandMap.getMap());
	}

	/** 
	 * @메소드명	: popUpDwgPlanSaveReason
	 * @날짜		: 2016. 08. 17.
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 
	 * REASON 메인그리드 저장
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> popUpDwgPlanSaveReason(CommandMap commandMap) throws Exception {
		
		List<Map<String, Object>> rowData = DisJsonUtil.toList(commandMap.get("chmResultList"));
		//중복 방지를 위해 삭제부터 처리
		for(int i=0; i<rowData.size(); i++){
			if( "D".equals(rowData.get(i).get("oper")) ){
				rowData.get(i).put("loginId", commandMap.get("loginId"));
				dwgPlanDAO.popUpDwgPlanReasonDelete(rowData.get(i));
			}
		}
		//추가 처리
		for(int i=0; i<rowData.size(); i++){
			if( "I".equals(rowData.get(i).get("oper")) ){
				rowData.get(i).put("loginId", commandMap.get("loginId"));
				dwgPlanDAO.popUpDwgPlanReasonInsert(rowData.get(i));
			}
		}
		//수정 처리
		for(int i=0; i<rowData.size(); i++){
			if( "U".equals(rowData.get(i).get("oper")) ){
				rowData.get(i).put("loginId", commandMap.get("loginId"));
				dwgPlanDAO.popUpDwgPlanReasonUpdate(rowData.get(i));
			}
		}

		// 여기까지 Exception 없으면 성공 메시지
		Map<String, Object> resultMsg = DisMessageUtil.getResultObjMessage(DisConstants.RESULT_SUCCESS);
		return resultMsg;
	}
	
	/** 
	 * @메소드명	: downloadReasonFile
	 * @날짜		: 2016. 08. 19.
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 파일 다운로드
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@Override
	public void downloadReasonFile(CommandMap commandMap, HttpServletResponse response) throws Exception {
		Map<String, Object> rs = dwgPlanDAO.downloadReasonFile(commandMap.getMap());

		byte[] data = (byte[]) rs.get("fileDataBytes");
		String contentType = (String) rs.get("FILE_CONTENT_TYPE");
		String filename = (String) rs.get("FILE_NAME");

		String docName = new String(filename.getBytes("euc-kr"), "8859_1");
		response.setHeader("Content-Disposition", "attachment; filename=\"" + docName + "\"");
		response.setHeader("Content-Type", contentType);
		response.setContentLength(data.length);
		response.setHeader("Content-Transfer-Encoding", "binary;");
		response.setHeader("Pragma", "no-cache;");
		response.setHeader("Expires", "-1;");

		ServletOutputStream out = response.getOutputStream();
		out.write(data);
		out.flush();
		out.close();
	}
	
	/** 
	 * @메소드명	: saveReasonFile
	 * @날짜		: 2016. 08. 17.
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 파일업로드 팝업창에서 저장
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@Override
	public Map<String, String> saveReasonFile(CommandMap commandMap, HttpServletRequest request) throws Exception {
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
		int result = 0;
		Object formfile = multipartRequest.getFile("formfile");
		if (!(formfile == null || "".equals(formfile))) {
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("originalFileName", ((CommonsMultipartFile) formfile).getOriginalFilename());
			param.put("uploadFile", ((CommonsMultipartFile) formfile).getBytes());
			param.put("commentes", commandMap.get("commentes"));
			param.put("seq", commandMap.get("seq"));
			param.put("loginId", commandMap.get("loginId"));
			param.put("contentType", ((CommonsMultipartFile) formfile).getContentType());
			result = dwgPlanDAO.insert("reasonFile.saveReasonFile", param);

		}

		if (result == 0) {
			throw new DisException();
		}

		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}
	
	/** 
	 * @메소드명	: delReasonFile
	 * @날짜		: 2016. 08. 17.
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 파일삭제
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */	
	@Override
	public Map<String, String> delReasonFile(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> formFileList = DisJsonUtil.toList(commandMap.get("chmResultList"));

		for (Map<String, Object> rowData : formFileList) {
			dwgPlanDAO.delete("reasonFile.deleteReasonFile", rowData);
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}
	
	/**
	 * @메소드명 : dwgPlanExcelExport
	 * @날짜 : 2016. 09. 23.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 엑셀 출력을 실행
	 * 
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public View dwgPlanExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {

		// COLNAME 설정
		List<String> colName = new ArrayList<String>();
		colName.add("PROJECT");
		colName.add("항목");
		colName.add("GROUP");
		colName.add("직종");
		colName.add("DESCRIPTION");
		colName.add("UOM");
		colName.add("부서");
		colName.add("견적항목");
		colName.add("견적물량(A)");
		colName.add("사업계획물량(B)");
		colName.add("실적물량(D)");
		colName.add("달성률(D/B)");
		colName.add("REASON");

		// COLVALUE 설정
		List<List<String>> colValue = new ArrayList<List<String>>();

		//해당 세션 TEMP 테이블 DELETE
		dwgPlanDAO.deletePlanTemp(commandMap.getMap());
		
		StringBuffer sb = new StringBuffer();
		for (int i = 1; i <= 7; i++) {
			int n = (int) (Math.random() * 9) + 1;
			sb.append(n);
		}
		
		commandMap.put("i_session_id", sb.toString() );
		
		//해당 세션으로 TEMP 테이블 INSRT
		dwgPlanDAO.insertPlanTemp(commandMap.getMap());
		
		// 리스트를 취득한다.
		//List<Map<String, Object>> list = getGridData(commandMap.getMap());
		
		List<Map<String, Object>> list = dwgPlanDAO.selectPlanTemp(commandMap.getMap());
		
		
		for (Map<String, Object> rowData : list) {
			// Map을 리스트로 변경
			List<String> row = new ArrayList<String>();

			row.add((String) rowData.get("project"));
			row.add((String) rowData.get("supply_id"));
			row.add((String) rowData.get("group1"));
			row.add((String) rowData.get("group2"));
			row.add((String) rowData.get("description"));
			row.add((String) rowData.get("uom"));
			row.add((String) rowData.get("dept"));
			row.add((String) rowData.get("join_data"));
			if(rowData.get("estimate_supply") != null ){
				row.add( ((String)rowData.get("estimate_supply")).replaceAll(",","") );
			}
			else{
				row.add("");
			}
			if(rowData.get("purpose_supply") != null ){
				row.add( ((String)rowData.get("purpose_supply")).replaceAll(",","") );
			}
			else{
				row.add("");
			}
			if(rowData.get("result_supply") != null){
				row.add( ((String)rowData.get("result_supply")).replaceAll(",","") );
			}
			else{
				row.add("");
			}
			row.add((String) rowData.get("purpose_rate"));
			row.add((String) rowData.get("reason"));

			colValue.add(row);
		}
		
				
		modelMap.put("excelName", "dwgPlan");
		modelMap.put("colName", colName);
		modelMap.put("colValue", colValue);

		return new GenericExcelView();

	}
}
