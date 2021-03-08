package org.zerock.service;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@Log4j
@ContextConfiguration({"file:src/main/webapp/WEB-INF/spring/root-context.xml"})
public class SampleTxServiceTests {
	@Setter (onMethod_= {@Autowired})
	private SampleTxService service;
	
	@Test
	public void testLong() {
		String str = "반짝반짝\r\n" + "작은 별 \r\n" + "아름답게 비치네 \r\n" +"서쪽하늘 에서도";
		log.info(str.getBytes().length);
		service.addData(str);
	}
}
