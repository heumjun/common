package stxship.dis.common.util;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

import org.springframework.web.multipart.MultipartFile;

import com.shaco.EgSubAPI;

public class DisEGDecrypt {
	/*****************************************************************************/
	/* EGAPI For JAVA 1.3.0 버전 예제입니다. */
	/* Modified Date : 2014.11.26. / Modified Developer : Sam Koo */
	/**
	 * @throws IOException ***************************************************************************/
	public static File createDecryptFile(MultipartFile file) {
		
		File DecryptFile = null;
		
		String uploadDir = DisMessageUtil.getMessage("decrypt.path");
		File desti = new File(uploadDir);
		if(!desti.exists()){
			desti.mkdirs(); 
		}
		String fileExt = file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf('.'));
		String uuidFileName = UUID.randomUUID().toString() + fileExt;
		File uploadFile = new File(uploadDir + uuidFileName );
		try {
			file.transferTo(uploadFile);
			String DecryptPath = ""; 
			DecryptPath = decrypt(uploadFile, uploadDir, uuidFileName, file.getContentType());
			DecryptFile = new File(DecryptPath);
		} catch (IllegalStateException | IOException e) {
			e.printStackTrace();
		}
		if(uploadFile.delete()) {
			System.out.println(uploadFile.getName() + " 파일 또는 디렉토리를 성공적으로 지웠습니다.");
		}
		
