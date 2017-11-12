package stxship.dis.dwg.dwgSystem.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.dwg.dwgSystem.service.DwgSystemService;

/**
 * @파일명 : DwgSystemController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * DwgSystem의 컨트롤러
 *     </pre>
 */
@Controller
public class DwgSystemController extends CommonController {
	@Resource(name = "dwgSystemService")
	private DwgSystemService dwgSystemService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * DwgSystem 화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "dwgSystem.do")
	public ModelAndView dwgSystemAction(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	@RequestMapping(value = "dwgInformation.do")
	public ModelAndView dwgInformationAction(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	@RequestMapping(value = "dwgMailReceiver.do")
	public ModelAndView dwgMailReceiverAction(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	@RequestMapping(value = "popUpDPShipList.do")
	public ModelAndView popUpDPShipListAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("dwg/popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	@RequestMapping(value = "selectDPShipList.do")
	public @ResponseBody Map<String, Object> selectDPShipListAction(CommandMap commandMap) {
		return dwgSystemService.getGridListNoPaging(commandMap);
	}

	@RequestMapping(value = "popUpDPDwgList.do")
	public ModelAndView popUpDPDwgListAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("dwg/popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	@RequestMapping(value = "selectDPDwgList.do")
	public @ResponseBody Map<String, Object> selectDPDwgListAction(CommandMap commandMap) {
		return dwgSystemService.getGridListNoPaging(commandMap);
	}

	@RequestMapping(value = "popUpDwgGrantorList.do")
	public ModelAndView popUpDwgGrantorListAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("dwg/popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	@RequestMapping(value = "selectGrantorList.do")
	public @ResponseBody Map<String, Object> selectGrantorListAction(CommandMap commandMap) {
		return dwgSystemService.getGridListNoPaging(commandMap);
	}

	@RequestMapping(value = "selectDwgUserList.do")
	public @ResponseBody List<Map<String, Object>> selectDwgUserListAction(CommandMap commandMap) {
		return dwgSystemService.getDbDataList(commandMap);
	}

	@RequestMapping(value = "dwgSearchList.do")
	public @ResponseBody Map<String, Object> dwgSearchListAction(CommandMap commandMap) {
		return dwgSystemService.getGridList(commandMap);
	}

	@RequestMapping(value = "dwgReceiverCheck.do")
	public @ResponseBody Map<String, Object> dwgReceiverCheckAction(CommandMap commandMap) throws Exception {
		return dwgSystemService.dwgReceiverCheck(commandMap);
	}

	@RequestMapping(value = "requiredDWG.do")
	public @ResponseBody Map<String, String> requiredDWGAction(CommandMap commandMap) throws Exception {
		return dwgSystemService.requiredDWG(commandMap);
	}

	@RequestMapping(value = "dwgItemList.do")
	public @ResponseBody Map<String, Object> dwgItemListAction(CommandMap commandMap) {
		return dwgSystemService.getGridListNoPaging(commandMap);
	}

	@RequestMapping(value = "dwgInformationList.do")
	public @ResponseBody Map<String, Object> dwgInformationListAction(CommandMap commandMap) {
		return dwgSystemService.getGridList(commandMap);
	}

	@RequestMapping(value = "popUpDWGView.do")
	public ModelAndView popUpDWGViewAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("dwg/popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	@RequestMapping(value = "selectView.do", produces="text/plain;charset=UTF-8")
	public @ResponseBody String selectView(CommandMap commandMap) throws Exception {
		return dwgSystemService.selectView(commandMap);
	}

	@RequestMapping(value = "mailReceiverList.do")
	public @ResponseBody Map<String, Object> mailReceiverListAction(CommandMap commandMap) {
		return dwgSystemService.getGridListNoPaging(commandMap);
	}

	@RequestMapping(value = "popUpDwgMailReceiver.do")
	public ModelAndView popUpDwgMailReceiverAction(CommandMap commandMap) throws Exception {
		ModelAndView mav = new ModelAndView("dwg/popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		List<Map<String, Object>> selectSeriesProject = dwgSystemService.modifyMailReceiver(commandMap);
		mav.addObject("selectSeriesProject", selectSeriesProject);
		mav.addObject("listSize", selectSeriesProject.size());
		return mav;
	}

	@RequestMapping(value = "modifyMailReceiverList.do")
	public @ResponseBody Map<String, Object> modifyMailReceiverListAction(CommandMap commandMap) {
		return dwgSystemService.getGridListNoPaging(commandMap);
	}

	@RequestMapping(value = "popUpDwgUserSearch.do")
	public ModelAndView popUpDwgUserSearchAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("dwg/popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	@RequestMapping(value = "selectERPUserInOutUserList.do")
	public @ResponseBody Map<String, Object> selectERPUserInOutUserListAction(CommandMap commandMap) {
		return dwgSystemService.getGridListNoPaging(commandMap);
	}

	@RequestMapping(value = "popUpDwgAddGroup.do")
	public ModelAndView popUpDwgAddGroupAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("dwg/popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	@RequestMapping(value = "selectDWGReceiverGroupDetail.do")
	public @ResponseBody Map<String, Object> selectDWGReceiverGroupDetailAction(CommandMap commandMap) {
		return dwgSystemService.getGridListNoPaging(commandMap);
	}

	@RequestMapping(value = "selectGroupList.do")
	public @ResponseBody List<Map<String, Object>> selectGroupListAction(CommandMap commandMap) {
		return dwgSystemService.getDbDataList(commandMap);
	}

	@RequestMapping(value = "delDWGReceiverGroup.do")
	public @ResponseBody Map<String, String> delDWGReceiverGroupAction(CommandMap commandMap) throws Exception {
		return dwgSystemService.delDWGReceiverGroup(commandMap);
	}

	@RequestMapping(value = "selectDWGEcoReceiver.do")
	public @ResponseBody Map<String, Object> selectDWGEcoReceiverAction(CommandMap commandMap) throws Exception {
		return dwgSystemService.getDbDataOne(commandMap);
	}

	@RequestMapping(value = "saveDWGMailReceiver.do")
	public @ResponseBody Map<String, String> saveDWGMailReceiverAction(CommandMap commandMap) throws Exception {
		return dwgSystemService.saveDWGMailReceiver(commandMap);
	}

	@RequestMapping(value = "popUpDwgDeptView.do")
	public ModelAndView popUpDwgDeptViewAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("dwg/popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	@RequestMapping(value = "selectDwgDeptList.do")
	public @ResponseBody Map<String, Object> selectDwgDeptListAction(CommandMap commandMap) {
		return dwgSystemService.getGridList(commandMap);
	}

	@RequestMapping(value = "saveMailReceiverGroup.do")
	public @ResponseBody Map<String, String> saveMailReceiverGroupAction(CommandMap commandMap) throws Exception {
		return dwgSystemService.saveMailReceiverGroup(commandMap);
	}

	@RequestMapping(value = "selectNotRequired.do")
	public @ResponseBody Map<String, Object> selectNotRequiredAction(CommandMap commandMap) throws Exception {
		return dwgSystemService.getDbDataOne(commandMap);
	}

	@RequestMapping(value = "dwgRevisionCancel.do")
	public @ResponseBody Map<String, String> dwgRevisionCancel(CommandMap commandMap) throws Exception {
		return dwgSystemService.dwgRevisionCancel(commandMap);
	}
	
	@RequestMapping(value = "selectDpDpspFlag.do")
	public @ResponseBody List<Map<String, Object>> selectDpDpspFlag(CommandMap commandMap) throws Exception {
		return dwgSystemService.selectDpDpspFlag(commandMap);
	}
	
	@RequestMapping(value = "selectDwgDeptCode.do")
	public @ResponseBody List<Map<String, Object>> selectDwgDeptCode(CommandMap commandMap) throws Exception {
		return dwgSystemService.selectDwgDeptCode(commandMap);
	}
}
