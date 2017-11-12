package stxship.dis.ems.partList1.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.ems.partList1.service.EmsPartList1Service;

/**
 * @파일명 : EmsPartListController.java
 * @프로젝트 : DIS
 * @날짜 : 2017. 2. 1.
 * @작성자 : 황성준
 * @설명
 * 
 * 	<pre>
 * EmsPartList 컨트롤러
 *     </pre>
 */

@Controller
public class EmsPartList1Controller extends CommonController {

	@RequestMapping(value = "popUpPartListCopy.do")
	public ModelAndView popUpUscActivity(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("ems/popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	@Resource(name = "emsPartList1Service")
	private EmsPartList1Service	emsPartList1Service;
	
	/**
	 * @메소드명  : emsPartList1
	 * @날짜 		: 2017. 2. 1.
	 * @작성자 	: 황성준
	 * @설명 	 	:
	 * 
	 *     <pre>
	 * emsPartList1 화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "emsPartList1.do")
	public ModelAndView emsPartList1(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		return mav;
	}
	
	/**
	 * @메소드명  : popUpPartListCopyList
	 * @날짜 		: 2017. 2. 1.
	 * @작성자 	: 황성준
	 * @설명 		:
	 * 
	 *     <pre>
	 * popUpPartListCopyList
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpPartListCopyList.do")
	public @ResponseBody Map<String, Object> popUpPartListCopyList(CommandMap commandMap) {		
		return emsPartList1Service.getEmsPartList1List(commandMap);
	}	

	/**
	 * @메소드명   : emsPartList1MainList
	 * @날짜 		: 2017. 2. 1.
	 * @작성자 	: 황성준
	 * @설명 		:
	 * 
	 *     <pre>
	 * emsPartList1MainList
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "emsPartList1MainList.do")
	public @ResponseBody Map<String, Object> emsPartList1MainList(CommandMap commandMap) {		
		return emsPartList1Service.getEmsPartList1List(commandMap);
	}	
	
	/**
	 * @메소드명 : emsPartList1SubList
	 * @날짜 		: 2017. 2. 1.
	 * @작성자 	: 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * emsPartList1SubList
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "emsPartList1SubList.do")
	public @ResponseBody Map<String, Object> emsPartList1SubList(CommandMap commandMap) {		
		return emsPartList1Service.getEmsPartList1List(commandMap);
	}
	
	/** 
	 * @메소드명	: infoMakerList
	 * @날짜 		: 2017. 2. 1.
	 * @작성자 	: 황성준
	 * @설명		: 
	 * <pre>
	 * infoMakerList
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoMakerList.do")
	public @ResponseBody List<Map<String, Object>> infoMakerList(CommandMap commandMap) {
		return emsPartList1Service.uscCodeNameList(commandMap);
	}
	
	/** 
	 * @메소드명	: infoMakerObj
	 * @날짜 		: 2017. 2. 1.
	 * @작성자 	: 황성준
	 * @설명		: 
	 * <pre>
	 * infoMakerObj
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoMakerObj.do")
	public @ResponseBody List<Map<String, Object>> infoMakerObj(CommandMap commandMap) {
		return emsPartList1Service.uscCodeNameList(commandMap);
	}
	
	/** 
	 * @메소드명	: infoPartListStrFlag
	 * @날짜 		: 2017. 2. 1.
	 * @작성자 	: 황성준
	 * @설명		: 
	 * <pre>
	 * infoMakerObj
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoPartListStrFlag.do")
	public @ResponseBody List<Map<String, Object>> infoPartListStrFlag(CommandMap commandMap) {
		return emsPartList1Service.uscCodeNameList(commandMap);
	}
	
	/** 
	 * @메소드명	: infoPartListJobType
	 * @날짜 		: 2017. 2. 1.
	 * @작성자 	: 황성준
	 * @설명		: 
	 * <pre>
	 * infoMakerObj
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoPartListJobType.do")
	public @ResponseBody List<Map<String, Object>> infoPartListJobType(CommandMap commandMap) {
		return emsPartList1Service.uscCodeNameList(commandMap);
	}
	
	/** 
	 * @메소드명	: infoJobCode
	 * @날짜 		: 2017. 2. 1.
	 * @작성자 	: 황성준
	 * @설명		: 
	 * <pre>
	 * infoJobCode
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoJobCode.do")
	public @ResponseBody List<Map<String, Object>> infoJobCode(CommandMap commandMap) {
		return emsPartList1Service.uscCodeNameList(commandMap);
	}
	
	/**
	 * @메소드명  : savePartList1MainList
	 * @날짜 		: 2017. 2. 1.
	 * @작성자 	: 황성준
	 * @설명 		:
	 * 
	 *     <pre>
	 * savePartList1MainList
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "savePartList1MainList.do")
	public @ResponseBody Map<String, String> savePartList1MainList(CommandMap commandMap) throws Exception {
		return emsPartList1Service.savePartListGridData(commandMap);
	}
	
	/**
	 * @메소드명  : savePartListCopy
	 * @날짜 		: 2017. 2. 1.
	 * @작성자 	: 황성준
	 * @설명 		:
	 * 
	 *     <pre>
	 * savePartListCopy
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "savePartListCopy.do")
	public @ResponseBody Map<String, String> savePartListCopy(CommandMap commandMap) throws Exception {
		return emsPartList1Service.savePartListCopy(commandMap);
	}
	
	/**
	 * @메소드명  : savePartListSsc
	 * @날짜 		: 2017. 2. 1.
	 * @작성자 	: 황성준
	 * @설명 		:
	 * 
	 *     <pre>
	 * savePartListSsc
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "savePartListSsc.do")
	public @ResponseBody Map<String, String> savePartListSsc(CommandMap commandMap) throws Exception {
		return emsPartList1Service.savePartListSsc(commandMap);
	}
	
	/**
	 * @메소드명  : savePartList1SubList
	 * @날짜 		: 2017. 2. 1.
	 * @작성자 	: 황성준
	 * @설명 		:
	 * 
	 *     <pre>
	 * savePartList1SubList
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "savePartList1SubList.do")
	public @ResponseBody Map<String, String> savePartList1SubList(CommandMap commandMap) throws Exception {
		return emsPartList1Service.savePartListGridData(commandMap);
	}
	
	/**
	 * @메소드명  : deletePartList
	 * @날짜 		: 2017. 2. 1.
	 * @작성자 	: 황성준
	 * @설명 		:
	 * 
	 *     <pre>
	 * deletePartList
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "deletePartList.do")
	public @ResponseBody Map<String, String> deletePartList(CommandMap commandMap) throws Exception {
		return emsPartList1Service.deletePartList(commandMap);
	}
	
	/**
	 * @메소드명  : emsPartList1ExcelList
	 * @날짜 		: 2017. 2. 1.
	 * @작성자 	: 황성준
	 * @설명 		:
	 * 
	 *     <pre>
	 * bomNeedsExcelList
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "emsPartList1ExcelList.do")
	public @ResponseBody View emsPartList1ExcelList(CommandMap commandMap, Map<String, Object> modelMap) {		
		return emsPartList1Service.partListExcelExport(commandMap, modelMap);
	}

}
