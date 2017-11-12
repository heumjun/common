package stxship.dis.ems.partList.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

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
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.ems.partList.service.EmsPartListService;

/**
 * @파일명 : EmsPartListController.java
 * @프로젝트 : DIS
 * @날짜 : 2016. 03. 09.
 * @작성자 : 이상빈
 * @설명
 * 
 * 	<pre>
 * EmsPartList 컨트롤러
 *     </pre>
 */

@Controller
public class EmsPartListController extends CommonController {

	@Resource(name = "emsPartListService")
	private EmsPartListService	emsPartListService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2016. 3. 28.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 * EmsPartList 모듈로 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "emsPartList.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : emsPartListList
	 * @날짜 : 2016. 3. 28.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	PartList Main
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "emsPartListMainList.do")
	public @ResponseBody Map<String, Object> emsPartListList(CommandMap commandMap) throws Exception {
		return emsPartListService.emsPartListMainList(commandMap);
	}

	/**
	 * @메소드명 : popUpEmsPartListStageDiv
	 * @날짜 : 2016. 3. 28.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Stage Div
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpEmsPartListStageDiv.do")
	public ModelAndView popUpEmsPartListStageDiv(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.addObject("partlistInfo", emsPartListService.emsPartListSelectOne(commandMap));
		mav.setViewName(DisConstants.EMS + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}

	/**
	 * @메소드명 : popUpEmsPartListProjectCopy
	 * @날짜 : 2016. 3. 28.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Project Copy
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpEmsPartListProjectCopy.do")
	public ModelAndView popUpEmsPartListProjectCopy(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.addObject("partlistInfo", emsPartListService.emsPartListSelectOne(commandMap));
		mav.setViewName(DisConstants.EMS + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}

	/**
	 * @메소드명 : popUpEmsPartListExcelImport
	 * @날짜 : 2016. 3. 28.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Excel Import 화면
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpEmsPartListExcelImport.do")
	public ModelAndView popUpEmsPartListExcelImport(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName(DisConstants.EMS + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}

	/**
	 * @메소드명 : sscCableTypeExcelExport
	 * @날짜 : 2016. 3. 23.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	MAIN EXCEL EXPORT
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "emsPartListExcelExport.do")
	public View sscCableTypeExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return emsPartListService.emsPartListExcelExport(commandMap, modelMap);
	}

	/**
	 * @메소드명 : emsPartListSaveAction
	 * @날짜 : 2016. 3. 30.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "emsPartListSaveAction.do")
	public @ResponseBody Map<String, Object> emsPartListSaveAction(CommandMap commandMap) throws Exception {
		return emsPartListService.emsPartListSaveAction(commandMap);
	}

	/**
	 * @메소드명 : emsPartListJobList
	 * @날짜 : 2016. 3. 30.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	job 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "emsPartListJobList.do")
	public @ResponseBody List<Map<String, Object>> emsPartListJobList(CommandMap commandMap) throws Exception {
		return emsPartListService.emsPartListJobList(commandMap);
	}

	/**
	 * @메소드명 : emsPartListBomDetail
	 * @날짜 : 2016. 4. 4.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	EMS PART LIST 세부 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "emsPartListBomDetail.do")
	public @ResponseBody List<Map<String, Object>> emsPartListBomDetail(CommandMap commandMap) throws Exception {
		return emsPartListService.emsPartListBomDetail(commandMap);
	}

	/**
	 * @메소드명 : emsPartListProjectCopyNextList
	 * @날짜 : 2016. 4. 4.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 * PROJECT COPY 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "emsPartListProjectCopyNextList.do")
	public @ResponseBody Map<String, Object> emsPartListProjectCopyNextList(CommandMap commandMap) throws Exception {
		return emsPartListService.emsPartListProjectCopyNextList(commandMap);
	}

	/**
	 * @메소드명 : emsPartListProjectCopySave
	 * @날짜 : 2016. 4. 5.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	PartList Project Copy 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "emsPartListProjectCopySave.do")
	public @ResponseBody Map<String, Object> emsPartListProjectCopySave(CommandMap commandMap) throws Exception {
		return emsPartListService.emsPartListProjectCopySave(commandMap);
	}

	/**
	 * @메소드명 : emsPartListImportAction
	 * @날짜 : 2016. 4. 7.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *
	 *     </pre>
	 * 
	 * @param file
	 * @param commandMap
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "emsPartListImportAction.do")
	public void emsPartListImportAction(@RequestParam(value = "fileName") MultipartFile file, CommandMap commandMap, HttpServletResponse response) throws Exception {
		commandMap.put("file", file);
		Map<String, Object> rtnMap = emsPartListService.emsPartListImportAction(commandMap);
		
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		response.getWriter().write(DisJsonUtil.mapToJsonstring(rtnMap));
	}
}
