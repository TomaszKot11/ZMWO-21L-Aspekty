package com.aspects;

import java.io.PrintStream;
import java.util.Calendar;

/*
 * Aspekt wyswietlajacy w konsoli czas rozpoczecia i zakonczenia nadawania
 * wiadomosci na konsole.
 */
public aspect MessageTimeDisplay
{
	/* XXX Aspect fields----------------------------------------------- */

	// Pole przechowujace kalendarz sluzacy do uzyskiwania daty i godziny
	private Calendar cld;

	/* XXX Pointcut and advice ---------------------------------------- */

	// Przekroj przechwytujacy wywolania print i println dla PrintStream
	
	// Pobiera każde wywołanie metody które jest zgodne z patternem z call(* PrintStream.print*(..))
	// Ten pattern -> * PrintStream.print*(..) oznacza, że na obiekcie klasy PrintStream metody print*() zwracajacej
	// dowolny tym
	pointcut printcut(): call(* PrintStream.print*(..)) && !within(com.aspects..*);

	// Przed wyswietleniem wiadomosci podajemy czas jej nadejscia
	before(): printcut()
	{
		cld = Calendar.getInstance();
		System.out.print(" TIME[" + cld.getTime() + "]: ");
	}

	// Po wyswietleniu wiadomosci podajemy czas po przetworzeniu
	after(): printcut()
	{
		cld = Calendar.getInstance();
		System.out.println(" EOM [" + cld.getTime() + "]");
	}
}
