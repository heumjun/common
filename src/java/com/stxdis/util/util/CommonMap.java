package com.stxdis.util.util;

import java.text.NumberFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.multipart.MultipartFile;

import com.stxdis.util.util.StringUtils;



public class CommonMap extends java.util.HashMap {

	Logger logger = LoggerFactory.getLogger(CommonMap.class);

	private NumberFormat nf = NumberFormat.getInstance();

	private NumberFormat cf = NumberFormat.getCurrencyInstance(Locale.KOREA);

	/**
	 * Logger for this class
	 */

	private boolean isSet = false;

	/**
	 * 
	 */
	public CommonMap() {
		super();
	}
	

	private List<MultipartFile> files;

	/**
	 * @param arg0
	 */
	public CommonMap(int arg0) {
		super(arg0);
	}

	/**
	 * @param arg0
	 * @param arg1
	 */
	public CommonMap(int arg0, float arg1) {
		super(arg0, arg1);
	}

	/**
	 * @param arg0
	 */
	public CommonMap(Map arg0) {
		super(arg0);
	}

	public void set() {
		this.isSet = true;
	}

	public boolean isSet() {
		return this.isSet;
	}

	public void addAll(Map map) {
		if (map == null) {
			return;
		}
		Iterator i$ = map.entrySet().iterator();
		do {
			if (!i$.hasNext()) {
				break;
			}
			java.util.Map.Entry entry = (java.util.Map.Entry) i$.next();
			Object value = entry.getValue();
			if (value != null) {
				Object toadd;
				if (value instanceof String[]) {
					String values[] = (String[]) (String[]) value;
					if (values.length > 1) {
						toadd = new ArrayList(Arrays.asList(values));
					} else if(values.length == 1) {
						toadd = values[0];
					} else {
						toadd = "";
					}
				} else {
					toadd = value;
				}
				super.put(((String)entry.getKey()).toLowerCase(), toadd);
			}
		} while (true);
	}
	
	public String getEscape4Js(String key)
	{
		return getEscape4Js(key, "");
	}
	
	public String getEscape4Js(String key, String def)
	{
		String str;
		
		if(get(key) == null)
			str = "";
		else
			str = String.valueOf(get(key));
		
		
		str = StringUtils.replace(str, "\\", "\\\\");
		str = StringUtils.replace(str, "\r\n", "\\n");
		str = StringUtils.replace(str, "\r", "\\n");
		str = StringUtils.replace(str, "\n", "\\n");
		str = StringUtils.replace(str, "'", "\\'");
		str = StringUtils.replace(str, "\"", "\\\"");

		if(str.equals(""))
			return def;
		else
			return str;
	}
	
	public String getToHTML(String key)
	{
		String str = String.valueOf(getString(key));
		
		str = StringUtils.replace(str, "&", "&amp;");
		str = StringUtils.replace(str, "<", "&lt;");
		str = StringUtils.replace(str, ">", "&gt;");
		str = StringUtils.replace(str, "\r\n", "<br>");
		str = StringUtils.replace(str, "\"", "&quot;");
		str = StringUtils.replace(str, " ", "&nbsp;");
		
		return str;
	}
	
	
	public String getToINPUT(String key, String def)
	{
		String str = String.valueOf(getString(key));
		
		if(str.length() == 0)
			str = def;
		
		str = StringUtils.replace(str, "<", "&lt;");
		str = StringUtils.replace(str, ">", "&gt;");
		str = StringUtils.replace(str, "\"", "&quot;");
		
		return str;
	}
	
	public String getToINPUT(String key)
	{
		return getToINPUT(key, "");
	}
	
	public String getString(String key){
		return 	getString(key, "");	
	}
	
	public String getString(String key, String def) {
		
		if(this.get(key.toLowerCase()) == null)
			return def;
		else
		{
			String str = String.valueOf(this.get(key.toLowerCase()));
			if (str.equals(""))
				str = def;
			
			return StringUtils.getNull(str);
		}
	}

	public int getInt(String key) {
		Object obj = super.get(key.toLowerCase());
		int ret = 0;
		if (obj instanceof java.lang.Number) {
			ret = ((Number) obj).intValue();
		} else {
			try {
				ret = Integer.parseInt(obj.toString());
			} catch (Exception ex) {
				ret = 0;
			}
		}
		return ret;
	}
	
	public int[] getInts(String key) {
		int[] ints = null;
		try{
			String[] obj = (String[])super.get(key.toLowerCase());
			ints = new int[obj.length];
			for(int i=0;i<obj.length;i++){				
				ints[i] = getInt(obj[i]);				
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return ints;		
	}

	public Integer getInteger(String key) {
		return new Integer(this.getInt(key.toLowerCase()));
	}

	public double getDouble(String key) {
		double ret = 0;
		Object obj = super.get(key.toLowerCase());
		if (obj == null)
			return 0;
		try {
			ret = Double.parseDouble(obj.toString());
		} catch (Exception ex) {
			return 0;
		}
		return ret;
	}

	public double getDouble(String key , double defaultVal) {
		double ret = 0;
		Object obj = super.get(key.toLowerCase());
		if (obj == null)
			return defaultVal;
		try {
			ret = Double.parseDouble(obj.toString());
		} catch (Exception ex) {
			return defaultVal;
		}
		return ret;
	}

	public String getPersent(String key) {
		String str = "";
		NumberFormat format = NumberFormat.getPercentInstance();
		double value = this.getDouble(key);
		str = format.format(value);
		return str;
	}

	public String getDateFormat(String key, String type) {
		String str = "";
		Object o = null;
		SimpleDateFormat in = new SimpleDateFormat("yyyyMMddkkmmss");
		SimpleDateFormat out = new SimpleDateFormat(type);

		o = this.get(key.toLowerCase());
		if (o == null || o.toString().trim().equals(""))
			return "-";
		try {
			str = o instanceof String ? out.format(in.parse((String) o)) : out
					.format((Date) o);
		} catch (ParseException e) {
			return "-";
		}

		return str;
	}

	public String getDateFormat(String key, String fType, String tType) {
		String str = "";
		String s = null;
		SimpleDateFormat in = new SimpleDateFormat(fType);
		SimpleDateFormat out = new SimpleDateFormat(tType);

		// s = this.getString(key.toLowerCase()).trim();
		s = key.toLowerCase();
		if (s.equals(""))
			return "-";
		try {
			str = out.format(in.parse(s));
		} catch (ParseException e) {
			return "-";
		}

		return str;
	}

	public String getNumberFormat(String key) {
		String str = "";
		str = nf.format(this.getDouble(key.toLowerCase()));
		return str;
	}

	public String getCurrencyFormat(String key) {
		String str = "";
		double d = this.getDouble(key.toLowerCase());
		if (d == 0)
			return "-";
		str = cf.format(d);
		return str;
	}

	
	public Object put(Object arg0,Object arg1) {
		arg0 = ((String)arg0).toLowerCase();
		return super.put(arg0, arg1);
	}
	
	public Object get(Object arg0) {
		arg0 = ((String)arg0).toLowerCase();
		String content = null;
		
			return super.get(arg0);
	}

	public List<MultipartFile> getFiles() {
		return files;
	}

	public void setFiles(List<MultipartFile> files) {
		this.files = files;
	}
	

    
}




