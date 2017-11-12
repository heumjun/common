package stxship.dis.common.command;

import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

/**
 * @파일명 : CommandMap.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * 뷰단에서 넘어오는 정보를 담는 맵 클레스
 *     </pre>
 */
public class CommandMap {
	Map<String, Object> map = new HashMap<String, Object>();

	/**
	 * @메소드명 : get
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Key로 맵 데이터를 취득
	 *     </pre>
	 * 
	 * @param key
	 * @return
	 */
	public Object get(String key) {
		return map.get(key);
	}

	/**
	 * @메소드명 : put
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 맵에 오브젝트를 입력
	 *     </pre>
	 * 
	 * @param key
	 * @param value
	 */
	public void put(String key, Object value) {
		map.put(key, value);
	}

	/**
	 * @메소드명 : remove
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 맵에서 Key에 해당하는 오브젝트를 제거
	 *     </pre>
	 * 
	 * @param key
	 * @return
	 */
	public Object remove(String key) {
		return map.remove(key);
	}

	/**
	 * @메소드명 : containsKey
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Key에 해당하는 오브젝트 확인
	 *     </pre>
	 * 
	 * @param key
	 * @return
	 */
	public boolean containsKey(String key) {
		return map.containsKey(key);
	}

	/**
	 * @메소드명 : containsValue
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 오브젝트가 들어 있는지 확인
	 *     </pre>
	 * 
	 * @param value
	 * @return
	 */
	public boolean containsValue(Object value) {
		return map.containsValue(value);
	}

	/**
	 * @메소드명 : clear
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 맵 삭제
	 *     </pre>
	 */
	public void clear() {
		map.clear();
	}

	/**
	 * @메소드명 : entrySet
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Set을 반환
	 *     </pre>
	 * 
	 * @return
	 */
	public Set<Entry<String, Object>> entrySet() {
		return map.entrySet();
	}

	/**
	 * @메소드명 : keySet
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * KeySet을 반환
	 *     </pre>
	 * 
	 * @return
	 */
	public Set<String> keySet() {
		return map.keySet();
	}

	/**
	 * @메소드명 : isEmpty
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 비어 있는 맵인지 확인
	 *     </pre>
	 * 
	 * @return
	 */
	public boolean isEmpty() {
		return map.isEmpty();
	}

	/**
	 * @메소드명 : putAll
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 맵을 입력
	 *     </pre>
	 * 
	 * @param m
	 */
	public void putAll(Map<? extends String, ? extends Object> m) {
		map.putAll(m);
	}

	/**
	 * @메소드명 : getMap
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 맵을 반환
	 *     </pre>
	 * 
	 * @return
	 */
	public Map<String, Object> getMap() {
		return map;
	}
}