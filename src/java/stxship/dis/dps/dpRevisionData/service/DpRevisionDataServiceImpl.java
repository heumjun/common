/**
 * 
 */
package stxship.dis.dps.dpRevisionData.service;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import stxship.dis.dps.common.service.DpsCommonServiceImpl;
import stxship.dis.dps.dpRevisionData.dao.DpRevisionDataDAO;

/** 
 * @파일명	: DpRevisionDataServiceImpl.java 
 * @프로젝트	: DIS
 * @날짜		: 2016. 8. 22. 
 * @작성자	: 조중호 
 * @설명
 * <pre>
 * 부서별 개정 시수 조회 Service Impl
 * </pre>
 */
@Service("dpRevisionDataService")
public class DpRevisionDataServiceImpl extends DpsCommonServiceImpl implements DpRevisionDataService {
	
	@Resource(name="dpRevisionDataDAO")
	private DpRevisionDataDAO dpRevisionDataDAO;
}
