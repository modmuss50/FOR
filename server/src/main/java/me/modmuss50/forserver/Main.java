package me.modmuss50.forserver;


import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import io.javalin.Javalin;
import sun.dc.pr.PathFiller;

import java.io.IOException;
import java.util.function.Consumer;
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
			dataManager.stations.put(station.id, station);
			dataManager.save();
			return null;
		});

		jsonPost(Types.Switch.class, "/switch/new", sw -> {
			System.out.println("New Switch added, " + sw.name);
			dataManager.switches.put(sw.id, sw);
			dataManager.save();
			return null;
		});

		jsonPost(Types.SwitchRequest.class, "/switch/request", sw -> {
			System.out.println("Train requesting switching into at " + sw.info.name);

			final boolean[] shouldSwitch = { false };

			Utils.ifValid(sw.minecart.dest, str -> {
				System.out.println("Train traveling to: " + str);
				Types.ComputerData dest = dataManager.getByName(str);
				Types.ComputerData current = dataManager.getByID(sw.info.id);
				Pathfinder pathfinder = new Pathfinder();
				pathfinder.build(dataManager);
				Types.ComputerData next = pathfinder.getNext(current, dest);

				System.out.println("Next point: " + next.name);
				Types.Switch aSwitch = (Types.Switch) current;
				System.out.println("Turn to " + aSwitch.turnsTo);
				if(aSwitch.turnsTo.equalsIgnoreCase(next.name)){
					System.out.println("Switching train onto other line");
					shouldSwitch[0] = true;
				}
			});

			Types.SwitchResponse response = new Types.SwitchResponse();
			response.shouldSwitch = shouldSwitch[0];
			return response;
		});

		jsonPost(Types.ListRequest.class, "/computer/list", request -> {
			Types.ComputerList list = new Types.ComputerList();
			list.computers = dataManager.getAll().stream()
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
				}).collect(Collectors.toList());
			return list;
		});
	}

	public static <T, R extends Types.DefaultResponse> void jsonPost(Class<T> type, String route, Function<T, R> function){
		APP.post(route, ctx -> {
			T request = GSON.fromJson(ctx.body(), type);
			Types.DefaultResponse object = function.apply(request);
			if(object == null) object = new Types.DefaultResponse();
			object.status = "success";
			String response = GSON.toJson(object);
			ctx.result(response);
		});
	}

	public static <T extends Types.DefaultResponse> void jsonGet(String route, Supplier<T> supplier){
		APP.get(route, ctx -> {
			Types.DefaultResponse object = supplier.get();
			if(object == null) object = new Types.DefaultResponse();
			object.status = "success";
			String response = GSON.toJson(object);
			ctx.result(response);
		});
	}
}
