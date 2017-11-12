package stxship.dis.baseInfo.pdUpperStructureMgnt.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import stxship.dis.baseInfo.pdUpperStructureMgnt.dao.PdUpperStructureMgntDAO;
import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.DisStringUtil;

/**
 * @파일명 : PdUpperStructureMgntServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * PdUpperStructureMgnt의 서비스
 *     </pre>
 */
@Service("pdUpperStructureMgntService")
public class PdUpperStructureMgntServiceImpl extends CommonServiceImpl implements PdUpperStructureMgntService {

	@Resource(name = "pdUpperStructureMgntDAO")
	private PdUpperStructureMgntDAO pdUpperStructureMgntDAO;

	public Map<String, String> savePdUpperStructureMgntList(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> resultList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST));

		String error_code = "";
		String error_msg = "";
		for (Map<String, Object> rowData : resultList) {
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			pdUpperStructureMgntDAO.selectOne("savePdUpperStructureMgntList.insert", rowData);
			error_code = DisStringUtil.nullString(rowData.get("error_code"));
			error_msg = DisStringUtil.nullString(rowData.get("error_msg"));
			if (!"S".equals(error_code) && !"F".equals(error_code)) {
				throw new DisException(error_msg);
			}
			if ("F".equals(error_code)) {
				throw new DisException("customer.message1", new String[] { error_msg });
			}
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

}
