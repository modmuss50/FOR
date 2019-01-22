package me.modmuss50.forserver;

import org.apache.commons.io.FileUtils;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;

public class DataManager {

	public static File data = new File("for_data.json");

	public HashMap<String, Types.ComputerData> computers = new HashMap<>();

	public void save()  {
		try {
			FileUtils.writeStringToFile(data, Main.GSON.toJson(this), StandardCharsets.UTF_8);
		} catch (IOException e) {
			throw new RuntimeException("Failed to save", e);
		}
	}

	public static DataManager read() throws IOException {
		if(data.exists()){
			String json = FileUtils.readFileToString(data, StandardCharsets.UTF_8);
			return Main.GSON.fromJson(json, DataManager.class);
		} else {
			return new DataManager();
		}
	}

}
