package me.modmuss50.forserver;

import java.util.function.Consumer;

public class Utils {

	public static void ifValid(String str, Consumer<String> consumer){
		if(str != null && !str.isEmpty()){
			consumer.accept(str);
		}
	}

}
