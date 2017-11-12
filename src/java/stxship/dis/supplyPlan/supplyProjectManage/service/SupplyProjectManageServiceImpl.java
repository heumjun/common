package stxship.dis.supplyPlan.supplyProjectManage.service;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.supplyPlan.supplyProjectManage.dao.SupplyProjectManageDAO;

/**
 * @파일명 : SupplyProjectManageServiceImpl.java
 * @프로젝트 : DIMS
 * @날짜 : 2016. 10. 25.
 * @작성자 : 조흠준
 * @설명
 * 
 */
@Service("supplyProjectManageService")
public class SupplyProjectManageServiceImpl extends CommonServiceImpl implements SupplyProjectManageService {

	@Resource(name = "supplyProjectManageDAO")
	private SupplyProjectManageDAO supplyProjectManageDAO;

	
}
