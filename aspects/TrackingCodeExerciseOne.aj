package aspects;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.lang.reflect.Array;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;

public aspect TrackingCodeExerciseOne {
	
	private static boolean isFirstRun = true;
	private static File logFile = new File("zmwo_logs.log");

	pointcut methodCallStats(Object objectOne) : execution(* com.telecom.custom.*.*(..)) && target(objectOne);
	
	Object around(Object objectOne): methodCallStats(objectOne) {
		Timer aspectTimer = new Timer();
		aspectTimer.start();
		Object returnedObject = null;
		try { 
			returnedObject = proceed(objectOne);
		} catch(NullPointerException e ) {
			System.err.println("Null pointer exception in method tracking aspect");
		}
		aspectTimer.stop();

		try { 
			createLogFileIfNotExists();
			appendTimestampIfFirstEntry();
			StringBuilder stats = prepareMethodCallEntry(thisJoinPoint, returnedObject, aspectTimer);
			appendMethodCallStatsToFile(stats);
		} catch(IOException e) {
			System.out.println("Error occured while creating a log entry");
			System.exit(1);
		}
		return returnedObject;
	}
	
	private static StringBuilder prepareMethodCallEntry(JoinPoint joinPoint, Object returnedObject, Timer aspectTimer) {
		StringBuilder stats = new StringBuilder();
		
		stats.append("-------------------");
		stats.append("\n");
		stats.append("Klasa wywołująca: " + joinPoint.getThis().getClass());
		stats.append("\n");
		stats.append("Sygnatura metody: " + joinPoint.getSignature().toString());
		stats.append("\n");
		stats.append("Argumenty metody: " + Arrays.toString(joinPoint.getArgs()));
		stats.append("\n");
		if(returnedObject == null) {
			stats.append("Wynik zwracany przez metode: void");
		} else {
			stats.append("Wynik zwracany przez metode: " + returnedObject.getClass() + " wartosc: " + returnedObject);
		}
		stats.append("\n");
		stats.append("Czas wykonania: " +  aspectTimer.getTime());
		stats.append("\n");
		stats.append("-------------------");
		return stats;
	}
	
	
	private static void createLogFileIfNotExists() throws IOException {
		if(!logFile.exists()) 
			logFile.createNewFile();	
	}
	
	private static void appendTimestampIfFirstEntry() throws IOException {
		if(isFirstRun) {
			isFirstRun = false;
			 DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");  
			 LocalDateTime now = LocalDateTime.now();  
			 String currentDateStr = "\n-------------------\n" + dtf.format(now) + "\n -------------------\n";
			 try(FileOutputStream oFile = new FileOutputStream(logFile, true)) {
				oFile.write(currentDateStr.getBytes());
			 };
		}
	}
	
	private static void appendMethodCallStatsToFile(StringBuilder stats) throws IOException {
		try(FileOutputStream oFile = new FileOutputStream(logFile, true)) {
			String myString = stats.toString();
			oFile.write(myString.getBytes());
		};
	}
}
