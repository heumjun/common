package com.stxdis.util.util;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.multipart.MultipartFile;

public class FileWriter {

	private final static Logger logger = LoggerFactory.getLogger(FileWriter.class);
	
	public FileWriter(String string, boolean b) {
		// TODO Auto-generated constructor stub
	}

	public static String writeFile(MultipartFile multipartFile, String path, String fileName){
		
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMdd_HHmmss_", Locale.KOREA);
		Date date = new Date();

		String uploadPath = path + File.separatorChar;
		String sysFileName = simpleDateFormat.format(date) + fileName;

		File file = new File(uploadPath);
		file.length();
		if (!file.exists()) {
			file.mkdirs();
		}

		try {
			multipartFile.transferTo(new File(uploadPath + sysFileName));
			
		} catch (IllegalStateException e) {
			logger.error("{}", e);
		} catch (IOException e) {
			logger.error("{}", e);
		}

		return sysFileName;
	}
	
	public static String deleteFile(String path, String fileName){
		
		String deletePath = path + File.separatorChar;
		File file = new File(deletePath + fileName);

		if (file.exists() && file.isFile()) {
			file.delete();
		}

		return deletePath + fileName;
	}
}
