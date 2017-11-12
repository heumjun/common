package stxship.dis.supplyPlan.supplyProjectManage.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.controller.CommonController;
import stxship.dis.supplyPlan.supplyProjectManage.service.SupplyProjectManageService;

/**
 * @파일명 : SupplyProjectManageController.java
 * @프로젝트 : DIS
 * @날짜 : 2016. 10. 25.
 * @작성자 : 조흠준
 * @설명
 * 
 * 	<pre>
 *  호선관리 컨트롤러
 *     </pre>
 */
@Controller
public class SupplyProjectManageController extends CommonController {
	@Resource(name = "supplyProjectManageService")
	private SupplyProjectManageService supplyProjectManageService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2016. 10. 25.
	 * @작성자 : 조흠준
	 * @설명 :
	 * 
	 *     <pre>
	 * 항목관리 화면으로 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "supplyProjectManage.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}
	
	/** 
	 * @메소드명	: supplyProjectManageList
	 * @날짜		: 2016. 10. 25.
	 * @작성자	: 조흠준
	 * @설명		: 
	 * <pre>
	 * 호선관리 메인 그리드 리스트
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "supplyProjectManageList.do")
	public @ResponseBody Map<String, Object> supplyProjectManageList(CommandMap commandMap) {
		return supplyProjectManageService.getGridList(commandMap);
	}
}