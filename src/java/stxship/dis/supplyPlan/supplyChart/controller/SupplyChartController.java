package stxship.dis.supplyPlan.supplyChart.controller;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.supplyPlan.supplyChart.service.SupplyChartService;

@Controller
public class SupplyChartController extends CommonController {
	
	@Resource(name = "supplyChartService")
	private SupplyChartService supplyChartService;
	
	/** 
	 * @메소드명	: supplyChart
	 * @날짜		: 2016. 08. 19.
	 * @작성자		: 이상빈
	 * @설명		: 
	 * <pre>
	 * 물량관리통계 모듈로 이동
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "supplyChart.do")
	public ModelAndView supplyChart(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}
	
	/** 
	 * @메소드명	: supplyChartList
	 * @날짜		: 2016. 10. 26.
	 * @작성자	: 조흠준
	 * @설명		: 
	 * <pre>
	 * 메인 그리드 리스트
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "supplyChartList.do")
	public @ResponseBody Map<String, Object> supplyChartList(CommandMap commandMap) throws Exception {
		return supplyChartService.supplyChartList(commandMap);
	}
	
	@RequestMapping(value = "supplyChartSaveAction.do")
	public @ResponseBody Map<String, Object> saveGridListAction(CommandMap commandMap) throws Exception {
		return supplyChartService.supplyChartSaveAction(commandMap);
	}
	
}
