package stxship.dis.dps.dwgDeplyCnt.service;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import stxship.dis.dps.common.service.DpsCommonService;
import stxship.dis.dps.common.service.DpsCommonServiceImpl;
import stxship.dis.dps.dwgDeployHis.dao.DwgDeployHisDAO;
import stxship.dis.dps.dwgDeplyCnt.dao.DwgDeployCntDAO;

/**
 * 
 * @파일명	: DwgDeployCntServiceImpl.java 
 * @프로젝트	: DIS
 * @날짜		: 2016. 8. 8. 
 * @작성자	: 조중호 
 * @설명
 * <pre>
 * 도면 출도 건 수 조회 service 구현부 
 * </pre>
 */
@Service("dwgDeployCntService")
public class DwgDeployCntServiceImpl extends DpsCommonServiceImpl implements DwgDeployCntService {
	
	@Resource(name = "dwgDeployCnt")
	private DwgDeployCntDAO dwgDeployCntDAO;
	
}
