package com.stxdis.util.util;

import java.util.List;
import java.util.Map;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;

import net.sf.json.JSONArray;
import net.sf.json.JSONException;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

import org.apache.commons.beanutils.BeanUtils; 

public class JsonUtil {

	/**
	 *  해쉬맵 리스트를 json방식의 키쌍 밸류로 출력
	 * @param 개발자 : 최유진
	 * @return
	 */
	public static String listmap_to_json_string(List<Map<String, Object>> list)
	{       
		JSONArray json_arr=new JSONArray();
		for (Map<String, Object> map : list) {
			JSONObject json_obj=new JSONObject();
			for (Map.Entry<String, Object> entry : map.entrySet()) {
				String key = entry.getKey();
				Object value = entry.getValue();
				try {
					json_obj.put(key,value);
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}                           
			}
			json_arr.add(json_obj);
		}
		return json_arr.toString();
	}
	
	/**
	 *  해쉬맵 리스트를 json방식의 키쌍 밸류로 출력
	 * @param 개발자 : 최유진
	 * @return
	 */
	public static String listToJsonstring(List<Map> list)
	{       
		
		JSONArray jsonArray   = (JSONArray)JSONSerializer.toJSON(list);
		
		String 		   json   = "{'rows':"+jsonArray+"}";
		
		JSONObject jsonObject = (JSONObject)JSONSerializer.toJSON(json);
		
		return jsonObject.toString();
	}
	
	/**
	 *  해쉬맵 맵를 json방식의 키쌍 밸류로 출력
	 * @param 개발자 : 최유진
	 * @return
	 */
	public static String mapToJsonstring(Map map)
	{       
		JSONObject jsonObject   = (JSONObject)JSONSerializer.toJSON(map);
		return jsonObject.toString();
	}


	/**
	 * 
	 * @author wangwei JSON工具类
	 * @param <T>
	 * 
	 */

	/***
	 * jsonArray를 스트링값으로 변환 개발자 : 최유진
	 */
	public static <T> String toJSONString(List<T> list)
	{
		JSONArray jsonArray = JSONArray.fromObject(list);

		return jsonArray.toString();
	}

	/***
	 * Objectf
	 * @param object
	 * @return
	 */
	public static String toJSONString(Object object)
	{
		JSONArray jsonArray = JSONArray.fromObject(object);

		return jsonArray.toString();
	}

	/***
	 *JSONArray를 스트링으로 변환 개발자 : 최유진
	 * @param jsonArray
	 * @return
	 */
	public static String toJSONString(JSONArray jsonArray)
	{
		return jsonArray.toString();
	}

	/***
	 * JSONObject를 스트링으로 변환 개발자 : 최유진
	 * @param jsonObject
	 * @return
	 */
	public static String toJSONString(JSONObject jsonObject)
	{
		return jsonObject.toString();
	}   

	/***
	 * Object 형태를 일반 리스트로 변환 개발자 : 최유진
	 * @param object
	 * @return
	 */
	public static List toArrayList(Object object)
	{
		List arrayList = new ArrayList();

		JSONArray jsonArray = JSONArray.fromObject(object);

		Iterator it = jsonArray.iterator();
		while (it.hasNext())
		{
			JSONObject jsonObject = (JSONObject) it.next();

			Iterator keys = jsonObject.keys();
			while (keys.hasNext())
			{
				Object key = keys.next();
				Object value = jsonObject.get(key);
				arrayList.add(value);
			}
		}

		return arrayList;
	}

	/***
	 * Object를 Collection형태로 변환 개발자 : 최유진
	 * @param object
	 * @return
	 */
	public static Collection toCollection(Object object)
	{
		JSONArray jsonArray = JSONArray.fromObject(object);

		return JSONArray.toCollection(jsonArray);
	}

	/***
	 * json Object를 JSONArray형태로 변환 리스트가 있을시 개발자 : 최유진
	 * @param object
	 * @return
	 */
	public static JSONArray toJSONArray(Object object)
	{
		return JSONArray.fromObject(object);
	}

	/***
	 * 将对象转换为JSON对象
	 * @param object
	 * @return
	 */
	public static JSONObject toJSONObject(Object object)
	{
		return JSONObject.fromObject(object);
	}

	/***
	 * json Object를 해쉬맵으로 변환
	 * @param object
	 * @return
	 */
	public static HashMap toHashMap(Object object)
	{
		HashMap<String, Object> data = new HashMap<String, Object>();
		JSONObject jsonObject = JsonUtil.toJSONObject(object);
		Iterator it = jsonObject.keys();
		while (it.hasNext())
		{
			String key = String.valueOf(it.next());
			Object value = jsonObject.get(key);
			data.put(key, value);
		}

		return data;
	}