		return DecryptFile;
	}
	
	public static void deleteDecryptFile(File file) {
		if(file.delete()) {
			System.out.println(file.getName() + " 파일 또는 디렉토리를 성공적으로 지웠습니다.");
		}
	}
	
	public static String decrypt(File file, String pathHeader, String fileName, String contentTypeOrg) throws IOException {
		String authCode = "EG";
		String moduleLicense = "[CLIENT]";
		
		//String pathHeader = "D:\\EGAPI\\";
		//String fileName = "Test.xls";
		String fileNm = "";

		// *** 아래의 변수는 반드시 설정하여 이용하십시오.
		String fileExt;
		// *** 위의 변수는 반드시 설정하여 이용하십시오.

		String pathEncoded = pathHeader + fileName;
		String pathDecryptFileEx;
		
		System.out.println(pathHeader);
		System.out.println(fileName);
		
		com.shaco.EgSubAPI egSub = new com.shaco.EgSubAPI();
		boolean delOldFileFlag = true;
		// String FileExtListUsingSEED =
		// ".ppt/.pptx/.xls/.xlsx/.doc/.docx/.pdf/";

		// *** 아래의 변수는 반드시 설정하여 이용하십시오.
		String FileExtListUsingJLED = ".dwg/.catdrawing/.catpart/";
		// *** 위의 변수는 반드시 설정하여 이용하십시오.

		// Set Local variables
		
		// *** 아래의 변수 설정은 반드시 설정하여 이용하십시오.
		fileExt = pathEncoded.substring(pathEncoded.lastIndexOf('.'));
		fileNm = fileName.substring(0, fileName.lastIndexOf('.'));

		// *** 위의 변수 설정은 반드시 설정하여 이용하십시오.
		pathDecryptFileEx = pathHeader + fileNm + "_Decrypt" + fileExt;

		// Load EGIS-i API
		if (!egSub.loadAPI()) {
			System.exit(704);
		}
		
		// set LogMode : Default is false
		egSub.setLogMode(true);
		// set Licese Input
		egSub.setLicense(authCode, moduleLicense);

		if(delOldFileFlag) {
			if (!deleteOldFile(pathDecryptFileEx))
				System.out.println("Can not delete " + pathDecryptFileEx
						+ " File");
		}

		if (egSub.isLicenseCheckState()) {
			if (egSub.isConfirmLicense()) {
				//System.out.println("Encrypt Algorithm : " + egSub.getEncryptAlgorithm(pathEncoded));

				System.out.println(">>>" + egSub.getFileType(pathEncoded));
				if(egSub.getFileType(pathEncoded) == 0) {
					File t = new File(pathDecryptFileEx);
					file.renameTo(t);

				} else {
					/*****************************************************************************/
					/****************************** 복호화에 관한 예제 *******************************/
					/*****************************************************************************/
					/*****************************************************************************/
					/* 하나의 암호화 알고리즘을 이용하여 복호화하는 경우 */
					/*****************************************************************************/

					// 하나의 암호화 알고리즘을 이용하는 경우 해당 암호화 알고리즘을 설정하여 사용한다.
					// 아래의 예제에서는 "SEED"로 설정하였습니다.
					// EGIS-i에서 설정할 수 있는 암호알고리즘은 "ARIA", "SEED", "JLED"입니다.
					if (!egSub.decryptFileExSetEncAlgorithmOptionFree(pathEncoded, pathDecryptFileEx,
							"SEED")) {
						System.out.println("Log : 1 Algorithm - decryptFileEx using SEED is failed");
					}
				}
				
			}
		}
		
		return pathDecryptFileEx;
	
	}

	public static boolean deleteOldFile(String filePath) {
		File f = new File(filePath);
		if (f.isFile()) {
			if (!f.delete())
				return false;
		}
		return true;
	}
	
	public static String buyerClassDecrypt(File file, String pathHeader, String fileName, String contentTypeOrg) throws IOException {
		String authCode = "EG";
		String moduleLicense = "[CLIENT]";
		
		//String pathHeader = "D:\\EGAPI\\";
		//String fileName = "Test.xls";
		String fileNm = "";

		// *** 아래의 변수는 반드시 설정하여 이용하십시오.
		String fileExt;
		String descryptFlag = "Y";
		// *** 위의 변수는 반드시 설정하여 이용하십시오.

		String pathEncoded = pathHeader + fileName;
		String pathDecryptFileEx;
		EgSubAPI egSub = new EgSubAPI();
		boolean delOldFileFlag = true;
		// String FileExtListUsingSEED =
		// ".ppt/.pptx/.xls/.xlsx/.doc/.docx/.pdf/";

		// *** 아래의 변수는 반드시 설정하여 이용하십시오.
		String FileExtListUsingJLED = ".dwg/.catdrawing/.catpart/";
		// *** 위의 변수는 반드시 설정하여 이용하십시오.

		// Set Local variables
		
		// *** 아래의 변수 설정은 반드시 설정하여 이용하십시오.
		fileExt = pathEncoded.substring(pathEncoded.lastIndexOf('.'));
		fileNm = fileName.substring(0, fileName.lastIndexOf('.'));

		// *** 위의 변수 설정은 반드시 설정하여 이용하십시오.
		pathDecryptFileEx = pathHeader + fileNm + "_Decrypt" + fileExt;

		// Load EGIS-i API
		if (!egSub.loadAPI()) {
			System.exit(704);
		}
		
		// set LogMode : Default is false
		egSub.setLogMode(true);
		// set Licese Input
		egSub.setLicense(authCode, moduleLicense);

		if(delOldFileFlag) {
			if (!deleteOldFile(pathDecryptFileEx))
				System.out.println("Can not delete " + pathDecryptFileEx
						+ " File");
		}

		if (egSub.isLicenseCheckState()) {
			if (egSub.isConfirmLicense()) {
				//System.out.println("Encrypt Algorithm : " + egSub.getEncryptAlgorithm(pathEncoded));

				System.out.println(">>>" + egSub.getFileType(pathEncoded));

				if(egSub.getFileType(pathEncoded) == 0) {
					descryptFlag = "N";
					//File t = new File(pathDecryptFileEx);
					//file.renameTo(t);

				} else {
					/*****************************************************************************/
					/****************************** 복호화에 관한 예제 *******************************/
					/*****************************************************************************/
					/*****************************************************************************/
					/* 하나의 암호화 알고리즘을 이용하여 복호화하는 경우 */
					/*****************************************************************************/

					// 하나의 암호화 알고리즘을 이용하는 경우 해당 암호화 알고리즘을 설정하여 사용한다.
					// 아래의 예제에서는 "SEED"로 설정하였습니다.
					// EGIS-i에서 설정할 수 있는 암호알고리즘은 "ARIA", "SEED", "JLED"입니다.
					if (!egSub.decryptFileExSetEncAlgorithmOptionFree(pathEncoded, pathDecryptFileEx,
							"SEED")) {
						System.out.println("Log : 1 Algorithm - decryptFileEx using SEED is failed");
					}
				}
				
			}
		}
		
		return descryptFlag;
	
	}

}
