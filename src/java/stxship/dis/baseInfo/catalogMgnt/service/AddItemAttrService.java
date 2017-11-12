package stxship.dis.baseInfo.catalogMgnt.service;

import java.util.Map;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

/**
 * @파일명 : AddItemAttrService.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * CatalogMgnt의 부가속성이 선택되었을때 사용되는 서비스
 *     </pre>
 */
public interface AddItemAttrService extends CommonService {

	/**
	 * @메소드명 : saveItemAddAttribute
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 부가속성 저장을 선택하였을때 사용되는 서비스
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	Map<String, String> saveItemAddAttribute(CommandMap commandMap) throws Exception;
}
