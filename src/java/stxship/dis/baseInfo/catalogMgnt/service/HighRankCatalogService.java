package stxship.dis.baseInfo.catalogMgnt.service;

import java.util.Map;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

/**
 * @파일명 : HighRankCatalogService.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * CatalogMgnt에서 상위Catalog가 선택되어졌을때 사용되는 서비스
 *     </pre>
 */
public interface HighRankCatalogService extends CommonService {

	/**
	 * @메소드명 : saveHighRankCatalog
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 상위 Catalog에서 저장을 실행
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	Map<String, String> saveHighRankCatalog(CommandMap commandMap) throws Exception;

}
