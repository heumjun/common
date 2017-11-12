package com.stx.common.util;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.Properties;

public class TbcPropertiesRead {
	Properties properties;
	
	public TbcPropertiesRead(String fName) {
		
		this.properties = new Properties();
		try {
			ClassLoader cl;
		    cl = Thread.currentThread().getContextClassLoader();
		    if(cl == null){
		       cl = ClassLoader.getSystemClassLoader();
		    }
		    
		    URL url = cl.getResource(fName);
		    System.out.println("url : " + url);
			properties.load(new FileInputStream(url.getPath()));
		} catch (FileNotFoundException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
	}
	
	public String read(String key) {
		return properties.getProperty(key);
	}

}
