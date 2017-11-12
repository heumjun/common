package com.stx.common.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Iterator;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;


public class JsonUtil {
	
	public static List toList(Object object)
	{
		List list = new ArrayList();
		JSONArray jsonArray = JSONArray.fromObject(object);
		
		for (int i=0;i<jsonArray.size();i++)
		{
			JSONObject jsonObject = (JSONObject) jsonArray.get(i);
			Map map = new HashMap();
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
	
	public static String listToJsonstring(List list)
	{       
		
		JSONArray jsonArray   = (JSONArray)JSONSerializer.toJSON(list);
		
		String 		   json   = "{'rows':"+jsonArray+"}";
		
		JSONObject jsonObject = (JSONObject)JSONSerializer.toJSON(json);
		
		return jsonObject.toString();
	}
	
	
	public static StringBuffer jsonToString(List ar)
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
				String val = dbox.get(key).toString();
				
				val = val.replaceAll("[\"]", "\\\\\"");
				
				rtnVal.append("\""+key+"\" : \"" + val+"\"");
				
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
	public static String toJSONString(List list)
	{
		JSONArray jsonArray = JSONArray.fromObject(list);
		System.out.println(jsonArray.toString());
		return jsonArray.toString();
	}
	
	
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


}
