package stxship.dis.etc.ndtPcsMgnt.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.etc.ndtPcsMgnt.dao.NdtPcsMgntDAO;

/**
 * @파일명 : NdtPcsMgntServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * NdtPcsMgnt에서 사용되는 서비스
 *     </pre>
 */
@Service("ndtPcsMgntService")
public class NdtPcsMgntServiceImpl extends CommonServiceImpl implements NdtPcsMgntService {

	@Resource(name = "ndtPcsMgntDAO")
	private NdtPcsMgntDAO ndtPcsMgntDAO;
	
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> saveGridList(CommandMap commandMap) throws Exception {
		
		List<Map<String, Object>> saveList = DisJsonUtil
				.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());
		
		// 결과값 최초
		for (Map<String, Object> rowData : saveList) {
			// CommandMap에 저장되어있는 DB용 로그인 아이디, 맵퍼네임 등을 설정한다.
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			rowData.put(DisConstants.MAPPER_NAME, commandMap.get(DisConstants.MAPPER_NAME));
			
			// UPDATE 인경우
			if (DisConstants.UPDATE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				// p_chk_series의 순대로 돌림.
				String[] p_chk_series = commandMap.get("p_chk_series").toString().split(",");
				// 체크된 시리즈가 없으면 그리드의 리스트 그대로 LOOP 진행
				if (p_chk_series[0].equals("")) {
					gridDataUpdate(rowData);	
				} else {
					for (String vSeries : p_chk_series) {
						rowData.put("project_no", vSeries);
						gridDataUpdate(rowData);
					}
				}
				
			}
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);

	}
}
