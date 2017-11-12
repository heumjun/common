package stxship.dis.eco.eco.controller;

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
import stxship.dis.eco.eco.service.EcoService;

/**
 * @파일명 : EcoController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 30.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 *     ECO컨트롤러
 *     </pre>
 */
@Controller
public class EcoController extends CommonController {
	@Resource(name = "ecoService")
	private EcoService ecoService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 *     eco 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "eco.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName(DisConstants.ECO + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}

	/**
	 * @메소드명 : ecoListAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * eco리스트 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "ecoList.do")
	public @ResponseBody Map<String, Object> ecoListAction(CommandMap commandMap) {
		return ecoService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : ecoNewPartsAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 *     ecoNewParts이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "ecoNewParts.do")
	public ModelAndView ecoNewPartsAction(CommandMap commandMap) {
		return new ModelAndView(DisConstants.ECO + commandMap.get(DisConstants.JSP_NAME));
	}

	/**
	 * @메소드명 : infoEcoNewPartsListAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 *     NewPartsList취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoEcoNewPartsList.do")
	public @ResponseBody Map<String, Object> infoEcoNewPartsListAction(CommandMap commandMap) {
		return ecoService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : ecoSearchECRResultsAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 *     ecoSearchECRResults이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "ecoSearchECRResults.do")
	public ModelAndView ecoSearchECRResultsAction(CommandMap commandMap) {
		return new ModelAndView(DisConstants.ECO + commandMap.get(DisConstants.JSP_NAME));
	}

	/**
	 * @메소드명 : infoEcoEcrResultsListAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 *     EcoEcrResultsList취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoEcoEcrResultsList.do")
	public @ResponseBody Map<String, Object> infoEcoEcrResultsListAction(CommandMap commandMap) {
		return ecoService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : ecoRelatedProjectsAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 *     ecoRelatedProjects이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "ecoRelatedProjects.do")
	public ModelAndView ecoRelatedProjectsAction(CommandMap commandMap) {
		return new ModelAndView(DisConstants.ECO + commandMap.get(DisConstants.JSP_NAME));
	}

	/**
	 * @메소드명 : infoSearchEcoProjectListAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 *     EcoProjectList취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoEcoProjectList.do")
	public @ResponseBody Map<String, Object> infoSearchEcoProjectListAction(CommandMap commandMap) {
		return ecoService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : ecoReleaseNotificationResultsAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 *     ecoReleaseNotificationResults이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "ecoReleaseNotificationResults.do")
	public ModelAndView ecoReleaseNotificationResultsAction(CommandMap commandMap) {
		return new ModelAndView(DisConstants.ECO + commandMap.get(DisConstants.JSP_NAME));
	}

	/**
	 * @메소드명 : infoEcoReleaseNotificationResultsListAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 *     EcoReleaseNotificationResultsList취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoEcoReleaseNotificationResultsList.do")
	public @ResponseBody Map<String, Object> infoEcoReleaseNotificationResultsListAction(CommandMap commandMap) {
		return ecoService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : relatedEcoAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 *     relatedEco이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "relatedEco.do")
	public ModelAndView relatedEcoAction(CommandMap commandMap) {
		return new ModelAndView(DisConstants.ECO + commandMap.get(DisConstants.JSP_NAME));
	}

	/**
	 * @메소드명 : infoSelectRelatedEcoAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * RelatedEco 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoSelectRelatedEco.do")
	public @ResponseBody Map<String, Object> infoSelectRelatedEcoAction(CommandMap commandMap) {
		return ecoService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : ecoExcelExportAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 *     ecoExcelExport
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 */
	@RequestMapping(value = "ecoExcelExport.do")
	public View ecoExcelExportAction(CommandMap commandMap, Map<String, Object> modelMap) {
		return ecoService.ecoExcelExport(commandMap, modelMap);
	}