	/***
	 * json Object를 <Map<String,Object>>로 변환 개발자 : 최유진
	 * @param object
	 * @return
	 */

	public static List<Map<String, Object>> toList(Object object)
	{
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		JSONArray jsonArray = JSONArray.fromObject(object);
		for (Object obj : jsonArray)
		{
			JSONObject jsonObject = (JSONObject) obj;
			Map<String, Object> map = new HashMap<String, Object>();
			Iterator it = jsonObject.keys();
			while (it.hasNext())
			{
				String key = (String) it.next();
				Object value = jsonObject.get(key);
				map.put((String) key, value);
			}
			list.add(map);
		}
		return list;
	}

	/***
	 * jsonArray를 objectClass로 변환
	 * @param <T>
	 * @param jsonArray
	 * @param objectClass
	 * @return
	 */
	public static <T> List<T> toList(JSONArray jsonArray, Class<T> objectClass)
	{
		return JSONArray.toList(jsonArray, objectClass);
	}

	/***
	 * Object형태의 json을 원하는 objectClass listt로 변환 개발자 : 최유진
	 * @param <T>
	 * @param jsonArray
	 * @param objectClass
	 * @return
	 */
	public static <T> List<T> toList(Object object, Class<T> objectClass)
	{
		JSONArray jsonArray = JSONArray.fromObject(object);

		return JSONArray.toList(jsonArray, objectClass);
	}

	/***
	 * jsonObject을 beanClass로 변환  개발자 : 최유진
	 * @param <T>
	 * @param jsonObject
	 * @param beanClass
	 * @return
	 */
	public static <T> T toBean(JSONObject jsonObject, Class<T> beanClass)
	{
		return (T) JSONObject.toBean(jsonObject, beanClass);
	}

	/***
	 * 将将对象转换为传入类型的对象
	 * @param <T>
	 * @param object
	 * @param beanClass
	 * @return
	 */
	public static <T> T toBean(Object object, Class<T> beanClass)
	{
		JSONObject jsonObject = JSONObject.fromObject(object);

		return (T) JSONObject.toBean(jsonObject, beanClass);
	}

	/***
	 * 将JSON文本反序列化为主从关系的实体
	 * @param <T> 泛型T 代表主实体类型
	 * @param <D> 泛型D 代表从实体类型
	 * @param jsonString JSON文本
	 * @param mainClass 主实体类型
	 * @param detailName 从实体类在主实体类中的属性名称
	 * @param detailClass 从实体类型
	 * @return
	 */
	public static <T, D> T toBean(String jsonString, Class<T> mainClass,
			String detailName, Class<D> detailClass)
	{
		JSONObject jsonObject = JSONObject.fromObject(jsonString);
		JSONArray jsonArray = (JSONArray) jsonObject.get(detailName);

		T mainEntity = JsonUtil.toBean(jsonObject, mainClass);
		List<D> detailList = JsonUtil.toList(jsonArray, detailClass);

		try
		{
			BeanUtils.setProperty(mainEntity, detailName, detailList);
		}
		catch (Exception ex)
		{
			throw new RuntimeException("主从关系JSON反序列化实体失败！");
		}

		return mainEntity;
	}

	/***
	 * 将JSON文本反序列化为主从关系的实体
	 * @param <T>泛型T 代表主实体类型
	 * @param <D1>泛型D1 代表从实体类型
	 * @param <D2>泛型D2 代表从实体类型
	 * @param jsonString JSON文本
	 * @param mainClass  主实体类型
	 * @param detailName1 从实体类在主实体类中的属性
	 * @param detailClass1 从实体类型
	 * @param detailName2 从实体类在主实体类中的属性
	 * @param detailClass2 从实体类型
	 * @return
	 */
	public static <T, D1, D2> T toBean(String jsonString, Class<T> mainClass,
			String detailName1, Class<D1> detailClass1, String detailName2,
			Class<D2> detailClass2)
	{
		JSONObject jsonObject = JSONObject.fromObject(jsonString);
		JSONArray jsonArray1 = (JSONArray) jsonObject.get(detailName1);
		JSONArray jsonArray2 = (JSONArray) jsonObject.get(detailName2);

		T mainEntity = JsonUtil.toBean(jsonObject, mainClass);
		List<D1> detailList1 = JsonUtil.toList(jsonArray1, detailClass1);
		List<D2> detailList2 = JsonUtil.toList(jsonArray2, detailClass2);

		try
		{
			BeanUtils.setProperty(mainEntity, detailName1, detailList1);
			BeanUtils.setProperty(mainEntity, detailName2, detailList2);
		}
		catch (Exception ex)
		{
			throw new RuntimeException("主从关系JSON反序列化实体失败！");
		}

		return mainEntity;
	}

