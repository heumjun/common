package stxship.dis.modelProject.modelMgnt.controller;

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
import stxship.dis.modelProject.modelMgnt.service.ModelMgntService;

/**
 * @파일명 : ModelMgntController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 30.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 *  ModelMgnt 컨트롤러
 *     </pre>
 */
@Controller
public class ModelMgntController extends CommonController {
	/**
	 * modelMgnt 서비스
	 */
	@Resource(name = "modelMgntService")
	private ModelMgntService modelMgntService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2015. 12. 03.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 1.유저의 권한체크
	 * 2.ModelMgnt 페이지 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "modelMgnt.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : getGridListAction
	 * @날짜 : 2015. 12. 03.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 * 
	 *     <pre>
	 * ModelMgnt 리스트 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "modelMgntList.do")
	public @ResponseBody Map<String, Object> getGridListAction(CommandMap commandMap) {
		// 공통 서비스에서 사용되어질 커스텀 서비스를 설정한다.
		// 각 서비스별로 별도 로직이 이루어진다.
		return modelMgntService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : saveModelMgntService
	 * @날짜 : 2015. 12. 03.
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
	@RequestMapping(value = "saveModelMgnt.do")
	public @ResponseBody Map<String, String> saveGridListAction(CommandMap commandMap) throws Exception {
		return modelMgntService.saveGridList(commandMap);
	}

	/**
	 * @메소드명 : popupModel
	 * @날짜 : 2015. 12. 07.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	popUpModelShipType 팝업창을 실행한다.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpModelShipType.do")
	public ModelAndView popUpModelShipType(CommandMap commandMap) {
		ModelAndView mv = new ModelAndView(
				"/modelProject" + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mv.addAllObjects(commandMap.getMap());
		return mv;
	}

	/**
	 * @메소드명 : popupModelList
	 * @날짜 : 2015. 12. 07.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	popUpModelShipTypeList 팝업창의 리스트를 취득한다.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpModelShipTypeList.do")
	public @ResponseBody Map<String, Object> popUpModelShipTypeList(CommandMap commandMap) {
		// 공통 서비스에서 사용되어질 커스텀 서비스를 설정한다.
		// 각 서비스별로 별도 로직이 이루어진다.
		return modelMgntService.getGridListNoPaging(commandMap);
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
	@RequestMapping(value = "modelMgntExcelExport.do")
	public View modelMgntExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return modelMgntService.excelExport(commandMap, modelMap);
	}
}
