package stxship.dis.baseInfo.catalogCodeLength.service;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import stxship.dis.baseInfo.catalogCodeLength.dao.CatalogCodeLengthDAO;
import stxship.dis.common.service.CommonServiceImpl;

/**
 * @파일명 : CatalogCodeLengthServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2016. 12. 6.
 * @작성자 : 황성준
 * @설명
 * 
 * 	<pre>
 * CatalogCodeLength에서 사용되는 서비스
 *     </pre>
 */
@Service("catalogCodeLengthService")
public class CatalogCodeLengthServiceImpl extends CommonServiceImpl implements CatalogCodeLengthService {

	@Resource(name = "catalogCodeLengthDAO")
	private CatalogCodeLengthDAO catalogCodeLengthDAO;

}
