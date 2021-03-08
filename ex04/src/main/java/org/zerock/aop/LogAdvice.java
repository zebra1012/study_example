package org.zerock.aop;

import java.util.Arrays;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

import lombok.extern.log4j.Log4j;

@Aspect //이 클래스는 Aspect
@Log4j
@Component
public class LogAdvice {

		@Before( "execution(* org.zerock.service.SampleService*.*(..))")
		public void logBefore() {
			log.info("==========");
		}
		
		@Before("execution(* org.zerock.service.SampleService*.doAdd(String,String))&&args(str1,str2)")
		//메소드와 파라미터 지정
		public void logBeforeWithParam(String str1, String str2) {
			log.info("Str1 : " + str1);
			log.info("Str2 " + str2);
		}
		@AfterThrowing(pointcut = "execution(* org.zerock.service.SampleService*.*(..))",throwing="exception")
		//예외 발생 시 문제 찾기
		public void logException(Exception exception) {
			log.info("Exception....!!!!");
			log.info("exception: "+ exception);
		}
		
		@Around("execution(* org.zerock.service.SampleService*.*(..))")
		public Object logTime(ProceedingJoinPoint pjp) {
			long start = System.currentTimeMillis();
			log.info("Target: " + pjp.getTarget());
			log.info("Param : " + Arrays.toString(pjp.getArgs()));
			
			//invoke method
			Object result=null;
			try {
				result = pjp.proceed();
			}catch (Throwable e) {
				e.printStackTrace();
			}
			long end = System.currentTimeMillis();
			log.info("TIME : " + (end-start));
			return result;
		}
		
}
