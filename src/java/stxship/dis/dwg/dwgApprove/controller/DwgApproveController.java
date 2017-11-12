package stxship.dis.dwg.dwgApprove.controller;

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
import stxship.dis.dwg.dwgApprove.service.DwgApproveService;

/**
 * @파일명 : DwgApproveController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * CatelogType의 컨트롤러
 *     </pre>
 */
@Controller
public class DwgApproveController extends CommonController {
	@Resource(name = "dwgApproveService")
	private DwgApproveService dwgApproveService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * DwgApprove 화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "dwgComplete.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName(DisConstants.DWG + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}

	/**
	 * @메소드명 : getGridListAction
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * DwgApprove  리스트 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "dwgCompleteList.do")
	public @ResponseBody Map<String, Object> getGridListAction(CommandMap commandMap) {
		return dwgApproveService.getGridList(commandMap);
	}

	@RequestMapping(value = "dwgPreViewFileList.do")
	public @ResponseBody List<Map<String, Object>> dwgPreViewFileListAction(CommandMap commandMap) {
		return dwgApproveService.getDbDataList(commandMap);
	}

	@RequestMapping(value = "dwgReturn.do")
	public @ResponseBody Map<String, String> dwgReturnAction(CommandMap commandMap) throws Exception {
		return dwgApproveService.dwgReturn(commandMap);
	}
	
	@RequestMapping(value = "dwgApprove.do")
	public @ResponseBody Map<String, String> dwgApproveAction(CommandMap commandMap) throws Exception {
		return dwgApproveService.dwgApprove(commandMap);
	}
	
	@RequestMapping(value = "selectPermission.do")
	public @ResponseBody Map<String, Object> selectPermissionAction(CommandMap commandMap) throws Exception {
		return dwgApproveService.getDbDataOne(commandMap);
	}

	@RequestMapping(value = "dwgApproveExcelExport.do")
	public View dwgApproveExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return dwgApproveService.dwgApproveExcelExport(commandMap, modelMap);
	}
}
