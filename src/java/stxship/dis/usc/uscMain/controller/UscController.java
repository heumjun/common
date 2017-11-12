package stxship.dis.usc.uscMain.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.common.util.DisEGDecrypt;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.usc.uscMain.service.UscService;

/**
 * @파일명 : UscController.java
 * @프로젝트 : DIS
 * @날짜 : 2016. 10. 4.
 * @작성자 : 황성준
 * @설명
 * 
 *     <pre>
 * Usc의 컨트롤러
 * </pre>
 */
@Controller
public class UscController extends CommonController {
	@Resource(name = "uscService")
	private UscService uscService;	

	@RequestMapping(value = "popUpUscBlock.do")
	public ModelAndView popUpUscBlock(CommandMap commandMap) throws Exception {
		//commandMap.put("p_project_no", uscService.uscMasterCode(commandMap.getMap()));
		ModelAndView mav = new ModelAndView("usc/popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	@RequestMapping(value = "popUpUscVirtualBlock.do")
	public ModelAndView popUpUscVirtualBlock(CommandMap commandMap) throws Exception {
		//commandMap.put("p_project_no", uscService.uscMasterCode(commandMap.getMap()));
		ModelAndView mav = new ModelAndView("usc/popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	@RequestMapping(value = "popUpUscActivity.do")
	public ModelAndView popUpUscActivity(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("usc/popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	@RequestMapping(value = "popUpUscBom.do")
	public ModelAndView popUpUscBom(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("usc/popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	@RequestMapping(value = "popUpUscDelete.do")
	public ModelAndView popUpUscDelete(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("usc/popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	@RequestMapping(value = "popUpUscJobCreateAdd.do")
	public ModelAndView popUpUscJobCreateAdd(CommandMap commandMap) throws Exception {
		commandMap.put("p_master_no", uscService.uscMasterCode(commandMap.getMap()));
		ModelAndView mav = new ModelAndView("usc/popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	@RequestMapping(value = "popUpUscJobCreateMove.do")
	public ModelAndView popUpUscJobCreateMove(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("usc/popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	@RequestMapping(value = "popUpUscJobCreateBom.do")
	public ModelAndView popUpUscJobCreateBom(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("usc/popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	@RequestMapping(value = "popUpUscTableDetail.do")
	public ModelAndView popUpUscTableDetail(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("usc/popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/** 
	 * @메소드명	: uscActivityCatalogList
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * Activity Standard List 취득
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "uscActivityCatalogList.do")
	public @ResponseBody Map<String, Object> uscActivityCatalogList(CommandMap commandMap) {
		//return uscService.getUscActivityStdList(commandMap);
		return uscService.getUscList(commandMap);
	}
	
	/** 
	 * @메소드명	: uscJobCatalogList
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * Activity Standard List 취득
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "uscJobCatalogList.do")
	public @ResponseBody Map<String, Object> uscJobCatalogList(CommandMap commandMap) {
		//return uscService.getUscActivityStdList(commandMap);
		return uscService.getUscList(commandMap);
	}
	
	/** 
	 * @메소드명	: infoModelTypeList
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * 모델Type 셀렉트박스 취득
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoModelTypeList.do")
	public @ResponseBody List<Map<String, Object>> infoModelTypeList(CommandMap commandMap) {
		return uscService.getDbDataList(commandMap);
	}	
	
	/** 
	 * @메소드명	: infoAreaList
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * 모델Type 셀렉트박스 취득
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoAreaList.do")
	public @ResponseBody List<Map<String, Object>> infoAreaList(CommandMap commandMap) {
		return uscService.uscCodeNameList(commandMap);
	}
	
	/** 
	 * @메소드명	: infoBlockCataList
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * Block Catalog 셀렉트박스 취득
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoBlockCataList.do")
	public @ResponseBody List<Map<String, Object>> infoBlockCata(CommandMap commandMap) {
		return uscService.uscCodeNameList(commandMap);
	}
	
	/** 
	 * @메소드명	: infoBlockStrList
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * STR 셀렉트박스 취득
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoBlockStrList.do")
	public @ResponseBody List<Map<String, Object>> infoBlockStrList(CommandMap commandMap) {
		return uscService.uscCodeNameList(commandMap);
	}
	
	/** 
	 * @메소드명	: infoStrList
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * STR 셀렉트박스 취득
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoStrList.do")
	public @ResponseBody List<Map<String, Object>> infoStrList(CommandMap commandMap) {
		return uscService.uscCodeNameList(commandMap);
	}
	
	/** 
	 * @메소드명	: infoJobCreateBlock
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * BLOCK 셀렉트박스 취득
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoJobCreateMoveBlock.do")
	public @ResponseBody List<Map<String, Object>> infoJobCreateMoveBlock(CommandMap commandMap) {
		return uscService.uscCodeNameList(commandMap);
	}
	
	/** 
	 * @메소드명	: infoJobCreateStr
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * STR 셀렉트박스 취득
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoJobCreateMoveStr.do")
	public @ResponseBody List<Map<String, Object>> infoJobCreateMoveStr(CommandMap commandMap) {
		return uscService.uscCodeNameList(commandMap);
	}
	
	/** 
	 * @메소드명	: infoJobCreateJobStr
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * STR 셀렉트박스 취득
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoJobCreateMoveJobStr.do")
	public @ResponseBody List<Map<String, Object>> infoJobCreateMoveJobStr(CommandMap commandMap) {
		return uscService.uscCodeNameList(commandMap);
	}
	
	/** 
	 * @메소드명	: infoJobCreateMoveActCode
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * ACT CODE 셀렉트박스 취득
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoJobCreateMoveActCode.do")
	public @ResponseBody List<Map<String, Object>> infoJobCreateMoveActCode(CommandMap commandMap) {
		return uscService.uscCodeNameList(commandMap);
	}
	
	/** 
	 * @메소드명	: infoJobCreateActCode
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * ACT CODE 셀렉트박스 취득
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoJobCreateActCode.do")
	public @ResponseBody List<Map<String, Object>> infoJobCreateActCode(CommandMap commandMap) {
		return uscService.uscCodeNameList(commandMap);
	}	
	
	/** 
	 * @메소드명	: infoJobCreateJobCode
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * JOB CODE 셀렉트박스 취득
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoJobCreateJobCode.do")
	public @ResponseBody List<Map<String, Object>> infoJobCreateJobCode(CommandMap commandMap) {
		return uscService.uscCodeNameList(commandMap);
	}
	
	/**
	 * @메소드명 : infoUscSeriesProjectList
	 * @날짜 : 2016. 10. 4.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 *	시리즈 호선 선택하는 페이지
	 *	1. ADD Main 화면 사용
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoUscSeriesProjectList.do")
	public @ResponseBody ModelAndView infoUscSeriesProjectList(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("usc/" + commandMap.get(DisConstants.MAPPER_NAME));
		mav.addObject("seriesList", uscService.getUscList(commandMap).get("rows"));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	// --------------------------------------------------------
	// USC ACTIVITY STANDARD 관련
	// --------------------------------------------------------
	/** 
	 * @메소드명	: uscActivityStd
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * Activity Standard 화면으로 이동
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "uscActivityStd.do")
	public ModelAndView uscActivityStd(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}		
	
	/** 
	 * @메소드명	: uscActivityStdList
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * Activity Standard List 취득
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "uscActivityStdList.do")
	public @ResponseBody Map<String, Object> uscActivityStdList(CommandMap commandMap) {
		//return uscService.getUscActivityStdList(commandMap);
		return uscService.getUscList(commandMap);
	}
	
	/**
	 * @메소드명 : popUpUscActivityStdCatalogSearch
	 * @날짜 : 2016. 10. 4.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre> 
	 * USC Activity Catalog 팝업 호출
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpUscActivityStdCatalogSearch.do")
	public ModelAndView popUpUscActivityStdCatalogSearch(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}
	
	/**
	 * @메소드명 : infoUscActivityStdCatalogCode
	 * @날짜 : 2016. 10. 4.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * USC Activity Catalog 리스트 검색
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoUscActivityStdCatalogCode.do")
	public @ResponseBody Map<String, Object> infoUscActivityStdCatalogCode(CommandMap commandMap) {
		return uscService.getUscList(commandMap);
	}
	
	/**
	 * @메소드명 : popUpUscActivityJobCatalogSearch
	 * @날짜 : 2016. 10. 4.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre> 
	 * USC Job Catalog 팝업 호출
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpUscActivityJobCatalogSearch.do")
	public ModelAndView popUpUscActivityJobCatalogSearch(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}
	
	/**
	 * @메소드명 : infoUscJobCatalogCode
	 * @날짜 : 2016. 10. 4.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * USC Job Catalog 리스트 검색
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoUscActivityJobCatalogCode.do")
	public @ResponseBody Map<String, Object> infoUscActivityJobCatalogCode(CommandMap commandMap) {
		return uscService.getUscList(commandMap);
	}
	
	/**
	 * @메소드명 : activityJobCatalogCheck
	 * @날짜 : 2016. 10. 4.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * USC Job Catalog 리스트 검색
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "activityJobCatalogCheck.do")
	public @ResponseBody Map<String, Object> activityJobCatalogCheck(CommandMap commandMap) {
		return uscService.getUscList(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: saveUscActivityStd
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * UscActivityStd 저장
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveUscActivityStd.do")
	public @ResponseBody Map<String, String> saveUscActivityStd(CommandMap commandMap) throws Exception {
		return uscService.saveUscActivityStd(commandMap); 
	}
	
	/**
	 * 
	 * @메소드명	: uscActivityStdExcelExport
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * ActivityStd 엑셀 출력
	 * </pre>
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "uscActivityStdExcelExport.do")
	public View uscActivityStdExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return uscService.uscExcelExport(commandMap, modelMap);
	}
	
	/**
	 * @메소드명 : excelImport
	 * @날짜 : 2016. 10. 4.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 *	EXCEL IMPORT 페이지
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpUscActivityStdExcelImport.do")
	public ModelAndView popUpUscActivityStdExcelImport(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : uscActivityStdExcelImportAction
	 * @날짜 : 2016. 10. 4.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 *		엑셀 업로드
	 *     </pre>
	 * 
	 * @param file
	 * @param commandMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "uscActivityStdExcelImportAction.do")
	public void uscActivityStdExcelImportAction(@RequestParam(value = "fileName") MultipartFile file, CommandMap commandMap, HttpServletResponse response) throws Exception {
		
		//파일 복호화
		File DecryptFile = null; 
		DecryptFile = DisEGDecrypt.createDecryptFile(file);
		
		commandMap.put("file", DecryptFile);
		List<Map<String, Object>> list = uscService.uscActivityStdExcelImportAction(commandMap);
		
		//복화화된 파일 삭제
		DisEGDecrypt.deleteDecryptFile(DecryptFile);
		
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		response.getWriter().write(DisJsonUtil.listToJsonstring(list));
	}
	
	// --------------------------------------------------------
	// USC ACTIVITY JOB 관련
	// --------------------------------------------------------		
	/**
	 * @메소드명 : uscActivityJob
	 * @날짜 : 2016. 10. 4.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * USC ACTIVITY JOB 화면으로이동
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "uscActivityJob.do")
	public ModelAndView uscActivityJob(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : uscActivityJobList
	 * @날짜 : 2016. 10. 4.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * USC ACTIVITY JOB 리스트 취득(페이징포함)
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "uscActivityJobList.do")
	public @ResponseBody Map<String, Object> uscActivityJobList(CommandMap commandMap) {
		//return uscService.getGridList(commandMap);
		return uscService.getUscList(commandMap);
	}
	
	/**
	 * @메소드명 : popUpUscActivityStdCatalogSearch1
	 * @날짜 : 2016. 10. 4.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre> 
	 * USC Activity Catalog 팝업 호출
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpUscActivityStdCatalogSearch1.do")
	public ModelAndView popUpUscActivityStdCatalogSearch1(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}
	
	/**
	 * @메소드명 : infoUscActivityJobCata
	 * @날짜 : 2016. 10. 4.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * USC Activity Catalog 리스트 검색
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoUscActivityJobCata.do")
	public @ResponseBody Map<String, Object> infoUscActivityJobCata(CommandMap commandMap) {
		return uscService.getUscList(commandMap);
	}
	
	/**
	 * @메소드명 : popUpUscActivityJobCatalogSearch1
	 * @날짜 : 2016. 10. 4.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre> 
	 * USC Job Catalog 팝업 호출
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpUscActivityJobCatalogSearch1.do")
	public ModelAndView popUpUscActivityJobCatalogSearch1(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : saveUscActivityJob
	 * @날짜 : 2016. 10. 4.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * USC ACTIVITY JOB 저장
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveUscActivityJob.do")
	public @ResponseBody Map<String, String> saveUscActivityJob(CommandMap commandMap) throws Exception {
		//return uscService.saveGridList(commandMap);
		return uscService.saveUscActivityStd(commandMap); 
	}
	
	/**
	 * 
	 * @메소드명	: uscActivityJobExcelExport
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * ActivityStd 엑셀 출력
	 * </pre>
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "uscActivityJobExcelExport.do")
	public View uscActivityJobExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return uscService.uscExcelExport(commandMap, modelMap);
	}
	
	/**
	 * @메소드명 : excelImport
	 * @날짜 : 2016. 10. 4.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 *	EXCEL IMPORT 페이지
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpUscActivityJobExcelImport.do")
	public ModelAndView popUpUscActivityJobExcelImport(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}
	
	// --------------------------------------------------------
	// USC JOB CREATE 관련
	// --------------------------------------------------------
	/**
	 * @메소드명 : uscJobCreate
	 * @날짜 : 2016. 10. 4.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *  <pre>
	 * 	UscJobCreate 화면 이동
	 * 	</pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "uscJobCreate.do")
	public ModelAndView uscJobCreate(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}	
	
	/**
	 * @메소드명 : uscJobCreateList
	 * @날짜 : 2016. 10. 4.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * USC JOB CREATE 리스트 취득(페이징포함)
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "uscJobCreateList.do")
	public @ResponseBody Map<String, Object> uscJobCreateList(CommandMap commandMap) {
		return uscService.getUscList(commandMap);
	}
	
	/**
	 * @메소드명 : jobCreateAddCheck
	 * @날짜 : 2016. 10. 4.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * act 아이템 코드 취득
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "jobCreateAddCheck.do")
	public @ResponseBody List<Map<String, Object>> jobCreateAddCheck(CommandMap commandMap) throws Exception {
		return uscService.jobCreateAddCheck(commandMap);
	}
	
	/**
	 * @메소드명 : jobCreateMoveCheck
	 * @날짜 : 2016. 10. 4.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * act 아이템 코드 취득
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "jobCreateMoveCheck.do")
	public @ResponseBody Map<String, Object> jobCreateMoveCheck(CommandMap commandMap) throws Exception {
		return uscService.jobCreateMoveCheck(commandMap.getMap());
	}
	
	/**
	 * 
	 * @메소드명	: saveUscJobCreateEco
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * saveUscJobCreateEco 저장
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveUscJobCreateEco.do")
	public @ResponseBody Map<String, String> saveUscJobCreateEco(CommandMap commandMap) throws Exception {
		return uscService.saveUscJobCreateEco(commandMap); 
	}
	
	/**
	 * 
	 * @메소드명	: uscJobCreateExcelExport
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * JobCreate 엑셀 출력
	 * </pre>
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "uscJobCreateExcelExport.do")
	public View uscJobCreateExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return uscService.uscExcelExport(commandMap, modelMap);
	}
	
	/**
	 * 
	 * @메소드명	: deleteUscJobCreate
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * UscJobCreate 삭제
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "deleteUscJobCreate.do")
	public @ResponseBody Map<String, String> deleteUscJobCreate(CommandMap commandMap) throws Exception {
		return uscService.saveUscJobCreateEco(commandMap); 
	}
	
	/**
	 * @메소드명 : restoreUscJobCreate
	 * @날짜 : 2016. 10. 4.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * restoreUscJobCreate
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "restoreUscJobCreate.do")
	public @ResponseBody Map<String, String> restoreUscJobCreate(CommandMap commandMap) throws Exception {
		return uscService.restoreUscJobCreate(commandMap);
	}
	
	/**
	 * @메소드명 : cancelUscJobCreate
	 * @날짜 : 2016. 10. 4.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * cancelUscJobCreate
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "cancelUscJobCreate.do")
	public @ResponseBody Map<String, String> cancelUscJobCreate(CommandMap commandMap) throws Exception {
		return uscService.cancelUscJobCreate(commandMap);
	}
	
	/**
	 * @메소드명 : uscJobCreateEconoCreate
	 * @날짜 : 2016. 10. 4.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * econo 취득
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "uscJobCreateEconoCreate.do")
	public @ResponseBody Map<String, Object> uscJobCreateEconoCreate(CommandMap commandMap) throws Exception {
		return uscService.uscJobCreateEconoCreate(commandMap.getMap());
	}
	
	// --------------------------------------------------------
	// USC MAIN 관련
	// --------------------------------------------------------
	/**
	 * @메소드명 : uscMain
	 * @날짜 : 2016. 10. 4.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * Usc Main 화면 이동
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "uscMain.do")
	public ModelAndView uscMain(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}	
	
	/**
	 * @메소드명 : uscMainList
	 * @날짜 : 2016. 10. 4.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * USC ACTIVITY JOB 리스트 취득(페이징포함)
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "uscMainList.do")
	public @ResponseBody Map<String, Object> uscMainList(CommandMap commandMap) {
		return uscService.getUscList(commandMap);
	}
	
	/**
	 * @메소드명 : popUpUscUpperBlockSearch
	 * @날짜 : 2016. 10. 4.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre> 
	 * popUpUscUpperBlock 팝업 호출
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpUscUpperBlockSearch.do")
	public ModelAndView popUpUscUpperBlockSearch(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}
	
	/**
	 * @메소드명 : infoUscUpperBlockCode
	 * @날짜 : 2016. 10. 4.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * infoUscUpperBlockCode 리스트 검색
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoUscUpperBlockCode.do")
	public @ResponseBody Map<String, Object> infoUscUpperBlockCode(CommandMap commandMap) {
		return uscService.getUscList(commandMap);
	}
	
	/** 
	 * @메소드명	: uscBlockImportCheck
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * uscBlockImportCheck
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "uscBlockImportCheck.do")
	public @ResponseBody List<Map<String, Object>> uscBlockImportCheck(CommandMap commandMap) throws Exception {
		/*Map<String, Object> resultMap = new HashMap<String, Object>();
		String str = uscService.uscAreaCodeName(commandMap.getMap());
		resultMap.put("area_name", str);
		String str1 = uscService.uscBlockImportCheck(commandMap.getMap());
		resultMap.put("chk", str1);
		resultMap.put("area", commandMap.get("p_area"));
		resultMap.put("block", commandMap.get("p_block"));
		resultMap.put("bk_code", commandMap.get("p_bk_code"));
		resultMap.put("block_str_flag", commandMap.get("p_block_str_flag"));
		return resultMap;*/
		return uscService.uscBlockImportCheck(commandMap);
	}
	
	/**
	 * @메소드명 : useJobActAction
	 * @날짜 : 2016. 10. 4.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * useJobActAction
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "useJobActAction.do")
	public @ResponseBody Map<String, String> useJobActAction(CommandMap commandMap) throws Exception {
		return uscService.useJobActAction(commandMap);
	}
	
	/** 
	 * @메소드명	: uscActivityImport
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * uscActivityImport
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "uscActivityImport.do")
	public @ResponseBody Map<String, Object> uscActivityImport(CommandMap commandMap) throws Exception {
		//return uscService.getUscList(commandMap);
		return uscService.useActivityImport(commandMap);
	}
	
	/** 
	 * @메소드명	: uscVirtualBlockImport
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * uscVirtualBlockImport
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "uscVirtualBlockImport.do")
	public @ResponseBody Map<String, Object> uscVirtualBlockImport(CommandMap commandMap) throws Exception {
		return uscService.getUscList(commandMap);
	}
	
	/** 
	 * @메소드명	: uscActivityImportCheck
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * uscActivityImportCheck
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "uscActivityImportCheck.do")
	public @ResponseBody Map<String, Object> uscActivityImportCheck(CommandMap commandMap) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		String str = uscService.uscActivityImportCheck(commandMap);
		map.put("msg", str);
		return map;
	}
	
	/** 
	 * @메소드명	: uscVirtualBlockImportCheck
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * uscActivityImportCheck
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "uscVirtualBlockImportCheck.do")
	public @ResponseBody Map<String, Object> uscVirtualBlockImportCheck(CommandMap commandMap) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		String str = uscService.uscVirtualBlockImportCheck(commandMap);
		map.put("msg", str);
		return map;
	}
	
	/**
	 * 
	 * @메소드명	: saveUscMain
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * UscActivityStd 저장
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveUscMain.do")
	public @ResponseBody Map<String, String> saveUscMain(CommandMap commandMap) throws Exception {
		return uscService.saveUscActivityStd(commandMap); 
	}
	
	/**
	 * 
	 * @메소드명	: deleteUscMain
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * UscActivityStd 삭제
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "deleteUscMain.do")
	public @ResponseBody Map<String, String> deleteUscMain(CommandMap commandMap) throws Exception {
		return uscService.saveUscActivityStd(commandMap); 
	}
	
	/**
	 * 
	 * @메소드명	: restoreUscMain
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * UscActivityStd RESTORE
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "restoreUscMain.do")
	public @ResponseBody Map<String, String> restoreUscMain(CommandMap commandMap) throws Exception {
		return uscService.saveUscActivityStd(commandMap); 
	}
	
	/**
	 * 
	 * @메소드명	: saveUscMainEco
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * saveUscMainEco 저장
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveUscMainEco.do")
	public @ResponseBody Map<String, String> saveUscMainEco(CommandMap commandMap) throws Exception {
		return uscService.saveUscMainEco(commandMap); 
	}
	
	/**
	 * 
	 * @메소드명	: uscMainExcelExport
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * UseMain 엑셀 출력
	 * </pre>
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "uscMainExcelExport.do")
	public View uscMainExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return uscService.uscExcelExport(commandMap, modelMap);
	}
	
	/**
	 * @메소드명 : uscMainEconoCreate
	 * @날짜 : 2016. 10. 4.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * econo 취득
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "uscMainEconoCreate.do")
	public @ResponseBody Map<String, Object> uscMainEconoCreate(CommandMap commandMap) throws Exception {
		return uscService.uscMainEconoCreate(commandMap.getMap());
	}
	
	/**
	 * @메소드명 : uscBlockExportList
	 * @날짜 : 2016. 10. 4.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * econo 취득
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "uscBlockExportList.do")
	public @ResponseBody Map<String, Object> uscBlockExportList(CommandMap commandMap) throws Exception {
		// 제이슨 데이터를 List Map 형식으로 형변환하기 위한 타입참조
		TypeReference<List<HashMap<String, Object>>> typeRef = new TypeReference<List<HashMap<String, Object>>>() {
		};
		// 그리드로부터 데이타리스트를 제이슨 형식으로 받아온다.
		String gridDataList = commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString();
		commandMap.remove(DisConstants.FROM_GRID_DATA_LIST);
		// List Map 형식으로 형변환
		List<Map<String, Object>> saveList = new ObjectMapper().readValue(gridDataList, typeRef);
		List<Map<String, Object>> newList = new ArrayList<Map<String, Object>>();
		
		for(Map<String, Object> rowData : saveList) {			
			Map<String, Object> newMap = new HashMap<String, Object>();
			newMap.put("state_flag", "A");
			newMap.put("project_no", rowData.get("project_no"));
			newMap.put("area", rowData.get("area"));
			newMap.put("block_no", rowData.get("block"));
			newMap.put("str_flag", rowData.get("block_str_flag"));
			newMap.put("block_str_flag", rowData.get("block_str_flag"));
			newMap.put("block_code", rowData.get("bk_code"));
			newMap.put("oper", "I");
			newList.add(newMap);			
		}

		Collections.sort(newList, new Comparator<Map<String, Object >>() {
            @Override
            public int compare(Map<String, Object> first, Map<String, Object> second) {
                return (first.get("project_no").toString()).compareTo(second.get("project_no").toString()); //ascending order
                //return ((Integer) second.get("DOC_ID")).compareTo((Integer) first.get("DOC_ID")); //descending order
            }
        });

		Map<String, Object> result = new HashMap<String, Object>();
		result.put(DisConstants.GRID_RESULT_DATA, newList);
		result.put(DisConstants.GRID_RESULT_RECORDS_CNT, newList.size());
		return result;
	}
	
	/**
	 * @메소드명 : uscActivityExportList
	 * @날짜 : 2016. 10. 4.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * econo 취득
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "uscActivityExportList.do")
	public @ResponseBody Map<String, Object> uscActivityExportList(CommandMap commandMap) throws Exception {
		// 제이슨 데이터를 List Map 형식으로 형변환하기 위한 타입참조
		TypeReference<List<HashMap<String, Object>>> typeRef = new TypeReference<List<HashMap<String, Object>>>() {
		};
		// 그리드로부터 데이타리스트를 제이슨 형식으로 받아온다.
		String gridDataList = commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString();
		commandMap.remove(DisConstants.FROM_GRID_DATA_LIST);
		// List Map 형식으로 형변환
		List<Map<String, Object>> saveList = new ObjectMapper().readValue(gridDataList, typeRef);
		List<Map<String, Object>> newList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
		
		//String[] projects = commandMap.get("projects").toString().split(",");
		
		for(Map<String, Object> rowData : saveList) {
			/*if(rowData.get("oper").toString().equals("N")) {
				Map<String, Object> newMap = new HashMap<String, Object>();
				newMap.put("state_flag", "A");
				newMap.put("representative_pro_num", rowData.get("representative_pro_num"));
				newMap.put("project_no", rowData.get("project_no"));
				newMap.put("area", rowData.get("area"));
				newMap.put("block_no", rowData.get("block_no"));				
				newMap.put("str_flag", rowData.get("block_str_flag"));
				newMap.put("block_str_flag", rowData.get("block_str_flag"));
				newMap.put("job_str_flag", rowData.get("job_str_flag"));
				newMap.put("upper_block", rowData.get("upper_block"));
				newMap.put("block_code", rowData.get("block_catalog"));
				newMap.put("act_code", rowData.get("activity_catalog"));
				newMap.put("job_code", rowData.get("job_catalog"));
				newMap.put("work_yn", rowData.get("work_yn"));
				newMap.put("virtual_yn", rowData.get("virtual_yn"));
				newMap.put("usc_job_type", rowData.get("usc_job_type"));
				newMap.put("oper", "I");
				newList.add(newMap);
			} else {*/
				//for (int i = 0; i < projects.length; i++) {
					Map<String, Object> newMap = new HashMap<String, Object>();
					newMap.put("state_flag", "A");
					newMap.put("representative_pro_num", rowData.get("representative_pro_num"));
					newMap.put("project_no", rowData.get("project_no"));
					newMap.put("area", rowData.get("area"));
					newMap.put("block_no", rowData.get("block_no"));
					newMap.put("str_flag", rowData.get("block_str_flag"));
					newMap.put("block_str_flag", rowData.get("block_str_flag"));
					newMap.put("job_str_flag", rowData.get("job_str_flag"));
					newMap.put("upper_block", rowData.get("upper_block"));
					newMap.put("block_code", rowData.get("block_catalog"));
					newMap.put("act_code", rowData.get("activity_catalog"));
					newMap.put("job_code", rowData.get("job_catalog"));
					newMap.put("work_yn", rowData.get("work_yn"));
					newMap.put("virtual_yn", rowData.get("virtual_yn"));
					newMap.put("usc_job_type", rowData.get("usc_job_type"));
					newMap.put("oper", "I");
					newList.add(newMap);
				//}
			//}
		}

		Collections.sort(newList, new Comparator<Map<String, Object >>() {
            @Override
            public int compare(Map<String, Object> first, Map<String, Object> second) {
                return (first.get("project_no").toString()).compareTo(second.get("project_no").toString()); //ascending order
                //return ((Integer) second.get("DOC_ID")).compareTo((Integer) first.get("DOC_ID")); //descending order
            }
        });

		Map<String, Object> result = new HashMap<String, Object>();
		result.put(DisConstants.GRID_RESULT_DATA, newList);
		result.put(DisConstants.GRID_RESULT_RECORDS_CNT, newList.size());
		return result;
	}
	
	// --------------------------------------------------------
	// USC TABLE 관련
	// --------------------------------------------------------
	/**
	 * @메소드명 : uscTable
	 * @날짜 : 2016. 10. 4.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * Usc Table 화면 이동
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "uscTable.do")
	public ModelAndView uscTable(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}	
	
	/**
	 * @메소드명 : uscTableList
	 * @날짜 : 2016. 10. 4.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * uscTable 리스트 취득(페이징포함)
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "uscTableList.do")
	public @ResponseBody Map<String, Object> uscTableList(CommandMap commandMap) {
		return uscService.getUscList(commandMap);
	}
	
	@RequestMapping(value = "infoUscTableColList.do")
	public @ResponseBody Map<String, Object> infoUscTableColList(CommandMap commandMap) {
		return uscService.getUscList(commandMap);
	}
	
	/**
	 * @메소드명 : uscTableDetailList
	 * @날짜 : 2016. 10. 4.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * uscTable 리스트 취득(페이징포함)
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "uscTableDetailList.do")
	public @ResponseBody Map<String, Object> uscTableDetailList(CommandMap commandMap) {
		return uscService.getUscList(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: uscTableExcelExport
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 * uscTable 엑셀 출력
	 * </pre>
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "uscTableExcelExport.do")
	public View uscTableExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return uscService.uscExcelExport(commandMap, modelMap);
	}

	// /////////////////////삭제//////////////////////////////////

	@RequestMapping(value = "wbsbomCreate.do")
	public ModelAndView wbsbomCreate(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	@RequestMapping(value = "actJobPdCreator.do")
	public ModelAndView actJobPdCreator(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	@RequestMapping(value = "jobCatalogInfoMgnt.do")
	public ModelAndView jobCatalogInfoMgnt(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	@RequestMapping(value = "wbsbomSearchList.do")
	public @ResponseBody Map<String, Object> wbsbomSearchList(CommandMap commandMap) {
		return uscService.getGridListNoPaging(commandMap);
	}
	// //////////////////////////////////////////////////////
	
	
	
	/**
	 * @메소드명 : popUpUscBlockExcelImport
	 * @날짜 : 2016. 10. 4.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 *	EXCEL IMPORT 페이지
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpUscBlockExcelImport.do")
	public ModelAndView popUpUscBlockExcelImport(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}	
	
	/**
	 * @메소드명 : uscActivityStdExcelImportAction
	 * @날짜 : 2016. 10. 4.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 *		엑셀 업로드
	 *     </pre>
	 * 
	 * @param file
	 * @param commandMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "uscBlockExcelImportAction.do")
	public void uscBlockExcelImportAction(@RequestParam(value = "fileName") MultipartFile file, CommandMap commandMap, HttpServletResponse response) throws Exception {
		
		File DecryptFile = null; 
		DecryptFile = DisEGDecrypt.createDecryptFile(file);
		
		commandMap.put("file", DecryptFile);
		
		List<Map<String, Object>> list = uscService.uscActivityStdExcelImportAction(commandMap);
		
		DisEGDecrypt.deleteDecryptFile(DecryptFile);
		
		/*List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
		for (Map<String, Object> rowData : list) {
			rowData.put("p_project_no", commandMap.getMap().get("p_project_no"));
			String str = uscService.uscAreaCodeName(rowData);
			rowData.put("area_name", str);
			String str1 = uscService.uscBlockImportCheck(rowData);
			rowData.put("chk", str1);
			resultList.add(rowData);
		}*/
		
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		response.getWriter().write(DisJsonUtil.listToJsonstring(list));
	}
	
	

}
