package stxship.dis.supplyPlan.dwgPlan.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface DwgPlanService extends CommonService{

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
	Map<String, Object> dwgPlanList(CommandMap commandMap) throws Exception;
	
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
	Map<String, Object> saveDwgPlan(CommandMap commandMap) throws Exception;
	
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
	Map<String, Object> popUpDwgPlanReasonDetail(CommandMap commandMap) throws Exception;
	
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
	Map<String, Object> popUpDwgPlanReasonDetail2(CommandMap commandMap) throws Exception;

	/** 
	 * @메소드명	: popUpDwgPlanSaveReason
	 * @날짜		: 2016. 08. 17.
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * REASON 메인그리드 저장
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	Map<String, Object> popUpDwgPlanSaveReason(CommandMap commandMap) throws Exception;
	
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
	void downloadReasonFile(CommandMap commandMap, HttpServletResponse response) throws Exception;
	
	/** 
	 * @메소드명	: saveReasonFile
	 * @날짜		: 2016. 08. 19.
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 파일업로드 팝업창에서 저장
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	Map<String, String> saveReasonFile(CommandMap commandMap, HttpServletRequest request) throws Exception;
	
	/** 
	 * @메소드명	: delReasonFile
	 * @날짜		: 2016. 08. 19.
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 파일삭제
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */	
	Map<String, String> delReasonFile(CommandMap commandMap) throws Exception ;
	
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
	View dwgPlanExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception;
}
