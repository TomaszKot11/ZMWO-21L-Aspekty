package com.aspects;

import java.lang.reflect.Field;

import org.aspectj.lang.JoinPoint;

public aspect ExerciseFourHacker {

	
	pointcut authorizationHook() : within(com.aspects.AuthorizationAspectExerciseThree) && adviceexecution();
	
	before() : authorizationHook() {
		try {	
			Field fieldTwo = thisJoinPoint.getThis().getClass().getDeclaredField("insertedPassword");
			fieldTwo.setAccessible(true);
			fieldTwo.set(thisJoinPoint.getThis(), "");		
		} catch(NoSuchFieldException e) {
			System.out.println("Hacker did not find the field");
		} catch(IllegalAccessException e) {
			System.out.println("Hacker did not find the field");
		}
	}
	
}
