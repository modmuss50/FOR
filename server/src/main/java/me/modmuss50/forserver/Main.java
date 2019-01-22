package me.modmuss50.forserver;


import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import io.javalin.Javalin;

import java.util.function.Function;
import java.util.function.Supplier;
import java.util.stream.Collectors;

public class Main  {

	public static Javalin APP = Javalin.create().start(9999);
	public static Gson GSON = new GsonBuilder().setPrettyPrinting().create();
	public static DataManager dataManager = new DataManager();

	public static void main(String[] args) {

		APP.get("/", ctx -> ctx.result("Hello"));

		jsonPost(Types.Station.class, "/station/new", station -> {
			System.out.println("New station, " + station.name);
			dataManager.stations.add(station);
			return null;
		});

		jsonGet("/station/list", () -> {
			Types.StationList list = new Types.StationList();
			list.stations = dataManager.stations.stream()
				.map(station -> station.name)
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
