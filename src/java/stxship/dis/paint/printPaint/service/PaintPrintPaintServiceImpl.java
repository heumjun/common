package stxship.dis.paint.printPaint.service;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.paint.printPaint.dao.PaintPrintPaintDAO;

@Service("paintPrintPaintService")
public class PaintPrintPaintServiceImpl extends CommonServiceImpl implements PaintPrintPaintService {

	@Resource(name = "paintPrintPaintDAO")
	private PaintPrintPaintDAO paintPrintPaintDAO;

}