	/***
	 * 将JSON文本反序列化为主从关系的实体
	 * @param <T>泛型T 代表主实体类型
	 * @param <D1>泛型D1 代表从实体类型
	 * @param <D2>泛型D2 代表从实体类型
	 * @param jsonString JSON文本
	 * @param mainClass  主实体类型
	 * @param detailName1 从实体类在主实体类中的属性
	 * @param detailClass1 从实体类型
	 * @param detailName2 从实体类在主实体类中的属性
	 * @param detailClass2 从实体类型
	 * @param detailName3 从实体类在主实体类中的属性
	 * @param detailClass3 从实体类型
	 * @return
	 */
	public static <T, D1, D2, D3> T toBean(String jsonString,
			Class<T> mainClass, String detailName1, Class<D1> detailClass1,
			String detailName2, Class<D2> detailClass2, String detailName3,
			Class<D3> detailClass3)
	{
		JSONObject jsonObject = JSONObject.fromObject(jsonString);
		JSONArray jsonArray1 = (JSONArray) jsonObject.get(detailName1);
		JSONArray jsonArray2 = (JSONArray) jsonObject.get(detailName2);
		JSONArray jsonArray3 = (JSONArray) jsonObject.get(detailName3);

		T mainEntity = JsonUtil.toBean(jsonObject, mainClass);
		List<D1> detailList1 = JsonUtil.toList(jsonArray1, detailClass1);
		List<D2> detailList2 = JsonUtil.toList(jsonArray2, detailClass2);
		List<D3> detailList3 = JsonUtil.toList(jsonArray3, detailClass3);

		try
		{
			BeanUtils.setProperty(mainEntity, detailName1, detailList1);
			BeanUtils.setProperty(mainEntity, detailName2, detailList2);
			BeanUtils.setProperty(mainEntity, detailName3, detailList3);
		}
		catch (Exception ex)
		{
			throw new RuntimeException("런타임에러！");
		}

		return mainEntity;
	}

	/***
	 * jsonString을 클래스로 변환  개발자 : 최유진
	 * @param <T> 主实体类型
	 * @param jsonString JSON文本
	 * @param mainClass 主实体类型
	 * @param detailClass 存放了多个从实体在主实体中属性名称和类型
	 * @return
	 */
	public static <T> T toBean(String jsonString, Class<T> mainClass,
			HashMap<String, Class> detailClass)
	{
		JSONObject jsonObject = JSONObject.fromObject(jsonString);
		T mainEntity = JsonUtil.toBean(jsonObject, mainClass);
		for (Object key : detailClass.keySet())
		{
			try
			{
				Class value = (Class) detailClass.get(key);
				BeanUtils.setProperty(mainEntity, key.toString(), value);
			}
			catch (Exception ex)
			{
				throw new RuntimeException("런타임에러！");
			}
		}
		return mainEntity;
	}

	public static StringBuffer jsonToString(List<Map> ar)
	{
		StringBuffer rtnVal = new StringBuffer();

		rtnVal.append("[");
		for(int i =0 ; i<ar.size(); i++)
		{
			Map dbox = (Map) ar.get(i);

			Iterator iter = dbox.keySet().iterator();
			rtnVal.append("{");

			while(iter.hasNext())
			{
				String key = (String)iter.next();				

				rtnVal.append("\""+key+"\" : \"" + dbox.get(key).toString()+"\"");

				if(iter.hasNext())rtnVal.append(", ");

			}
			rtnVal.append("}");
			if(i<ar.size()-1)rtnVal.append(",");

		}
		rtnVal.append("]");

		return rtnVal;
	}

	public static StringBuffer jsonToString(Map map)
	{

		StringBuffer rtnVal = new StringBuffer();
		Map dbox 			= map;

		Iterator iter = dbox.keySet().iterator();

		rtnVal.append("{");

		while(iter.hasNext())
		{
			String key = (String)iter.next();				

			rtnVal.append("\""+key+"\" : \"" + dbox.get(key).toString()+"\"");

			if(iter.hasNext())rtnVal.append(", ");

		}
		rtnVal.append("}");

		return rtnVal;
	}


}
