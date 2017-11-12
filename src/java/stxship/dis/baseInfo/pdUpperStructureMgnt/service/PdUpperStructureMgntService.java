package stxship.dis.baseInfo.pdUpperStructureMgnt.service;

import java.util.Map;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

/**
 * @파일명 : PdUpperStructureMgntService.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 *     PdUpperStructureMgnt의 서비스
 *     </pre>
 */
public interface PdUpperStructureMgntService extends CommonService {

	Map<String, String> savePdUpperStructureMgntList(CommandMap commandMap) throws Exception;
}
