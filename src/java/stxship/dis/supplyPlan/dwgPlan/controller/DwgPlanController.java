package stxship.dis.supplyPlan.dwgPlan.controller;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.supplyPlan.dwgPlan.service.DwgPlanService;


/** 
 * @파일명	: DwgPlanController.java 
 * @프로젝트	: DIS
 * @날짜		: 2015. 12. 7. 
 * @작성자	: 강선중 
 * @설명
 * <pre>
 * Paint Plan 컨트롤러
 * </pre>
 */
@Controller
public class DwgPlanController extends CommonController {
	
	@Resource(name = "dwgPlanService")
	private DwgPlanService dwgPlanService;
	
	/** 
	 * @메소드명	: dwgPlan
	 * @날짜		: 2016. 08. 09.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 * 설계계획물량관리 모듈로 이동
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "dwgPlan.do")
	public ModelAndView dwgPlan(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/** 
	 * @메소드명	: dwgPlanList
	 * @날짜		: 2016. 08. 10.
	 * @작성자		: 이상빈
	 * @설명		: temp 테이블에 조회 조건을 입력
	 * <pre>
	 * 
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "dwgPlanList.do")
	public @ResponseBody Map<String, Object> dwgPlanList(CommandMap commandMap) throws Exception {
		return dwgPlanService.dwgPlanList(commandMap);
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
	@RequestMapping(value = "saveDwgPlan.do")
	public @ResponseBody Map<String, Object> saveDwgPlan(CommandMap commandMap) throws Exception {
		return dwgPlanService.saveDwgPlan(commandMap);
	}	
	
	/** 
	 * @메소드명	: popUpDwgPlanReason
	 * @날짜		: 2016. 08. 11.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 * 설계계획물량관리 REASON 팝업창 실행
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpDwgPlanReason.do")
	public ModelAndView popUpDwgPlanReason(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName(DisConstants.SUPPLY_PLAN + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}
	
	/** 
	 * @메소드명	: popUpDwgPlanReasonList
	 * @날짜		: 2016. 08. 16.
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 설계계획물량관리 REASON 리스트 조회
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpDwgPlanReasonList.do")
	public @ResponseBody Map<String, Object> popUpDwgPlanReasonList(CommandMap commandMap) {
		return dwgPlanService.getGridList(commandMap);
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
	 * @throws Exception 
	 */
	@RequestMapping(value = "popUpDwgPlanReasonDetail.do")
	public @ResponseBody Map<String, Object> popUpDwgPlanReasonDetail(CommandMap commandMap) throws Exception {
		return dwgPlanService.popUpDwgPlanReasonDetail(commandMap);
	}
	
	/** 
	 * @메소드명	: popUpDwgPlanReasonDetail2
	 * @날짜		: 2016. 08. 17.
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 설계계획물량관리 상세내역
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "popUpDwgPlanReasonDetail2.do")
	public @ResponseBody Map<String, Object> popUpDwgPlanReasonDetail2(CommandMap commandMap) throws Exception {
		return dwgPlanService.popUpDwgPlanReasonDetail2(commandMap);
	}

	/** 
	 * @메소드명	: reasonFile
	 * @날짜		: 2016. 08. 19.
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * REASON 파일 리스트 조회
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "reasonFile.do")
	public @ResponseBody Map<String, Object> reasonFile(CommandMap commandMap) {
		return dwgPlanService.getGridList(commandMap);
	}
	
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
	@RequestMapping(value = "popUpDwgPlanSaveReason.do")
	public @ResponseBody Map<String, Object> popUpDwgPlanSaveReason(CommandMap commandMap) throws Exception {
		return dwgPlanService.popUpDwgPlanSaveReason(commandMap);
	}
	
	/** 
	 * @메소드명	: popUpAddReasonFile
	 * @날짜		: 2016. 08. 17.
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 파일업로드 팝업창
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "popUpAddReasonFile.do")
	public ModelAndView popUpAddReasonFile(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName("/supplyPlan/popUp" + commandMap.get(DisConstants.JSP_NAME));
		return mav;
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
	@RequestMapping(value = "downloadReasonFile.do")
	public void downloadReasonFile(CommandMap commandMap, HttpServletResponse response) throws Exception {
		dwgPlanService.downloadReasonFile(commandMap, response);
	}
	
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
	@RequestMapping(value = "saveReasonFile.do")
	public @ResponseBody Map<String, String> saveReasonFile(CommandMap commandMap, HttpServletRequest request)
			throws Exception {
		return dwgPlanService.saveReasonFile(commandMap, request);
	}
	
	/** 
	 * @메소드명	: delReasonFile
	 * @날짜		: 2016. 08. 19.
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 파일 삭제
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */	
	@RequestMapping(value = "delReasonFile.do")
	public @ResponseBody Map<String, String> delReasonFile(CommandMap commandMap) throws Exception {
		return dwgPlanService.delReasonFile(commandMap);
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
	@RequestMapping(value = "dwgPlanExcelExport.do")
	public View dwgPlanExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return dwgPlanService.dwgPlanExcelExport(commandMap, modelMap);
	}
}
