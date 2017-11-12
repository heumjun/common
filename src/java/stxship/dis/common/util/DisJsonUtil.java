package stxship.dis.common.util;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.springframework.web.bind.annotation.ResponseBody;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

public class DisJsonUtil {

	/**
	 * @메소드명 : toList
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 제이슨 데이터를 List Map 형식으로 형변환
	 *     </pre>
	 * 
	 * @param object
	 * @return
	 * @throws Exception
	 */
	public static List<Map<String, Object>> toList(Object object) throws Exception {
		// 제이슨 데이터를 List Map 형식으로 형변환하기 위한 타입참조
		TypeReference<List<HashMap<String, Object>>> typeRef = new TypeReference<List<HashMap<String, Object>>>() {
		};
		// 그리드로부터 데이타리스트를 제이슨 형식으로 받아온다.
		// List Map 형식으로 형변환
		List<Map<String, Object>> list = new ObjectMapper().readValue(object.toString(), typeRef);
		return list;
	}

	/**
	 * @메소드명 : listToJsonstring
	 * @날짜 : 2016. 4. 8.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	MultiPartForm에서는 @ResponseBody를 사용 못하기 떄문에 해당 함수를 이용해 JSON 데이터를 뿌려준다. 
	 *	리스트 용
	 *     </pre>
	 * 
	 * @param list
	 * @return
	 */
	public static String listToJsonstring(List list) {

		JSONArray jsonArray = (JSONArray) JSONSerializer.toJSON(list);
		String json = "{'rows':" + jsonArray + "}";
		JSONObject jsonObject = (JSONObject) JSONSerializer.toJSON(json);
		return jsonObject.toString();
	}

	/**
	 * @메소드명 : mapToJsonstring
	 * @날짜 : 2016. 4. 8.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *  MultiPartForm에서는 @ResponseBody를 사용 못하기 떄문에 해당 함수를 이용해 JSON 데이터를 뿌려준다.
	 *  맵 용 
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public static String mapToJsonstring(Map<String, Object> map) {
		JSONObject jsonObject = JSONObject.fromObject( map );
		return jsonObject.toString();
	}
}
