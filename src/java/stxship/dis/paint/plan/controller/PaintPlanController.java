package stxship.dis.paint.plan.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.controller.CommonController;
import stxship.dis.paint.plan.service.PaintPlanService;

/** 
 * @파일명	: PaintPlanController.java 
 * @프로젝트	: DIS
 * @날짜		: 2015. 12. 7. 
 * @작성자	: 강선중 
 * @설명
 * <pre>
 * Paint Plan 컨트롤러
 * </pre>
 */
@Controller
public class PaintPlanController extends CommonController {
	@Resource(name = "paintPlanService")
	private PaintPlanService paintPlanService;
	
	/** 
	 * @메소드명	: linkSelectedMenu
	 * @날짜		: 2015. 12. 7.
	 * @작성자	: 강선중
	 * @설명		: 
	 * <pre>
	 * Paint Plan 모듈로 이동
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "paintPlan.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/** 
	 * @메소드명	: getGridListAction
	 * @날짜		: 2015. 12. 7.
	 * @작성자	: 강선중
	 * @설명		: 
	 * <pre>
	 * Paint Plan 리스트
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "paintPlanList.do")
	public @ResponseBody Map<String, Object> getGridListAction(CommandMap commandMap) {
		return paintPlanService.getGridList(commandMap);
	}

	/** 
	 * @메소드명	: saveGridListAction
	 * @날짜		: 2015. 12. 7.
	 * @작성자	: 강선중
	 * @설명		: 
	 * <pre>
	 * Paint Plan 수정사항 저장
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "savePaintPlan.do")
	public @ResponseBody Map<String, String> saveGridListAction(CommandMap commandMap) throws Exception {
		return paintPlanService.saveGridList(commandMap);
	}	
	
	/** 
	 * @메소드명	: savePlanRevAddAction
	 * @날짜		: 2015. 12. 7.
	 * @작성자	: 강선중
	 * @설명		: 
	 * <pre>
	 * Paint Plan 호선 리비전 증가
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "savePlanRevAdd.do")
	public @ResponseBody Map<String, String> savePlanRevAddAction(CommandMap commandMap) throws Exception {
		return paintPlanService.savePlanRevAdd(commandMap);
	}	

	@RequestMapping(value = "savePlanProjectAdd.do")
	public @ResponseBody Map<String, String> savePlanProjectAddAction(CommandMap commandMap) throws Exception {
		return paintPlanService.savePlanProjectAdd(commandMap);
	}	

}
