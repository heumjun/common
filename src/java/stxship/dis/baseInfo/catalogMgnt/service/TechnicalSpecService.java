package stxship.dis.baseInfo.catalogMgnt.service;

import java.util.Map;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

/**
 * @파일명 : TechnicalSpecService.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * CatalogMgnt의 비용성코드 생성이 선택되어졌을때 사용되는 서비스
 *     </pre>
 */
public interface TechnicalSpecService extends CommonService {

	/** 
	 * @메소드명	: saveTechnicalSpec
	 * @날짜		: 2015. 12. 4.
	 * @작성자	: 황경호
	 * @설명		: 
	 * <pre>
	 * 비용성 코드 생성을 생성했을때 실행
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	Map<String, String> saveTechnicalSpec(CommandMap commandMap) throws Exception;
}
