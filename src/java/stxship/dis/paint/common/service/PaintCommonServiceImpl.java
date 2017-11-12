package stxship.dis.paint.common.service;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisSessionUtil;
import stxship.dis.paint.common.dao.PaintCommonDAO;

/**
 * @파일명 : PaintCommonServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 30.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 *  페인트 공통 서비스
 *     </pre>
 */
@Service("paintCommonService")
public class PaintCommonServiceImpl extends CommonServiceImpl implements PaintCommonService {

	@Resource(name = "paintCommonDAO")
	private PaintCommonDAO paintCommonDAO;

	/**
	 * @메소드명 : paintPlanProjectNoCheck
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Paint의 Project 넘버를 체크
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	public Map<String, Object> paintPlanProjectNoCheck(CommandMap commandMap) {

		Map<String, Object> result = (Map<String, Object>) paintCommonDAO
				.selectPaintPlanProjectNoCheck(commandMap.getMap());
		if(DisConstants.NO.equals(commandMap.get("sessionFlag"))){
			return result;
		}
		if (result != null) {
			DisSessionUtil.setObject("paint_project_no", commandMap.get("project_no"));
			DisSessionUtil.setObject("paint_revision", commandMap.get("revision"));
		} else {
			DisSessionUtil.setObject("paint_project_no", "");
			DisSessionUtil.setObject("paint_revision", "");
		}
		return result;
	}

	/** 
	 * @메소드명	: selectPaintNewRuleFlag
	 * @날짜		: 2016. 3. 17.
	 * @작성자	: 강선중
	 * @설명		: 
	 * <pre>
	 * Project - DIS Rule 체크 여부 확인 (DIS 적용호선 or Mig 대상호선)
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> selectPaintNewRuleFlag(CommandMap commandMap) throws Exception {
		Map<String, Object> result = (Map<String, Object>) paintCommonDAO.selectPaintNewRuleFlag(commandMap.getMap());
		return result;
	}
}
