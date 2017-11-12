package stxship.dis.baseInfo.catalogType.service;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import stxship.dis.baseInfo.catalogType.dao.CatalogTypeDAO;
import stxship.dis.common.service.CommonServiceImpl;

/**
 * @파일명 : CatalogTypeServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * CatalogType에서 사용되는 서비스
 *     </pre>
 */
@Service("catalogTypeService")
public class CatalogTypeServiceImpl extends CommonServiceImpl implements CatalogTypeService {

	@Resource(name = "catalogTypeDAO")
	private CatalogTypeDAO catalogTypeDAO;

}
