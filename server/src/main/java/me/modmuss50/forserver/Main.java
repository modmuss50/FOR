package me.modmuss50.forserver;


import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import io.javalin.Javalin;

import java.io.IOException;
import java.util.Map;
import java.util.function.Function;
import java.util.function.Supplier;
import java.util.stream.Collectors;

public class Main  {

	public static Javalin APP = Javalin.create().start(9999);
	public static Gson GSON = new GsonBuilder().setPrettyPrinting().create();
	public static DataManager dataManager;

	static {
		try {
			dataManager = DataManager.read();
		} catch (IOException e) {
			throw new RuntimeException("Failed to load data");
		}
	}

	public static void main(String[] args) {

		APP.get("/", ctx -> ctx.result("Hello"));

		jsonPost(Types.Station.class, "/station/new", station -> {
			System.out.println("New Station added, " + station.name);
			dataManager.computers.put(station.id, station);
			dataManager.save();
			return null;
		});

		jsonPost(Types.Switch.class, "/switch/new", sw -> {
			System.out.println("New Switch added, " + sw.name);
			dataManager.computers.put(sw.id, sw);
			dataManager.save();
			return null;
		});

		jsonPost(Types.ListRequest.class, "/computer/list", request -> {
			Types.ComputerList list = new Types.ComputerList();
			list.computers = dataManager.computers.entrySet().stream()
				.map(Map.Entry::getValue)
				.filter(computerData -> {
					if(request.ingoreId != null && request.ingoreId.equalsIgnoreCase(computerData.id)){
						return false;
					}
					if(request.type == null || request.type.isEmpty()){
						return true;
					}
					if(request.type.equalsIgnoreCase("station")){
						return computerData instanceof Types.Station;
					}
					if(request.type.equalsIgnoreCase("switch")){
						return computerData instanceof Types.Station;
					}
					return false;
				})
				.map(computer -> computer.name)
				.collect(Collectors.toList());
			return list;
		});
	}

	public static <T, R extends Types.Default> void jsonPost(Class<T> type, String route, Function<T, R> function){
		APP.post(route, ctx -> {
			T request = GSON.fromJson(ctx.body(), type);
			Types.Default object = function.apply(request);
			if(object == null) object = new Types.Default();
			object.status = "success";
			String response = GSON.toJson(object);
			ctx.result(response);
		});
	}

	public static <T extends Types.Default> void jsonGet(String route, Supplier<T> supplier){
		APP.get(route, ctx -> {
			Types.Default object = supplier.get();
			if(object == null) object = new Types.Default();
			object.status = "success";
			String response = GSON.toJson(object);
			ctx.result(response);
		});
	}
}
