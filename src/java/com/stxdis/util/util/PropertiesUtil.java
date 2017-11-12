package com.stxdis.util.util;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;

import javax.naming.Context;
import javax.naming.InitialContext;



public class PropertiesUtil {

	@SuppressWarnings("finally")
	public static String getProperties(String propertyId) {
		String propertyValue = "";

		Properties properties = new Properties();
		
		
         try {
     			Context ctx  = new InitialContext();
     			Context envCtx = (Context)ctx.lookup("java:comp/env");
     			String propertiesFileLocation = (String) envCtx.lookup("commonProperties");
	 			properties.load(new FileInputStream(propertiesFileLocation));
     			propertyValue = properties.getProperty(propertyId).toString();

         } catch (IOException ioe) {
              ioe.printStackTrace();
              System.exit(-1);
         } finally{
        	 return propertyValue;
         }

	}
	
	
	/*
	public static String getProperties(String propertyId) {
		String propertyValue = "";


		Properties  pp  = new Properties();
         try {
              FileInputStream fis  = new FileInputStream(System.getenv("CATALINA_HOME")+"/conf/common.properties");
              pp.load(fis);
              propertyValue = pp.getProperty(propertyId).toString();

         } catch (IOException ioe) {
              ioe.printStackTrace();
              System.exit(-1);
         } finally{
        	 return propertyValue;
         }

	}
	*/
	
}
