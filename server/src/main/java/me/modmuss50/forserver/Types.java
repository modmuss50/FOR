package me.modmuss50.forserver;

import java.util.ArrayList;
import java.util.List;

public class Types {

	public static class Default {
		public String status;
	}

	public static class Station {
		public String name;
		public String id;
		public Position pos;
	}

	public static class StationList extends Default {
		public List<String> stations = new ArrayList<>();
	}

	public static class Position {
		int x;
		int y;
		int z;
	}

}
