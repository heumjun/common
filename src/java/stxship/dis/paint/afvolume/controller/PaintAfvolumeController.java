package stxship.dis.paint.afvolume.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.controller.CommonController;
import stxship.dis.paint.afvolume.service.PaintAfvolumeService;

/**
 * @파일명 : PaintAfvolumeController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 11.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 *  A/F Volume 컨트롤러
 *     </pre>
 */
@Controller
public class PaintAfvolumeController extends CommonController {
	@Resource(name = "paintAfvolumeService")
	private PaintAfvolumeService paintAfvolumeService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2015. 12. 11.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * A/F Volume Control 화면으로 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "paintAfvolume.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : getGridListAction
	 * @날짜 : 2015. 12. 11.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * A/F Volume 리스트 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "searchPaintAfvolume.do")
	public @ResponseBody Map<String, Object> getGridListAction(CommandMap commandMap) {
		return paintAfvolumeService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : savePaintAfvolumeAction
	 * @날짜 : 2015. 12. 11.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * A/F Volume 저장(구간 정보 저장)
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "savePaintAfvolume.do")
	public @ResponseBody Map<String, String> savePaintAfvolumeAction(CommandMap commandMap) throws Exception {
		return paintAfvolumeService.savePaintAfvolume(commandMap);
	}

	/**
	 * @메소드명 : searchPaintSeparatedValueAction
	 * @날짜 : 2015. 12. 11.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * SeparatedValue(구간 정보) 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "searchPaintSeparatedValue.do")
	public @ResponseBody List<Map<String, Object>> searchPaintSeparatedValueAction(CommandMap commandMap) {
		return paintAfvolumeService.getDbDataList(commandMap);
	}
}
