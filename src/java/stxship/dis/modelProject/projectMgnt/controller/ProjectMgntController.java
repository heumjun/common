package stxship.dis.modelProject.projectMgnt.controller;

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
import stxship.dis.modelProject.projectMgnt.service.ProjectMgntService;

/**
 * @파일명 : ProjectMgntController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 30.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 *  ProjectMgnt 컨트롤러
 *     </pre>
 */
@Controller
public class ProjectMgntController extends CommonController {
	/**
	 * ProjectMgnt 서비스
	 */
	@Resource(name = "projectMgntService")
	private ProjectMgntService projectMgntService;

	/**
	 * @메소드명 : linkCodeMaster
	 * @날짜 : 2015. 12. 07.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 1.유저의 권한체크
	 * 2.ProjectMgnt 페이지 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "projectMgnt.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : getProjectMgnt
	 * @날짜 : 2015. 12. 07.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * ModelMgnt 리스트 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "projectMgntList.do")
	public @ResponseBody Map<String, Object> getGridListAction(CommandMap commandMap) {
		// 공통 서비스에서 사용되어질 커스텀 서비스를 설정한다.
		// 각 서비스별로 별도 로직이 이루어진다.
		return projectMgntService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : getMasterList
	 * @날짜 : 2015. 12. 07.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * Select Box 대표호선 List 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoProjectSelectBox.do")
	public @ResponseBody List<Map<String, Object>> getMasterList(CommandMap commandMap) {
		return projectMgntService.getDbDataList(commandMap);
	}

	/**
	 * @메소드명 : saveProjectMgntService
	 * @날짜 : 2015. 12. 07.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	변경된 그리드 정보를 가져와서 데이타베이스에 반영한다.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveProjectMgnt.do")
	public @ResponseBody Map<String, String> saveGridListAction(CommandMap commandMap) throws Exception {
		return projectMgntService.saveGridList(commandMap);
	}

	/**
	 * @메소드명 : popupModel
	 * @날짜 : 2015. 12. 07.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	popupModel 팝업창을 실행한다.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpModel.do")
	public ModelAndView popupModel(CommandMap commandMap) {
		return new ModelAndView("/modelProject" + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
	}

	/**
	 * @메소드명 : popupModel
	 * @날짜 : 2015. 12. 07.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	popupModel 팝업창의 리스트를 취득한다.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpModelList.do")
	public @ResponseBody Map<String, Object> popupModelList(CommandMap commandMap) {
		// 공통 서비스에서 사용되어질 커스텀 서비스를 설정한다.
		// 각 서비스별로 별도 로직이 이루어진다.
		return projectMgntService.getGridListNoPaging(commandMap);
	}
	
	/**
	 * @메소드명 : modelMgntExcelExport
	 * @날짜 : 2017. 2. 28.
	 * @작성자 : 조흠준
	 * @설명 :
	 * 
	 *     <pre>
	 * modelMgnt Excel 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "projectMgntExcelExport.do")
	public View projectMgntExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return projectMgntService.excelExport(commandMap, modelMap);
	}
}
