package com.aspects;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.Scanner;
import java.util.stream.*;

import org.aspectj.lang.JoinPoint;

import com.telecom.custom.Customer;

public aspect AuthorizationAspectExerciseThree {	
	static Map<String, String> userPasswordMap = new HashMap<>();
	
	static {
		// load a file with a password and login
		File userFile = new File("./src/com/aspects/user_password_db.txt");
		FileReader userFileReader = null;
		try {
			userFileReader = new FileReader(userFile);
		} catch(FileNotFoundException e) {
			System.out.println("User and password file not found");
			System.exit(1);
		}
			try(BufferedReader userFileStream = new BufferedReader(userFileReader)) {
				Stream<String> userStream = userFileStream.lines();

				java.util.List<String[]> collectedList = userStream.map(el -> el.split(";")).collect(Collectors.toList());
				for(String[] el : collectedList)
					userPasswordMap.put(el[0], el[1]);
			} catch (IOException e) {
				System.out.println("Error occured while initializing the list");
				System.exit(1);
			}
	}
	String insertedPassword;
	String insertedUser;
	
	String foundPassword;
	String foundUser;
	
	pointcut callMethodCut(Customer customer) : this(customer) && execution(* com.telecom.custom.Customer.call(..));
	
	before(Customer customer): callMethodCut(customer)
	{
		Scanner scanner = new Scanner(System.in);
		System.out.println("Insert user: ");
		insertedUser = scanner.nextLine();
		System.out.println("Insert password: ");
		insertedPassword = scanner.nextLine();
	}
	
	Object around(Customer customer) : callMethodCut(customer) { 
		foundPassword = userPasswordMap.get(insertedUser);
		if(!(userPasswordMap.containsKey(insertedUser) &&  foundPassword.equals(insertedPassword))) { 
			System.out.println("Error occured while inserting the user and password");
			System.exit(1);
		}
		return Optional.empty();
	}
}