	/**
	 * @메소드명 : saveEcoAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * ECO 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveEco.do")
	public @ResponseBody Map<String, String> saveEcoAction(CommandMap commandMap) throws Exception {
		return ecoService.saveEco(commandMap);
	}
	
	/**
	 * @메소드명 : saveEco1Action
	 * @날짜 : 2016. 11. 10.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * ECO 저장(행추가 없이 바로 저장)
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveEco1.do")
	public @ResponseBody Map<String, String> saveEco1Action(CommandMap commandMap) throws Exception {
		return ecoService.saveEco1(commandMap);
	}

	/**
	 * @메소드명 : saveReleaseNotificationResultsAction
	 * @날짜 : 2016. 3. 9.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 확정통보 담당자 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveReleaseNotificationResults.do")
	public @ResponseBody Map<String, String> saveReleaseNotificationResultsAction(CommandMap commandMap)
			throws Exception {
		return ecoService.saveReleaseNotificationResults(commandMap);
	}
	
	/**
	 * @메소드명 : ecoRegisterInfo
	 * @날짜 : 2016. 11. 9.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * 확정통보 담당자 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "ecoRegisterInfo.do")
	public @ResponseBody List<Map<String, Object>> infoAreaList(CommandMap commandMap) throws Exception {
		return ecoService.ecoRegisterInfo(commandMap);
	}
	
	/**
	 * @메소드명 : saveEcoReleaseNotificationGroupAction
	 * @날짜 : 2017. 4. 4.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * 확정통보 담당자 그룹 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveEcoReleaseNotificationGroup.do")
	public @ResponseBody Map<String, String> saveEcoReleaseNotificationGroupAction(CommandMap commandMap)
			throws Exception {
		return ecoService.saveEcoReleaseNotificationGroup(commandMap);
	}	
	
	
	/**
	 * @메소드명 : popUpEcoAddGroupAction
	 * @날짜 : 2017. 4. 4.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * 확정통보 담당자 그룹 추가/편집 화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */	
	@RequestMapping(value = "popUpAddEcoReleaseNotificationGroup.do")
	public ModelAndView popUpAddEcoReleaseNotificationGroupAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(DisConstants.ECO + DisConstants.POPUP  + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/**
	 * @메소드명 : selectEcoReleaseNotificationGroupListAction
	 * @날짜 : 2017. 4. 4.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * 사용자 별 ECO 확정통보 담당자 그룹 목록 추출 (Select Box용)
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */		
	@RequestMapping(value = "selectEcoReleaseNotificationGroupList.do")
	public @ResponseBody List<Map<String, Object>> selectEcoReleaseNotificationGroupListAction(CommandMap commandMap) {
		return ecoService.getDbDataList(commandMap);
	}
	
	/**
	 * @메소드명 : selectEcoReleaseNotificationGroupDetailAction
	 * @날짜 : 2017. 4. 4.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * 사용자 별 ECO 확정통보 담당자 그룹 별 대상자 리스트 추출
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */		
	@RequestMapping(value = "selectEcoReleaseNotificationGroupDetail.do")
	public @ResponseBody Map<String, Object> selectEcoReleaseNotificationGroupDetailAction(CommandMap commandMap) {
		return ecoService.getGridListNoPaging(commandMap);
	}	
	
	
	/**
	 * @메소드명 : selectEcoReleaseNotificationGroupDetailAction
	 * @날짜 : 2017. 4. 4.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * 사용자 별 ECO 확정통보 담당자 그룹 별 대상자 리스트 추출
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */			
	@RequestMapping(value = "delEcoReleaseNotificationGroup.do")
	public @ResponseBody Map<String, String> delEcoReleaseNotificationGroupAction(CommandMap commandMap) throws Exception {
		return ecoService.delEcoReleaseNotificationGroup(commandMap);
	}	

	
	/**
	 * @메소드명 : popUpEconoCreate
	 * @날짜 : 2016. 11. 9.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * 확정통보 담당자 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpEconoCreate.do")
	public ModelAndView popUpEconoCreate(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
}
