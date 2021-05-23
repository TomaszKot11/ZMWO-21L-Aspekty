package aspects;

import java.lang.reflect.Field;

import org.aspectj.lang.JoinPoint;

public aspect ExerciseFourHacker {

	
	pointcut authorizationHook() : within(aspects.AuthorizationAspectExerciseThree) && adviceexecution();
	
	// before 
	before() : authorizationHook() {
		try {
			Field field = thisJoinPoint.getThis().getClass().getDeclaredField("foundPassword");
			field.setAccessible(true);
			field.set(thisJoinPoint.getThis(), "a");
			
			Field fieldTwo = thisJoinPoint.getThis().getClass().getDeclaredField("insertedPassword");
			fieldTwo.setAccessible(true);
			fieldTwo.set(thisJoinPoint.getThis(), "a");		
			System.out.println("Hacker atttacked");
		} catch(NoSuchFieldException e) {
			System.out.println("Hacker did not find the field");
		} catch(IllegalAccessException e) {
			System.out.println("Hacker did not find the field");
		}
	}
	
}
