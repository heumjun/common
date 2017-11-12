package stxship.dis.bom.unit.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import stxship.dis.bom.unit.dao.UnitDAO;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.util.DisPageUtil;
import stxship.dis.eco.eco.dao.EcoDAO;
import stxship.dis.item.createItem.dao.CreateItemDAO;

@Service("unitService")
public class UnitServiceImpl implements UnitService {
	Logger					log	= Logger.getLogger(this.getClass());

	@Resource(name = "unitDAO")
	private UnitDAO			unitDAO;

	@Resource(name = "ecoDAO")
	private EcoDAO			ecoDAO;
	
	@Resource(name = "createItemDAO")
	private CreateItemDAO	createItemDAO;

	@Override
	public Map<String, Object> unitMainList(CommandMap commandMap) throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();

		try {
			// 페이지 전처리
			DisPageUtil.actionPageBefore(commandMap);
			// 결과 리스트 받음 : 일반 쿼리는 리턴값으로 담겨 온다.
			List<Map<String, Object>> list = unitDAO.unitMainList(commandMap.getMap());
			// 페이지 후처리
			DisPageUtil.actionPageAfter(commandMap, result, list);

			// 페이징 처리 END
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

}
