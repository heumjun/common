package com.stxdis.util.util;

import java.io.File;
import java.util.List;
import java.util.ArrayList;

import org.apache.commons.io.FilenameUtils;
import org.springframework.web.multipart.MultipartFile;

public class FileUploadUtil {

	
	

	/**
	 * 첨부파일 업로드 확장.
	 */
	public static List<CommonMap> getExUploadFiles( List<MultipartFile> files , String uploadPath ) throws Exception {


		String fileUploadDir = PropertiesUtil.getProperties("temp.upload.path");
		
		
		
		String fileLocation     =	fileUploadDir + "/" + uploadPath;

		
		List<CommonMap> fileList =  getUploadFiles(files, uploadPath , fileLocation);
		
		return fileList;
	}

	
	/**
	 * 첨부파일 업로드
	 */
	public static List<CommonMap> getUploadFiles( List<MultipartFile> files , String uploadPath , String path  ) throws Exception {

		
		String filePath;
		String fileName;

		List<CommonMap> fileList = new ArrayList<CommonMap>();


		File uploadDir = new File(path);
		if (!uploadDir.exists())
			uploadDir.mkdirs();

		if (files != null && files.size() > 0) {

			for (MultipartFile multipartFile : files) {

				if (multipartFile != null) {

					fileName = multipartFile.getOriginalFilename();

					if (StringUtils.isNotEmpty(fileName)) {

						// 파일 전송
						filePath = FilenameUtils.concat(path, fileName);

						// 파일 중복 시 파일명 rename
						File newFile = new File(filePath);
						newFile = new FileRenamePolicy().rename(newFile);

						multipartFile.transferTo(newFile);

						CommonMap cmap = new CommonMap();
						cmap.put("FILE_NAME", fileName);
						cmap.put("UPLOAD_PATH", uploadPath);
						cmap.put("NEW_FILE_NAME", newFile.getName());
						cmap.put("FULL_FILE_LOCATION", path);

						fileList.add(cmap);

					} // end of if

				} // end of if

			} // end of for

		} // end of if

		return fileList;
	}
	
	
}
